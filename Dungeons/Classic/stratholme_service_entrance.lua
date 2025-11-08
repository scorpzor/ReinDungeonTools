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
        scale = 0.7,
    },
    ["strat_crypt_crawler"] = {
        name = "Crypt Crawler",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\crypt_crawler",
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
                ["strat_ghoul_ravener"] = 1,
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
            x = 0.628,
            y = 0.475,
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
        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.658,
            y = 0.750,
            mobs = {
                ["strat_boss_magistrate_barthilas"] = 1,
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
            x = 0.597,
            y = 0.766,
            name = "Main Gate",
            description = "",
        },
    },
}

RDT.Data:RegisterDungeon("Stratholme Service Entrance", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Stratholme Service Entrance")
