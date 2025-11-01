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
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_5",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_6",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_7",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_8",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_9",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_10",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_11",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_12",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_13",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_14",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_15",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_16",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_17",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_18",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_19",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_20",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_21",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_22",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_23",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_24",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_25",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_26",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_27",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_28",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_29",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_30",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_31",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_32",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_33",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_34",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_35",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_36",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_37",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_38",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_39",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_40",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_41",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_42",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_43",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_44",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_45",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_46",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_47",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_48",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_49",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_50",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_51",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_52",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\sunken_temple\\tile_53",
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

RDT.Data:RegisterDungeon("Sunken Temple", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Sunken Temple")
