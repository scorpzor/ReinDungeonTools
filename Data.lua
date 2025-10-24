-- Dungeon data and validation
local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- Data module
RDT.Data = {}
local Data = RDT.Data

-- Dungeon definitions
-- packData uses normalized x,y (0-1) coords
-- 'count' = enemy forces percentage
local Dungeons = {
    ["Test Dungeon"] = {
        texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\TestDungeon",
        packData = {
            {id=1, x=0.08, y=0.85, count=5},
            {id=2, x=0.18, y=0.82, count=8},
            {id=3, x=0.12, y=0.78, count=6},
            {id=4, x=0.22, y=0.75, count=10},
            {id=5, x=0.28, y=0.72, count=7},
            {id=6, x=0.32, y=0.68, count=9},
            {id=7, x=0.38, y=0.82, count=5},
            {id=8, x=0.42, y=0.78, count=8},
            {id=9, x=0.48, y=0.75, count=6},
            {id=10, x=0.52, y=0.72, count=10},
            {id=11, x=0.58, y=0.68, count=7},
            {id=12, x=0.62, y=0.65, count=9},
            {id=13, x=0.68, y=0.62, count=5},
            {id=14, x=0.72, y=0.58, count=8},
            {id=15, x=0.78, y=0.55, count=6},
            {id=16, x=0.82, y=0.52, count=10},
            {id=17, x=0.88, y=0.48, count=7},
            {id=18, x=0.92, y=0.45, count=9},
            {id=19, x=0.15, y=0.45, count=5},
            {id=20, x=0.25, y=0.38, count=8},
            -- Total: 148%
        }
    },
    ["Utgarde Keep"] = {
        texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\UtgardeKeep",
        packData = {
            {id=1, x=0.10, y=0.90, count=15},
            {id=2, x=0.20, y=0.85, count=20},
            {id=3, x=0.30, y=0.80, count=18},
            {id=4, x=0.40, y=0.75, count=25},
            {id=5, x=0.50, y=0.70, count=22},
            -- Total: 100%
        }
    },
    -- Add more dungeons here:
    -- ["Dungeon Name"] = {
    --     texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\DungeonName",
    --     packData = {
    --         {id=1, x=0.5, y=0.5, count=10},
    --         ...
    --     }
    -- },
}

-- Validate a single pack's data
local function ValidatePack(dungeonName, pack, packIndex)
    local errors = {}
    
    -- Check ID
    if not pack.id then
        tinsert(errors, string.format("Pack #%d missing id", packIndex))
    end
    
    -- Check coordinates
    if not pack.x or type(pack.x) ~= "number" or pack.x < 0 or pack.x > 1 then
        tinsert(errors, string.format("Pack %s has invalid x coordinate: %s", 
            tostring(pack.id or packIndex), tostring(pack.x)))
    end
    
    if not pack.y or type(pack.y) ~= "number" or pack.y < 0 or pack.y > 1 then
        tinsert(errors, string.format("Pack %s has invalid y coordinate: %s", 
            tostring(pack.id or packIndex), tostring(pack.y)))
    end
    
    -- Check count
    if not pack.count or type(pack.count) ~= "number" or pack.count < 0 then
        tinsert(errors, string.format("Pack %s has invalid count: %s", 
            tostring(pack.id or packIndex), tostring(pack.count)))
    end
    
    return errors
end

-- Validate all dungeon data
function Data:ValidateAll()
    local totalErrors = 0
    local totalWarnings = 0
    
    RDT:DebugPrint("Validating dungeon data...")
    
    for dungeonName, data in pairs(Dungeons) do
        -- Check texture
        if not data.texture or type(data.texture) ~= "string" then
            RDT:PrintError(string.format("Dungeon '%s' missing or invalid texture path", dungeonName))
            totalErrors = totalErrors + 1
        end
        
        -- Check packData
        if not data.packData or type(data.packData) ~= "table" then
            RDT:PrintError(string.format("Dungeon '%s' has invalid packData", dungeonName))
            totalErrors = totalErrors + 1
        elseif #data.packData == 0 then
            RDT:PrintError(string.format("Dungeon '%s' has no packs defined", dungeonName))
            totalWarnings = totalWarnings + 1
        else
            -- Validate each pack
            local packIds = {}
            local totalCount = 0
            
            for i, pack in ipairs(data.packData) do
                local packErrors = ValidatePack(dungeonName, pack, i)
                
                for _, err in ipairs(packErrors) do
                    RDT:PrintError(string.format("[%s] %s", dungeonName, err))
                    totalErrors = totalErrors + 1
                end
                
                -- Check for duplicate IDs
                if pack.id then
                    if packIds[pack.id] then
                        RDT:PrintError(string.format("[%s] Duplicate pack ID: %d", dungeonName, pack.id))
                        totalErrors = totalErrors + 1
                    else
                        packIds[pack.id] = true
                    end
                end
                
                -- Sum total forces
                if pack.count and type(pack.count) == "number" then
                    totalCount = totalCount + pack.count
                end
            end
            
            -- Report total enemy forces
            RDT:DebugPrint(string.format("[%s] Total enemy forces: %d%%", dungeonName, totalCount))
            
            if totalCount < 100 then
                RDT:PrintError(string.format("[%s] Total forces (%d%%) is less than 100%%", dungeonName, totalCount))
                totalWarnings = totalWarnings + 1
            end
        end
    end
    
    -- Summary
    if totalErrors > 0 then
        RDT:PrintError(string.format("Data validation found %d error(s) and %d warning(s)", totalErrors, totalWarnings))
    elseif totalWarnings > 0 then
        RDT:Print(string.format("Data validation found %d warning(s)", totalWarnings))
    else
        RDT:DebugPrint("Data validation passed with no errors")
    end
    
    return totalErrors == 0
end

-- Get list of all dungeon names
function Data:GetDungeonNames()
    local names = {}
    for name in pairs(Dungeons) do
        tinsert(names, name)
    end
    table.sort(names)
    return names
end

-- Get dungeon data by name
function Data:GetDungeon(name)
    return Dungeons[name]
end

-- Check if dungeon exists
function Data:DungeonExists(name)
    return Dungeons[name] ~= nil
end

-- Get total available enemy forces for a dungeon
function Data:GetDungeonTotalForces(name)
    local dungeon = Dungeons[name]
    if not dungeon or not dungeon.packData then return 0 end
    
    local total = 0
    for _, pack in ipairs(dungeon.packData) do
        if pack.count then
            total = total + pack.count
        end
    end
    return total
end