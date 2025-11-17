local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--local mobs = {
--    [""] = {
--        name = "",
--        count = 0.5,
--        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\",
--        scale = 0.7,
--    },
--}

--local bosses = {
--    ["rtdos_boss_"] = {
--        name = "",
--        count = 2,
--        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\",
--        scale = 1.25,
--    },
--}

--RDT.Data:RegisterMobs(mobs)
--RDT.Data:RegisterMobs(bosses)

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.1,
            y = 0.1,
            mobs = {
                ["generic_trash_mob"] = 1,
            }
        },
        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.257,
            y = 0.606,
            mobs = {
                ["generic_boss"] = 1,
            }
        },
    },
    identifiers = {
        {
            id = 1,
            type = "dungeon-entrance",
            x = 0.2,
            y = 0.1,
            name = "Entrance Portal",
            description = "Main entrance",
        },
    },
}

RDT.Data:RegisterDungeon("Road to De Other Side", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Road to De Other Side")
