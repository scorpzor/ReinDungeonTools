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
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\blackfathom_deeps\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\blackfathom_deeps\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\blackfathom_deeps\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\blackfathom_deeps\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\blackfathom_deeps\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\blackfathom_deeps\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.493,
            y = 0.170,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 2,
            x = 0.530,
            y = 0.290,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 3,
            x = 0.507,
            y = 0.288,
            mobs = {
                ["bfd_skittering_crustacean"] = 2,
            }
        },
        {
            id = 4,
            x = 0.486,
            y = 0.307,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 5,
            x = 0.538,
            y = 0.248,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 6,
            x = 0.519,
            y = 0.319,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 7,
            x = 0.553,
            y = 0.396,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 8,
            x = 0.571,
            y = 0.420,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 9,
            x = 0.478,
            y = 0.344,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
        {
            id = 10,
            x = 0.552,
            y = 0.318,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 11,
            x = 0.568,
            y = 0.339,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 12,
            x = 0.589,
            y = 0.386,
            mobs = {
                ["bfd_blindlight_murloc"] = 2,
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 13,
            x = 0.596,
            y = 0.441,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 14,
            x = 0.441,
            y = 0.356,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 15,
            x = 0.421,
            y = 0.401,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 16,
            x = 0.475,
            y = 0.365,
            mobs = {
                ["bfd_blindlight_murloc"] = 1,
            }
        },
        {
            id = 17,
            x = 0.426,
            y = 0.443,
            mobs = {
                ["bfd_murkshallow_snapclaw"] = 1,
            }
        },
        {
            id = 18,
            x = 0.404,
            y = 0.475,
            mobs = {
                ["bfd_skittering_crustacean"] = 1,
            }
        },
    },
    identifiers = {
        -- Entrance and main doors
        {
            id = 1,
            type = "door-in",
            x = 0.49,
            y = 0.12,
            name = "Entrance Portal",
            description = "Main entrance to Blackfathom Deeps",
            linkedTo = 2,
        },
        {
            id = 2,
            type = "door-out",
            x = 0.52,
            y = 0.22,
            name = "Iron Gate",
            description = "Sealed iron gate to the depths",
            linkedTo = 1,
        },

        -- Underwater passages
        {
            id = 3,
            type = "stairs",
            x = 0.46,
            y = 0.28,
            name = "Descent",
            description = "Spiral ramp leading down",
        },
        {
            id = 4,
            type = "stairs",
            x = 0.58,
            y = 0.36,
            name = "Cavern Steps",
            description = "Steps carved into the rock",
            scale = 0.95,
        },

        -- Teleportation shrines (Portal pair 1)
        {
            id = 5,
            type = "portal",
            x = 0.42,
            y = 0.38,
            name = "Shrine of Water",
            description = "Ancient naga teleportation shrine",
            linkedTo = 6,
            scale = 1.15,
        },
        {
            id = 6,
            type = "portal",
            x = 0.61,
            y = 0.45,
            name = "Shrine of Depths",
            description = "Connected to the Shrine of Water",
            linkedTo = 5,
            scale = 1.15,
        },

        -- Special actions
        {
            id = 7,
            type = "action",
            x = 0.50,
            y = 0.40,
            name = "Altar of the Deeps",
            description = "Summons the Guardian of the Deeps",
            scale = 1.2,
        },
        {
            id = 8,
            type = "action",
            x = 0.55,
            y = 0.26,
            name = "Twilight Flame",
            description = "Corrupted flame brazier",
            scale = 0.9,
        },
    },
}

RDT.Data:RegisterDungeon("Blackfathom Deeps", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Blackfathom Deeps")
