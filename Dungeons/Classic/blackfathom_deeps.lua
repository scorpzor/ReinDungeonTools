local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--------------------------------------------------------------------------------
-- Mob Definitions
--------------------------------------------------------------------------------

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
}

RDT.Data:RegisterMobs(mobs)

--------------------------------------------------------------------------------
-- Map Definitions
--------------------------------------------------------------------------------

local mainGate = {
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
    },
}

RDT.Data:RegisterDungeon("Blackfathom Deeps", mainGate)

RDT:DebugPrint("Loaded dungeon module: Blackfathom Deeps")
