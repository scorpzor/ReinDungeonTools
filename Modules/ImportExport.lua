-- Modules/ImportExport.lua
-- Route import/export with serialization, compression, and validation

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- Module namespace
RDT.ImportExport = {}
local IE = RDT.ImportExport

-- Format version for import/export compatibility
local EXPORT_VERSION = 1
local EXPORT_PREFIX = "RDT"

--------------------------------------------------------------------------------
-- Export Functions
--------------------------------------------------------------------------------

--- Export current route as compressed string
-- @return string Encoded route string or nil on failure
function IE:Export()
    if not RDT.State.currentRoute then 
        RDT:Print("No route to export")
        return nil
    end
    
    local dungeonName = RDT.db.profile.currentDungeon
    
    local exportData = {
        version = EXPORT_VERSION,
        addonVersion = RDT.Version,
        dungeon = dungeonName,
        pulls = RDT.State.currentRoute.pulls,
        timestamp = time(),
        author = UnitName("player") .. "-" .. GetRealmName(),
    }
    
    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    local LibCompress = LibStub:GetLibrary("LibCompress", true)
    
    if not AceSerializer or not LibCompress then
        RDT:PrintError("Required libraries not found")
        return nil
    end
    
    -- Step 1: Serialize
    local serialized = AceSerializer:Serialize(exportData)
    RDT:DebugPrint("Serialized length: " .. string.len(serialized))
    
    -- Step 2: Compress
    local compressed = LibCompress:CompressHuffman(serialized)
    local didCompress = false
    
    if compressed and string.len(compressed) < string.len(serialized) then
        didCompress = true
        RDT:DebugPrint("Compressed length: " .. string.len(compressed))
    else
        compressed = serialized
        didCompress = false
        RDT:DebugPrint("Compression skipped")
    end
    
    -- Step 3: Encode
    local encoded = LibCompress:GetAddonEncodeTable():Encode(compressed)
    
    -- Add prefix
    local importString = (didCompress and "RDT1C:" or "RDT1:") .. encoded
    RDT:Print(string.format("Route exported! Length: %d characters", string.len(importString)))
    
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
    
    -- Parse prefix
    local prefix, encoded = importString:match("^(RDT%d+C?):(.+)$")
    if not prefix then
        RDT:PrintError("Invalid import string")
        return false
    end
    
    local isCompressed = prefix:match("C$") ~= nil
    local version = prefix:match("^RDT(%d+)")
    
    if version ~= "1" then
        RDT:PrintError("Unsupported version: " .. tostring(version))
        return false
    end
    
    RDT:DebugPrint("Import: version=" .. version .. ", compressed=" .. tostring(isCompressed))
    
    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    local LibCompress = LibStub:GetLibrary("LibCompress", true)
    
    if not AceSerializer or not LibCompress then
        RDT:PrintError("Required libraries not found")
        return false
    end
    
    -- Step 1: Decode
    local decoded = LibCompress:GetAddonEncodeTable():Decode(encoded)
    if not decoded then
        RDT:PrintError("Failed to decode")
        return false
    end
    
    RDT:DebugPrint("Decoded length: " .. string.len(decoded))
    
    -- Step 2: Decompress (only if compressed)
    local decompressed
    if isCompressed then
        RDT:DebugPrint("Attempting decompression...")
        local success, result = pcall(LibCompress.DecompressHuffman, LibCompress, decoded)
        if success and result then
            decompressed = result
            RDT:DebugPrint("Decompressed length: " .. string.len(decompressed))
        else
            RDT:PrintError("Failed to decompress: " .. tostring(result))
            return false
        end
    else
        decompressed = decoded
        RDT:DebugPrint("Not compressed")
    end
    
    -- Step 3: Deserialize
    local success, data = AceSerializer:Deserialize(decompressed)
    if not success then
        RDT:PrintError("Failed to deserialize")
        return false
    end
    
    -- Step 4: Validate data structure
    if not self:ValidateImportData(data) then
        RDT:PrintError("Import data validation failed (corrupted or malicious data)")
        return false
    end
    
    -- Step 5: Check dungeon exists
    if not RDT.Data:DungeonExists(data.dungeon) then
        RDT:PrintError("Dungeon '" .. data.dungeon .. "' not found in your addon")
        RDT:Print("This route is for: " .. data.dungeon)
        return false
    end
    
    -- Step 6: Show import info
    RDT:Print("|cFFFFFF00Importing route:|r")
    RDT:Print("  Dungeon: |cFFFFAA00" .. data.dungeon .. "|r")
    if data.author then
        RDT:Print("  Author: " .. data.author)
    end
    if data.addonVersion and data.addonVersion ~= RDT.Version then
        RDT:Print("  |cFFFFFF00Created with v" .. data.addonVersion .. " (you have v" .. RDT.Version .. ")|r")
    end
    if data.stats and data.stats.totalForces then
        RDT:Print(string.format("  Total Forces: %d%% in %d pulls", 
            data.stats.totalForces, data.stats.pullCount or 0))
    end
    
    -- Count packs
    local packCount = 0
    for _ in pairs(data.pulls) do packCount = packCount + 1 end
    RDT:Print("  Packs: " .. packCount .. " assigned")
    
    -- Step 7: Load the dungeon first
    if not RDT:LoadDungeon(data.dungeon) then
        RDT:PrintError("Failed to load dungeon")
        return false
    end
    
    -- Step 8: Apply the pulls
    wipe(RDT.State.currentRoute.pulls)
    for packId, pullNum in pairs(data.pulls) do
        RDT.State.currentRoute.pulls[packId] = pullNum
    end
    
    -- Recalculate current pull
    if RDT.RouteManager then
        RDT.State.currentPull = RDT.RouteManager:GetNextPull(RDT.State.currentRoute.pulls)
    end
    
    -- Step 9: Update UI
    if RDT.UI then
        if RDT.UI.UpdateLabels then
            RDT.UI:UpdateLabels()
        end
        if RDT.UI.UpdatePullList then
            RDT.UI:UpdatePullList()
        end
    end
    
    RDT:Print("|cFF00FF00Route imported successfully!|r")
    return true
end

--------------------------------------------------------------------------------
-- Validation
--------------------------------------------------------------------------------

--- Validate imported data structure (SECURITY CRITICAL)
-- @param data table Deserialized import data
-- @return boolean Valid status
function IE:ValidateImportData(data)
    -- Check basic structure
    if type(data) ~= "table" then 
        RDT:DebugPrint("Validation failed: data is not a table")
        return false 
    end
    
    -- Check required fields
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
    
    -- Validate pulls table entries
    for packId, pullNum in pairs(data.pulls) do
        -- Check pack ID is number and reasonable
        if type(packId) ~= "number" then
            RDT:DebugPrint("Validation failed: pack ID not a number")
            return false
        end
        if packId < 1 or packId > 1000 then  -- Reasonable limits
            RDT:DebugPrint(string.format("Validation failed: pack ID out of range (%d)", packId))
            return false
        end
        
        -- Check pull number is valid
        if type(pullNum) ~= "number" then
            RDT:DebugPrint("Validation failed: pull number not a number")
            return false
        end
        if pullNum < 0 or pullNum > 100 then  -- Max 100 pulls should be plenty
            RDT:DebugPrint(string.format("Validation failed: pull number out of range (%d)", pullNum))
            return false
        end
    end
    
    -- Optional: Validate metadata fields if present
    if data.stats and type(data.stats) ~= "table" then
        RDT:DebugPrint("Validation warning: stats is not a table")
        -- Don't fail, just warn
    end
    
    return true
end

RDT:DebugPrint("ImportExport.lua loaded")