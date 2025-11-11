local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

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

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_5",
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

RDT.Data:RegisterDungeon("Dire Maul East", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul East")
