local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--------------------------------------------------------------------------------
-- Mob Definitions
--------------------------------------------------------------------------------

local mobs = {
    ["strat_skeletal_berserker"] = {
        name = "Skeletal Berserker",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\skeletal_berserker",
        scale = 0.7,
    },
    ["strat_skeletal_guardian"] = {
        name = "Skeletal Guardian",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\skeletal_guardian",
        scale = 0.7,
    },
    ["strat_mangled_cadaver"] = {
        name = "Mangled Cadaver",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\mangled_cadaver",
        scale = 0.7,
    },
    ["strat_ravaged_cadaver"] = {
        name = "Ravaged Cadaver",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ravaged_cadaver",
        scale = 0.7,
    },
    ["strat_plague_ghoul"] = {
        name = "Plague Ghoul",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\plague_ghoul",
        scale = 0.8,
    },
    ["strat_ghostly_citizen"] = {
        name = "Ghostly Citizen",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ghostly_citizen",
        scale = 0.7,
    },
    ["strat_spectral_citizen"] = {
        name = "Spectral Citizen",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ghostly_citizen",
        scale = 0.7,
    },
    ["strat_undead_postman"] = {
        name = "Undead Postman",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\undead_postman",
        scale = 0.7,
    },
    ["strat_patchwork_horror"] = {
        name = "Patchwork Horror",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\patchwork_horror",
        scale = 0.9,
    },
    ["strat_vengeful_phantom"] = {
        name = "Vengeful Phantom",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\vengeful_phantom",
        scale = 0.7,
    },
    ["strat_crimson_conjuror"] = {
        name = "Crimson Conjuror",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crimson_conjuror",
        scale = 0.7,
    },
    ["strat_crimson_initiate"] = {
        name = "Crimson Initiate",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crimson_initiate",
        scale = 0.7,
    },
    ["strat_crimson_guardsman"] = {
        name = "Crimson Guardsman",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crimson_guardsman",
        scale = 0.7,
    },
    ["strat_crimson_sorcerer"] = {
        name = "Crimson Sorcerer",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crimson_sorcerer",
        scale = 0.7,
    },
    ["strat_crimson_gallant"] = {
        name = "Crimson Gallant",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crimson_gallant",
        scale = 0.7,
    },
    ["strat_crimson_inquisitor"] = {
        name = "Crimson Inquisitor",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 0.7,
    },
    ["strat_crimson_defender"] = {
        name = "Crimson Defender",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 0.7,
    },
    ["strat_crimson_priest"] = {
        name = "Crimson Priest",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 0.7,
    },
    ["strat_crimson_monk"] = {
        name = "Crimson Monk",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 0.7,
    },
    ["strat_crimson_battle_mage"] = {
        name = "Crimson Battle Mage",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 0.7,
    },

    -------------------------------- Bosses --------------------------------
    ["strat_boss_stratholme_courier"] = {
        name = "Stratholme Courier",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\undead_postman",
        scale = 1.25,
    },
    --["strat_boss_ezra_grimm"] = {
    --    name = "Ezra Grimm",
    --    count = 2,
    --    displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
    --    scale = 2,
    --},
    ["strat_boss_skul"] = {
        name = "Skul",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 1.25,
    },
    ["strat_boss_the_unforgiven"] = {
        name = "The Unforgiven",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_hearthsinger_forresten"] = {
        name = "Hearthsinger Forresten",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_timmy_the_cruel"] = {
        name = "Timmy the Cruel",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_commander_malor"] = {
        name = "Commander Malor",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    --["strat_boss_risen_hammersmith"] = {
    --    name = "Risen Hammersmith",
    --    count = 2,
    --    displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
    --    scale = 2,
    --},
    ["strat_boss_cannon_master_willey"] = {
        name = "Cannon Master Willey",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_archivist_galford"] = {
        name = "Archivist Galford",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_grand_crusader_dathrohan"] = {
        name = "Grand Crusader Dathrohan",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
}

RDT.Data:RegisterMobs(mobs)

--------------------------------------------------------------------------------
-- Stratholme - Main Gate
--------------------------------------------------------------------------------

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_5",
        }
    },
    totalCount = 102,
    packData = {
        {
            id = 1,
            x = 0.665,
            y = 0.807,
            mobs = {
                ["strat_skeletal_berserker"] = 3,
                ["strat_skeletal_guardian"] = 2,
            }
        },
        {
            id = 2,
            x = 0.679,
            y = 0.787,
            mobs = {
                ["strat_plague_ghoul"] = 1,--patrol
            }
        },
        {
            id = 3,
            x = 0.685,
            y = 0.753,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 3,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 4,
            x = 0.643,
            y = 0.738,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 5,
            x = 0.642,
            y = 0.701,
            mobs = {
                ["strat_ghostly_citizen"] = 1,
            }
        },
        {
            id = 6,
            x = 0.669,
            y = 0.656,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 7,
            x = 0.679,
            y = 0.699,
            mobs = {
                ["strat_plague_ghoul"] = 1,--patrol
            }
        },
        {
            id = 8,
            x = 0.675,
            y = 0.552,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 9,
            x = 0.649,
            y = 0.546,
            mobs = {
                ["strat_plague_ghoul"] = 1,--patrol
            }
        },
        {
            id = 10,
            x = 0.652,
            y = 0.588,
            mobs = {
                ["strat_patchwork_horror"] = 1,--patrol
            }
        },
        {
            id = 11,
            x = 0.726,
            y = 0.565,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 12,
            x = 0.632,
            y = 0.605,
            mobs = {
                ["strat_spectral_citizen"] = 2,
            }
        },
        {
            id = 13,
            x = 0.621,
            y = 0.575,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 14,
            x = 0.621,
            y = 0.507,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 15,
            x = 0.595,
            y = 0.502,
            mobs = {
                ["strat_plague_ghoul"] = 1,--patrol
            }
        },
        {
            id = 16,
            x = 0.569,
            y = 0.523,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 2,
            }
        },
        {
            id = 17,
            x = 0.591,
            y = 0.608,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 18,
            x = 0.571,
            y = 0.675,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_ravaged_cadaver"] = 3,
                ["strat_plague_ghoul"] = 1,
                ["strat_spectral_citizen"] = 1,
            }
        },
        {
            id = 19,
            x = 0.776,
            y = 0.494,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 20,
            x = 0.786,
            y = 0.458,
            mobs = {
                ["strat_patchwork_horror"] = 1,--patrol
            }
        },
        {
            id = 21,
            x = 0.853,
            y = 0.454,
            mobs = {
                ["strat_plague_ghoul"] = 2,
            }
        },
        {
            id = 22,
            x = 0.818,
            y = 0.409,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 2,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 23,
            x = 0.873,
            y = 0.381,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_ravaged_cadaver"] = 3,
            }
        },
        {
            id = 24,
            x = 0.791,
            y = 0.352,
            mobs = {
                ["strat_plague_ghoul"] = 3,
            }
        },
        {
            id = 25,
            x = 0.892,
            y = 0.387,
            mobs = {
                ["strat_spectral_citizen"] = 2,
            }
        },
        {
            id = 26,
            x = 0.817,
            y = 0.350,
            mobs = {
                ["strat_spectral_citizen"] = 1,
            }
        },
        {
            id = 27,
            x = 0.851,
            y = 0.315,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_ravaged_cadaver"] = 3,
            }
        },
        {
            id = 28,
            x = 0.851,
            y = 0.277,
            mobs = {
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 29,
            x = 0.810,
            y = 0.266,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 2,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 30,
            x = 0.773,
            y = 0.143,
            mobs = {
                ["strat_plague_ghoul"] = 3,
            }
        },
        {
            id = 31,
            x = 0.716,
            y = 0.204,
            mobs = {
                ["strat_patchwork_horror"] = 1,--patrol
            }
        },
        {
            id = 32,
            x = 0.722,
            y = 0.252,
            mobs = {
                ["strat_plague_ghoul"] = 2,
            }
        },
        {
            id = 33,
            x = 0.684,
            y = 0.235,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_ravaged_cadaver"] = 3,
            }
        },
        {
            id = 34,
            x = 0.685,
            y = 0.280,
            mobs = {
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 35,
            x = 0.637,
            y = 0.282,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 2,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 36,
            x = 0.825,
            y = 0.172,
            mobs = {
                ["strat_spectral_citizen"] = 1,
                ["strat_ghostly_citizen"] = 2
            }
        },
        {
            id = 37,
            x = 0.647,
            y = 0.224,
            mobs = {
                ["strat_spectral_citizen"] = 1,
                ["strat_ghostly_citizen"] = 1
            }
        },
        {
            id = 38,
            x = 0.600,
            y = 0.323,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 39,
            x = 0.631,
            y = 0.342,
            mobs = {
                ["strat_ghostly_citizen"] = 1
            }
        },
        {
            id = 40,
            x = 0.621,
            y = 0.300,
            mobs = {
                ["strat_spectral_citizen"] = 1
            }
        },
        {
            id = 41,
            x = 0.562,
            y = 0.285,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 2,
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 42,
            x = 0.495,
            y = 0.293,
            mobs = {
                ["strat_spectral_citizen"] = 2,
                ["strat_plague_ghoul"] = 2,
            }
        },
        {
            id = 43,
            x = 0.496,
            y = 0.167,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 2,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 44,
            x = 0.440,
            y = 0.271,
            mobs = {
                ["strat_crimson_gallant"] = 1,
                ["strat_crimson_conjuror"] = 1,
            }
        },
        {
            id = 45,
            x = 0.408,
            y = 0.277,
            mobs = {
                ["strat_skeletal_berserker"] = 1,
            }
        },
        {
            id = 46,
            x = 0.426,
            y = 0.346,
            mobs = {
                ["strat_skeletal_berserker"] = 1,
            }
        },
        {
            id = 47,
            x = 0.404,
            y = 0.268,
            mobs = {
                ["strat_crimson_gallant"] = 1,
                ["strat_crimson_conjuror"] = 1,
            }
        },
        {
            id = 48,
            x = 0.412,
            y = 0.307,
            mobs = {
                ["strat_crimson_guardsman"] = 2,
                ["strat_crimson_initiate"] = 1,
            }
        },
        {
            id = 49,
            x = 0.379,
            y = 0.307,
            mobs = {
                ["strat_crimson_guardsman"] = 2,
                ["strat_crimson_conjuror"] = 1,
            }
        },
        {
            id = 50,
            x = 0.374,
            y = 0.221,
            mobs = {
                ["strat_skeletal_berserker"] = 1,
            }
        },
        {
            id = 51,
            x = 0.333,
            y = 0.274,
            mobs = {
                ["strat_skeletal_berserker"] = 1,
                ["strat_skeletal_guardian"] = 1,
                ["strat_crimson_guardsman"] = 1,
            }
        },
        {
            id = 52,
            x = 0.338,
            y = 0.330,
            mobs = {
                ["strat_crimson_guardsman"] = 2,
                ["strat_crimson_initiate"] = 1,
            }
        },
        {
            id = 53,
            x = 0.378,
            y = 0.434,
            mobs = {
                ["strat_skeletal_berserker"] = 1,
            }
        },
        {
            id = 54,
            x = 0.362,
            y = 0.383,
            mobs = {
                ["strat_skeletal_berserker"] = 1,
                ["strat_skeletal_guardian"] = 1,
                ["strat_crimson_guardsman"] = 1,
            }
        },
        {
            id = 55,
            x = 0.257,
            y = 0.312,
            mobs = {
                ["strat_crimson_guardsman"] = 2,
                ["strat_crimson_initiate"] = 2,
            }
        },
        {
            id = 56,
            x = 0.226,
            y = 0.353,
            mobs = {
                ["strat_crimson_guardsman"] = 1,
                ["strat_crimson_initiate"] = 1,
                ["strat_crimson_conjuror"] = 1,
            }
        },
        {
            id = 57,
            x = 0.295,
            y = 0.405,
            mobs = {
                ["strat_crimson_guardsman"] = 3,
                ["strat_crimson_initiate"] = 2,
                ["strat_crimson_conjuror"] = 2,
            }
        },
        {
            id = 58,
            x = 0.225,
            y = 0.450,
            mobs = {
                ["strat_crimson_guardsman"] = 1,
                ["strat_crimson_initiate"] = 1,
                ["strat_crimson_conjuror"] = 1,
            }
        },
        {
            id = 59,
            x = 0.249,
            y = 0.502,
            mobs = {
                ["strat_crimson_guardsman"] = 1,
                ["strat_crimson_initiate"] = 1,
                ["strat_crimson_conjuror"] = 1,
            }
        },
        {
            id = 60,
            x = 0.223,
            y = 0.489,
            mobs = {
                ["strat_crimson_guardsman"] = 1,--patrol
            }
        },
        {
            id = 61,
            x = 0.242,
            y = 0.580,
            mobs = {
                ["strat_crimson_gallant"] = 2,
                ["strat_crimson_inquisitor"] = 2,
            }
        },
        {
            id = 62,
            x = 0.143,
            y = 0.575,
            mobs = {
                ["strat_crimson_defender"] = 2,
                ["strat_crimson_priest"] = 1,
            }
        },
        {
            id = 63,
            x = 0.149,
            y = 0.512,
            mobs = {
                ["strat_crimson_gallant"] = 1,--patrol
            }
        },
        {
            id = 64,
            x = 0.124,
            y = 0.497,
            mobs = {
                ["strat_crimson_defender"] = 1,
                ["strat_crimson_priest"] = 1,
                ["strat_crimson_sorcerer"] = 1,
            }
        },
        {
            id = 65,
            x = 0.086,
            y = 0.509,
            mobs = {
                ["strat_crimson_defender"] = 2,
                ["strat_crimson_priest"] = 1,
            }
        },
        {
            id = 66,
            x = 0.107,
            y = 0.557,
            mobs = {
                ["strat_crimson_defender"] = 2,
                ["strat_crimson_priest"] = 1,
                ["strat_crimson_gallant"] = 1,
            }
        },
        {
            id = 67,
            x = 0.074,
            y = 0.593,
            mobs = {
                ["strat_crimson_defender"] = 2,
                ["strat_crimson_priest"] = 2,
            }
        },
        {
            id = 68,
            x = 0.196,
            y = 0.580,
            mobs = {
                ["strat_crimson_monk"] = 1,--patrol
                ["strat_crimson_sorcerer"] = 1,--patrol
            }
        },
        {
            id = 69,
            x = 0.216,
            y = 0.624,
            mobs = {
                ["strat_crimson_gallant"] = 2,
                ["strat_crimson_battle_mage"] = 1,
            }
        },
        {
            id = 70,
            x = 0.243,
            y = 0.679,
            mobs = {
                ["strat_crimson_gallant"] = 3,
                ["strat_crimson_battle_mage"] = 1,
            }
        },
        {
            id = 71,
            x = 0.208,
            y = 0.695,
            mobs = {
                ["strat_crimson_monk"] = 1,--patrol
                ["strat_crimson_sorcerer"] = 1,--patrol
            }
        },
        {
            id = 72,
            x = 0.229,
            y = 0.738,
            mobs = {
                ["strat_crimson_gallant"] = 2,
                ["strat_crimson_battle_mage"] = 1,
            }
        },
        {
            id = 73,
            x = 0.256,
            y = 0.796,
            mobs = {
                ["strat_crimson_gallant"] = 1,
                ["strat_crimson_battle_mage"] = 1,
                ["strat_crimson_defender"] = 1,
            }
        },
        {
            id = 74,
            x = 0.256,
            y = 0.714,
            mobs = {
                ["strat_crimson_monk"] = 2,
            }
        },
        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.535,
            y = 0.673,
            mobs = {
                ["strat_boss_stratholme_courier"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.810,
            y = 0.479,
            mobs = {
                ["strat_boss_skul"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.728,
            y = 0.176,
            mobs = {
                ["strat_boss_the_unforgiven"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.599,
            y = 0.252,
            mobs = {
                ["strat_boss_hearthsinger_forresten"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.407,
            y = 0.455,
            mobs = {
                ["strat_boss_timmy_the_cruel"] = 1,
            }
        },
        {
            id = 1005,
            x = 0.300,
            y = 0.411,
            mobs = {
                ["strat_boss_commander_malor"] = 1,
            }
        },
        {
            id = 1006,
            x = 0.042,
            y = 0.510,
            mobs = {
                ["strat_boss_cannon_master_willey"] = 1,
            }
        },
        {
            id = 1007,
            x = 0.273,
            y = 0.751,
            mobs = {
                ["strat_boss_archivist_galford"] = 1,
            }
        },
        {
            id = 1008,
            x = 0.205,
            y = 0.822,
            mobs = {
                ["strat_boss_grand_crusader_dathrohan"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Stratholme Main Gate", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Stratholme Main Gate")
