local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["dmines_defias_miner"] = {
        name = "Defias Miner",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_miner",
        scale = 0.7,
    },
    ["dmines_defias_overseer"] = {
        name = "Defias Overseer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_overseer",
        scale = 0.7,
    },
    ["dmines_defias_evoker"] = {
        name = "Defias Evoker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_evoker",
        scale = 0.7,
    },
    ["dmines_defias_watchman"] = {
        name = "Defias Watchman",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_watchman",
        scale = 0.7,
    },
    ["dmines_goblin_miner"] = {
        name = "Goblin Miner",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\goblin_miner",
        scale = 0.7,
    },
    ["dmines_defias_strip_miner"] = {
        name = "Defias Strip Miner",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_strip_miner",
        scale = 0.7,
    },
    ["dmines_defias_taskmaster"] = {
        name = "Defias Taskmaster",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_taskmaster",
        scale = 0.7,
    },
    ["dmines_defias_wizard"] = {
        name = "Defias Wizard",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_wizard",
        scale = 0.7,
    },
    ["dmines_goblin_woodcarver"] = {
        name = "Goblin Woodcarver",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\goblin_woodcarver",
        scale = 0.7,
    },
    ["dmines_goblin_craftsman"] = {
        name = "Goblin Craftsman",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\goblin_craftsman",
        scale = 0.7,
    },
    ["dmines_goblin_engineer"] = {
        name = "Goblin Engineer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\goblin_engineer",
        scale = 0.7,
    },
    ["dmines_goblin_shipbuilder"] = {
        name = "Goblin Shipbuilder",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\goblin_shipbuilder",
        scale = 0.7,
    },
    ["dmines_defias_pirate"] = {
        name = "Defias Pirate",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_pirate",
        scale = 0.7,
    },
    ["dmines_defias_squallshaper"] = {
        name = "Defias Squallshaper",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_squallshaper",
        scale = 0.7,
    },
    ["dmines_tamed_parrot"] = {
        name = "Tamed Parrot",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\tamed_parrot",
        scale = 0.5,
    },
    ["dmines_defias_blackguard"] = {
        name = "Defias Blackguard",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\defias_blackguard",
        scale = 0.5,
    },
}

local bosses = {
    ["dmines_boss_rhahk_zor"] = {
        name = "Rhahk'Zor",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\rhahk_zor",
        scale = 1.25,
    },
    ["dmines_boss_miner_johnson"] = {
        name = "Miner Johnson",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\miner_johnson",
        scale = 1.25,
    },
    ["dmines_boss_sneed"] = {
        name = "Sneed",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\sneed",
        scale = 1.25,
    },
    ["dmines_boss_gilnid"] = {
        name = "Gilnid",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\gilnid",
        scale = 1.25,
    },
    ["dmines_boss_mr_smite"] = {
        name = "Mr. Smite",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\mr_smite",
        scale = 1.25,
    },
    ["dmines_boss_cookie"] = {
        name = "Cookie",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\cookie",
        scale = 1.25,
    },
    ["dmines_boss_captain_greenskin"] = {
        name = "Captain Greenskin",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\captain_greenskin",
        scale = 1.25,
    },
    ["dmines_boss_edwin_vancleef"] = {
        name = "Edwin VanCleef",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\edwin_vancleef",
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
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\deadmines\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\deadmines\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\deadmines\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\deadmines\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\deadmines\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\deadmines\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.085,
            y = 0.209,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 2,
            x = 0.079,
            y = 0.253,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 3,
            x = 0.078,
            y = 0.298,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 4,
            x = 0.111,
            y = 0.270,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.053, y = 0.284},
                {x = 0.111, y = 0.270},
                {x = 0.146, y = 0.295},
            }
        },
        {
            id = 5,
            x = 0.084,
            y = 0.313,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 6,
            x = 0.135,
            y = 0.232,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 7,
            x = 0.150,
            y = 0.262,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 8,
            x = 0.154,
            y = 0.304,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 9,
            x = 0.138,
            y = 0.308,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 10,
            x = 0.113,
            y = 0.323,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 11,
            x = 0.095,
            y = 0.339,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.095, y = 0.339},
                {x = 0.106, y = 0.278},
                {x = 0.142, y = 0.267},
            }
        },
        {
            id = 12,
            x = 0.093,
            y = 0.369,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 13,
            x = 0.105,
            y = 0.397,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.145, y = 0.378},
                {x = 0.105, y = 0.397},
                {x = 0.116, y = 0.444},
            }
        },
        {
            id = 14,
            x = 0.097,
            y = 0.444,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 15,
            x = 0.137,
            y = 0.439,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.137, y = 0.439},
                {x = 0.140, y = 0.381},
                {x = 0.111, y = 0.423},
                {x = 0.137, y = 0.439},
            }
        },
        {
            id = 16,
            x = 0.134,
            y = 0.452,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.134, y = 0.452},
                {x = 0.179, y = 0.461},
            }
        },
        {
            id = 17,
            x = 0.131,
            y = 0.346,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 18,
            x = 0.148,
            y = 0.406,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 19,
            x = 0.118,
            y = 0.482,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 20,
            x = 0.192,
            y = 0.393,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 21,
            x = 0.226,
            y = 0.439,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 22,
            x = 0.154,
            y = 0.463,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.150, y = 0.500},
                {x = 0.154, y = 0.463},
                {x = 0.149, y = 0.379},
            }
        },
        {
            id = 23,
            x = 0.199,
            y = 0.432,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.199, y = 0.432},
                {x = 0.208, y = 0.410},
                {x = 0.148, y = 0.434},
                {x = 0.148, y = 0.383},
            }
        },
        {
            id = 24,
            x = 0.160,
            y = 0.498,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },        {
            id = 25,
            x = 0.134,
            y = 0.508,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 26,
            x = 0.127,
            y = 0.556,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 27,
            x = 0.148,
            y = 0.579,
            mobs = {
                ["dmines_defias_overseer"] = 1,
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.141, y = 0.510},
                {x = 0.148, y = 0.579},
                {x = 0.163, y = 0.594},
            }
        },
        {
            id = 28,
            x = 0.158,
            y = 0.606,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 29,
            x = 0.295,
            y = 0.652,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 30,
            x = 0.295,
            y = 0.591,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 31,
            x = 0.304,
            y = 0.622,
            mobs = {
                ["dmines_defias_overseer"] = 1,
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.304, y = 0.622},
                {x = 0.326, y = 0.631},
            }
        },
        {
            id = 32,
            x = 0.321,
            y = 0.609,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.321, y = 0.609},
                {x = 0.339, y = 0.524},
                {x = 0.370, y = 0.524},
            }
        },
        {
            id = 33,
            x = 0.335,
            y = 0.613,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 34,
            x = 0.320,
            y = 0.581,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 35,
            x = 0.328,
            y = 0.537,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 36,
            x = 0.324,
            y = 0.678,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.324, y = 0.678},
                {x = 0.341, y = 0.695},
            }
        },
        {
            id = 37,
            x = 0.352,
            y = 0.507,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 38,
            x = 0.371,
            y = 0.548,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 39,
            x = 0.340,
            y = 0.656,
            mobs = {
                ["dmines_defias_miner"] = 2,
            }
        },
        {
            id = 40,
            x = 0.350,
            y = 0.690,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 41,
            x = 0.312,
            y = 0.705,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.329, y = 0.648},
                {x = 0.312, y = 0.705},
                {x = 0.288, y = 0.809},
            }
        },
        {
            id = 42,
            x = 0.294,
            y = 0.731,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.329, y = 0.648},
                {x = 0.294, y = 0.731},
                {x = 0.288, y = 0.809},
            }
        },
        {
            id = 43,
            x = 0.306,
            y = 0.685,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 44,
            x = 0.325,
            y = 0.715,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 45,
            x = 0.303,
            y = 0.743,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 46,
            x = 0.283,
            y = 0.718,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 47,
            x = 0.273,
            y = 0.761,
            mobs = {
                ["dmines_defias_miner"] = 1,
            }
        },
        {
            id = 48,
            x = 0.262,
            y = 0.869,
            mobs = {
                ["dmines_goblin_miner"] = 1,
            }
        },
        {
            id = 49,
            x = 0.306,
            y = 0.844,
            mobs = {
                ["dmines_goblin_miner"] = 1,
            }
        },
        {
            id = 50,
            x = 0.300,
            y = 0.940,
            mobs = {
                ["dmines_goblin_miner"] = 1,
            }
        },
        {
            id = 51,
            x = 0.294,
            y = 0.876,
            mobs = {
                ["dmines_goblin_miner"] = 1,
            },
            patrol = {
                {x = 0.294, y = 0.876},
                {x = 0.362, y = 0.888},
            }
        },
        {
            id = 52,
            x = 0.329,
            y = 0.891,
            mobs = {
                ["dmines_goblin_miner"] = 2,
            }
        },
        {
            id = 53,
            x = 0.358,
            y = 0.835,
            mobs = {
                ["dmines_goblin_miner"] = 1,
            }
        },
        {
            id = 54,
            x = 0.450,
            y = 0.910,
            mobs = {
                ["dmines_defias_taskmaster"] = 1,
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.399, y = 0.895},
                {x = 0.484, y = 0.933},
                {x = 0.506, y = 0.897},
                {x = 0.460, y = 0.807},
            }
        },
        {
            id = 55,
            x = 0.503,
            y = 0.933,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.399, y = 0.895},
                {x = 0.484, y = 0.933},
                {x = 0.506, y = 0.897},
                {x = 0.460, y = 0.807},
            }
        },
        {
            id = 56,
            x = 0.408,
            y = 0.871,
            mobs = {
                ["dmines_goblin_miner"] = 1,
            }
        },
        {
            id = 57,
            x = 0.423,
            y = 0.922,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 58,
            x = 0.440,
            y = 0.873,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 59,
            x = 0.467,
            y = 0.949,
            mobs = {
                ["dmines_defias_strip_miner"] = 2,
            }
        },
        {
            id = 60,
            x = 0.448,
            y = 0.804,
            mobs = {
                ["dmines_defias_taskmaster"] = 1,
                ["dmines_defias_wizard"] = 1,
            },
            patrol = {
                {x = 0.484, y = 0.933},
                {x = 0.506, y = 0.897},
                {x = 0.460, y = 0.807},
            }
        },
        {
            id = 61,
            x = 0.520,
            y = 0.908,
            mobs = {
                ["dmines_goblin_woodcarver"] = 1,
            }
        },
        {
            id = 62,
            x = 0.508,
            y = 0.875,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 63,
            x = 0.474,
            y = 0.866,
            mobs = {
                ["dmines_defias_strip_miner"] = 2,
            }
        },
        {
            id = 64,
            x = 0.430,
            y = 0.825,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
                ["dmines_goblin_woodcarver"] = 1,
            }
        },
        {
            id = 65,
            x = 0.478,
            y = 0.804,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 66,
            x = 0.437,
            y = 0.730,
            mobs = {
                ["dmines_goblin_craftsman"] = 2,
            },
            patrol = {
                {x = 0.437, y = 0.730},
                {x = 0.413, y = 0.668},
                {x = 0.438, y = 0.608},
            }
        },
        {
            id = 67,
            x = 0.505,
            y = 0.647,
            mobs = {
                ["dmines_goblin_craftsman"] = 3,
            },
            patrol = {
                {x = 0.463, y = 0.597},
                {x = 0.505, y = 0.647},
                {x = 0.498, y = 0.715},
            }
        },
        {
            id = 68,
            x = 0.516,
            y = 0.443,
            mobs = {
                ["dmines_goblin_craftsman"] = 1,
            }
        },
        {
            id = 69,
            x = 0.468,
            y = 0.486,
            mobs = {
                ["dmines_goblin_engineer"] = 1,
                ["dmines_goblin_craftsman"] = 1,
            },
            patrol = {
                {x = 0.468, y = 0.486},
                {x = 0.421, y = 0.452},
                {x = 0.428, y = 0.370},
            }
        },
        {
            id = 70,
            x = 0.410,
            y = 0.476,
            mobs = {
                ["dmines_goblin_engineer"] = 1,
                ["dmines_goblin_craftsman"] = 1,
            }
        },
        {
            id = 71,
            x = 0.444,
            y = 0.412,
            mobs = {
                ["dmines_goblin_craftsman"] = 1,
            }
        },
        {
            id = 72,
            x = 0.464,
            y = 0.429,
            mobs = {
                ["dmines_goblin_engineer"] = 1,
            }
        },
        {
            id = 73,
            x = 0.464,
            y = 0.392,
            mobs = {
                ["dmines_goblin_engineer"] = 1,
            }
        },
        {
            id = 74,
            x = 0.392,
            y = 0.405,
            mobs = {
                ["dmines_goblin_engineer"] = 1,
                ["dmines_goblin_craftsman"] = 1,
            }
        },
        {
            id = 75,
            x = 0.405,
            y = 0.351,
            mobs = {
                ["dmines_goblin_engineer"] = 1,
                ["dmines_goblin_craftsman"] = 1,
            }
        },
        {
            id = 76,
            x = 0.468,
            y = 0.234,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            }
        },
        {
            id = 77,
            x = 0.490,
            y = 0.243,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 78,
            x = 0.444,
            y = 0.237,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 79,
            x = 0.460,
            y = 0.182,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 80,
            x = 0.478,
            y = 0.187,
            mobs = {
                ["dmines_defias_strip_miner"] = 2,
            }
        },
        {
            id = 81,
            x = 0.510,
            y = 0.209,
            mobs = {
                ["dmines_defias_strip_miner"] = 2,
            }
        },
        {
            id = 82,
            x = 0.538,
            y = 0.209,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 83,
            x = 0.536,
            y = 0.156,
            mobs = {
                ["dmines_defias_strip_miner"] = 3,
            }
        },
        {
            id = 84,
            x = 0.546,
            y = 0.171,
            mobs = {
                ["dmines_defias_evoker"] = 1,
            },
            patrol = {
                {x = 0.546, y = 0.171},
                {x = 0.582, y = 0.167},
                {x = 0.661, y = 0.088},
            }
        },
        {
            id = 85,
            x = 0.637,
            y = 0.094,
            mobs = {
                ["dmines_defias_overseer"] = 1,
                ["dmines_defias_wizard"] = 1,
            },
            patrol = {
                {x = 0.637, y = 0.094},
                {x = 0.595, y = 0.121},
                {x = 0.574, y = 0.178},
                {x = 0.493, y = 0.183},
            }
        },
        {
            id = 86,
            x = 0.572,
            y = 0.170,
            mobs = {
                ["dmines_defias_overseer"] = 1,
            },
            patrol = {
                {x = 0.572, y = 0.170},
                {x = 0.550, y = 0.186},
                {x = 0.500, y = 0.187},
            }
        },
        {
            id = 87,
            x = 0.572,
            y = 0.137,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 88,
            x = 0.597,
            y = 0.088,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 89,
            x = 0.559,
            y = 0.211,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 90,
            x = 0.595,
            y = 0.182,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 91,
            x = 0.610,
            y = 0.141,
            mobs = {
                ["dmines_defias_strip_miner"] = 1,
            }
        },
        {
            id = 92,
            x = 0.629,
            y = 0.801,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.607, y = 0.801},
                {x = 0.670, y = 0.801},
            }
        },
        {
            id = 93,
            x = 0.629,
            y = 0.762,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.607, y = 0.762},
                {x = 0.670, y = 0.762},
            }
        },
        {
            id = 94,
            x = 0.605,
            y = 0.782,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.605, y = 0.782},
                {x = 0.672, y = 0.782},
            }
        },
        {
            id = 95,
            x = 0.673,
            y = 0.782,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },
        {
            id = 96,
            x = 0.689,
            y = 0.711,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.687, y = 0.626},
                {x = 0.689, y = 0.711},
                {x = 0.674, y = 0.765},
            }
        },
        {
            id = 97,
            x = 0.669,
            y = 0.664,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.669, y = 0.664},
                {x = 0.669, y = 0.611},
            }
        },
        {
            id = 98,
            x = 0.696,
            y = 0.611,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            }
        },
        {
            id = 99,
            x = 0.694,
            y = 0.548,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.733, y = 0.495},
                {x = 0.694, y = 0.548},
                {x = 0.689, y = 0.711},
            }
        },
        {
            id = 100,
            x = 0.672,
            y = 0.582,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.672, y = 0.582},
                {x = 0.679, y = 0.663},
            }
        },
        {
            id = 101,
            x = 0.676,
            y = 0.507,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.670, y = 0.538},
                {x = 0.685, y = 0.514},
                {x = 0.698, y = 0.521},
                {x = 0.726, y = 0.485},
            }
        },
        {
            id = 102,
            x = 0.733,
            y = 0.516,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.733, y = 0.516},
                {x = 0.700, y = 0.562},
            }
        },
        {
            id = 103,
            x = 0.787,
            y = 0.475,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.787, y = 0.475},
                {x = 0.715, y = 0.533},
            }
        },
        {
            id = 104,
            x = 0.845,
            y = 0.554,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            }
        },
        {
            id = 105,
            x = 0.829,
            y = 0.571,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.829, y = 0.571},
                {x = 0.807, y = 0.601},
                {x = 0.795, y = 0.638},
            }
        },
        {
            id = 106,
            x = 0.807,
            y = 0.601,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },
        {
            id = 107,
            x = 0.864,
            y = 0.559,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },
        {
            id = 108,
            x = 0.864,
            y = 0.533,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },
        {
            id = 109,
            x = 0.798,
            y = 0.625,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 110,
            x = 0.898,
            y = 0.558,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.862, y = 0.543},
                {x = 0.898, y = 0.558},
                {x = 0.943, y = 0.655},
            }
        },
        {
            id = 111,
            x = 0.927,
            y = 0.598,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.886, y = 0.548},
                {x = 0.927, y = 0.598},
                {x = 0.942, y = 0.697},
            }
        },
        {
            id = 112,
            x = 0.923,
            y = 0.635,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 113,
            x = 0.939,
            y = 0.739,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.939, y = 0.739},
                {x = 0.934, y = 0.697},
                {x = 0.943, y = 0.661},
            }
        },
        {
            id = 114,
            x = 0.921,
            y = 0.791,
            mobs = {
                ["dmines_defias_squallshaper"] = 2,
            },
            patrol = {
                {x = 0.900, y = 0.853},
                {x = 0.921, y = 0.791},
                {x = 0.939, y = 0.746},
            }
        },
        {
            id = 115,
            x = 0.886,
            y = 0.866,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 116,
            x = 0.792,
            y = 0.650,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.814, y = 0.591},
                {x = 0.792, y = 0.650},
                {x = 0.788, y = 0.715},
            }
        },
        {
            id = 117,
            x = 0.839,
            y = 0.862,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.839, y = 0.862},
                {x = 0.805, y = 0.799},
                {x = 0.788, y = 0.710},
            }
        },
        {
            id = 118,
            x = 0.816,
            y = 0.832,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 119,
            x = 0.837,
            y = 0.875,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 120,
            x = 0.794,
            y = 0.877,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 121,
            x = 0.816,
            y = 0.877,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            },
            patrol = {
                {x = 0.816, y = 0.877},
                {x = 0.778, y = 0.749},
            }
        },
        {
            id = 122,
            x = 0.784,
            y = 0.790,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },
        {
            id = 123,
            x = 0.787,
            y = 0.714,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 124,
            x = 0.784,
            y = 0.754,
            mobs = {
                ["dmines_defias_squallshaper"] = 2,
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },
        {
            id = 125,
            x = 0.826,
            y = 0.797,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 126,
            x = 0.828,
            y = 0.765,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            },
            patrol = {
                {x = 0.819, y = 0.695},
                {x = 0.828, y = 0.765},
                {x = 0.815, y = 0.792},
            }
        },
        {
            id = 127,
            x = 0.812,
            y = 0.750,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 1,
            }
        },
        {
            id = 128,
            x = 0.803,
            y = 0.687,
            mobs = {
                ["dmines_defias_pirate"] = 2,
                ["dmines_tamed_parrot"] = 2,
            }
        },
        {
            id = 129,
            x = 0.817,
            y = 0.619,
            mobs = {
                ["dmines_defias_squallshaper"] = 1,
            }
        },
        {
            id = 130,
            x = 0.594,
            y = 0.872,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 2,
            }
        },
        {
            id = 131,
            x = 0.594,
            y = 0.669,
            mobs = {
                ["dmines_goblin_shipbuilder"] = 2,
            }
        },
        {
            id = 132,
            x = 0.968,
            y = 0.692,
            mobs = {
                ["dmines_defias_pirate"] = 1,
                ["dmines_tamed_parrot"] = 1,
            }
        },

        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.213,
            y = 0.635,
            mobs = {
                ["dmines_boss_rhahk_zor"] = 1,
                ["dmines_defias_watchman"] = 2,
            }
        },
        {
            id = 1001,
            x = 0.387,
            y = 0.523,
            mobs = {
                ["dmines_boss_miner_johnson"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.360,
            y = 0.931,
            mobs = {
                ["dmines_boss_sneed"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.466,
            y = 0.325,
            mobs = {
                ["dmines_boss_gilnid"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.803,
            y = 0.522,
            mobs = {
                ["dmines_boss_mr_smite"] = 1,
                ["dmines_defias_blackguard"] = 2,
            }
        },
        {
            id = 1005,
            x = 0.929,
            y = 0.696,
            mobs = {
                ["dmines_boss_cookie"] = 1,
            }
        },
        {
            id = 1006,
            x = 0.867,
            y = 0.671,
            mobs = {
                ["dmines_boss_captain_greenskin"] = 1,
                ["dmines_defias_squallshaper"] = 1,
                ["dmines_defias_watchman"] = 1,
            },
            patrol = {
                {x = 0.867, y = 0.671},
                {x = 0.898, y = 0.689},
                {x = 0.882, y = 0.797},
                {x = 0.855, y = 0.797},
                {x = 0.833, y = 0.689},
                {x = 0.867, y = 0.671},
            }
        },
        {
            id = 1007,
            x = 0.866,
            y = 0.746,
            mobs = {
                ["dmines_boss_edwin_vancleef"] = 1,
                ["dmines_defias_blackguard"] = 4,
            }
        },
    },
    identifiers = {
        {
            id = 1,
            type = "dungeon-entrance",
            x = 0.148,
            y = 0.153,
            name = "Entrance Portal",
            description = "Main entrance",
        },
    },
}

RDT.Data:RegisterDungeon("Deadmines", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Deadmines")

