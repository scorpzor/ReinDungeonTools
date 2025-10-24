-- Data.lua
-- Dungeon definitions and data management module
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

--------------------------------------------------------------------------------
-- Example Dungeon: Test Dungeon
--------------------------------------------------------------------------------

dungeons["Test Dungeon"] = {
    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\TestDungeon",
    packData = {
        -- Format: {id, x, y, count}
        -- x, y are coordinates from 0.0 to 1.0 (percentage of map width/height)
        -- count is enemy forces percentage
        {id = 1, x = 0.2, y = 0.3, count = 5},
        {id = 2, x = 0.3, y = 0.4, count = 7},
        {id = 3, x = 0.5, y = 0.5, count = 8},
        {id = 4, x = 0.6, y = 0.3, count = 6},
        {id = 5, x = 0.7, y = 0.6, count = 10},
        {id = 6, x = 0.4, y = 0.7, count = 9},
        {id = 7, x = 0.8, y = 0.4, count = 11},
        {id = 8, x = 0.3, y = 0.6, count = 7},
        {id = 9, x = 0.6, y = 0.7, count = 12},
        {id = 10, x = 0.5, y = 0.3, count = 8},
    },
}

--------------------------------------------------------------------------------
-- Example Dungeon: Utgarde Keep (WotLK Heroic)
--------------------------------------------------------------------------------

dungeons["Utgarde Keep"] = {
    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\UtgardeKeep",
    packData = {
        -- First room
        {id = 1, x = 0.5, y = 0.15, count = 8},   -- Entrance pack
        {id = 2, x = 0.45, y = 0.25, count = 10}, -- Left patrol
        {id = 3, x = 0.55, y = 0.25, count = 10}, -- Right patrol
        
        -- Before first boss
        {id = 4, x = 0.5, y = 0.35, count = 12},  -- Large pack
        {id = 5, x = 0.4, y = 0.4, count = 7},    -- Side pack left
        {id = 6, x = 0.6, y = 0.4, count = 7},    -- Side pack right
        
        -- After first boss
        {id = 7, x = 0.5, y = 0.5, count = 9},    -- Corridor pack
        {id = 8, x = 0.45, y = 0.55, count = 11}, -- Dragon whelps left
        {id = 9, x = 0.55, y = 0.55, count = 11}, -- Dragon whelps right
        
        -- Before second boss
        {id = 10, x = 0.5, y = 0.65, count = 10}, -- Proto-drakes
        {id = 11, x = 0.4, y = 0.7, count = 8},   -- Small pack
        
        -- Final area
        {id = 12, x = 0.5, y = 0.8, count = 13},  -- Large pack before final boss
    },
}

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
        total = total + (pack.count or 0)
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
-- @param pack table Pack data {id, x, y, count}
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
    
    if type(pack.count) ~= "number" or pack.count < 0 then
        return false, string.format("Pack %d has invalid count: %s", pack.id, tostring(pack.count))
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
        tinsert(lines, string.format(
            '        {id = %d, x = %.2f, y = %.2f, count = %d},',
            pack.id, pack.x, pack.y, pack.count
        ))
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
    }
    
    for name, data in pairs(dungeons) do
        stats.totalDungeons = stats.totalDungeons + 1
        local packCount = #(data.packData or {})
        stats.totalPacks = stats.totalPacks + packCount
        stats.totalForces = stats.totalForces + self:GetDungeonTotalForces(name)
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

-- Module loaded message
if RDT.DebugPrint then
    RDT:DebugPrint("Data.lua loaded with " .. Data:GetDungeonCount() .. " dungeons")
end
