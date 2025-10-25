-- Data.lua
-- Dungeon definitions and data management module with mob dictionary
-- NOTE: This file loads AFTER Core/Init.lua, so RDT object already exists
--
-- MAP TEXTURE FORMATS:
-- ====================
-- 1. SINGLE TEXTURE (Simple, for small dungeons):
--    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\dungeon"
--
-- 2. TILED MAP (High-res, multi-floor support):
--    tiles = {
--        tileWidth = 1024,     -- Each tile texture size (must be power-of-2)
--        tileHeight = 1024,
--        cols = 2,             -- Number of tile columns
--        rows = 2,             -- Number of tile rows
--        floors = {
--            [1] = {           -- Floor 1 data
--                tiles = {
--                    "Interface\\AddOns\\ReinDungeonTools\\Textures\\DungeonName\\Floor1_Tile1",
--                    "Interface\\AddOns\\ReinDungeonTools\\Textures\\DungeonName\\Floor1_Tile2",
--                    "Interface\\AddOns\\ReinDungeonTools\\Textures\\DungeonName\\Floor1_Tile3",
--                    "Interface\\AddOns\\ReinDungeonTools\\Textures\\DungeonName\\Floor1_Tile4",
--                }
--            },
--            [2] = {           -- Floor 2 data (if dungeon has multiple floors)
--                tiles = { ... }
--            }
--        }
--    }
--    
-- Tiles are arranged left-to-right, top-to-bottom in the grid.
-- For a 2x2 grid: [1][2]
--                 [3][4]

local RDT = _G.RDT
if not RDT then
    error("RDT object not found! Data.lua must load after Core/Init.lua")
end

-- Data namespace
RDT.Data = {}
local Data = RDT.Data

-- Dungeon definitions
local dungeons = {}

-- Mob definitions (shared across all dungeons)
-- Each mob has: name, count (enemy forces value, decimal), creatureId (optional), displayIcon (optional), scale (optional)
-- count: decimal value representing enemy forces (e.g., 0.5 for weak trash, 2.0 for elite)
-- displayIcon can be: SetPortraitTexture for 3D portrait, or explicit texture path
-- If no displayIcon, defaults to question mark icon
-- scale: visual size multiplier (0.6-1.0), defaults to 1.0. Smaller scale = less important mob
local mobDatabase = {
    -- Example mobs for Test Dungeon
    ["generic_trash_mob"] = {
        name = "Generic Trash Mob",
        count = 0.5,
        creatureId = 10001,
        displayIcon = "Interface\\Icons\\INV_Misc_QuestionMark",
        scale = 0.5, -- Small weak mob
    },
    ["generic_normal_mob"] = {
        name = "Generic Normal Mob", 
        count = 1,
        creatureId = 10002,
        displayIcon = "Interface\\Icons\\Ability_Warrior_Savageblow",
        scale = 0.7, -- Medium sized
    },
    ["generic_big_mob"] = {
        name = "Generic Big Mob",
        count = 2,
        creatureId = 10003,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 0.9, -- Full size elite
    },
    ["generic_elite_mob"] = {
        name = "Generic Elite Mob",
        count = 2,
        creatureId = 10003,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 1.0, -- Full size elite
    },
    ["generic_boss"] = {
        name = "Generic Boss",
        count = 2,
        creatureId = 10003,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 1.0, -- Full size elite
    },
}

--------------------------------------------------------------------------------
-- Stratholme
--------------------------------------------------------------------------------
-- Dungeon structure:
--   texture: Map texture path (single texture or tiles structure)
--   totalCount: Required enemy forces count for 100% completion (e.g., 100)
--   packData: Array of pack definitions with id, x, y, and mobs

dungeons["Stratholme"] = {
    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Classic\\stratholme",
    totalCount = 120,  -- Required enemy forces to complete (100%)
    packData = {
        -- First room
        {
            id = 1, 
            x = 0.5, 
            y = 0.15, 
            mobs = {
                ["generic_trash_mob"] = 2,
                ["generic_big_mob"] = 1,
            }
        },
        {
            id = 2, 
            x = 0.45, 
            y = 0.25, 
            mobs = {
                ["generic_trash_mob"] = 3,
                ["generic_big_mob"] = 1,
                ["generic_elite_mob"] = 1,
            }
        },
    },
}

--------------------------------------------------------------------------------
-- Mob Database Access Functions
--------------------------------------------------------------------------------

--- Get mob definition by key
-- @param mobKey string Mob identifier
-- @return table Mob data {name, count, creatureId} or nil
function Data:GetMob(mobKey)
    return mobDatabase[mobKey]
end

--- Get all mobs
-- @return table Mob database
function Data:GetAllMobs()
    return mobDatabase
end

--- Add or update a mob definition
-- @param mobKey string Mob identifier
-- @param mobData table Mob data {name, count, creatureId}
-- @return boolean Success status
function Data:SetMob(mobKey, mobData)
    if type(mobKey) ~= "string" or mobKey == "" then
        if RDT.PrintError then
            RDT:PrintError("Invalid mob key")
        end
        return false
    end
    
    if type(mobData) ~= "table" then
        if RDT.PrintError then
            RDT:PrintError("Invalid mob data")
        end
        return false
    end
    
    mobDatabase[mobKey] = mobData
    return true
end

--- Calculate pack count from mob composition
-- @param mobs table Map of {mobKey = quantity}
-- @return number Total enemy forces count (decimal)
function Data:CalculatePackCount(mobs)
    if type(mobs) ~= "table" then
        return 0
    end
    
    local total = 0
    for mobKey, quantity in pairs(mobs) do
        local mobDef = mobDatabase[mobKey]
        if mobDef and mobDef.count then
            total = total + (mobDef.count * quantity)
        else
            if RDT.PrintError then
                RDT:PrintError("Unknown mob key: " .. tostring(mobKey))
            end
        end
    end
    
    return total
end

--------------------------------------------------------------------------------
-- Data Access Functions
--------------------------------------------------------------------------------

--- Get list of all dungeon names
-- @return table Array of dungeon names
function Data:GetDungeonNames()
    local names = {}
    for name in pairs(dungeons) do
        tinsert(names, name)
    end
    table.sort(names)
    return names
end

--- Get dungeon data by name
-- @param dungeonName string Name of the dungeon
-- @return table Dungeon data or nil if not found
function Data:GetDungeon(dungeonName)
    return dungeons[dungeonName]
end

--- Check if dungeon exists
-- @param dungeonName string Name of the dungeon
-- @return boolean True if dungeon exists
function Data:DungeonExists(dungeonName)
    return dungeons[dungeonName] ~= nil
end

--- Get dungeon data with calculated pack counts
-- This processes the raw pack data and adds calculated count values
-- @param dungeonName string Name of the dungeon
-- @return table Processed dungeon data with calculated counts
function Data:GetProcessedDungeon(dungeonName)
    local dungeon = dungeons[dungeonName]
    if not dungeon then
        return nil
    end
    
    -- Create a copy with calculated counts
    local processed = {
        texture = dungeon.texture,
        packData = {}
    }
    
    for i, pack in ipairs(dungeon.packData) do
        local processedPack = {
            id = pack.id,
            x = pack.x,
            y = pack.y,
            mobs = pack.mobs,
            count = self:CalculatePackCount(pack.mobs)
        }
        tinsert(processed.packData, processedPack)
    end
    
    return processed
end

--- Get total available forces for a dungeon
-- @param dungeonName string Name of the dungeon
-- @return number Total enemy forces count (decimal)
function Data:GetDungeonTotalForces(dungeonName)
    local dungeon = dungeons[dungeonName]
    if not dungeon or not dungeon.packData then
        return 0
    end
    
    local total = 0
    for _, pack in ipairs(dungeon.packData) do
        total = total + self:CalculatePackCount(pack.mobs)
    end
    return total
end

--- Get required enemy forces count to complete dungeon (100%)
-- @param dungeonName string Name of the dungeon
-- @return number Required count for 100% completion
function Data:GetDungeonRequiredCount(dungeonName)
    local dungeon = dungeons[dungeonName]
    if not dungeon then
        return 100  -- Default to 100
    end
    return dungeon.totalCount or 100
end

--- Get number of packs in a dungeon
-- @param dungeonName string Name of the dungeon
-- @return number Number of packs
function Data:GetDungeonPackCount(dungeonName)
    local dungeon = dungeons[dungeonName]
    if not dungeon or not dungeon.packData then
        return 0
    end
    return #dungeon.packData
end

--- Add a custom dungeon (for future user-created dungeons)
-- @param dungeonName string Name of the dungeon
-- @param dungeonData table Dungeon data structure
-- @return boolean Success status
function Data:AddDungeon(dungeonName, dungeonData)
    if type(dungeonName) ~= "string" or dungeonName == "" then
        if RDT.PrintError then
            RDT:PrintError("Invalid dungeon name")
        end
        return false
    end
    
    if type(dungeonData) ~= "table" then
        if RDT.PrintError then
            RDT:PrintError("Invalid dungeon data")
        end
        return false
    end
    
    if dungeons[dungeonName] then
        if RDT.Print then
            RDT:Print("Warning: Overwriting existing dungeon '" .. dungeonName .. "'")
        end
    end
    
    dungeons[dungeonName] = dungeonData
    return true
end

--------------------------------------------------------------------------------
-- Data Validation
--------------------------------------------------------------------------------

--- Validate a pack data entry
-- @param pack table Pack data {id, x, y, mobs}
-- @return boolean isValid, string errorMessage
local function ValidatePack(pack)
    if type(pack) ~= "table" then
        return false, "Pack is not a table"
    end
    
    if type(pack.id) ~= "number" then
        return false, "Pack ID must be a number"
    end
    
    if type(pack.x) ~= "number" or pack.x < 0 or pack.x > 1 then
        return false, string.format("Pack %d has invalid x coordinate: %s", pack.id, tostring(pack.x))
    end
    
    if type(pack.y) ~= "number" or pack.y < 0 or pack.y > 1 then
        return false, string.format("Pack %d has invalid y coordinate: %s", pack.id, tostring(pack.y))
    end
    
    if type(pack.mobs) ~= "table" then
        return false, string.format("Pack %d has invalid mobs table", pack.id)
    end
    
    -- Validate mob references
    for mobKey, quantity in pairs(pack.mobs) do
        if type(mobKey) ~= "string" then
            return false, string.format("Pack %d has invalid mob key type", pack.id)
        end
        
        if not mobDatabase[mobKey] then
            return false, string.format("Pack %d references unknown mob: %s", pack.id, mobKey)
        end
        
        if type(quantity) ~= "number" or quantity < 0 then
            return false, string.format("Pack %d has invalid mob quantity for %s", pack.id, mobKey)
        end
    end
    
    return true, nil
end

--- Validate dungeon data structure
-- @param dungeonName string Name of the dungeon
-- @param dungeonData table Dungeon data
-- @return boolean isValid, string errorMessage
function Data:ValidateDungeon(dungeonName, dungeonData)
    if type(dungeonData) ~= "table" then
        return false, "Dungeon data is not a table"
    end
    
    if type(dungeonData.texture) ~= "string" then
        return false, "Dungeon missing texture path"
    end
    
    if type(dungeonData.packData) ~= "table" then
        return false, "Dungeon missing packData table"
    end
    
    if #dungeonData.packData == 0 then
        return false, "Dungeon has no packs defined"
    end
    
    -- Validate each pack
    local packIds = {}
    for i, pack in ipairs(dungeonData.packData) do
        local isValid, err = ValidatePack(pack)
        if not isValid then
            return false, string.format("%s (pack index %d)", err, i)
        end
        
        -- Check for duplicate IDs
        if packIds[pack.id] then
            return false, string.format("Duplicate pack ID: %d", pack.id)
        end
        packIds[pack.id] = true
    end
    
    return true, nil
end

--- Validate all dungeons
-- @return boolean Success status
function Data:ValidateAll()
    local hasErrors = false
    
    for name, data in pairs(dungeons) do
        local isValid, err = self:ValidateDungeon(name, data)
        if not isValid then
            if RDT.PrintError then
                RDT:PrintError(string.format("Dungeon '%s' validation failed: %s", name, err))
            end
            hasErrors = true
        end
    end
    
    if not hasErrors then
        if RDT.DebugPrint then
            RDT:DebugPrint(string.format("Validated %d dungeons successfully", self:GetDungeonCount()))
        end
    end
    
    return not hasErrors
end

--- Get total number of dungeons
-- @return number Number of dungeons
function Data:GetDungeonCount()
    local count = 0
    for _ in pairs(dungeons) do
        count = count + 1
    end
    return count
end

--------------------------------------------------------------------------------
-- Data Export (for addon developers)
--------------------------------------------------------------------------------

--- Export dungeon data as Lua table string (for debugging/sharing)
-- @param dungeonName string Name of the dungeon
-- @return string Lua code representing the dungeon
function Data:ExportDungeonAsLua(dungeonName)
    local dungeon = dungeons[dungeonName]
    if not dungeon then
        return nil
    end
    
    local lines = {
        string.format('dungeons["%s"] = {', dungeonName),
        string.format('    texture = "%s",', dungeon.texture),
        '    packData = {',
    }
    
    for _, pack in ipairs(dungeon.packData) do
        tinsert(lines, string.format('        {'))
        tinsert(lines, string.format('            id = %d,', pack.id))
        tinsert(lines, string.format('            x = %.2f,', pack.x))
        tinsert(lines, string.format('            y = %.2f,', pack.y))
        tinsert(lines, string.format('            mobs = {'))
        
        for mobKey, quantity in pairs(pack.mobs) do
            tinsert(lines, string.format('                ["%s"] = %d,', mobKey, quantity))
        end
        
        tinsert(lines, string.format('            },'))
        tinsert(lines, string.format('        },'))
    end
    
    tinsert(lines, '    },')
    tinsert(lines, '}')
    
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Statistics
--------------------------------------------------------------------------------

--- Get statistics about all dungeons
-- @return table Statistics table
function Data:GetStatistics()
    local stats = {
        totalDungeons = 0,
        totalPacks = 0,
        totalForces = 0,
        avgPacksPerDungeon = 0,
        avgForcesPerDungeon = 0,
        totalMobTypes = 0,
    }
    
    for name, data in pairs(dungeons) do
        stats.totalDungeons = stats.totalDungeons + 1
        local packCount = #(data.packData or {})
        stats.totalPacks = stats.totalPacks + packCount
        stats.totalForces = stats.totalForces + self:GetDungeonTotalForces(name)
    end
    
    -- Count mob types
    for _ in pairs(mobDatabase) do
        stats.totalMobTypes = stats.totalMobTypes + 1
    end
    
    if stats.totalDungeons > 0 then
        stats.avgPacksPerDungeon = stats.totalPacks / stats.totalDungeons
        stats.avgForcesPerDungeon = stats.totalForces / stats.totalDungeons
    end
    
    return stats
end

--------------------------------------------------------------------------------
-- Debug Commands
--------------------------------------------------------------------------------

--- Print dungeon information
-- @param dungeonName string Name of the dungeon
function Data:PrintDungeonInfo(dungeonName)
    local dungeon = self:GetDungeon(dungeonName)
    if not dungeon then
        if RDT.PrintError then
            RDT:PrintError("Dungeon not found: " .. tostring(dungeonName))
        end
        return
    end
    
    if RDT.Print then
        local totalForces = self:GetDungeonTotalForces(dungeonName)
        local requiredCount = self:GetDungeonRequiredCount(dungeonName)
        local percentage = (totalForces / requiredCount) * 100
        
        RDT:Print(string.format("Dungeon: %s", dungeonName))
        RDT:Print(string.format("  Packs: %d", #dungeon.packData))
        RDT:Print(string.format("  Total Forces: %.1f/%.0f (%.1f%%)", totalForces, requiredCount, percentage))
        RDT:Print(string.format("  Texture: %s", dungeon.texture))
    end
end

--- Print all dungeon names
function Data:PrintDungeonList()
    local names = self:GetDungeonNames()
    if RDT.Print then
        RDT:Print(string.format("Available Dungeons (%d):", #names))
        for _, name in ipairs(names) do
            local packCount = self:GetDungeonPackCount(name)
            local totalForces = self:GetDungeonTotalForces(name)
            local requiredCount = self:GetDungeonRequiredCount(name)
            local percentage = (totalForces / requiredCount) * 100
            RDT:Print(string.format("  - %s (%d packs, %.1f/%.0f forces = %.1f%%)", name, packCount, totalForces, requiredCount, percentage))
        end
    end
end

--- Print pack details (including mob composition)
-- @param dungeonName string Name of the dungeon
-- @param packId number Pack ID to inspect
function Data:PrintPackInfo(dungeonName, packId)
    local dungeon = self:GetDungeon(dungeonName)
    if not dungeon then
        if RDT.PrintError then
            RDT:PrintError("Dungeon not found: " .. tostring(dungeonName))
        end
        return
    end
    
    local pack = nil
    for _, p in ipairs(dungeon.packData) do
        if p.id == packId then
            pack = p
            break
        end
    end
    
    if not pack then
        if RDT.PrintError then
            RDT:PrintError("Pack not found: " .. tostring(packId))
        end
        return
    end
    
    if RDT.Print then
        RDT:Print(string.format("Pack %d:", packId))
        RDT:Print(string.format("  Position: (%.2f, %.2f)", pack.x, pack.y))
        RDT:Print(string.format("  Total Count: %.1f", self:CalculatePackCount(pack.mobs)))
        RDT:Print("  Mobs:")
        
        for mobKey, quantity in pairs(pack.mobs) do
            local mobDef = mobDatabase[mobKey]
            if mobDef then
                RDT:Print(string.format("    - %dx %s (%.1f each = %.1f total)", 
                    quantity, mobDef.name, mobDef.count, quantity * mobDef.count))
            else
                RDT:Print(string.format("    - %dx %s (UNKNOWN MOB)", quantity, mobKey))
            end
        end
    end
end

-- Module loaded message
if RDT.DebugPrint then
    local stats = Data:GetStatistics()
    RDT:DebugPrint(string.format("Data.lua loaded: %d dungeons, %d mob types", 
        Data:GetDungeonCount(), stats.totalMobTypes))
end
