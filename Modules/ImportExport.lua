-- Modules/ImportExport.lua
-- Route import/export with Base64 serialization and validation

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

RDT.ImportExport = {}
local IE = RDT.ImportExport

-- Format version for import/export compatibility
local EXPORT_VERSION = 1

--------------------------------------------------------------------------------
-- Base64 Encoding/Decoding
--------------------------------------------------------------------------------

local base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function Base64Encode(data)
    local b64 = ""

    -- Process groups of 3 bytes
    for i = 1, #data, 3 do
        local b1, b2, b3 = string.byte(data, i, i+2)

        local n = b1 * 65536
        if b2 then n = n + b2 * 256 end
        if b3 then n = n + b3 end

        local c1 = math.floor(n / 262144) % 64
        local c2 = math.floor(n / 4096) % 64
        local c3 = math.floor(n / 64) % 64
        local c4 = n % 64

        b64 = b64 .. string.sub(base64_chars, c1+1, c1+1)
        b64 = b64 .. string.sub(base64_chars, c2+1, c2+1)

        if b2 then
            b64 = b64 .. string.sub(base64_chars, c3+1, c3+1)
        else
            b64 = b64 .. "="
        end

        if b3 then
            b64 = b64 .. string.sub(base64_chars, c4+1, c4+1)
        else
            b64 = b64 .. "="
        end
    end

    return b64
end

local function Base64Decode(b64)
    -- Create reverse lookup table
    local decode_table = {}
    for i = 1, #base64_chars do
        decode_table[string.sub(base64_chars, i, i)] = i - 1
    end

    local data = ""
    b64 = string.gsub(b64, "[^" .. base64_chars .. "=]", "")

    for i = 1, #b64, 4 do
        local c1, c2, c3, c4 = string.byte(b64, i, i+3)

        local n1 = decode_table[string.char(c1)] or 0
        local n2 = decode_table[string.char(c2)] or 0
        local n3 = decode_table[string.char(c3)] or 0
        local n4 = decode_table[string.char(c4)] or 0

        local n = n1 * 262144 + n2 * 4096 + n3 * 64 + n4

        local b1 = math.floor(n / 65536) % 256
        local b2 = math.floor(n / 256) % 256
        local b3 = n % 256

        data = data .. string.char(b1)

        if c3 ~= 61 then  -- 61 is '='
            data = data .. string.char(b2)
        end

        if c4 ~= 61 then
            data = data .. string.char(b3)
        end
    end

    return data
end

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

--- Print human-readable debug output for export/import data
-- @param exportData table The export data structure
-- @param label string Debug section label (e.g., "EXPORT" or "IMPORT")
local function DebugPrintRouteData(exportData, label)
    RDT:DebugPrint("=== " .. label .. " DEBUG ===")
    RDT:DebugPrint("Dungeon: " .. tostring(exportData.dungeon))
    RDT:DebugPrint("Route Name: " .. tostring(exportData.routeName))
    RDT:DebugPrint("Author: " .. tostring(exportData.author))
    RDT:DebugPrint("Version: " .. tostring(exportData.version))
    RDT:DebugPrint("Addon Version: " .. tostring(exportData.addonVersion))

    local pullCount = 0
    local packsByPull = {}
    for packId, pullNum in pairs(exportData.pulls) do
        pullCount = pullCount + 1
        packsByPull[pullNum] = packsByPull[pullNum] or {}
        table.insert(packsByPull[pullNum], packId)
    end

    RDT:DebugPrint("Total Packs: " .. pullCount)
    RDT:DebugPrint("Pulls:")

    local sortedPulls = {}
    for pullNum in pairs(packsByPull) do
        table.insert(sortedPulls, pullNum)
    end
    table.sort(sortedPulls)

    for _, pullNum in ipairs(sortedPulls) do
        local packs = packsByPull[pullNum]
        table.sort(packs)
        local packList = table.concat(packs, ", ")
        RDT:DebugPrint(string.format("  Pull %d: [%s]", pullNum, packList))
    end

    RDT:DebugPrint("==================")
end

--------------------------------------------------------------------------------
-- Export Functions
--------------------------------------------------------------------------------

--- Export current route as Base64-encoded string
-- @return string Encoded route string or nil on failure
function IE:Export()
    if not RDT.State.currentRoute then
        RDT:Print("No route to export")
        return nil
    end

    local dungeonName = RDT.db.profile.currentDungeon
    if not dungeonName then
        RDT:PrintError("No dungeon selected")
        return nil
    end

    local routeName = "Unnamed"
    if RDT.RouteManager then
        routeName = RDT.RouteManager:GetCurrentRouteName(dungeonName) or "Unnamed"
    end

    local exportData = {
        version = EXPORT_VERSION,
        addonVersion = RDT.Version,
        dungeon = dungeonName,
        routeName = routeName,
        pulls = RDT.State.currentRoute.pulls,
        timestamp = time(),
        author = UnitName("player") .. "-" .. GetRealmName(),
    }

    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    if not AceSerializer then
        RDT:PrintError("AceSerializer library not found")
        return nil
    end

    local serialized = AceSerializer:Serialize(exportData)
    RDT:DebugPrint("Serialized length: " .. string.len(serialized))

    local encoded = Base64Encode(serialized)

    local importString = "RDT1:" .. encoded
    RDT:Print(string.format("Route exported! Length: %d characters", string.len(importString)))

    DebugPrintRouteData(exportData, "EXPORT")

    return importString
end

--------------------------------------------------------------------------------
-- Import Functions
--------------------------------------------------------------------------------

--- Import route from encoded string
-- @param importString string The encoded route string
-- @return boolean Success status
function IE:Import(importString)
    if not importString or importString == "" then
        RDT:PrintError("Invalid import string")
        return false
    end

    importString = strtrim(importString)

    local prefix, encoded = importString:match("^(RDT%d+):(.+)$")
    if not prefix then
        RDT:PrintError("Invalid import string format")
        return false
    end

    local version = prefix:match("^RDT(%d+)")
    if version ~= "1" then
        RDT:PrintError("Unsupported version: " .. tostring(version))
        return false
    end

    RDT:DebugPrint("Import: version=" .. version)

    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    if not AceSerializer then
        RDT:PrintError("AceSerializer library not found")
        return false
    end

    local decoded = Base64Decode(encoded)
    if not decoded then
        RDT:PrintError("Failed to decode Base64")
        return false
    end

    RDT:DebugPrint("Decoded length: " .. string.len(decoded))

    local success, data = AceSerializer:Deserialize(decoded)
    if not success then
        RDT:PrintError("Failed to deserialize: " .. tostring(data))
        return false
    end

    DebugPrintRouteData(data, "IMPORT")

    if not self:ValidateImportData(data) then
        RDT:PrintError("Import data validation failed (corrupted or malicious data)")
        return false
    end

    if not RDT.Data:DungeonExists(data.dungeon) then
        RDT:PrintError("Dungeon '" .. data.dungeon .. "' not found in your addon")
        RDT:Print("This route is for: " .. data.dungeon)
        return false
    end

    RDT:Print("|cFFFFFF00Importing route:|r")
    RDT:Print("  Dungeon: |cFFFFAA00" .. data.dungeon .. "|r")
    if data.routeName then
        RDT:Print("  Route Name: " .. data.routeName)
    end
    if data.author then
        RDT:Print("  Author: " .. data.author)
    end
    if data.addonVersion and data.addonVersion ~= RDT.Version then
        RDT:Print("  |cFFFFFF00Created with v" .. data.addonVersion .. " (you have v" .. RDT.Version .. ")|r")
    end

    local packCount = 0
    for _ in pairs(data.pulls) do packCount = packCount + 1 end
    RDT:Print("  Packs: " .. packCount .. " assigned")
    
    if not RDT:LoadDungeon(data.dungeon) then
        RDT:PrintError("Failed to load dungeon")
        return false
    end
    
    if not RDT.RouteManager then
        RDT:PrintError("RouteManager not available")
        return false
    end
    
    local importedRouteName = data.routeName or "Imported Route"
    local newRouteName = RDT.RouteManager:CreateRoute(data.dungeon, importedRouteName)
    
    if not newRouteName then
        RDT:PrintError("Failed to create new route")
        return false
    end
    
    if not RDT.State.currentRoute then
        RDT:PrintError("Failed to get current route")
        return false
    end
    
    wipe(RDT.State.currentRoute.pulls)
    for packId, pullNum in pairs(data.pulls) do
        RDT.State.currentRoute.pulls[packId] = pullNum
    end
    
    RDT.State.currentPull = RDT.RouteManager:GetNextPull(RDT.State.currentRoute.pulls)
    
    if RDT.UI then
        if RDT.UI.UpdateLabels then
            RDT.UI:UpdateLabels()
        end
        if RDT.UI.UpdatePullList then
            RDT.UI:UpdatePullList()
        end
        if RDT.UI.UpdateRouteDropdown then
            RDT.UI:UpdateRouteDropdown()
        end
        if RDT.UI.UpdateTotalForces then
            RDT.UI:UpdateTotalForces()
        end
    end
    
    RDT:Print("|cFF00FF00Route imported successfully to: " .. newRouteName .. "|r")
    return true
end

--------------------------------------------------------------------------------
-- Validation
--------------------------------------------------------------------------------

--- Validate imported data structure
-- @param data table Deserialized import data
-- @return boolean Valid status
function IE:ValidateImportData(data)
    if type(data) ~= "table" then 
        RDT:DebugPrint("Validation failed: data is not a table")
        return false 
    end
    
    if not data.version or type(data.version) ~= "number" then
        RDT:DebugPrint("Validation failed: invalid version")
        return false
    end
    
    if not data.dungeon or type(data.dungeon) ~= "string" then
        RDT:DebugPrint("Validation failed: invalid dungeon")
        return false
    end
    
    if not data.pulls or type(data.pulls) ~= "table" then
        RDT:DebugPrint("Validation failed: invalid pulls table")
        return false
    end

    for packId, pullNum in pairs(data.pulls) do
        if type(packId) ~= "number" then
            RDT:DebugPrint("Validation failed: pack ID not a number")
            return false
        end
        if packId < 1 or packId > 1050 then
            RDT:DebugPrint(string.format("Validation failed: pack ID out of range (%d)", packId))
            return false
        end

        -- Check pull number is valid
        if type(pullNum) ~= "number" then
            RDT:DebugPrint("Validation failed: pull number not a number")
            return false
        end
    end

    return true
end

RDT:DebugPrint("ImportExport.lua loaded")