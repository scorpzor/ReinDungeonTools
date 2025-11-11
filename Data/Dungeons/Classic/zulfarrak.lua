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

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\zulfarrak\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\zulfarrak\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\zulfarrak\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\zulfarrak\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\zulfarrak\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\zulfarrak\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.5,
            y = 0.15,
            mobs = {
                ["generic_trash_mob"] = 2,
                ["generic_elite_mob"] = 1,
            }
        },
        {
            id = 2,
            x = 0.45,
            y = 0.25,
            mobs = {
                ["generic_trash_mob"] = 3,
                ["generic_elite_mob"] = 1,
                ["generic_big_mob"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Zulfarrak", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Zulfarrak")
