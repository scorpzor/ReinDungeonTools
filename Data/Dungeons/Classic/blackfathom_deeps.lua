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
        scale = 0.9,
    },

    ["bfd_boss_lady_sarevess"] = {
        name = "Lady Sarevess",
        count = 1,
        displayIcon = "Interface\\Icons\\achievement_boss_elitenagamale",
        scale = 2.0,
    },
}

RDT.Data:RegisterMobs(mobs)

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
