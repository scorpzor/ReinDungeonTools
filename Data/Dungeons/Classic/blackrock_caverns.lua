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
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\evolved_twilight_zealot",
        scale = 0.7,
    },
    ["brc_twilight_zealot"] = {
        name = "Twilight Zealot",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_zealot",
        scale = 0.7,
    },
    ["brc_conflagration"] = {
        name = "Conflagration",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\conflagration",
        scale = 0.7,
    },
    ["brc_twilight_obsidian_borer"] = {
        name = "Twilight Obsidian Borer",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_obsidian_borer",
        scale = 0.7,
    },
    ["brc_twilight_element_warden"] = {
        name = "Twilight Element Warden",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_element_warden",
        scale = 0.7,
    },
    ["brc_incendiary_spark"] = {
        name = "Incendiary Spark",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\incendiary_spark",
        scale = 0.7,
    },
    ["brc_defiled_earth_ravager"] = {
        name = "Defiled Earth Ravager",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defiled_earth_ravager",
        scale = 0.7,
    },
    ["brc_bellows_slave"] = {
        name = "Bellows Slave",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\bellows_slave",
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
    ["brc_boss_corla_herald_of_twilight"] = {
        name = "Corla, Herald of Twilight",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\corla_herald_of_twilight",
        scale = 1.25,
    },
    ["brc_boss_karsh_steelbender"] = {
        name = "Karsh Steelbender",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\karsh_steelbender",
        scale = 1.25,
    },
    ["brc_boss_beauty"] = {
        name = "Beauty",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\beauty",
        scale = 1.25,
    },
    ["brc_boss_ascendant_lord_obsidius"] = {
        name = "Ascendant Lord Obsidius",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ascendant_lord_obsidius",
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
        {
            id = 5,
            x = 0.233,
            y = 0.760,
            mobs = {
                ["brc_twilight_torturer"] = 1,
                ["brc_twilight_sadist"] = 1,
                ["brc_mad_prisoner"] = 1,
            }
        },
        {
            id = 6,
            x = 0.224,
            y = 0.760,
            mobs = {
                ["brc_twilight_torturer"] = 1,
            },
            patrol = {
                {x = 0.224, y = 0.760},
                {x = 0.216, y = 0.664},
            }
        },
        {
            id = 7,
            x = 0.258,
            y = 0.752,
            mobs = {
                ["brc_twilight_torturer"] = 1,
            },
            patrol = {
                {x = 0.258, y = 0.752},
                {x = 0.299, y = 0.727},
            }
        },
        {
            id = 8,
            x = 0.278,
            y = 0.702,
            mobs = {
                ["brc_twilight_torturer"] = 1,
                ["brc_twilight_sadist"] = 1,
                ["brc_crazed_mage"] = 1,
            }
        },
        {
            id = 9,
            x = 0.306,
            y = 0.732,
            mobs = {
                ["brc_twilight_torturer"] = 1,
                ["brc_twilight_sadist"] = 1,
                ["brc_mad_prisoner"] = 1,
            }
        },
        {
            id = 10,
            x = 0.312,
            y = 0.700,
            mobs = {
                ["brc_twilight_torturer"] = 1,
            },
            patrol = {
                {x = 0.312, y = 0.707},
                {x = 0.278, y = 0.702},
            }
        },
        {
            id = 11,
            x = 0.306,
            y = 0.641,
            mobs = {
                ["brc_twilight_torturer"] = 1,
                ["brc_twilight_sadist"] = 1,
                ["brc_mad_prisoner"] = 1,
            }
        },
        {
            id = 12,
            x = 0.252,
            y = 0.580,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 2,
            }
        },
        {
            id = 13,
            x = 0.252,
            y = 0.540,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 2,
            }
        },
        {
            id = 14,
            x = 0.252,
            y = 0.490,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 2,
            }
        },
        {
            id = 15,
            x = 0.252,
            y = 0.445,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 2,
            }
        },
        {
            id = 16,
            x = 0.294,
            y = 0.276,
            mobs = {
                ["brc_twilight_flame_caller"] = 2,
            },
            patrol = {
                {x = 0.294, y = 0.276},
                {x = 0.290, y = 0.299},
                {x = 0.269, y = 0.316},
            }
        },
        {
            id = 17,
            x = 0.318,
            y = 0.211,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 1,
            },
            patrol = {
                {x = 0.291, y = 0.211},
                {x = 0.318, y = 0.211},
                {x = 0.354, y = 0.211},
                {x = 0.354, y = 0.185},
            }
        },
        {
            id = 18,
            x = 0.355,
            y = 0.183,
            mobs = {
                ["brc_twilight_zealot"] = 4,
            }
        },
        {
            id = 19,
            x = 0.318,
            y = 0.134,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 1,
            },
            patrol = {
                {x = 0.255, y = 0.134},
                {x = 0.318, y = 0.134},
                {x = 0.354, y = 0.134},
                {x = 0.354, y = 0.165},
            }
        },
        {
            id = 20,
            x = 0.462,
            y = 0.173,
            mobs = {
                ["brc_twilight_zealot"] = 4,
            },
            patrol = {
                {x = 0.462, y = 0.173},
                {x = 0.529, y = 0.173},
            }
        },
        {
            id = 21,
            x = 0.516,
            y = 0.135,
            mobs = {
                ["brc_twilight_zealot"] = 2,
            }
        },
        {
            id = 22,
            x = 0.507,
            y = 0.198,
            mobs = {
                ["brc_twilight_zealot"] = 5,
            }
        },
        {
            id = 23,
            x = 0.550,
            y = 0.147,
            mobs = {
                ["brc_twilight_zealot"] = 4,
            }
        },
        {
            id = 24,
            x = 0.552,
            y = 0.253,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 1,
            },
            patrol = {
                {x = 0.552, y = 0.196},
                {x = 0.552, y = 0.307},
            }
        },
        {
            id = 25,
            x = 0.601,
            y = 0.352,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 1,
            }
        },
        {
            id = 26,
            x = 0.601,
            y = 0.465,
            mobs = {
                ["brc_evolved_twilight_zealot"] = 9,
            }
        },
        {
            id = 27,
            x = 0.610,
            y = 0.699,
            mobs = {
                ["brc_conflagration"] = 1,
            },
            patrol = {
                {x = 0.610, y = 0.699},
                {x = 0.609, y = 0.628},
                {x = 0.657, y = 0.629},
                {x = 0.656, y = 0.696},
                {x = 0.610, y = 0.699},
            }
        },
        {
            id = 28,
            x = 0.657,
            y = 0.629,
            mobs = {
                ["brc_conflagration"] = 1,
            },
            patrol = {
                {x = 0.610, y = 0.699},
                {x = 0.609, y = 0.628},
                {x = 0.657, y = 0.629},
                {x = 0.656, y = 0.696},
                {x = 0.610, y = 0.699},
            }
        },
        {
            id = 29,
            x = 0.633,
            y = 0.580,
            mobs = {
                ["brc_bellows_slave"] = 3,
            }
        },
        {
            id = 30,
            x = 0.663,
            y = 0.593,
            mobs = {
                ["brc_bellows_slave"] = 2,
            }
        },
        {
            id = 31,
            x = 0.680,
            y = 0.628,
            mobs = {
                ["brc_bellows_slave"] = 4,
            }
        },
        {
            id = 32,
            x = 0.652,
            y = 0.752,
            mobs = {
                ["brc_bellows_slave"] = 3,
            }
        },
        {
            id = 33,
            x = 0.617,
            y = 0.738,
            mobs = {
                ["brc_bellows_slave"] = 1,
            }
        },
        {
            id = 34,
            x = 0.576,
            y = 0.709,
            mobs = {
                ["brc_bellows_slave"] = 3,
            }
        },
        {
            id = 35,
            x = 0.566,
            y = 0.634,
            mobs = {
                ["brc_bellows_slave"] = 2,
            }
        },
        {
            id = 36,
            x = 0.762,
            y = 0.691,
            mobs = {
                ["brc_defiled_earth_ravager"] = 2,
            },
            patrol = {
                {x = 0.736, y = 0.707},
                {x = 0.762, y = 0.691},
                {x = 0.841, y = 0.716},
            }
        },
        {
            id = 37,
            x = 0.713,
            y = 0.680,
            mobs = {
                ["brc_twilight_obsidian_borer"] = 2,
                ["brc_twilight_element_warden"] = 1,
                ["brc_incendiary_spark"] = 1,
            }
        },
        {
            id = 38,
            x = 0.709,
            y = 0.740,
            mobs = {
                ["brc_twilight_obsidian_borer"] = 2,
                ["brc_twilight_element_warden"] = 1,
                ["brc_incendiary_spark"] = 1,
            }
        },
        {
            id = 39,
            x = 0.786,
            y = 0.736,
            mobs = {
                ["brc_twilight_obsidian_borer"] = 2,
                ["brc_twilight_element_warden"] = 1,
                ["brc_incendiary_spark"] = 1,
            }
        },
        {
            id = 40,
            x = 0.838,
            y = 0.687,
            mobs = {
                ["brc_defiled_earth_ravager"] = 2,
            },
            patrol = {
                {x = 0.844, y = 0.720},
                {x = 0.838, y = 0.687},
                {x = 0.859, y = 0.582},
            }
        },
        {
            id = 41,
            x = 0.807,
            y = 0.663,
            mobs = {
                ["brc_twilight_obsidian_borer"] = 2,
                ["brc_twilight_element_warden"] = 2,
                ["brc_incendiary_spark"] = 1,
            }
        },
        {
            id = 42,
            x = 0.868,
            y = 0.652,
            mobs = {
                ["brc_twilight_obsidian_borer"] = 2,
                ["brc_twilight_element_warden"] = 2,
                ["brc_incendiary_spark"] = 1,
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
        {
            id = 1001,
            x = 0.430,
            y = 0.160,
            mobs = {
                ["brc_boss_corla_herald_of_twilight"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.633,
            y = 0.664,
            mobs = {
                ["brc_boss_karsh_steelbender"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.832,
            y = 0.848,
            mobs = {
                ["brc_boss_beauty"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.853,
            y = 0.512,
            mobs = {
                ["brc_boss_ascendant_lord_obsidius"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Blackrock Caverns", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Blackrock Caverns")
