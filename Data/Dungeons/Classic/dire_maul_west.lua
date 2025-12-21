local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["dmw_petrified_treant"] = {
        name = "Petrified Treant",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\petrified_treant",
        scale = 0.7,
    },
    ["dmw_petrified_guardian"] = {
        name = "Petrified Guardian",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\petrified_guardian",
        scale = 0.7,
    },
    ["dmw_warpwood_tangler"] = {
        name = "Warpwood Tangler",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_tangler",
        scale = 0.7,
    },
    ["dmw_ironbark_protector"] = {
        name = "Ironbark Protector",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ironbark_protector",
        scale = 0.7,
    },
    ["dmw_arcane_abberation"] = {
        name = "Arcane Abberation",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\arcane_abberation",
        scale = 0.7,
    },
    ["dmw_mana_remnant"] = {
        name = "Mana Remnant",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\mana_remnant",
        scale = 0.7,
    },
}

local bosses = {
    ["dmw_boss_tendris_warpwood"] = {
        name = "Tendris Warpwood",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\tendris_warpwood",
        scale = 1.25,
    },
    ["dmw_boss_magister_kalendris"] = {
        name = "Magister Kalendris",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magister_kalendris",
        scale = 1.25,
    },
    ["dmw_boss_tsuzee"] = {
        name = "Tsu'zee",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\tsuzee",
        scale = 1.25,
    },
    ["dmw_boss_illyanna_ravenoak"] = {
        name = "Illyanna Ravenoak",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\illyanna_ravenoak",
        scale = 1.25,
    },
    ["dmw_boss_immolthar"] = {
        name = "Immol'thar",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\immolthar",
        scale = 1.25,
    },
    ["dmw_boss_prince_tortheldrin"] = {
        name = "Prince Tortheldrin",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\prince_tortheldrin",
        scale = 1.25,
    },
}

RDT.Data:RegisterMobs(mobs)
RDT.Data:RegisterMobs(bosses)

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
            x = 0.055,
            y = 0.876,
            mobs = {
                ["dmw_petrified_treant"] = 3,
            }
        },
        {
            id = 2,
            x = 0.161,
            y = 0.876,
            mobs = {
                ["dmw_petrified_guardian"] = 3,
            }
        },
        {
            id = 3,
            x = 0.354,
            y = 0.876,
            mobs = {
                ["dmw_petrified_treant"] = 2,
                ["dmw_petrified_guardian"] = 1,
            }
        },
        {
            id = 4,
            x = 0.289,
            y = 0.679,
            mobs = {
                ["dmw_petrified_treant"] = 4,
                ["dmw_warpwood_tangler"] = 1,
            }
        },
        {
            id = 5,
            x = 0.132,
            y = 0.762,
            mobs = {
                ["dmw_petrified_treant"] = 3,
                ["dmw_petrified_guardian"] = 2,
            }
        },
        {
            id = 6,
            x = 0.128,
            y = 0.677,
            mobs = {
                ["dmw_petrified_treant"] = 2,
                ["dmw_petrified_guardian"] = 1,
            }
        },
        {
            id = 7,
            x = 0.119,
            y = 0.833,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 8,
            x = 0.196,
            y = 0.833,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 9,
            x = 0.302,
            y = 0.833,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 10,
            x = 0.117,
            y = 0.593,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 11,
            x = 0.210,
            y = 0.593,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 12,
            x = 0.308,
            y = 0.593,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 13,
            x = 0.347,
            y = 0.657,
            mobs = {
                ["dmw_ironbark_protector"] = 1,
            },
            patrol = {
                { x = 0.075, y = 0.829 },
                { x = 0.075, y = 0.598 },
                { x = 0.343, y = 0.598 },
                { x = 0.343, y = 0.829 },
                { x = 0.075, y = 0.829 },
            }
        },
        {
            id = 14,
            x = 0.054,
            y = 0.567,
            mobs = {
                ["dmw_petrified_treant"] = 2,
                ["dmw_petrified_guardian"] = 1,
            }
        },
        {
            id = 15,
            x = 0.356,
            y = 0.565,
            mobs = {
                ["dmw_petrified_treant"] = 1,
                ["dmw_petrified_guardian"] = 2,
            }
        },
        {
            id = 16,
            x = 0.211,
            y = 0.717,
            mobs = {
                ["dmw_mana_remnant"] = 3,
                ["dmw_arcane_abberation"] = 5,
            }
        },

        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.208,
            y = 0.335,
            mobs = {
                ["dmw_boss_tendris_warpwood"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Dire Maul West", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul West")
