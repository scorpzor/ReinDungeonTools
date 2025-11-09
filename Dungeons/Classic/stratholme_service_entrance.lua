-- Dungeons/Classic/Stratholme.lua
-- Stratholme dungeon data for WotLK 3.3.5a

local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--------------------------------------------------------------------------------
-- Mob Definitions
--------------------------------------------------------------------------------

local mobs = {
    ["strat_shrieking_banshee"] = {
        name = "Shrieking Banshee",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\shrieking_banshee",
        scale = 0.7,
    },
    ["strat_crypt_beast"] = {
        name = "Crypt Beast",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crypt_beast",
        scale = 0.7,
    },
    ["strat_rockwing_screecher"] = {
        name = "Rockwing Screecher",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\rockwing_screecher",
        scale = 0.7,
    },
    ["strat_ghoul_ravener"] = {
        name = "Ghoul Ravener",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ghoul_ravener",
        scale = 0.7,
    },
    ["strat_fleshflayer_ghoul"] = {
        name = "Fleshflayer Ghoul",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fleshflayer_ghoul",
        scale = 0.7,
    },
    ["strat_thuzadin_necromancer"] = {
        name = "Thuzadin Necromancer",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\thuzadin_necromancer",
        scale = 0.7,
    },
    ["strat_thuzadin_shadowcaster"] = {
        name = "Thuzadin Shadowcaster",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\thuzadin_shadowcaster",
        scale = 0.7,
    },
    ["strat_risen_lackey"] = {
        name = "Risen Lackey",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\risen_lackey",
        scale = 0.4,
    },
    ["strat_crypt_crawler"] = {
        name = "Crypt Crawler",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crypt_crawler",
        scale = 0.7,
    },
    ["strat_thuzadin_acolyte"] = {
        name = "Thuzadin Acolyte",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\thuzadin_acolyte",
        scale = 0.7,
    },
    ["strat_wailing_banshee"] = {
        name = "Wailing Banshee",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wailing_banshee",
        scale = 0.7,
    },
}

local bosses = {
    ["strat_boss_magistrate_barthilas"] = {
        name = "Magistrate Barthilas",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_stonespine"] = {
        name = "Stonespine",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_nerubenkan"] = {
        name = "Nerub'enkan",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_black_guard_swordsmith"] = {
        name = "Black Guard Swordsmith",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_maleki_the_pallid"] = {
        name = "Maleki the Pallid",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_baroness_anastari"] = {
        name = "Baroness Anastari",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_ramstein_the_gorger"] = {
        name = "Ramstein the Gorger",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
    ["strat_boss_baron_rivendare"] = {
        name = "Baron Rivendare",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\magistrate_barthilas",
        scale = 1.25,
    },
}

RDT.Data:RegisterMobs(mobs)
RDT.Data:RegisterMobs(bosses)

--------------------------------------------------------------------------------
-- Stratholme - Service Entrance
--------------------------------------------------------------------------------

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_service_entrance\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_service_entrance\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_service_entrance\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_service_entrance\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_service_entrance\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_service_entrance\\tile_5",
        }
    },
    totalCount = 120,
    packData = {
        {
            id = 1,
            x = 0.677,
            y = 0.795,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 2,
            }
        },
        {
            id = 2,
            x = 0.622,
            y = 0.737,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 2,
                ["strat_mangled_cadaver"] = 2,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 3,
            x = 0.642,
            y = 0.680,
            mobs = {
                ["strat_skeletal_berserker"] = 2,
                ["strat_skeletal_guardian"] = 3,
                ["strat_mangled_cadaver"] = 1,
                ["strat_ravaged_cadaver"] = 1,
            }
        },
        {
            id = 4,
            x = 0.651,
            y = 0.553,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
            }
        },
        {
            id = 5,
            x = 0.658,
            y = 0.522,
            mobs = {
                ["strat_crypt_beast"] = 1,
                ["strat_rockwing_screecher"] = 1,
            }
        },
        {
            id = 6,
            x = 0.665,
            y = 0.496,
            mobs = {
                ["strat_rockwing_screecher"] = 1,
            }
        },
        {
            id = 7,
            x = 0.679,
            y = 0.510,
            mobs = {
                ["strat_rockwing_screecher"] = 1,
                ["strat_shrieking_banshee"] = 1,
            }
        },
        {
            id = 8,
            x = 0.693,
            y = 0.550,
            mobs = {
                ["strat_ghoul_ravener"] = 2,
                ["strat_fleshflayer_ghoul"] = 1,
            }
        },
        {
            id = 9,
            x = 0.679,
            y = 0.478,
            mobs = {
                ["strat_ghoul_ravener"] = 2,
            }
        },
        {
            id = 10,
            x = 0.658,
            y = 0.495,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
            }
        },
        {
            id = 11,
            x = 0.649,
            y = 0.466,
            mobs = {
                ["strat_thuzadin_necromancer"] = 1,
                ["strat_thuzadin_shadowcaster"] = 1,
                ["strat_risen_lackey"] = 1,
            }
        },
        {
            id = 12,
            x = 0.621,
            y = 0.512,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_fleshflayer_ghoul"] = 2,
            }
        },
        {
            id = 13,
            x = 0.648,
            y = 0.494,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 14,
            x = 0.618,
            y = 0.450, 
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_beast"] = 1,
            }
        },
        {
            id = 15,
            x = 0.590,
            y = 0.493,
            mobs = {
                ["strat_thuzadin_shadowcaster"] = 2,
            }
        },
        {
            id = 16,
            x = 0.590,
            y = 0.431,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_beast"] = 1,
            }
        },
        {
            id = 17,
            x = 0.572,
            y = 0.417,
            mobs = {
                ["strat_thuzadin_necromancer"] = 1,
                ["strat_thuzadin_shadowcaster"] = 1,
                ["strat_risen_lackey"] = 1,
            }
        },
        {
            id = 18,
            x = 0.550,
            y = 0.438,
            mobs = {
                ["strat_thuzadin_necromancer"] = 1,
                ["strat_thuzadin_shadowcaster"] = 1,
                ["strat_risen_lackey"] = 1,
            }
        },
        {
            id = 19,
            x = 0.584,
            y = 0.458,
            mobs = {
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 20,
            x = 0.536,
            y = 0.494,
            mobs = {
                ["strat_thuzadin_acolyte"] = 5,
            }
        },
        {
            id = 21,
            x = 0.718,
            y = 0.488,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_beast"] = 1,
            }
        },
        {
            id = 22,
            x = 0.695,
            y = 0.446,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 23,
            x = 0.707,
            y = 0.428,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 24,
            x = 0.724,
            y = 0.529,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_plague_ghoul"] = 1,
            }
        },
        {
            id = 25,
            x = 0.726,
            y = 0.464,
            mobs = {
                ["strat_rockwing_screecher"] = 1,
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 26,
            x = 0.756,
            y = 0.527,
            mobs = {
                ["strat_thuzadin_necromancer"] = 2,
                ["strat_thuzadin_shadowcaster"] = 1,
                ["strat_risen_lackey"] = 2,
            }
        },
        {
            id = 27,
            x = 0.762,
            y = 0.499,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
            }
        },
        {
            id = 28,
            x = 0.697,
            y = 0.366,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
            }
        },
        {
            id = 29,
            x = 0.687,
            y = 0.400,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_thuzadin_necromancer"] = 2,
                ["strat_risen_lackey"] = 2,
            }
        },
        {
            id = 30,
            x = 0.724,
            y = 0.396,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_fleshflayer_ghoul"] = 1,
            }
        },
        {
            id = 31,
            x = 0.767,
            y = 0.414,
            mobs = {
                ["strat_thuzadin_necromancer"] = 2,
                ["strat_thuzadin_shadowcaster"] = 1,
                ["strat_risen_lackey"] = 2,
                ["strat_shrieking_banshee"] = 1,
            }
        },
        {
            id = 32,
            x = 0.790,
            y = 0.482,
            mobs = {
                ["strat_thuzadin_acolyte"] = 5,
            }
        },
        {
            id = 33,
            x = 0.671,
            y = 0.344,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_fleshflayer_ghoul"] = 2,
            }
        },
        {
            id = 34,
            x = 0.669,
            y = 0.313,
            mobs = {
                ["strat_rockwing_screecher"] = 1,
            }
        },
        {
            id = 35,
            x = 0.687,
            y = 0.287,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_plague_ghoul"] = 1,
                ["strat_shrieking_banshee"] = 1,
            }
        },
        {
            id = 36,
            x = 0.647,
            y = 0.292,
            mobs = {
                ["strat_ghoul_ravener"] = 1,
                ["strat_fleshflayer_ghoul"] = 1,
            }
        },
        {
            id = 37,
            x = 0.690,
            y = 0.242,
            mobs = {
                ["strat_thuzadin_necromancer"] = 1,
                ["strat_thuzadin_shadowcaster"] = 2,
                ["strat_risen_lackey"] = 1,
            }
        },
        {
            id = 38,
            x = 0.655,
            y = 0.253,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 39,
            x = 0.700,
            y = 0.166,
            mobs = {
                ["strat_thuzadin_acolyte"] = 5,
            }
        },
        {
            id = 40,
            x = 0.644,
            y = 0.201,
            mobs = {
                ["strat_thuzadin_necromancer"] = 2,
                ["strat_thuzadin_shadowcaster"] = 2,
                ["strat_risen_lackey"] = 2,
            }
        },
        {
            id = 41,
            x = 0.622,
            y = 0.305,
            mobs = {
                ["strat_plague_ghoul"] = 2,
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 42,
            x = 0.638,
            y = 0.262,
            mobs = {
                ["strat_rockwing_screecher"] = 1,
            }
        },
        {
            id = 43,
            x = 0.626,
            y = 0.235,
            mobs = {
                ["strat_plague_ghoul"] = 1,
                ["strat_ghoul_ravener"] = 2,
                ["strat_wailing_banshee"] = 1,
                ["strat_crypt_beast"] = 1,
            }
        },
        {
            id = 44,
            x = 0.605,
            y = 0.323,
            mobs = {
                ["strat_thuzadin_necromancer"] = 1,
                ["strat_thuzadin_shadowcaster"] = 2,
                ["strat_wailing_banshee"] = 1,
            }
        },
        {
            id = 45,
            x = 0.575,
            y = 0.307,
            mobs = {
                ["strat_fleshflayer_ghoul"] = 2,
                ["strat_ghoul_ravener"] = 1,
            }
        },
        {
            id = 46,
            x = 0.604,
            y = 0.258,
            mobs = {
                ["strat_shrieking_banshee"] = 1,
                ["strat_crypt_crawler"] = 1,
            }
        },
        {
            id = 47,
            x = 0.570,
            y = 0.269,
            mobs = {
                ["strat_thuzadin_necromancer"] = 2,
                ["strat_risen_lackey"] = 2,
            }
        },
        {
            id = 48,
            x = 0.596,
            y = 0.206,
            mobs = {
                ["strat_plague_ghoul"] = 1,
                ["strat_ghoul_ravener"] = 2,
            }
        },
        {
            id = 49,
            x = 0.552,
            y = 0.243,
            mobs = {
                ["strat_fleshflayer_ghoul"] = 1,
                ["strat_plague_ghoul"] = 3,
                ["strat_wailing_banshee"] = 1,
            }
        },
        {
            id = 48,
            x = 0.547,
            y = 0.164,
            mobs = {
                ["strat_plague_ghoul"] = 1,
                ["strat_ghoul_ravener"] = 1,
            }
        },
        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.658,
            y = 0.750,
            mobs = {
                ["strat_boss_magistrate_barthilas"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.568,
            y = 0.364,
            mobs = {
                ["strat_boss_stonespine"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.568,
            y = 0.364,
            mobs = {
                ["strat_boss_nerubenkan"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.753,
            y = 0.466,
            mobs = {
                ["strat_boss_baroness_anastari"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.676,
            y = 0.200,
            mobs = {
                ["strat_boss_maleki_the_pallid"] = 1,
                ["strat_thuzadin_shadowcaster"] = 3,
            }
        },
    },
    identifiers = {
        {
            id = 1,
            type = "dungeon-entrance",
            x = 0.657,
            y = 0.908,
            name = "Entrance Portal",
            description = "Main entrance",
        },
        {
            id = 2,
            type = "gate",
            x = 0.570,
            y = 0.469,
            name = "Main Gate",
            description = "",
        },
    },
}

RDT.Data:RegisterDungeon("Stratholme Service Entrance", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Stratholme Service Entrance")
