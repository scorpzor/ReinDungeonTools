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
        tileWidth = 256,
        tileHeight = 256,
        cols = 9,
        rows = 6,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_5",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_6",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_7",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_8",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_9",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_10",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_11",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_12",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_13",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_14",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_15",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_16",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_17",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_18",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_19",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_20",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_21",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_22",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_23",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_24",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_25",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_26",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_27",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_28",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_29",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_30",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_31",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_32",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_33",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_34",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_35",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_36",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_37",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_38",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_39",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_40",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_41",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_42",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_43",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_44",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_45",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_46",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_47",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_48",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_49",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_50",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_51",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_52",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_west\\tile_53",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.1,
            y = 0.1,
            mobs = {
                ["generic_elite_mob"] = 1,
            }
        }
    },
}

RDT.Data:RegisterDungeon("Dire Maul West", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul West")
