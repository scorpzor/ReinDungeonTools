-- Core/Data.lua
-- Dungeon registry and data management module
-- NOTE: This file loads AFTER Core/Init.lua, so RDT object already exists
--
-- This module provides the registry for dungeons and mobs. Individual dungeons
-- are defined in separate files under Dungeons/ folder.
--
-- MAP TEXTURE FORMATS:
-- ====================
-- 1. SINGLE TEXTURE (Simple, for small dungeons):
--    texture = "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\DungeonName\\map"
--
-- 2. TILED MAP (High-res, for large dungeons):
--    tiles = {
--        tileWidth = 1024,     -- Each tile texture size (must be power-of-2)
--        tileHeight = 1024,
--        cols = 2,             -- Number of tile columns
--        rows = 2,             -- Number of tile rows
--        tiles = {             -- Array of tile paths (left-to-right, top-to-bottom)
--            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\DungeonName\\Tile1",
--            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\DungeonName\\Tile2",
--            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\DungeonName\\Tile3",
--            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\DungeonName\\Tile4",
--        }
--    }
--    
-- Tiles are arranged left-to-right, top-to-bottom in the grid.
-- For a 2x2 grid: [1][2]
--                 [3][4]

local RDT = _G.RDT
if not RDT then
    error("RDT object not found! Core/Data.lua must load after Core/Init.lua")
end

-- Data namespace
RDT.Data = {}
local Data = RDT.Data

-- Dungeon registry
local dungeons = {}

-- Mob database (shared across all dungeons)
local mobDatabase = {}

-- Identifier icon type database (doors, stairs, portals, etc.)
local identifierTypes = {}

--------------------------------------------------------------------------------
-- Core Registry Functions
--------------------------------------------------------------------------------

--- Register a new dungeon (called by dungeon modules)
-- @param name string Display name of the dungeon
-- @param data table Dungeon data {texture/tiles, totalCount, packData}
function Data:RegisterDungeon(name, data)
    if not name or not data then
        RDT:PrintError("RegisterDungeon: Invalid parameters")
        return
    end
    
    if dungeons[name] then
        RDT:PrintError("RegisterDungeon: Dungeon already registered: " .. name)
        return
    end
    
    dungeons[name] = data
    RDT:DebugPrint("Registered dungeon: " .. name)
end

--- Register multiple mobs at once (called by dungeon modules)
-- @param mobs table Dictionary of mob definitions {[key] = {name, count, ...}}
function Data:RegisterMobs(mobs)
    if not mobs then
        RDT:PrintError("RegisterMobs: Invalid parameters")
        return
    end
    
    for key, mobData in pairs(mobs) do
        if mobDatabase[key] then
            RDT:PrintError("RegisterMobs: Mob already registered: " .. key)
        else
            mobDatabase[key] = mobData
            RDT:DebugPrint("Registered mob: " .. key)
        end
    end
end

--- Register a single mob (called by dungeon modules)
-- @param key string Mob identifier
-- @param mobData table Mob definition {name, count, creatureId, displayIcon, scale}
function Data:RegisterMob(key, mobData)
    if not key or not mobData then
        RDT:PrintError("RegisterMob: Invalid parameters")
        return
    end
    
    if mobDatabase[key] then
        RDT:PrintError("RegisterMob: Mob already registered: " .. key)
        return
    end
    
    mobDatabase[key] = mobData
    RDT:DebugPrint("Registered mob: " .. key)
end

--- Register identifier icon types (called by dungeon modules or core)
-- @param types table Dictionary of identifier type definitions {[key] = {name, description, icon, scale}}
function Data:RegisterIdentifierTypes(types)
    if not types then
        RDT:PrintError("RegisterIdentifierTypes: Invalid parameters")
        return
    end

    for key, typeData in pairs(types) do
        if identifierTypes[key] then
            RDT:PrintError("RegisterIdentifierTypes: Type already registered: " .. key)
        else
            identifierTypes[key] = typeData
            RDT:DebugPrint("Registered identifier type: " .. key)
        end
    end
end

--- Register a single identifier type
-- @param key string Identifier type key (e.g., "door", "stairs", "portal")
-- @param typeData table Type definition {name, description, icon, scale}
function Data:RegisterIdentifierType(key, typeData)
    if not key or not typeData then
        RDT:PrintError("RegisterIdentifierType: Invalid parameters")
        return
    end

    if identifierTypes[key] then
        RDT:PrintError("RegisterIdentifierType: Type already registered: " .. key)
        return
    end

    identifierTypes[key] = typeData
    RDT:DebugPrint("Registered identifier type: " .. key)
end

--------------------------------------------------------------------------------
-- Access Functions
--------------------------------------------------------------------------------

--- Get dungeon data by name
-- @param name string Dungeon name
-- @return table Dungeon data or nil
function Data:GetDungeon(name)
    return dungeons[name]
end

--- Get all registered dungeons
-- @return table Array of dungeon names
function Data:GetDungeonList()
    local list = {}
    for name, _ in pairs(dungeons) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

--- Get all registered dungeon names (alias for GetDungeonList)
-- @return table Array of dungeon names
function Data:GetDungeonNames()
    return self:GetDungeonList()
end

--- Check if a dungeon is registered
-- @param name string Dungeon name
-- @return boolean True if dungeon exists
function Data:DungeonExists(name)
    return dungeons[name] ~= nil
end

--- Get mob definition by key
-- @param mobKey string Mob identifier
-- @return table Mob data {name, count, creatureId, displayIcon, scale} or nil
function Data:GetMob(mobKey)
    return mobDatabase[mobKey]
end

--- Get all mobs
-- @return table Mob database
function Data:GetAllMobs()
    return mobDatabase
end

--- Get identifier type definition by key
-- @param typeKey string Identifier type key (e.g., "door", "stairs")
-- @return table Type data {name, description, icon, scale} or nil
function Data:GetIdentifierType(typeKey)
    return identifierTypes[typeKey]
end

--- Get all identifier types
-- @return table Identifier type database
function Data:GetAllIdentifierTypes()
    return identifierTypes
end

--- Get the required enemy forces count for a dungeon
-- @param dungeonName string Name of the dungeon
-- @return number Required count (e.g., 100) or nil if not found
function Data:GetDungeonRequiredCount(dungeonName)
    local dungeon = self:GetDungeon(dungeonName)
    if dungeon and dungeon.totalCount then
        return dungeon.totalCount
    end
    return nil
end

--- Get dungeon data with calculated pack counts (processes mob counts)
-- @param dungeonName string Name of the dungeon
-- @return table Dungeon data with pack.count added for each pack, or nil
function Data:GetProcessedDungeon(dungeonName)
    local dungeon = self:GetDungeon(dungeonName)
    if not dungeon then
        return nil
    end
    
    -- Create a deep copy to avoid modifying the original
    local processed = {
        texture = dungeon.texture,
        tiles = dungeon.tiles,
        totalCount = dungeon.totalCount,
        packData = {}
    }
    
    -- Process each pack and calculate total count
    for _, pack in ipairs(dungeon.packData or {}) do
        local packCopy = {
            id = pack.id,
            x = pack.x,
            y = pack.y,
            mobs = pack.mobs,
            count = 0  -- Will be calculated
        }
        
        -- Calculate pack count from mobs
        if pack.mobs then
            for mobKey, quantity in pairs(pack.mobs) do
                local mobDef = self:GetMob(mobKey)
                if mobDef and mobDef.count then
                    packCopy.count = packCopy.count + (mobDef.count * quantity)
                end
            end
        end
        
        table.insert(processed.packData, packCopy)
    end
    
    return processed
end

--------------------------------------------------------------------------------
-- Built-in Generic Mobs (fallbacks)
--------------------------------------------------------------------------------

-- Register some generic fallback mobs for testing
local genericMobs = {
    ["generic_trash_mob"] = {
        name = "Generic Trash",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 0.7,
    },
    ["generic_big_mob"] = {
        name = "Generic Big Mob",
        count = 1.0,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 0.9,
    },
    ["generic_elite_mob"] = {
        name = "Generic Elite",
        count = 2.0,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 0.9,
    },
    ["generic_boss"] = {
        name = "Generic Boss",
        count = 2.0,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 1.0,
    },
}

Data:RegisterMobs(genericMobs)

--------------------------------------------------------------------------------
-- Default Identifier Types (Doors, Stairs, Portals, etc.)
--------------------------------------------------------------------------------

local defaultIdentifierTypes = {
    door = {
        name = "Door",
        description = "A door or gate",
        icon = "Interface\\Icons\\INV_Misc_Key_03",  -- Placeholder: Key icon
        scale = 1.0,
    },
    stairs = {
        name = "Stairs",
        description = "Stairs or ramp",
        icon = "Interface\\Icons\\Ability_Rogue_Sprint",  -- Placeholder: Sprint icon
        scale = 1.0,
    },
    portal = {
        name = "Portal",
        description = "Teleport portal",
        icon = "Interface\\Icons\\Spell_Arcane_PortalDalaran",  -- Placeholder: Portal icon
        scale = 1.2,
    },
    action = {
        name = "Action",
        description = "Special action point",
        icon = "Interface\\Icons\\INV_Misc_QuestionMark",  -- Placeholder: Question mark
        scale = 1.0,
    },
}

Data:RegisterIdentifierTypes(defaultIdentifierTypes)

--------------------------------------------------------------------------------
-- Validation
--------------------------------------------------------------------------------

--- Validate a dungeon's data structure
-- @param dungeonName string Name to validate
-- @return boolean, string Success status and error message
function Data:ValidateDungeon(dungeonName)
    local dungeon = self:GetDungeon(dungeonName)
    if not dungeon then
        return false, "Dungeon not found: " .. dungeonName
    end
    
    -- Check for map data
    if not dungeon.texture and not dungeon.tiles then
        return false, "No map texture or tiles defined"
    end
    
    -- Check for total count
    if not dungeon.totalCount or dungeon.totalCount <= 0 then
        return false, "Invalid totalCount: " .. tostring(dungeon.totalCount)
    end
    
    -- Check for pack data
    if not dungeon.packData or #dungeon.packData == 0 then
        return false, "No pack data defined"
    end
    
    -- Validate each pack
    for i, pack in ipairs(dungeon.packData) do
        if not pack.id then
            return false, "Pack " .. i .. " missing id"
        end
        if not pack.x or not pack.y then
            return false, "Pack " .. pack.id .. " missing coordinates"
        end
        if not pack.mobs or not next(pack.mobs) then
            return false, "Pack " .. pack.id .. " has no mobs"
        end
        
        -- Check if all mob keys exist
        for mobKey, count in pairs(pack.mobs) do
            if not self:GetMob(mobKey) then
                return false, "Pack " .. pack.id .. " references unknown mob: " .. mobKey
            end
        end
    end
    
    return true, "Valid"
end

--- Validate all registered dungeons
-- @return table Results {total, valid, invalid, errors}
function Data:ValidateAll()
    local results = {
        total = 0,
        valid = 0,
        invalid = 0,
        errors = {}
    }
    
    local dungeonList = self:GetDungeonList()
    results.total = #dungeonList
    
    for _, name in ipairs(dungeonList) do
        local success, msg = self:ValidateDungeon(name)
        if success then
            results.valid = results.valid + 1
            RDT:DebugPrint("✓ Validated: " .. name)
        else
            results.invalid = results.invalid + 1
            results.errors[name] = msg
            RDT:PrintError("✗ Validation failed for " .. name .. ": " .. msg)
        end
    end
    
    -- Summary
    if results.invalid == 0 then
        RDT:DebugPrint(string.format("All %d dungeons validated successfully", results.valid))
    else
        RDT:PrintError(string.format("Validation: %d valid, %d invalid out of %d total", 
            results.valid, results.invalid, results.total))
    end
    
    return results
end

--------------------------------------------------------------------------------
-- Statistics
--------------------------------------------------------------------------------

--- Get statistics about registered data
-- @return table Stats {dungeonCount, mobCount, totalPacks}
function Data:GetStats()
    local dungeonCount = 0
    local totalPacks = 0
    
    for name, dungeon in pairs(dungeons) do
        dungeonCount = dungeonCount + 1
        if dungeon.packData then
            totalPacks = totalPacks + #dungeon.packData
        end
    end
    
    local mobCount = 0
    for _ in pairs(mobDatabase) do
        mobCount = mobCount + 1
    end
    
    return {
        dungeonCount = dungeonCount,
        mobCount = mobCount,
        totalPacks = totalPacks,
    }
end

--------------------------------------------------------------------------------
-- Export Functions (for ImportExport module)
--------------------------------------------------------------------------------

--- Export dungeon data as Lua table string (for debugging/sharing)
-- @param dungeonName string Name of dungeon to export
-- @return string Serialized dungeon data or nil
function Data:ExportDungeon(dungeonName)
    local dungeon = self:GetDungeon(dungeonName)
    if not dungeon then
        RDT:PrintError("ExportDungeon: Dungeon not found: " .. dungeonName)
        return nil
    end
    
    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    if AceSerializer then
        return AceSerializer:Serialize(dungeon)
    end

    return "-- Export not available without AceSerializer"
end

--- Export all registered dungeons
-- @return table List of {name, data} pairs
function Data:ExportAll()
    local exports = {}
    for name, data in pairs(dungeons) do
        table.insert(exports, {
            name = name,
            data = data,
        })
    end
    return exports
end

--------------------------------------------------------------------------------
-- Debug Commands
--------------------------------------------------------------------------------

--- Print all registered dungeons
function Data:ListDungeons()
    local list = self:GetDungeonList()
    RDT:Print("Registered dungeons (" .. #list .. "):")
    for _, name in ipairs(list) do
        local dungeon = self:GetDungeon(name)
        local packCount = dungeon.packData and #dungeon.packData or 0
        RDT:Print("  - " .. name .. " (" .. packCount .. " packs)")
    end
end

--- Print all registered mobs
function Data:ListMobs()
    local count = 0
    RDT:Print("Registered mobs:")
    for key, mob in pairs(mobDatabase) do
        count = count + 1
        RDT:Print(string.format("  - [%s] %s (count: %.1f)", key, mob.name, mob.count))
    end
    RDT:Print("Total: " .. count .. " mob types")
end

--------------------------------------------------------------------------------
-- Module Initialization
--------------------------------------------------------------------------------

RDT:DebugPrint("Data registry initialized (dungeons will be loaded from modules)")
