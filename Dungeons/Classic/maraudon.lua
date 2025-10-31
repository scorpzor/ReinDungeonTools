local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--------------------------------------------------------------------------------
-- Mob Definitions
--------------------------------------------------------------------------------

--local mobs = {
--    ["trash"] = {
--        name = "Trash",
--        count = 0.5,
--        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
--        scale = 0.7,
--    },
--}
--
--RDT.Data:RegisterMobs(mobs)

--------------------------------------------------------------------------------
-- Map Definitions
--------------------------------------------------------------------------------

local tilesDefinition = {
    tileWidth = 512,
    tileHeight = 512,
    cols = 3,
    rows = 2,
    tiles = {
        "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\maraudon\\tile_0",
        "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\maraudon\\tile_1",
        "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\maraudon\\tile_2",
        "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\maraudon\\tile_3",
        "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\maraudon\\tile_4",
        "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\maraudon\\tile_5",
    }
}

local packDefinition = {
    {
        id = 1,
        x = 0.1,
        y = 0.1,
        mobs = {
            ["generic_elite_mob"] = 1,
        }
    }
}

local mapOrangeCrystalsDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition
}

local mapPristineWatersDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition
}

local mapPurpleCrystalsDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition
}

RDT.Data:RegisterDungeon("Maraudon Orange Crystals", mapOrangeCrystalsDefinition)
RDT:DebugPrint("Loaded dungeon module: Maraudon Orange Crystals")

RDT.Data:RegisterDungeon("Maraudon Pristine Waters", mapPristineWatersDefinition)
RDT:DebugPrint("Loaded dungeon module: Maraudon Pristine Waters")

RDT.Data:RegisterDungeon("Maraudon Purple Crystals", mapPurpleCrystalsDefinition)
RDT:DebugPrint("Loaded dungeon module: Maraudon Purple Crystals")