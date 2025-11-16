local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["bfd_skittering_crustacean"] = {
        name = "Skittering Crustacean",
        count = 0.5,
        displayIcon = "Interface\\Icons\\INV_Misc_Birdbeck_02",
        scale = 0.7,
    },
    ["bfd_murkshallow_snapclaw"] = {
        name = "Murkshallow Snapclaw",
        count = 0.5,
        displayIcon = "Interface\\Icons\\INV_Misc_Monsterhead_02",
        scale = 0.8,
    },
    ["bfd_blindlight_murloc"] = {
        name = "Blindlight Murlock",
        count = 0.5,
        displayIcon = "Interface\\Icons\\inv_pet_babymurlocs_white",
        scale = 0.7,
    },
    ["bfd_blackfathom_sea_witch"] = {
        name = "Blackfathom Sea Witch",
        count = 1,
        displayIcon = "Interface\\Icons\\inv_misc_nagafemale",
        scale = 0.8,
    },
    ["bfd_blackfathom_myrmidon"] = {
        name = "Blackfathom Myrmidon",
        count = 1,
        displayIcon = "Interface\\Icons\\inv_misc_nagamale",
        scale = 0.8,
    },
    ["bfd_aku_mai_fisher"] = {
        name = "Aku'mai Fisher",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aku_mai_fisher",
        scale = 0.8,
    },
    ["bfd_fallenroot_shadowstalker"] = {
        name = "Fallenroot Shadowstalker",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fallenroot_shadowstalker",
        scale = 0.8,
    },
}

local bosses = {
    ["bfd_boss_ghamoora"] = {
        name = "Ghamoo-ra",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ghamoora",
        scale = 1.25,
    },
    ["bfd_boss_lady_sarevess"] = {
        name = "Lady Sarevess",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lady_sarevess",
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
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackfathom_deeps\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackfathom_deeps\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackfathom_deeps\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackfathom_deeps\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackfathom_deeps\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackfathom_deeps\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.439,
            y = 0.150,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 2,
            x = 0.447,
            y = 0.250,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 3,
            x = 0.460,
            y = 0.264,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 4,
            x = 0.476,
            y = 0.284,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 5,
            x = 0.458,
            y = 0.299,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 6,
            x = 0.430,
            y = 0.287,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 7,
            x = 0.413,
            y = 0.302,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 8,
            x = 0.480,
            y = 0.335,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 9,
            x = 0.496,
            y = 0.335,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 10,
            x = 0.446,
            y = 0.329,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 11,
            x = 0.511,
            y = 0.388,
            mobs = {
                ["bfd_blindlight_murloc"] = 2,
            }
        },
        {
            id = 12,
            x = 0.523,
            y = 0.360,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 13,
            x = 0.523,
            y = 0.430,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 14,
            x = 0.537,
            y = 0.439,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 15,
            x = 0.492,
            y = 0.435,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 16,
            x = 0.435,
            y = 0.487,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 17,
            x = 0.413,
            y = 0.401,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 18,
            x = 0.419,
            y = 0.359,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 19,
            x = 0.380,
            y = 0.395,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 20,
            x = 0.398,
            y = 0.334,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 21,
            x = 0.394,
            y = 0.344,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 22,
            x = 0.376,
            y = 0.344,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 23,
            x = 0.355,
            y = 0.369,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 24,
            x = 0.351,
            y = 0.387,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 25,
            x = 0.334,
            y = 0.440,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 2,
            }
        },
        {
            id = 26,
            x = 0.324,
            y = 0.502,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 27,
            x = 0.294,
            y = 0.542,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 28,
            x = 0.296,
            y = 0.511,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 29,
            x = 0.392,
            y = 0.562,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 30,
            x = 0.396,
            y = 0.587,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 31,
            x = 0.357,
            y = 0.601,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 32,
            x = 0.388,
            y = 0.617,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 33,
            x = 0.344,
            y = 0.622,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 34,
            x = 0.375,
            y = 0.693,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 35,
            x = 0.327,
            y = 0.679,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 36,
            x = 0.312,
            y = 0.742,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 2,
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 37,
            x = 0.285,
            y = 0.725,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 38,
            x = 0.278,
            y = 0.684,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 39,
            x = 0.251,
            y = 0.752,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 2,
            }
        },
        {
            id = 40,
            x = 0.226,
            y = 0.738,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 41,
            x = 0.209,
            y = 0.716,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 42,
            x = 0.197,
            y = 0.713,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 43,
            x = 0.178,
            y = 0.662,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 44,
            x = 0.184,
            y = 0.631,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 45,
            x = 0.167,
            y = 0.594,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 46,
            x = 0.166,
            y = 0.551,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 47,
            x = 0.141,
            y = 0.567,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 48,
            x = 0.123,
            y = 0.552,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 49,
            x = 0.102,
            y = 0.550,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 50,
            x = 0.174,
            y = 0.483,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 51,
            x = 0.183,
            y = 0.525,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 52,
            x = 0.219,
            y = 0.476,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 53,
            x = 0.205,
            y = 0.483,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 54,
            x = 0.242,
            y = 0.464,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 55,
            x = 0.277,
            y = 0.461,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 56,
            x = 0.252,
            y = 0.427,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 57,
            x = 0.264,
            y = 0.401,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 58,
            x = 0.281,
            y = 0.389,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 59,
            x = 0.265,
            y = 0.545,
            mobs = {
                ["bfd_aku_mai_fisher"] = 1,
            }
        },
        {
            id = 60,
            x = 0.224,
            y = 0.556,
            mobs = {
                ["bfd_aku_mai_fisher"] = 1,
            }
        },
        {
            id = 61,
            x = 0.222,
            y = 0.613,
            mobs = {
                ["bfd_aku_mai_fisher"] = 1,
            }
        },
        {
            id = 62,
            x = 0.294,
            y = 0.588,
            mobs = {
                ["bfd_aku_mai_fisher"] = 1,
            }
        },
        {
            id = 63,
            x = 0.279,
            y = 0.656,
            mobs = {
                ["bfd_aku_mai_fisher"] = 1,
            }
        },
        {
            id = 64,
            x = 0.236,
            y = 0.656,
            mobs = {
                ["bfd_aku_mai_fisher"] = 1,
            }
        },
        {
            id = 65,
            x = 0.174,
            y = 0.440,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 66,
            x = 0.157,
            y = 0.437,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 67,
            x = 0.118,
            y = 0.461,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 68,
            x = 0.096,
            y = 0.439,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 69,
            x = 0.107,
            y = 0.401,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 70,
            x = 0.108,
            y = 0.362,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 71,
            x = 0.142,
            y = 0.367,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 72,
            x = 0.056,
            y = 0.420,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 73,
            x = 0.235,
            y = 0.796,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 74,
            x = 0.244,
            y = 0.778,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 75,
            x = 0.242,
            y = 0.821,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 76,
            x = 0.222,
            y = 0.818,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 77,
            x = 0.244,
            y = 0.888,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 78,
            x = 0.217,
            y = 0.864,
            mobs = {
                ["bfd_fallenroot_shadowstalker"] = 1,
            }
        },
        {
            id = 79,
            x = 0.209,
            y = 0.907,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 2,
            }
        },
        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.257,
            y = 0.606,
            mobs = {
                ["bfd_boss_ghamoora"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.041,
            y = 0.400,
            mobs = {
                ["bfd_boss_lady_sarevess"] = 1,
            }
        },
    },
    identifiers = {
        {
            id = 1,
            type = "dungeon-entrance",
            x = 0.382,
            y = 0.111,
            name = "Entrance Portal",
            description = "Main entrance",
        },
    },
}

RDT.Data:RegisterDungeon("Blackfathom Deeps", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Blackfathom Deeps")
