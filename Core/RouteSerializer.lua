-- Core/RouteSerializer.lua
-- Shared route serialization/deserialization utilities

local RDT = _G.RDT
if not RDT then
    error("RDT not found!")
end

RDT.RouteSerializer = {}
local RouteSerializer = RDT.RouteSerializer

-- Local references to dependencies
local Base64 = RDT.Base64
local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)

-- Format version for import/export compatibility
local EXPORT_VERSION = 1

--------------------------------------------------------------------------------
-- Serialization
--------------------------------------------------------------------------------

--- Create export data structure from current route
-- @param routeName string Optional route name (defaults to current route name)
-- @return table Export data structure or nil on failure
function RouteSerializer:CreateExportData(routeName)
    if not RDT.State.currentRoute then
        RDT:Print("No route to export")
        return nil
    end

    local dungeonName = RDT.db.profile.currentDungeon
    if not dungeonName then
        RDT:PrintError("No dungeon selected")
        return nil
    end

    if not routeName and RDT.RouteManager then
        routeName = RDT.RouteManager:GetCurrentRouteName(dungeonName) or "Unnamed"
    end
    routeName = routeName or "Unnamed"

    local exportData = {
        version = EXPORT_VERSION,
        addonVersion = RDT.Version,
        dungeon = dungeonName,
        routeName = routeName,
        pulls = {},
        timestamp = time(),
        author = UnitName("player") .. "-" .. GetRealmName(),
    }

    -- Copy pulls table
    for packId, pullNum in pairs(RDT.State.currentRoute.pulls) do
        exportData.pulls[packId] = pullNum
    end

    return exportData
end

--- Encode route data to RDT1: export string
-- @param exportData table The export data structure
-- @return string Encoded string or nil on failure
function RouteSerializer:EncodeRouteData(exportData)
    if not AceSerializer then
        RDT:PrintError("AceSerializer library not found")
        return nil
    end

    if not Base64 then
        RDT:PrintError("Base64 module not found")
        return nil
    end

    local serialized = AceSerializer:Serialize(exportData)
    RDT:DebugPrint("Serialized length: " .. string.len(serialized))

    local encoded = Base64:Encode(serialized)
    local importString = "RDT1:" .. encoded

    return importString
end

--- Full export: Create and encode route data
-- @param routeName string Optional route name
-- @return string Encoded export string or nil on failure
function RouteSerializer:Export(routeName)
    local exportData = self:CreateExportData(routeName)
    if not exportData then
        return nil
    end

    return self:EncodeRouteData(exportData)
end

--------------------------------------------------------------------------------
-- Deserialization
--------------------------------------------------------------------------------

--- Decode RDT1: export string to route data
-- @param importString string The encoded route string
-- @return table Route data or nil on failure
function RouteSerializer:DecodeRouteData(importString)
    if not importString or importString == "" then
        RDT:PrintError("Invalid import string")
        return nil
    end

    importString = strtrim(importString)

    local prefix, encoded = importString:match("^(RDT%d+):(.+)$")
    if not prefix then
        RDT:PrintError("Invalid import string format")
        return nil
    end

    local version = prefix:match("^RDT(%d+)")
    if version ~= "1" then
        RDT:PrintError("Unsupported version: " .. tostring(version))
        return nil
    end

    if not AceSerializer then
        RDT:PrintError("AceSerializer library not found")
        return nil
    end

    if not Base64 then
        RDT:PrintError("Base64 module not found")
        return nil
    end

    local decoded = Base64:Decode(encoded)
    if not decoded then
        RDT:PrintError("Failed to decode Base64")
        return nil
    end

    RDT:DebugPrint("Decoded length: " .. string.len(decoded))

    local success, data = AceSerializer:Deserialize(decoded)
    if not success then
        RDT:PrintError("Failed to deserialize: " .. tostring(data))
        return nil
    end

    return data
end

--- Parse basic route info from export string (without full validation)
-- @param exportString string The RDT1: export string
-- @return table Route information (dungeon, routeName, packCount) or nil
function RouteSerializer:ParseRouteInfo(exportString)
    local data = self:DecodeRouteData(exportString)
    if not data then
        return {
            dungeon = "Unknown",
            routeName = "Unknown",
            packCount = 0
        }
    end

    local packCount = 0
    if data.pulls and type(data.pulls) == "table" then
        for _ in pairs(data.pulls) do
            packCount = packCount + 1
        end
    end

    return {
        dungeon = data.dungeon or "Unknown",
        routeName = data.routeName or "Unnamed",
        packCount = packCount,
        author = data.author,
        addonVersion = data.addonVersion,
        timestamp = data.timestamp
    }
end

--------------------------------------------------------------------------------
-- Validation
--------------------------------------------------------------------------------

--- Validate imported data structure
-- @param data table Deserialized import data
-- @return boolean Valid status
function RouteSerializer:ValidateRouteData(data)
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

RDT:DebugPrint("RouteSerializer module loaded")
