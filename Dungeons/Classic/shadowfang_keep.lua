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
        cols = 9,
        rows = 6,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_5",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_6",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_7",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_8",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_9",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_10",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_11",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_12",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_13",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_14",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_15",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_16",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_17",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_18",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_19",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_20",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_21",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_22",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_23",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_24",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_25",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_26",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_27",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_28",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_29",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_30",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_31",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_32",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_33",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_34",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_35",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_36",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_37",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_38",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_39",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_40",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_41",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_42",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_43",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_44",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_45",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_46",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_47",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_48",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_49",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_50",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_51",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_52",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\shadowfang_keep\\tile_53",
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

RDT.Data:RegisterDungeon("Shadowfang Keep", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Shadowfang Keep")
