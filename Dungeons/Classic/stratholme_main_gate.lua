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


    ["strat_boss_ezra_grimm"] = {
        name = "Ezra Grimm",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
    },
    ["strat_boss_skul"] = {
        name = "Skul",
        count = 2,
        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
        scale = 2,
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
            x = 0.685,
            y = 0.753,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 3,
                ["strat_mangled_cadaver"] = 2,
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 3,
            x = 0.643,
            y = 0.738,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 4,
            x = 0.642,
            y = 0.701,
            mobs = {
                ["strat_ghostly_citizen"] = 1,
            }
        },
        {
            id = 5,
            x = 0.669,
            y = 0.656,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 6,
            x = 0.684,
            y = 0.686,
            mobs = {
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 7,
            x = 0.675,
            y = 0.552,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
        {
            id = 8,
            x = 0.656,
            y = 0.558,
            mobs = {
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 9,
            x = 0.645,
            y = 0.592,
            mobs = {
                ["strat_patchwork_horror"] = 1,
            }
        },
        {
            id = 10,
            x = 0.726,
            y = 0.565,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 3,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Stratholme Main Gate", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Stratholme Main Gate")
