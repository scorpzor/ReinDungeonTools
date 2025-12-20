local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["dme_warpwood_treant"] = {
        name = "Warpwood Treant",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_treant",
        scale = 0.7,
    },
    ["dme_warpwood_tangler"] = {
        name = "Warpwood Tangler",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_tangler",
        scale = 0.7,
    },
    ["dme_warpwood_crusher"] = {
        name = "Warpwood Crusher",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_crusher",
        scale = 0.8,
    },
    ["dme_phase_lasher"] = {
        name = "Phase Lasher",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\phase_lasher",
        scale = 0.7,
    },
    ["dme_whip_lasher"] = {
        name = "Whip Lasher",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\whip_lasher",
        scale = 0.5,
    },
    ["dme_wildspawn_shadowstalker"] = {
        name = "Wildspawn Shadowstalker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_shadowstalker",
        scale = 0.7,
    },
    ["dme_wildspawn_betrayer"] = {
        name = "Wildspawn Betrayer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_betrayer",
        scale = 0.7,
    },
    ["dme_wildspawn_satyr"] = {
        name = "Wildspawn Satyr",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_satyr",
        scale = 0.7,
    },
    ["dme_fel_lash"] = {
        name = "Fel Lash",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fel_lash",
        scale = 0.7,
    },
    ["dme_wildspawn_felsworn"] = {
        name = "Wildspawn Felsworn",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_felsworn",
        scale = 0.7,
    },
    ["dme_wildspawn_hellcaller"] = {
        name = "Wildspawn Hellcaller",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_hellcaller",
        scale = 0.7,
    },
    ["dme_wildspawn_rogue"] = {
        name = "Wildspawn Rogue",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_rogue",
        scale = 0.7,
    },
    ["dme_wildspawn_trickster"] = {
        name = "Wildspawn Trickster",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_trickster",
        scale = 0.7,
    },
    ["dme_wildspawn_imp"] = {
        name = "Wildspawn Imp",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_imp",
        scale = 0.5,
    },
    ["dme_death_lash"] = {
        name = "Death Lash",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\death_lash",
        scale = 0.7,
    },
    ["dme_warpwood_stomper"] = {
        name = "Warpwood Stomper",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_stomper",
        scale = 0.7,
    },
    ["dme_warpwood_guardian"] = {
        name = "Warpwood Guardian",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_guardian",
        scale = 0.7,
    },
}

local bosses = {
    ["dme_boss_pusillin"] = {
        name = "Pusillin",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\pusillin",
        scale = 1.25,
    },
    ["dme_boss_lethtendris"] = {
        name = "Lethtendris",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lethtendris",
        scale = 1.25,
    },
    ["dme_boss_pimgib" ] = {
        name = "Pimgib",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\pimgib",
        scale = 1,
    },
    ["dme_boss_hydrospawn"] = {
        name = "Hydrospawn",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\hydrospawn",
        scale = 1.25,
    },
    ["dme_boss_zevrim_thornhoof"] = {
        name = "Zevrim Thornhoof",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\zevrim_thornhoof",
        scale = 1.25,
    },
    ["dme_boss_alzzin_the_wildshaper"] = {
        name = "Alzzin the Wildshaper",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\alzzin_the_wildshaper",
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
            x = 0.110,
            y = 0.323,
            mobs = {
                ["dme_warpwood_treant"] = 1,
            },
            patrol = {
                {x = 0.115, y = 0.323},
                {x = 0.115, y = 0.617},
            },
        },
        {
            id = 2,
            x = 0.110,
            y = 0.414,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 3,
            x = 0.099,
            y = 0.441,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 4,
            x = 0.092,
            y = 0.567,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 5,
            x = 0.105,
            y = 0.625,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 6,
            x = 0.115,
            y = 0.686,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 7,
            x = 0.151,
            y = 0.693,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 8,
            x = 0.193,
            y = 0.657,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 9,
            x = 0.280,
            y = 0.678,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 10,
            x = 0.280,
            y = 0.621,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 11,
            x = 0.290,
            y = 0.562,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 12,
            x = 0.290,
            y = 0.479,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 13,
            x = 0.277,
            y = 0.421,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 14,
            x = 0.290,
            y = 0.365,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 15,
            x = 0.294,
            y = 0.280,
            mobs = {
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 16,
            x = 0.255,
            y = 0.245,
            mobs = {
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 17,
            x = 0.270,
            y = 0.185,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            }
        },
        {
            id = 18,
            x = 0.214,
            y = 0.185,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            }
        },
        {
            id = 19,
            x = 0.426,
            y = 0.235,
            mobs = {
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 20,
            x = 0.392,
            y = 0.260,
            mobs = {
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 21,
            x = 0.489,
            y = 0.215,
            mobs = {
                ["dme_wildspawn_betrayer"] = 1,
                ["dme_wildspawn_satyr"] = 2,
            }
        },
        {
            id = 22,
            x = 0.521,
            y = 0.267,
            mobs = {
                ["dme_fel_lash"] = 1,
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 23,
            x = 0.544,
            y = 0.213,
            mobs = {
                ["dme_phase_lasher"] = 2,
            }
        },
        {
            id = 24,
            x = 0.582,
            y = 0.263,
            mobs = {
                ["dme_wildspawn_felsworn"] = 1,
                ["dme_wildspawn_betrayer"] = 1,
                ["dme_wildspawn_satyr"] = 2,
            }
        },
        {
            id = 25,
            x = 0.610,
            y = 0.222,
            mobs = {
                ["dme_wildspawn_shadowstalker"] = 1,
                ["dme_wildspawn_betrayer"] = 1,
                ["dme_wildspawn_satyr"] = 2,
            }
        },
        {
            id = 26,
            x = 0.690,
            y = 0.242,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_fel_lash"] = 2,
            }
        },
        {
            id = 27,
            x = 0.404,
            y = 0.303,
            mobs = {
                ["dme_wildspawn_felsworn"] = 2,
            }
        },
        {
            id = 28,
            x = 0.334,
            y = 0.321,
            mobs = {
                ["dme_wildspawn_betrayer"] = 1,
                ["dme_wildspawn_satyr"] = 2,
            }
        },
        {
            id = 29,
            x = 0.360,
            y = 0.383,
            mobs = {
                ["dme_wildspawn_felsworn"] = 1,
            }
        },
        {
            id = 30,
            x = 0.360,
            y = 0.383,
            mobs = {
                ["dme_wildspawn_felsworn"] = 1,
                ["dme_phase_lasher"] = 1,
                ["dme_fel_lash"] = 1,
            }
        },
        {
            id = 31,
            x = 0.422,
            y = 0.447,
            mobs = {
                ["dme_wildspawn_hellcaller"] = 1,
                ["dme_wildspawn_satyr"] = 1,
                ["dme_wildspawn_betrayer"] = 1,
            }
        },
        {
            id = 32,
            x = 0.356,
            y = 0.494,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 33,
            x = 0.370,
            y = 0.573,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 34,
            x = 0.330,
            y = 0.452,
            mobs = {
                ["dme_wildspawn_hellcaller"] = 1,
                ["dme_wildspawn_satyr"] = 1,
                ["dme_wildspawn_betrayer"] = 1,
            }
        },
        {
            id = 35,
            x = 0.330,
            y = 0.571,
            mobs = {
                ["dme_wildspawn_felsworn"] = 1,
                ["dme_wildspawn_satyr"] = 2,
                ["dme_wildspawn_betrayer"] = 1,
            }
        },
        {
            id = 36,
            x = 0.851,
            y = 0.864,
            mobs = {
                ["dme_wildspawn_rogue"] = 2,
                ["dme_wildspawn_trickster"] = 1,
            }
        },
        {
            id = 37,
            x = 0.830,
            y = 0.830,
            mobs = {
                ["dme_wildspawn_hellcaller"] = 1,
                ["dme_wildspawn_imp"] = 11,
            }
        },
        {
            id = 38,
            x = 0.867,
            y = 0.778,
            mobs = {
                ["dme_fel_lash"] = 1,
            }
        },
        {
            id = 39,
            x = 0.853,
            y = 0.701,
            mobs = {
                ["dme_wildspawn_imp"] = 7,
            }
        },
        {
            id = 40,
            x = 0.831,
            y = 0.680,
            mobs = {
                ["dme_fel_lash"] = 1,
            }
        },
        {
            id = 41,
            x = 0.820,
            y = 0.637,
            mobs = {
                ["dme_wildspawn_felsworn"] = 1,
                ["dme_wildspawn_betrayer"] = 1,
            }
        },
        {
            id = 42,
            x = 0.811,
            y = 0.675,
            mobs = {
                ["dme_fel_lash"] = 1,
            }
        },
        {
            id = 43,
            x = 0.791,
            y = 0.655,
            mobs = {
                ["dme_wildspawn_hellcaller"] = 1,
                ["dme_wildspawn_imp"] = 11,
            }
        },
        {
            id = 44,
            x = 0.791,
            y = 0.718,
            mobs = {
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 45,
            x = 0.783,
            y = 0.761,
            mobs = {
                ["dme_wildspawn_trickster"] = 1,
                ["dme_wildspawn_rogue"] = 2,
            }
        },
        {
            id = 46,
            x = 0.784,
            y = 0.854,
            mobs = {
                ["dme_wildspawn_trickster"] = 2,
                ["dme_wildspawn_rogue"] = 1,
            }
        },
        {
            id = 47,
            x = 0.795,
            y = 0.914,
            mobs = {
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 48,
            x = 0.844,
            y = 0.610,
            mobs = {
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
        {
            id = 49,
            x = 0.831,
            y = 0.732,
            mobs = {
                ["dme_wildspawn_hellcaller"] = 1,
                ["dme_wildspawn_imp"] = 7,
            }
        },
        {
            id = 50,
            x = 0.746,
            y = 0.915,
            mobs = {
                ["dme_death_lash"] = 1,
            }
        },
        {
            id = 51,
            x = 0.711,
            y = 0.897,
            mobs = {
                ["dme_whip_lasher"] = 5,
            }
        },
        {
            id = 52,
            x = 0.657,
            y = 0.890,
            mobs = {
                ["dme_death_lash"] = 2,
            }
        },
        {
            id = 53,
            x = 0.634,
            y = 0.853,
            mobs = {
                ["dme_whip_lasher"] = 1,
            }
        },
        {
            id = 54,
            x = 0.625,
            y = 0.919,
            mobs = {
                ["dme_whip_lasher"] = 7,
            }
        },
        {
            id = 55,
            x = 0.647,
            y = 0.809,
            mobs = {
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 56,
            x = 0.690,
            y = 0.793,
            mobs = {
                ["dme_warpwood_guardian"] = 1,
                ["dme_warpwood_stomper"] = 2,
            },
            patrol = {
                { x = 0.690, y = 0.793 },
                { x = 0.648, y = 0.810 },
                { x = 0.696, y = 0.862 },
                { x = 0.747, y = 0.816 },
                { x = 0.690, y = 0.793 },
            },
        },
        {
            id = 57,
            x = 0.698,
            y = 0.688,
            mobs = {
                ["dme_warpwood_guardian"] = 2,
            },
            patrol = {
                { x = 0.698, y = 0.688 },
                { x = 0.657, y = 0.671 },
                { x = 0.639, y = 0.723 },
                { x = 0.743, y = 0.728 },
                { x = 0.698, y = 0.688 },
            },
        },
        {
            id = 58,
            x = 0.625,
            y = 0.756,
            mobs = {
                ["dme_fel_lash"] = 1,
            }
        },
        {
            id = 59,
            x = 0.638,
            y = 0.725,
            mobs = {
                ["dme_whip_lasher"] = 5,
            }
        },
        {
            id = 60,
            x = 0.631,
            y = 0.650,
            mobs = {
                ["dme_fel_lash"] = 2,
                ["dme_death_lash"] = 1,
            }
        },
        {
            id = 61,
            x = 0.627,
            y = 0.592,
            mobs = {
                ["dme_whip_lasher"] = 10,
            }
        },
        {
            id = 62,
            x = 0.679,
            y = 0.693,
            mobs = {
                ["dme_death_lash"] = 1,
            }
        },
        {
            id = 63,
            x = 0.695,
            y = 0.597,
            mobs = {
                ["dme_warpwood_guardian"] = 1,
                ["dme_warpwood_stomper"] = 2,
            },
            patrol = {
                { x = 0.695, y = 0.597 },
                { x = 0.662, y = 0.650 },
                { x = 0.693, y = 0.669 },
                { x = 0.754, y = 0.641 },
                { x = 0.695, y = 0.597 },
            },
        },
        {
            id = 64,
            x = 0.668,
            y = 0.644,
            mobs = {
                ["dme_whip_lasher"] = 9,
            }
        },
        {
            id = 65,
            x = 0.742,
            y = 0.819,
            mobs = {
                ["dme_whip_lasher"] = 8,
            }
        },
        {
            id = 66,
            x = 0.730,
            y = 0.727,
            mobs = {
                ["dme_whip_lasher"] = 8,
            }
        },
        {
            id = 67,
            x = 0.762,
            y = 0.686,
            mobs = {
                ["dme_death_lash"] = 1,
            }
        },
        {
            id = 68,
            x = 0.759,
            y = 0.588,
            mobs = {
                ["dme_death_lash"] = 1,
                ["dme_whip_lasher"] = 3,
            }
        },
        {
            id = 69,
            x = 0.762,
            y = 0.467,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            }
        },
        {
            id = 70,
            x = 0.771,
            y = 0.328,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            }
        },
        {
            id = 71,
            x = 0.872,
            y = 0.304,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            },
            patrol = {
                { x = 0.774, y = 0.380 },
                { x = 0.813, y = 0.312 },
                { x = 0.893, y = 0.308 },
                { x = 0.933, y = 0.382 },
                { x = 0.899, y = 0.503 },
            },
        },
        {
            id = 72,
            x = 0.894,
            y = 0.385,
            mobs = {
                ["dme_fel_lash"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 73,
            x = 0.857,
            y = 0.364,
            mobs = {
                ["dme_death_lash"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 74,
            x = 0.885,
            y = 0.447,
            mobs = {
                ["dme_death_lash"] = 1,
                ["dme_whip_lasher"] = 9,
            }
        },


        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.613,
            y = 0.297,
            mobs = {
                ["dme_boss_pusillin"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.384,
            y = 0.428,
            mobs = {
                ["dme_boss_lethtendris"] = 1,
                ["dme_boss_pimgib"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.811,
            y = 0.754,
            mobs = {
                ["dme_boss_hydrospawn"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.840,
            y = 0.767,
            mobs = {
                ["dme_boss_zevrim_thornhoof"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.831,
            y = 0.408,
            mobs = {
                ["dme_boss_alzzin_the_wildshaper"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Dire Maul East", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul East")
