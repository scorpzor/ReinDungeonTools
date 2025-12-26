local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["bfd_skittering_crustacean"] = {
        name = "Skittering Crustacean",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\skittering_crustacean",
        scale = 0.7,
    },
    ["bfd_murkshallow_snapclaw"] = {
        name = "Murkshallow Snapclaw",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\murkshallow_snapclaw",
        scale = 0.7,
    },
    ["bfd_blindlight_murloc"] = {
        name = "Blindlight Murlock",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blindlight_murloc",
        scale = 0.7,
    },
    ["bfd_blackfathom_sea_witch"] = {
        name = "Blackfathom Sea Witch",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blackfathom_sea_witch",
        scale = 0.7,
    },
    ["bfd_blackfathom_myrmidon"] = {
        name = "Blackfathom Myrmidon",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blackfathom_myrmidon",
        scale = 0.7,
    },
    ["bfd_aku_mai_fisher"] = {
        name = "Aku'mai Fisher",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aku_mai_snapjaw",
        scale = 0.8,
    },
    ["bfd_fallenroot_shadowstalker"] = {
        name = "Fallenroot Shadowstalker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fallenroot_shadowstalker",
        scale = 0.7,
    },
    ["bfd_fallenroot_hellcaller"] = {
        name = "Fallenroot Hellcaller",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fallenroot_hellcaller",
        scale = 0.8,
    },
    ["bfd_blindlight_muckdweller"] = {
        name = "Blindlight Muckdweller",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blindlight_muckdweller",
        scale = 0.7,
    },
    ["bfd_blindlight_oracle"] = {
        name = "Blindlight Oracle",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blindlight_oracle",
        scale = 0.7,
    },
    ["bfd_twilight_reaver"] = {
        name = "Twilight Reaver",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_reaver",
        scale = 0.7,
    },
    ["bfd_twilight_aquamancer"] = {
        name = "Twilight Aquamancer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_aquamancer",
        scale = 0.7,
    },
    ["bfd_twilight_loreseeker"] = {
        name = "Twilight Loreseeker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_loreseeker",
        scale = 0.7,
    },
    ["bfd_twilight_acolyte"] = {
        name = "Twilight Acolyte",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_acolyte",
        scale = 0.7,
    },
    ["bfd_summoned_aqua_guardian"] = {
        name = "Summoned Aqua Guardian",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aqua_guardian",
        scale = 0.6,
    },
    ["bfd_deep_pool_threshfin"] = {
        name = "Deep Pool Threshfin",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\deep_pool_threshfin",
        scale = 0.8,
    },
    ["bfd_barbed_crustacean"] = {
        name = "Barbed Crustacean",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\barbed_crustacean",
        scale = 0.7,
    },
    ["bfd_twilight_shadowmage"] = {
        name = "Twilight Shadowmage",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_shadowmage",
        scale = 0.7,
    },
    ["bfd_twilight_elementalist"] = {
        name = "Twilight Elementalist",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_aquamancer",
        scale = 0.7,
    },
    ["bfd_enslaved_void_guardian"] = {
        name = "Enslaved Void Guardian",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\void_guardian",
        scale = 0.6,
    },
    ["bfd_aku_mai_snapjaw"] = {
        name = "Aku'mai Snapjaw",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aku_mai_snapjaw",
        scale = 0.7,
    },
}

local bosses = {
    ["bfd_boss_ghamoora"] = {
        name = "Ghamoo-ra",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aku_mai_snapjaw",
        scale = 1.25,
    },
    ["bfd_boss_lady_sarevess"] = {
        name = "Lady Sarevess",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lady_sarevess",
        scale = 1.25,
    },
    ["bfd_boss_gelihast"] = {
        name = "Gelihast",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blindlight_oracle",
        scale = 1.25,
    },
    ["bfd_boss_lorgus_jett"] = {
        name = "Lorgus Jett",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lorgus_jett",
        scale = 1.25,
    },
    ["bfd_boss_baron_aquanis"] = {
        name = "Baron Aquanis",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aqua_guardian",
        scale = 1.25,
    },
    ["bfd_boss_twilight_lord_kelris"] = {
        name = "Twilight Lord Kelris",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_lord_kelris",
        scale = 1.25,
    },
    ["bfd_boss_aku_mai"] = {
        name = "Aku'mai",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\aku_mai",
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
        {
            id = 80,
            x = 0.275,
            y = 0.898,
            mobs = {
                ["bfd_fallenroot_shadowstalker"] = 2,
            }
        },
        {
            id = 81,
            x = 0.319,
            y = 0.929,
            mobs = {
                ["bfd_fallenroot_shadowstalker"] = 1,
                ["bfd_blackfathom_sea_witch"] = 2,
            }
        },
        {
            id = 82,
            x = 0.363,
            y = 0.937,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 2,
            }
        },
        {
            id = 83,
            x = 0.404,
            y = 0.921,
            mobs = {
                ["bfd_fallenroot_shadowstalker"] = 1,
            },
            patrol = {
                { x = 0.380, y = 0.930 },
                { x = 0.425, y = 0.908 },
                { x = 0.448, y = 0.882 },
            }
        },
        {
            id = 84,
            x = 0.434,
            y = 0.846,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 2,
            }
        },
        {
            id = 85,
            x = 0.439,
            y = 0.869,
            mobs = {
                ["bfd_fallenroot_shadowstalker"] = 1,
            }
        },
        {
            id = 86,
            x = 0.464,
            y = 0.901,
            mobs = {
                ["bfd_fallenroot_hellcaller"] = 1,
                ["bfd_fallenroot_shadowstalker"] = 2,
            }
        },
        {
            id = 87,
            x = 0.467,
            y = 0.860,
            mobs = {
                ["bfd_fallenroot_hellcaller"] = 1,
            },
            patrol = {
                { x = 0.450, y = 0.884 },
                { x = 0.478, y = 0.845 },
                { x = 0.498, y = 0.788 },
            }
        },
        {
            id = 88,
            x = 0.494,
            y = 0.822,
            mobs = {
                ["bfd_fallenroot_hellcaller"] = 1,
                ["bfd_fallenroot_shadowstalker"] = 2,
            }
        },
        {
            id = 89,
            x = 0.497,
            y = 0.767,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 90,
            x = 0.508,
            y = 0.734,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
            }
        },
        {
            id = 91,
            x = 0.466,
            y = 0.722,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 2,
            }
        },
        {
            id = 92,
            x = 0.482,
            y = 0.638,
            mobs = {
                ["bfd_blindlight_muckdweller"] = 2,
            }
        },
        {
            id = 93,
            x = 0.493,
            y = 0.585,
            mobs = {
                ["bfd_blindlight_oracle"] = 2,
            }
        },
        {
            id = 94,
            x = 0.471,
            y = 0.591,
            mobs = {
                ["bfd_blindlight_oracle"] = 1,
            }
        },
        {
            id = 95,
            x = 0.446,
            y = 0.597,
            mobs = {
                ["bfd_blindlight_oracle"] = 1,
            }
        },
        {
            id = 96,
            x = 0.470,
            y = 0.572,
            mobs = {
                ["bfd_blindlight_muckdweller"] = 1,
            }
        },
        {
            id = 97,
            x = 0.479,
            y = 0.543,
            mobs = {
                ["bfd_blindlight_muckdweller"] = 2,
                ["bfd_blindlight_oracle"] = 1,
            }
        },
        {
            id = 98,
            x = 0.538,
            y = 0.725,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
                ["bfd_blackfathom_myrmidon"] = 1,
                ["bfd_fallenroot_hellcaller"] = 1,
            }
        },
        {
            id = 99,
            x = 0.536,
            y = 0.652,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
                ["bfd_fallenroot_shadowstalker"] = 1,
            }
        },
        {
            id = 100,
            x = 0.568,
            y = 0.724,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 2,
                ["bfd_fallenroot_hellcaller"] = 1,
                ["bfd_fallenroot_shadowstalker"] = 1,
            }
        },
        {
            id = 101,
            x = 0.776,
            y = 0.176,
            mobs = {
                ["bfd_fallenroot_hellcaller"] = 1,
                ["bfd_fallenroot_shadowstalker"] = 2,
            }
        },
        {
            id = 102,
            x = 0.773,
            y = 0.229,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 2,
            }
        },
        {
            id = 103,
            x = 0.735,
            y = 0.300,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
                ["bfd_fallenroot_hellcaller"] = 1,
            }
        },
        {
            id = 104,
            x = 0.778,
            y = 0.312,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
                ["bfd_fallenroot_hellcaller"] = 1,
            }
        },
        {
            id = 105,
            x = 0.754,
            y = 0.354,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
            }
        },
        {
            id = 106,
            x = 0.715,
            y = 0.385,
            mobs = {
                ["bfd_blackfathom_sea_witch"] = 1,
                ["bfd_fallenroot_hellcaller"] = 1,
            }
        },
        {
            id = 107,
            x = 0.695,
            y = 0.423,
            mobs = {
                ["bfd_fallenroot_hellcaller"] = 2,
            }
        },
        {
            id = 108,
            x = 0.667,
            y = 0.470,
            mobs = {
                ["bfd_blackfathom_myrmidon"] = 1,
                ["bfd_fallenroot_shadowstalker"] = 1,
            }
        },
        {
            id = 109,
            x = 0.721,
            y = 0.473,
            mobs = {
                ["bfd_twilight_loreseeker"] = 1,
                ["bfd_twilight_reaver"] = 1,
            }
        },
        {
            id = 110,
            x = 0.720,
            y = 0.530,
            mobs = {
                ["bfd_twilight_aquamancer"] = 1,
                ["bfd_twilight_reaver"] = 1,
                ["bfd_summoned_aqua_guardian"] = 1,
            }
        },
        {
            id = 111,
            x = 0.757,
            y = 0.473,
            mobs = {
                ["bfd_twilight_reaver"] = 2,
            }
        },
        {
            id = 112,
            x = 0.789,
            y = 0.482,
            mobs = {
                ["bfd_twilight_reaver"] = 2,
            }
        },
        {
            id = 113,
            x = 0.814,
            y = 0.471,
            mobs = {
                ["bfd_twilight_acolyte"] = 1,
            },
            patrol = {
                { x = 0.825, y = 0.467 },
                { x = 0.765, y = 0.467 },
                { x = 0.765, y = 0.441 },
                { x = 0.760, y = 0.441 },
                { x = 0.760, y = 0.467 },
                { x = 0.747, y = 0.467 },
                { x = 0.747, y = 0.477 },
                { x = 0.825, y = 0.477 },
            }
        },
        {
            id = 114,
            x = 0.767,
            y = 0.428,
            mobs = {
                ["bfd_twilight_acolyte"] = 1,
                ["bfd_twilight_loreseeker"] = 1,
                ["bfd_twilight_aquamancer"] = 1,
                ["bfd_summoned_aqua_guardian"] = 1,
            }
        },
        {
            id = 115,
            x = 0.829,
            y = 0.478,
            mobs = {
                ["bfd_twilight_loreseeker"] = 1,
            }
        },
        {
            id = 116,
            x = 0.850,
            y = 0.475,
            mobs = {
                ["bfd_twilight_acolyte"] = 1,
                ["bfd_twilight_aquamancer"] = 1,
                ["bfd_summoned_aqua_guardian"] = 1,
            }
        },
        {
            id = 117,
            x = 0.816,
            y = 0.438,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 118,
            x = 0.868,
            y = 0.489,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 119,
            x = 0.827,
            y = 0.520,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 120,
            x = 0.760,
            y = 0.524,
            mobs = {
                ["bfd_barbed_crustacean"] = 1,
            }
        },
        {
            id = 121,
            x = 0.790,
            y = 0.551,
            mobs = {
                ["bfd_twilight_loreseeker"] = 1,
                ["bfd_twilight_aquamancer"] = 1,
                ["bfd_summoned_aqua_guardian"] = 1,
            }
        },
        {
            id = 122,
            x = 0.844,
            y = 0.573,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 123,
            x = 0.834,
            y = 0.608,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 124,
            x = 0.875,
            y = 0.562,
            mobs = {
                ["bfd_barbed_crustacean"] = 1,
            }
        },
        {
            id = 125,
            x = 0.774,
            y = 0.624,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 126,
            x = 0.790,
            y = 0.607,
            mobs = {
                ["bfd_twilight_loreseeker"] = 1,
                ["bfd_twilight_aquamancer"] = 1,
                ["bfd_summoned_aqua_guardian"] = 1,
                ["bfd_twilight_reaver"] = 1,
            }
        },
        {
            id = 127,
            x = 0.788,
            y = 0.646,
            mobs = {
                ["bfd_twilight_loreseeker"] = 1,
                ["bfd_twilight_aquamancer"] = 1,
                ["bfd_summoned_aqua_guardian"] = 1,
                ["bfd_twilight_acolyte"] = 1,
            }
        },
        {
            id = 128,
            x = 0.825,
            y = 0.641,
            mobs = {
                ["bfd_twilight_loreseeker"] = 2,
            }
        },
        {
            id = 129,
            x = 0.808,
            y = 0.682,
            mobs = {
                ["bfd_barbed_crustacean"] = 1,
            }
        },
        {
            id = 130,
            x = 0.839,
            y = 0.687,
            mobs = {
                ["bfd_deep_pool_threshfin"] = 1,
            }
        },
        {
            id = 131,
            x = 0.861,
            y = 0.644,
            mobs = {
                ["bfd_twilight_shadowmage"] = 2,
                ["bfd_twilight_elementalist"] = 1,
                ["bfd_enslaved_void_guardian"] = 2,
            }
        },
        {
            id = 132,
            x = 0.858,
            y = 0.677,
            mobs = {
                ["bfd_twilight_elementalist"] = 1,
            }
        },
        {
            id = 133,
            x = 0.858,
            y = 0.603,
            mobs = {
                ["bfd_twilight_shadowmage"] = 1,
                ["bfd_enslaved_void_guardian"] = 1,
            }
        },
        {
            id = 134,
            x = 0.872,
            y = 0.584,
            mobs = {
                ["bfd_twilight_elementalist"] = 2,
            }
        },
        {
            id = 135,
            x = 0.875,
            y = 0.706,
            mobs = {
                ["bfd_twilight_shadowmage"] = 2,
                ["bfd_enslaved_void_guardian"] = 2,
            }
        },
        {
            id = 136,
            x = 0.904,
            y = 0.712,
            mobs = {
                ["bfd_twilight_elementalist"] = 1,
            }
        },
        {
            id = 137,
            x = 0.914,
            y = 0.690,
            mobs = {
                ["bfd_twilight_shadowmage"] = 1,
                ["bfd_enslaved_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.895, y = 0.690 },
                { x = 0.936, y = 0.690 },
            }
        },
        {
            id = 138,
            x = 0.885,
            y = 0.656,
            mobs = {
                ["bfd_twilight_shadowmage"] = 1,
                ["bfd_enslaved_void_guardian"] = 1,
            }
        },
        {
            id = 139,
            x = 0.896,
            y = 0.570,
            mobs = {
                ["bfd_twilight_elementalist"] = 1,
            }
        },
        {
            id = 140,
            x = 0.914,
            y = 0.585,
            mobs = {
                ["bfd_twilight_shadowmage"] = 1,
                ["bfd_enslaved_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.895, y = 0.585 },
                { x = 0.936, y = 0.585 },
            }
        },
        {
            id = 141,
            x = 0.623,
            y = 0.877,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
            }
        },
        {
            id = 142,
            x = 0.623,
            y = 0.807,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
            }
        },
        {
            id = 143,
            x = 0.661,
            y = 0.804,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
            }
        },
        {
            id = 144,
            x = 0.659,
            y = 0.858,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
            }
        },
        {
            id = 145,
            x = 0.773,
            y = 0.881,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
            }
        },
        {
            id = 146,
            x = 0.862,
            y = 0.921,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
            }
        },
        {
            id = 147,
            x = 0.844,
            y = 0.828,
            mobs = {
                ["bfd_aku_mai_snapjaw"] = 1,
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
        {
            id = 1002,
            x = 0.462,
            y = 0.531,
            mobs = {
                ["bfd_boss_gelihast"] = 1,
            }
        },
        {
            id = 1003,
            x = 0.850,
            y = 0.516,
            mobs = {
                ["bfd_boss_lorgus_jett"] = 1,
            }
        },
        {
            id = 1004,
            x = 0.750,
            y = 0.590,
            mobs = {
                ["bfd_boss_baron_aquanis"] = 1,
            }
        },
        {
            id = 1005,
            x = 0.916,
            y = 0.643,
            mobs = {
                ["bfd_boss_twilight_lord_kelris"] = 1,
            }
        },
        {
            id = 1006,
            x = 0.895,
            y = 0.891,
            mobs = {
                ["bfd_boss_aku_mai"] = 1,
            },
            patrol = {
                { x = 0.913, y = 0.891 },
                { x = 0.826, y = 0.891 },
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
        {
            id = 2,
            type = "action",
            x = 0.445,
            y = 0.537,
            name = "Shrine of Gelihast",
            description = "Frost Resistance 5%, All Stats 5%",
            scale = 0.5,
        },
    },
}

RDT.Data:RegisterDungeon("Blackfathom Deeps", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Blackfathom Deeps")
