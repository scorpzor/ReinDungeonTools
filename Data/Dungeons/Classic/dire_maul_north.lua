local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["dmn_gordok_brute"] = {
        name = "Gordok Brute",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\gordok_brute",
        scale = 0.7,
    },
    ["dmn_gordok_mage_lord"] = {
        name = "Gordok Mage-Lord",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\gordok_mage_lord",
        scale = 0.7,
    },
    ["dmn_gordok_mastiff"] = {
        name = "Gordok Mastiff",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\gordok_mastiff",
        scale = 0.5,
    },
    ["dmn_carrion_swarmer"] = {
        name = "Carrion Swarmer",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\carrion_swarmer",
        scale = 0.5,
    },
}

local bosses = {
    ["dmn_boss_guard_moldar"] = {
        name = "Guard Mol'dar",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\guard_moldar",
        scale = 1.25,
    },
    ["dmn_boss_stomper_kreeg"] = {
        name = "Stomper Kreeg",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\stomper_kreeg",
        scale = 1.25,
    },
    ["dmn_boss_guard_fengus"] = {
        name = "Guard Fengus",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\guard_fengus",
        scale = 1.25,
    },
    ["dmn_boss_guard_slipkik"] = {
        name = "Guard Slip'kik",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\guard_slipkik",
        scale = 1.25,
    },
    ["dmn_boss_captain_kromcrush"] = {
        name = "Captain Kromcrush",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\captain_kromcrush",
        scale = 1.25,
    },
    ["dmn_boss_cho_rush_the_observer"] = {
        name = "Cho'Rush the Observer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\cho_rush_the_observer",
        scale = 1.25,
    },
    ["dmn_boss_king_gordok"] = {
        name = "King Gordok",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\king_gordok",
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
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_north\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_north\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_north\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_north\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_north\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_north\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.767,
            y = 0.894,
            mobs = {
                ["dmn_gordok_brute"] = 2,
            }
        },
        {
            id = 2,
            x = 0.708,
            y = 0.875,
            mobs = {
                ["dmn_gordok_brute"] = 1,
            }
        },
        {
            id = 3,
            x = 0.668,
            y = 0.893,
            mobs = {
                ["dmn_gordok_mage_lord"] = 2,
                ["dmn_gordok_brute"] = 3,
            }
        },
        {
            id = 4,
            x = 0.595,
            y = 0.866,
            mobs = {
                ["dmn_gordok_mage_lord"] = 2,
                ["dmn_gordok_brute"] = 2,
            }
        },
        {
            id = 5,
            x = 0.607,
            y = 0.821,
            mobs = {
                ["dmn_gordok_mastiff"] = 2,
                ["dmn_gordok_brute"] = 1,
            },
            patrol = {
                { x = 0.714, y = 0.680 },
                { x = 0.607, y = 0.686 },
                { x = 0.607, y = 0.821 },
                { x = 0.607, y = 0.890 },
            }
        },
        {
            id = 6,
            x = 0.585,
            y = 0.791,
            mobs = {
                ["dmn_gordok_mage_lord"] = 1,
                ["dmn_gordok_brute"] = 2,
            }
        },
        {
            id = 7,
            x = 0.611,
            y = 0.778,
            mobs = {
                ["dmn_gordok_brute"] = 1,
                ["dmn_gordok_mastiff"] = 3,
            }
        },
        {
            id = 8,
            x = 0.585,
            y = 0.716,
            mobs = {
                ["dmn_gordok_brute"] = 2,
            }
        },
        {
            id = 9,
            x = 0.649,
            y = 0.682,
            mobs = {
                ["dmn_gordok_mage_lord"] = 2,
                ["dmn_gordok_brute"] = 1,
            }
        },
        {
            id = 10,
            x = 0.739,
            y = 0.683,
            mobs = {
                ["dmn_carrion_swarmer"] = 15,
            }
        },
        {
            id = 11,
            x = 0.784,
            y = 0.727,
            mobs = {
                ["dmn_carrion_swarmer"] = 20,
            }
        },
        {
            id = 12,
            x = 0.780,
            y = 0.838,
            mobs = {
                ["dmn_gordok_mage_lord"] = 1,
                ["dmn_gordok_brute"] = 1,
            }
        },
        {
            id = 13,
            x = 0.670,
            y = 0.822,
            mobs = {
                ["dmn_gordok_mage_lord"] = 2,
                ["dmn_gordok_brute"] = 2,
            }
        },
        {
            id = 14,
            x = 0.667,
            y = 0.746,
            mobs = {
                ["dmn_gordok_mastiff"] = 6,
            }
        },
        {
            id = 15,
            x = 0.719,
            y = 0.838,
            mobs = {
                ["dmn_gordok_mastiff"] = 5,
            }
        },
        {
            id = 16,
            x = 0.750,
            y = 0.841,
            mobs = {
                ["dmn_gordok_mastiff"] = 5,
            }
        },
        {
            id = 17,
            x = 0.750,
            y = 0.784,
            mobs = {
                ["dmn_gordok_mastiff"] = 5,
            }
        },
        {
            id = 18,
            x = 0.734,
            y = 0.743,
            mobs = {
                ["dmn_gordok_mastiff"] = 5,
            }
        },
        {
            id = 19,
            x = 0.640,
            y = 0.740,
            mobs = {
                ["dmn_gordok_brute"] = 1,
                ["dmn_gordok_mastiff"] = 3,
            }
        },
        {
            id = 20,
            x = 0.618,
            y = 0.945,
            mobs = {
                ["dmn_gordok_brute"] = 2,
                ["dmn_gordok_mage_lord"] = 1,
            }
        },

        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.695,
            y = 0.770,
            mobs = {
                ["dmn_boss_guard_moldar"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.626,
            y = 0.679,
            mobs = {
                ["dmn_boss_stomper_kreeg"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.497,
            y = 0.783,
            mobs = {
                ["dmn_boss_guard_fengus"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.215,
            y = 0.631,
            mobs = {
                ["dmn_boss_guard_slipkik"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.319,
            y = 0.500,
            mobs = {
                ["dmn_boss_captain_kromcrush"] = 1,
            }
        },
        {
            id = 1005,
            x = 0.319,
            y = 0.266,
            mobs = {
                ["dmn_boss_king_gordok"] = 1,
            }
        },
        {
            id = 1006,
            x = 0.304,
            y = 0.228,
            mobs = {
                ["dmn_boss_cho_rush_the_observer"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Dire Maul North", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul North")
