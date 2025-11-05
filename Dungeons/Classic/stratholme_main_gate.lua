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
    ["strat_risen_monk"] = {
        name = "Risen Monk",
        count = 0.5,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 0.7,
    },
    ["strat_risen_battle_mage"] = {
        name = "Risen Battle Mage",
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
    ["strat_boss_risen_hammersmith"] = {
        name = "Risen Hammersmith",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_willey_hopebreaker"] = {
        name = "Willey Hopebreaker",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_instructor_galford"] = {
        name = "Instructor Galford",
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
    },
}

RDT.Data:RegisterDungeon("Stratholme Main Gate", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Stratholme Main Gate")
