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
        scale = 0.8,
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
    ["dmw_eldreth_spectre"] = {
        name = "Eldreth Spectre",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_spectre",
        scale = 0.7,
    },
    ["dmw_eldreth_seether"] = {
        name = "Eldreth Seether",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_seether",
        scale = 0.7,
    },
    ["dmw_eldreth_sorcerer"] = {
        name = "Eldreth Sorcerer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_sorcerer",
        scale = 0.7,
    },
    ["dmw_eldreth_darter"] = {
        name = "Eldreth Darter",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_darter",
        scale = 0.7,
    },
    ["dmw_rotting_highborne"] = {
        name = "Rotting Highborne",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\rotting_highborne",
        scale = 0.7,
    },
    ["dmw_skeletal_highborne"] = {
        name = "Skeletal Highborne",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\skeletal_highborne",
        scale = 0.7,
    },
    ["dmw_eldreth_spirit"] = {
        name = "Eldreth Spirit",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_spirit",
        scale = 0.7,
    },
    ["dmw_eldreth_apparition"] = {
        name = "Eldreth Apparition",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_apparition",
        scale = 0.7,
    },
    ["dmw_eldreth_phantasm"] = {
        name = "Eldreth Phantasm",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\eldreth_phantasm",
        scale = 0.7,
    },
    ["dmw_arcane_torrent"] = {
        name = "Arcane Torrent",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\arcane_torrent",
        scale = 0.7,
    },
    ["dmw_arcane_feedback"] = {
        name = "Arcane Feedback",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\arcane_feedback",
        scale = 0.7,
    },
    ["dmw_residual_monstrosity"] = {
        name = "Residual Monstrosity",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\residual_monstrosity",
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
    ["dmw_boss_lord_helnurath"] = {
        name = "Lord Hel'nurath",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lord_helnurath",
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
        {
            id = 17,
            x = 0.286,
            y = 0.335,
            mobs = {
                ["dmw_eldreth_spectre"] = 1,
            }
        },
        {
            id = 18,
            x = 0.264,
            y = 0.280,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
                ["dmw_eldreth_darter"] = 1,
                ["dmw_rotting_highborne"] = 2,
            }
        },
        {
            id = 19,
            x = 0.191,
            y = 0.280,
            mobs = {
                ["dmw_eldreth_sorcerer"] = 2,
                ["dmw_eldreth_darter"] = 1,
                ["dmw_skeletal_highborne"] = 2,
            }
        },
        {
            id = 20,
            x = 0.149,
            y = 0.280,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 2,
                ["dmw_rotting_highborne"] = 2,
            }
        },
        {
            id = 21,
            x = 0.740,
            y = 0.394,
            mobs = {
                ["dmw_eldreth_spirit"] = 1,
                ["dmw_eldreth_apparition"] = 1,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 22,
            x = 0.722,
            y = 0.329,
            mobs = {
                ["dmw_eldreth_spirit"] = 1,
                ["dmw_eldreth_apparition"] = 2,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 23,
            x = 0.709,
            y = 0.270,
            mobs = {
                ["dmw_eldreth_spirit"] = 2,
                ["dmw_eldreth_apparition"] = 1,
            }
        },
        {
            id = 24,
            x = 0.705,
            y = 0.142,
            mobs = {
                ["dmw_eldreth_spirit"] = 1,
                ["dmw_eldreth_apparition"] = 1,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 25,
            x = 0.657,
            y = 0.158,
            mobs = {
                ["dmw_eldreth_spirit"] = 2,
                ["dmw_eldreth_apparition"] = 2,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 26,
            x = 0.596,
            y = 0.139,
            mobs = {
                ["dmw_eldreth_spirit"] = 1,
                ["dmw_eldreth_apparition"] = 1,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 27,
            x = 0.541,
            y = 0.145,
            mobs = {
                ["dmw_eldreth_spirit"] = 1,
                ["dmw_eldreth_apparition"] = 1,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 28,
            x = 0.492,
            y = 0.151,
            mobs = {
                ["dmw_eldreth_spirit"] = 2,
                ["dmw_eldreth_apparition"] = 2,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 29,
            x = 0.448,
            y = 0.207,
            mobs = {
                ["dmw_eldreth_spirit"] = 2,
                ["dmw_eldreth_apparition"] = 1,
            }
        },
        {
            id = 30,
            x = 0.440,
            y = 0.319,
            mobs = {
                ["dmw_eldreth_spirit"] = 1,
                ["dmw_eldreth_apparition"] = 1,
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 31,
            x = 0.305,
            y = 0.205,
            mobs = {
                ["dmw_eldreth_spectre"] = 1,
            }
        },
        {
            id = 32,
            x = 0.307,
            y = 0.166,
            mobs = {
                ["dmw_eldreth_seether"] = 2,
                ["dmw_eldreth_sorcerer"] = 3,
                ["dmw_rotting_highborne"] = 1,
                ["dmw_skeletal_highborne"] = 1,
            }
        },
        {
            id = 33,
            x = 0.346,
            y = 0.326,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 2,
            }
        },
        {
            id = 34,
            x = 0.314,
            y = 0.328,
            mobs = {
                ["dmw_skeletal_highborne"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
                ["dmw_eldreth_darter"] = 1,
                ["dmw_rotting_highborne"] = 1,
            }
        },
        {
            id = 35,
            x = 0.350,
            y = 0.400,
            mobs = {
                ["dmw_mana_remnant"] = 3,
                ["dmw_arcane_abberation"] = 5,
            }
        },
        {
            id = 36,
            x = 0.331,
            y = 0.488,
            mobs = {
                ["dmw_rotting_highborne"] = 4,
                ["dmw_skeletal_highborne"] = 6,
            }
        },
        {
            id = 37,
            x = 0.081,
            y = 0.489,
            mobs = {
                ["dmw_rotting_highborne"] = 5,
                ["dmw_skeletal_highborne"] = 5,
            }
        },
        {
            id = 38,
            x = 0.078,
            y = 0.393,
            mobs = {
                ["dmw_mana_remnant"] = 3,
                ["dmw_arcane_abberation"] = 5,
            }
        },
        {
            id = 39,
            x = 0.054,
            y = 0.239,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
                ["dmw_rotting_highborne"] = 1,
                ["dmw_skeletal_highborne"] = 1,
            }
        },
        {
            id = 40,
            x = 0.103,
            y = 0.248,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
            }
        },
        {
            id = 41,
            x = 0.128,
            y = 0.168,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
                ["dmw_eldreth_darter"] = 1,
                ["dmw_skeletal_highborne"] = 2,
            }
        },
        {
            id = 42,
            x = 0.182,
            y = 0.224,
            mobs = {
                ["dmw_eldreth_sorcerer"] = 2,
                ["dmw_eldreth_darter"] = 1,
                ["dmw_skeletal_highborne"] = 1,
                ["dmw_rotting_highborne"] = 1,
            }
        },
        {
            id = 43,
            x = 0.203,
            y = 0.168,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
                ["dmw_eldreth_darter"] = 1,
            }
        },
        {
            id = 44,
            x = 0.271,
            y = 0.232,
            mobs = {
                ["dmw_eldreth_seether"] = 1,
                ["dmw_eldreth_sorcerer"] = 1,
                ["dmw_eldreth_darter"] = 1,
            }
        },
        {
            id = 45,
            x = 0.099,
            y = 0.298,
            mobs = {
                ["dmw_eldreth_spectre"] = 1,
            }
        },
        {
            id = 46,
            x = 0.881,
            y = 0.616,
            mobs = {
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 47,
            x = 0.866,
            y = 0.705,
            mobs = {
                ["dmw_eldreth_phantasm"] = 1,
            }
        },
        {
            id = 48,
            x = 0.873,
            y = 0.646,
            mobs = {
                ["dmw_eldreth_spectre"] = 1,
            },
            patrol = {
                { x = 0.891, y = 0.603 },
                { x = 0.875, y = 0.629 },
                { x = 0.874, y = 0.689 },
                { x = 0.849, y = 0.721 },
            },
        },
        {
            id = 49,
            x = 0.873,
            y = 0.676,
            mobs = {
                ["dmw_eldreth_spectre"] = 1,
            },
            patrol = {
                { x = 0.891, y = 0.603 },
                { x = 0.875, y = 0.629 },
                { x = 0.874, y = 0.689 },
                { x = 0.849, y = 0.721 },
            },
        },
        {
            id = 50,
            x = 0.784,
            y = 0.644,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
            patrol = {
                { x = 0.770, y = 0.631 },
                { x = 0.818, y = 0.719 },
                { x = 0.778, y = 0.782 },
                { x = 0.751, y = 0.703 },
            },
        },
        {
            id = 51,
            x = 0.769,
            y = 0.710,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
            patrol = {
                { x = 0.770, y = 0.631 },
                { x = 0.818, y = 0.719 },
                { x = 0.778, y = 0.782 },
                { x = 0.751, y = 0.703 },
            },
        },
        {
            id = 52,
            x = 0.790,
            y = 0.778,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
            patrol = {
                { x = 0.770, y = 0.631 },
                { x = 0.818, y = 0.719 },
                { x = 0.778, y = 0.782 },
                { x = 0.751, y = 0.703 },
            },
        },
        -- 21 mobs in a circle
        {
            id = 53,
            x = 0.211,
            y = 0.717,
            mobs = {
                ["dmw_mana_remnant"] = 4,
                ["dmw_arcane_abberation"] = 4,
            }
        },
        {
            id = 54,
            x = 0.685,
            y = 0.550,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
        },
        {
            id = 55,
            x = 0.586,
            y = 0.568,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
        },
        {
            id = 56,
            x = 0.722,
            y = 0.866,
            mobs = {
                ["dmw_mana_remnant"] = 4,
                ["dmw_arcane_abberation"] = 4,
            }
        },
        {
            id = 57,
            x = 0.655,
            y = 0.893,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
        },
        {
            id = 58,
            x = 0.580,
            y = 0.863,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
        },
        {
            id = 59,
            x = 0.540,
            y = 0.808,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
        },
        {
            id = 60,
            x = 0.540,
            y = 0.637,
            mobs = {
                ["dmw_arcane_torrent"] = 1,
                ["dmw_arcane_feedback"] = 4,
            },
        },
        {
            id = 61,
            x = 0.645,
            y = 0.574,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 62,
            x = 0.672,
            y = 0.581,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 63,
            x = 0.695,
            y = 0.598,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 64,
            x = 0.704,
            y = 0.609,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 65,
            x = 0.720,
            y = 0.631,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 66,
            x = 0.733,
            y = 0.663,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 67,
            x = 0.741,
            y = 0.709,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 68,
            x = 0.739,
            y = 0.746,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 69,
            x = 0.734,
            y = 0.776,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 70,
            x = 0.719,
            y = 0.812,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 71,
            x = 0.698,
            y = 0.835,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 72,
            x = 0.673,
            y = 0.852,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 73,
            x = 0.644,
            y = 0.858,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 74,
            x = 0.614,
            y = 0.850,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 75,
            x = 0.589,
            y = 0.832,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 76,
            x = 0.572,
            y = 0.802,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 77,
            x = 0.558,
            y = 0.764,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 78,
            x = 0.552,
            y = 0.727,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 79,
            x = 0.558,
            y = 0.681,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 80,
            x = 0.569,
            y = 0.640,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
        },
        {
            id = 81,
            x = 0.594,
            y = 0.601,
            mobs = {
                ["dmw_residual_monstrosity"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.574 },
                { x = 0.672, y = 0.581 },
                { x = 0.695, y = 0.598 },
                { x = 0.704, y = 0.609 },
                { x = 0.720, y = 0.631 },
                { x = 0.733, y = 0.663 },
                { x = 0.741, y = 0.709 },
                { x = 0.739, y = 0.746 },
                { x = 0.734, y = 0.776 },
                { x = 0.719, y = 0.812 },
                { x = 0.698, y = 0.835 },
                { x = 0.673, y = 0.852 },
                { x = 0.644, y = 0.858 },
                { x = 0.614, y = 0.850 },
                { x = 0.589, y = 0.832 },
                { x = 0.572, y = 0.802 },
                { x = 0.558, y = 0.764 },
                { x = 0.552, y = 0.727 },
                { x = 0.558, y = 0.681 },
                { x = 0.569, y = 0.640 },
                { x = 0.594, y = 0.601 },
                { x = 0.645, y = 0.574 },
            },
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
        {
            id = 1001,
            x = 0.591,
            y = 0.088,
            mobs = {
                ["dmw_boss_magister_kalendris"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.750,
            y = 0.125,
            mobs = {
                ["dmw_boss_tsuzee"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.084,
            y = 0.197,
            mobs = {
                ["dmw_boss_illyanna_ravenoak"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.644,
            y = 0.720,
            mobs = {
                ["dmw_boss_immolthar"] = 1,
            }
        },
        {
            id = 1005,
            x = 0.825,
            y = 0.432,
            mobs = {
                ["dmw_boss_prince_tortheldrin"] = 1,
            }
        },
        {
            id = 1006,
            x = 0.505,
            y = 0.720,
            mobs = {
                ["dmw_boss_lord_helnurath"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Dire Maul West", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul West")
