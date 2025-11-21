local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["brc_twilight_flame_caller"] = {
        name = "Twilight Flame Caller",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_flame_caller",
        scale = 0.7,
    },
    ["brc_twilight_torturer"] = {
        name = "Twilight Torturer",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_torturer",
        scale = 0.7,
    },
    ["brc_twilight_sadist"] = {
        name = "Twilight Sadist",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_sadist",
        scale = 0.7,
    },
    ["brc_mad_prisoner"] = {
        name = "Mad Prisoner",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\mad_prisoner",
        scale = 0.7,
    },
    ["brc_crazed_mage"] = {
        name = "Crazed Mage",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crazed_mage",
        scale = 0.7,
    },
    ["brc_evolved_twilight_zealot"] = {
        name = "Evolved Twilight Zealot",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\evolved_twilight_zealot",
        scale = 0.7,
    },
}

local bosses = {
    ["brc_boss_romogg_bonecrusher"] = {
        name = "Rom'ogg Bonecrusher",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\romogg_bonecrusher",
        scale = 1.25,
    },
}

RDT.Data:RegisterMobs(mobs)
RDT.Data:RegisterMobs(bosses)

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_caverns\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_caverns\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_caverns\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_caverns\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_caverns\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_caverns\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.127,
            y = 0.664,
            mobs = {
                ["brc_twilight_flame_caller"] = 1,
            }
        },
        {
            id = 2,
            x = 0.127,
            y = 0.752,
            mobs = {
                ["brc_twilight_flame_caller"] = 1,
            }
        },
        {
            id = 3,
            x = 0.181,
            y = 0.719,
            mobs = {
                ["brc_twilight_flame_caller"] = 2,
            },
            patrol = {
                {x = 0.149, y = 0.707},
                {x = 0.181, y = 0.719},
                {x = 0.222, y = 0.725},
            }
        },
        {
            id = 4,
            x = 0.211,
            y = 0.659,
            mobs = {
                ["brc_twilight_torturer"] = 1,
                ["brc_twilight_sadist"] = 1,
                ["brc_crazed_mage"] = 1,
            }
        },

        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.260,
            y = 0.686,
            mobs = {
                ["brc_boss_romogg_bonecrusher"] = 1,
            },
            patrol = {
                {x = 0.260, y = 0.686},
                {x = 0.279, y = 0.707},
                {x = 0.297, y = 0.645},
            }
        },
    },
}

RDT.Data:RegisterDungeon("Blackrock Caverns", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Blackrock Caverns")
