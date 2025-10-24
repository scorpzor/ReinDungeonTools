-- Data.lua
-- Dungeon definitions and data management module with mob dictionary support
-- NOTE: This file loads AFTER Core/Init.lua, so RDT object already exists

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
-- Each mob has: name, count (enemy forces %), creatureId (optional), displayIcon (optional), scale (optional)
-- displayIcon can be: SetPortraitTexture for 3D portrait, or explicit texture path
-- If no displayIcon, defaults to question mark icon
-- scale: visual size multiplier (0.6-1.0), defaults to 1.0. Smaller scale = less important mob
local mobDatabase = {
    -- Example mobs for Test Dungeon
    ["test_trash_1"] = {
        name = "Weak Trash Mob",
        count = 2,
        creatureId = 10001,
        displayIcon = "Interface\\Icons\\INV_Misc_QuestionMark",
        scale = 0.7, -- Small weak mob
    },
    ["test_trash_2"] = {
        name = "Strong Trash Mob", 
        count = 3,
        creatureId = 10002,
        displayIcon = "Interface\\Icons\\Ability_Warrior_Savageblow",
        scale = 0.9, -- Medium sized
    },
    ["test_elite"] = {
        name = "Elite Guard",
        count = 5,
        creatureId = 10003,
        displayIcon = "Interface\\Icons\\Achievement_Character_Human_Male",
        scale = 1.0, -- Full size elite
    },
    
    -- Utgarde Keep mobs (using thematic WotLK icons)
    ["uk_vrykul_warrior"] = {
        name = "Vrykul Warrior",
        count = 4,
        creatureId = 23970,
        displayIcon = "Interface\\Icons\\INV_Sword_68", -- Warrior sword
        scale = 0.9, -- Medium elite
    },
    ["uk_vrykul_necromancer"] = {
        name = "Vrykul Necromancer",
        count = 4,
        creatureId = 23954,
        displayIcon = "Interface\\Icons\\Spell_Shadow_AnimateDead", -- Necromancer
        scale = 1.0, -- Dangerous caster - full size
    },
    ["uk_dragonflayer_forge_master"] = {
        name = "Dragonflayer Forge Master",
        count = 4,
        creatureId = 24079,
        displayIcon = "Interface\\Icons\\INV_Hammer_20", -- Blacksmith hammer
        scale = 0.85, -- Medium threat
    },
    ["uk_dragonflayer_runecaster"] = {
        name = "Dragonflayer Runecaster",
        count = 4,
        creatureId = 23960,
        displayIcon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain", -- Caster
        scale = 1.0, -- Dangerous caster - full size
    },
    ["uk_dragonflayer_ironhelm"] = {
        name = "Dragonflayer Ironhelm",
        count = 4,
        creatureId = 23961,
        displayIcon = "Interface\\Icons\\INV_Helmet_08", -- Helmet
        scale = 0.85, -- Medium threat
    },
    ["uk_proto_drake"] = {
        name = "Proto-Drake",
        count = 4,
        creatureId = 24082,
        displayIcon = "Interface\\Icons\\Ability_Mount_Drake_Proto", -- Drake mount
        scale = 1.0, -- Big dangerous drake - full size
    },
    ["uk_tunneling_ghoul"] = {
        name = "Tunneling Ghoul",
        count = 1,
        creatureId = 23632,
        displayIcon = "Interface\\Icons\\Spell_Shadow_RaiseDead", -- Ghoul
        scale = 0.65, -- Small trash mob
    },
    ["uk_dragonflayer_bonecrusher"] = {
        name = "Dragonflayer Bonecrusher",
        count = 4,
        creatureId = 24069,
        displayIcon = "Interface\\Icons\\INV_Mace_12", -- Mace/crusher
        scale = 0.9, -- Medium elite
    },
    ["uk_savage_worg"] = {
        name = "Savage Worg",
        count = 1,
        creatureId = 23644,
        displayIcon = "Interface\\Icons\\Ability_Mount_WhiteDireWolf", -- Worg/wolf
        scale = 0.65, -- Small trash mob
    },
}

--------------------------------------------------------------------------------
-- Example Dungeon: Test Dungeon
--------------------------------------------------------------------------------

dungeons["Test Dungeon"] = {
    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\TestDungeon",
    packData = {
        -- New format: {id, x, y, mobs = {mobKey = count}}
        -- Pack count is auto-calculated from mob counts
        {
            id = 1, 
            x = 0.2, 
            y = 0.3, 
            mobs = {
                ["test_trash_1"] = 2,  -- 2 weak trash (2 * 2 = 4%)
                ["test_trash_2"] = 1,  -- 1 strong trash (1 * 3 = 3%)
            }
            -- Total: 7%
        },
        {
            id = 2, 
            x = 0.3, 
            y = 0.4, 
            mobs = {
                ["test_trash_2"] = 2,  -- 2 strong trash (2 * 3 = 6%)
                ["test_elite"] = 1,     -- 1 elite (1 * 5 = 5%)
            }
            -- Total: 11%
        },
        {
            id = 3, 
            x = 0.5, 
            y = 0.5, 
            mobs = {
                ["test_elite"] = 2,     -- 2 elites (2 * 5 = 10%)
            }
            -- Total: 10%
        },
        {
            id = 4, 
            x = 0.6, 
            y = 0.3, 
            mobs = {
                ["test_trash_1"] = 3,  -- 3 weak trash (3 * 2 = 6%)
            }
            -- Total: 6%
        },
        {
            id = 5, 
            x = 0.7, 
            y = 0.6, 
            mobs = {
                ["test_trash_2"] = 2,  -- 2 strong trash (2 * 3 = 6%)
                ["test_elite"] = 1,     -- 1 elite (1 * 5 = 5%)
            }
            -- Total: 11%
        },
        {
            id = 6, 
            x = 0.4, 
            y = 0.7, 
            mobs = {
                ["test_trash_1"] = 1,  -- 1 weak trash (1 * 2 = 2%)
                ["test_trash_2"] = 2,  -- 2 strong trash (2 * 3 = 6%)
                ["test_elite"] = 1,     -- 1 elite (1 * 5 = 5%)
            }
            -- Total: 13%
        },
        {
            id = 7, 
            x = 0.8, 
            y = 0.4, 
            mobs = {
                ["test_elite"] = 2,     -- 2 elites (2 * 5 = 10%)
                ["test_trash_2"] = 1,  -- 1 strong trash (1 * 3 = 3%)
            }
            -- Total: 13%
        },
        {
            id = 8, 
            x = 0.3, 
            y = 0.6, 
            mobs = {
                ["test_trash_1"] = 4,  -- 4 weak trash (4 * 2 = 8%)
            }
            -- Total: 8%
        },
        {
            id = 9, 
            x = 0.6, 
            y = 0.7, 
            mobs = {
                ["test_trash_2"] = 3,  -- 3 strong trash (3 * 3 = 9%)
                ["test_elite"] = 1,     -- 1 elite (1 * 5 = 5%)
            }
            -- Total: 14%
        },
        {
            id = 10, 
            x = 0.5, 
            y = 0.3, 
            mobs = {
                ["test_trash_1"] = 2,  -- 2 weak trash (2 * 2 = 4%)
                ["test_trash_2"] = 1,  -- 1 strong trash (1 * 3 = 3%)
            }
            -- Total: 7%
        },
    },
}

--------------------------------------------------------------------------------
-- Example Dungeon: Utgarde Keep (WotLK Heroic)
--------------------------------------------------------------------------------

dungeons["Utgarde Keep"] = {
    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\UtgardeKeep",
    packData = {
        -- First room
        {
            id = 1, 
            x = 0.5, 
            y = 0.15, 
            mobs = {
                ["uk_vrykul_warrior"] = 2,      -- 2 warriors (2 * 4 = 8%)
                ["uk_tunneling_ghoul"] = 3,     -- 3 ghouls (3 * 1 = 3%)
            }
            -- Total: 11%
        },
        {
            id = 2, 
            x = 0.45, 
            y = 0.25, 
            mobs = {
                ["uk_vrykul_warrior"] = 1,           -- 1 warrior (1 * 4 = 4%)
                ["uk_vrykul_necromancer"] = 1,       -- 1 necromancer (1 * 4 = 4%)
                ["uk_dragonflayer_ironhelm"] = 1,    -- 1 ironhelm (1 * 4 = 4%)
            }
            -- Total: 12%
        },
        {
            id = 3, 
            x = 0.55, 
            y = 0.25, 
            mobs = {
                ["uk_dragonflayer_runecaster"] = 2,  -- 2 runecasters (2 * 4 = 8%)
                ["uk_dragonflayer_ironhelm"] = 1,    -- 1 ironhelm (1 * 4 = 4%)
            }
            -- Total: 12%
        },
        
        -- Before first boss
        {
            id = 4, 
            x = 0.5, 
            y = 0.35, 
            mobs = {
                ["uk_dragonflayer_bonecrusher"] = 2, -- 2 bonecrusher (2 * 4 = 8%)
                ["uk_savage_worg"] = 4,              -- 4 worgs (4 * 1 = 4%)
            }
            -- Total: 12%
        },
        {
            id = 5, 
            x = 0.4, 
            y = 0.4, 
            mobs = {
                ["uk_vrykul_necromancer"] = 1,       -- 1 necromancer (1 * 4 = 4%)
                ["uk_tunneling_ghoul"] = 5,          -- 5 ghouls (5 * 1 = 5%)
            }
            -- Total: 9%
        },
        {
            id = 6, 
            x = 0.6, 
            y = 0.4, 
            mobs = {
                ["uk_dragonflayer_forge_master"] = 1, -- 1 forge master (1 * 4 = 4%)
                ["uk_dragonflayer_ironhelm"] = 1,     -- 1 ironhelm (1 * 4 = 4%)
            }
            -- Total: 8%
        },
        
        -- After first boss
        {
            id = 7, 
            x = 0.5, 
            y = 0.5, 
            mobs = {
                ["uk_vrykul_warrior"] = 2,           -- 2 warriors (2 * 4 = 8%)
                ["uk_savage_worg"] = 2,              -- 2 worgs (2 * 1 = 2%)
            }
            -- Total: 10%
        },
        {
            id = 8, 
            x = 0.45, 
            y = 0.55, 
            mobs = {
                ["uk_proto_drake"] = 2,              -- 2 proto-drakes (2 * 4 = 8%)
                ["uk_dragonflayer_runecaster"] = 1,  -- 1 runecaster (1 * 4 = 4%)
            }
            -- Total: 12%
        },
        {
            id = 9, 
            x = 0.55, 
            y = 0.55, 
            mobs = {
                ["uk_proto_drake"] = 2,              -- 2 proto-drakes (2 * 4 = 8%)
                ["uk_dragonflayer_ironhelm"] = 1,    -- 1 ironhelm (1 * 4 = 4%)
            }
            -- Total: 12%
        },
        
        -- Before second boss
        {
            id = 10, 
            x = 0.5, 
            y = 0.65, 
            mobs = {
                ["uk_proto_drake"] = 3,              -- 3 proto-drakes (3 * 4 = 12%)
            }
            -- Total: 12%
        },
        {
            id = 11, 
            x = 0.4, 
            y = 0.7, 
            mobs = {
                ["uk_dragonflayer_bonecrusher"] = 2, -- 2 bonecrusher (2 * 4 = 8%)
            }
            -- Total: 8%
        },
        
        -- Final area
        {
            id = 12, 
            x = 0.5, 
            y = 0.8, 
            mobs = {
                ["uk_vrykul_warrior"] = 2,           -- 2 warriors (2 * 4 = 8%)
                ["uk_vrykul_necromancer"] = 1,       -- 1 necromancer (1 * 4 = 4%)
                ["uk_dragonflayer_ironhelm"] = 1,    -- 1 ironhelm (1 * 4 = 4%)
            }
            -- Total: 16%
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
-- @return number Total enemy forces percentage
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
-- @return number Total enemy forces percentage
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
        RDT:Print(string.format("Dungeon: %s", dungeonName))
        RDT:Print(string.format("  Packs: %d", #dungeon.packData))
        RDT:Print(string.format("  Total Forces: %d%%", self:GetDungeonTotalForces(dungeonName)))
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
            RDT:Print(string.format("  - %s (%d packs, %d%% forces)", name, packCount, totalForces))
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
        RDT:Print(string.format("  Total Count: %d%%", self:CalculatePackCount(pack.mobs)))
        RDT:Print("  Mobs:")
        
        for mobKey, quantity in pairs(pack.mobs) do
            local mobDef = mobDatabase[mobKey]
            if mobDef then
                RDT:Print(string.format("    - %dx %s (%d%% each = %d%% total)", 
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
