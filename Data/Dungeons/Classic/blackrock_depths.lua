local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["brd_blazing_fireguard"] = {
        name = "Blazing Fireguard",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blazing_fireguard",
        scale = 0.6,
    },
    ["brd_anvilrage_footman"] = {
        name = "Anvilrage Footman",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_footman",
        scale = 0.6,
    },
    ["brd_anvilrage_warden"] = {
        name = "Anvilrage Warden",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_warden",
        scale = 0.6,
    },
    ["brd_anvilrage_overseer"] = {
        name = "Anvilrage Overseer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_overseer",
        scale = 0.6,
    },
    ["brd_anvilrage_guardsman"] = {
        name = "Anvilrage Guardsman",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_guardsman",
        scale = 0.6,
    },
    ["brd_twilights_hammer_torturer"] = {
        name = "Twilight's Hammer Torturer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilights_hammer_torturer",
        scale = 0.6,
    },
    ["brd_bloodhound"] = {
        name = "Bloodhound",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\bloodhound",
        scale = 0.5,
    },
}

local bosses = {
    ["brd_boss_high_interrogator_gerstahn"] = {
        name = "High Interrogator Gerstahn",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\high_interrogator_gerstahn",
        scale = 1.25,
    },
}

RDT.Data:RegisterMobs(mobs)
RDT.Data:RegisterMobs(bosses)

local tilesDefinition = {
    tileWidth = 512,
    tileHeight = 512,
    cols = 3,
    rows = 2,
    tiles = {
        "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_depths\\tile_0",
        "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_depths\\tile_1",
        "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_depths\\tile_2",
        "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_depths\\tile_3",
        "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_depths\\tile_4",
        "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\blackrock_depths\\tile_5",
    }
}

local packDefinition = {
    {
        id = 1,
        x = 0.689,
        y = 0.634,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
        }
    },
    {
        id = 2,
        x = 0.742,
        y = 0.694,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_warden"] = 1,
        }
    },
    {
        id = 3,
        x = 0.746,
        y = 0.609,
        mobs = {
            ["brd_bloodhound"] = 3,
        },
        patrol = {
            { x = 0.746, y = 0.609 },
            { x = 0.814, y = 0.641 },
            { x = 0.829, y = 0.707 },
            { x = 0.794, y = 0.723 },
            { x = 0.746, y = 0.609 },
        },
    },
    {
        id = 4,
        x = 0.776,
        y = 0.640,
        mobs = {
            ["brd_anvilrage_warden"] = 2,
        }
    },
    {
        id = 5,
        x = 0.813,
        y = 0.672,
        mobs = {
            ["brd_anvilrage_warden"] = 2,
        }
    },
    {
        id = 6,
        x = 0.783,
        y = 0.709,
        mobs = {
            ["brd_anvilrage_overseer"] = 1,
            ["brd_anvilrage_warden"] = 1,
        }
    },
    {
        id = 7,
        x = 0.771,
        y = 0.755,
        mobs = {
            ["brd_anvilrage_warden"] = 2,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 8,
        x = 0.810,
        y = 0.704,
        mobs = {
            ["brd_anvilrage_overseer"] = 1,
            ["brd_anvilrage_warden"] = 1,
        }
    },
    {
        id = 9,
        x = 0.844,
        y = 0.662,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_warden"] = 1,
        }
    },
    {
        id = 10,
        x = 0.803,
        y = 0.604,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
        }
    },
    {
        id = 11,
        x = 0.827,
        y = 0.748,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_warden"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 12,
        x = 0.803,
        y = 0.631,
        mobs = {
            ["brd_bloodhound"] = 3,
        },
        patrol = {
            { x = 0.803, y = 0.631 },
            { x = 0.767, y = 0.636 },
            { x = 0.827, y = 0.730 },
            { x = 0.774, y = 0.712 },
            { x = 0.803, y = 0.631 },
        },
    },
    {
        id = 13,
        x = 0.755,
        y = 0.662,
        mobs = {
            ["brd_bloodhound"] = 3,
        },
        patrol = {
            { x = 0.755, y = 0.662 },
            { x = 0.769, y = 0.711 },
            { x = 0.816, y = 0.715 },
            { x = 0.813, y = 0.735 },
            { x = 0.755, y = 0.662 },
        },
    },
    {
        id = 14,
        x = 0.784,
        y = 0.676,
        mobs = {
            ["brd_bloodhound"] = 2,
            ["brd_anvilrage_warden"] = 1,
        },
        patrol = {
            { x = 0.784, y = 0.676 },
            { x = 0.807, y = 0.624 },
            { x = 0.841, y = 0.668 },
            { x = 0.747, y = 0.698 },
            { x = 0.803, y = 0.729 },
            { x = 0.784, y = 0.676 },
        },
    },
    {
        id = 15,
        x = 0.803,
        y = 0.728,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
        },
        patrol = {
            { x = 0.803, y = 0.728 },
            { x = 0.841, y = 0.755 },
            { x = 0.889, y = 0.875 },
            { x = 0.845, y = 0.975 },
            { x = 0.767, y = 0.912 },
            { x = 0.774, y = 0.777 },
            { x = 0.803, y = 0.728 },
        },
    },
    {
        id = 16,
        x = 0.764,
        y = 0.806,
        mobs = {
            ["brd_bloodhound"] = 3,
        }
    },
    {
        id = 17,
        x = 0.768,
        y = 0.836,
        mobs = {
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 2,
            ["brd_anvilrage_warden"] = 1,
            ["brd_anvilrage_guardsman"] = 1,
        }
    },
    {
        id = 18,
        x = 0.738,
        y = 0.803,
        mobs = {
            ["brd_bloodhound"] = 1,
            ["brd_anvilrage_guardsman"] = 3,
        }
    },
    {
        id = 19,
        x = 0.841,
        y = 0.755,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
        },
        patrol = {
            { x = 0.841, y = 0.755 },
            { x = 0.889, y = 0.875 },
            { x = 0.845, y = 0.975 },
            { x = 0.767, y = 0.912 },
            { x = 0.774, y = 0.777 },
        },
    },
    {
        id = 20,
        x = 0.747,
        y = 0.870,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 21,
        x = 0.773,
        y = 0.892,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 22,
        x = 0.755,
        y = 0.929,
        mobs = {
            ["brd_anvilrage_warden"] = 2,
            ["brd_bloodhound"] = 4,
        }
    },
    {
        id = 23,
        x = 0.783,
        y = 0.946,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 24,
        x = 0.802,
        y = 0.947,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 25,
        x = 0.830,
        y = 0.982,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_twilights_hammer_torturer"] = 3,
        }
    },
    {
        id = 26,
        x = 0.860,
        y = 0.940,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 3,
        }
    },
    {
        id = 27,
        x = 0.890,
        y = 0.910,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_twilights_hammer_torturer"] = 2,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 28,
        x = 0.872,
        y = 0.897,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_anvilrage_warden"] = 2,
        }
    },
    {
        id = 29,
        x = 0.896,
        y = 0.851,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 30,
        x = 0.878,
        y = 0.842,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 31,
        x = 0.878,
        y = 0.802,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_anvilrage_warden"] = 2,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 32,
        x = 0.847,
        y = 0.794,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_anvilrage_warden"] = 2,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 33,
        x = 0.801,
        y = 0.774,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_twilights_hammer_torturer"] = 2,
            ["brd_anvilrage_warden"] = 1,
        }
    },
    {
        id = 34,
        x = 0.805,
        y = 0.806,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
            ["brd_bloodhound"] = 6,
        }
    },
    {
        id = 35,
        x = 0.814,
        y = 0.835,
        mobs = {
            ["brd_bloodhound"] = 2,
        },
        patrol = {
            { x = 0.800, y = 0.843 },
            { x = 0.842, y = 0.821 },
        },
    },
    {
        id = 36,
        x = 0.824,
        y = 0.866,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
        },
        patrol = {
            { x = 0.844, y = 0.859 },
            { x = 0.824, y = 0.866 },
            { x = 0.817, y = 0.822 },
            { x = 0.837, y = 0.822 },
            { x = 0.803, y = 0.841 },
            { x = 0.824, y = 0.866 },
            { x = 0.810, y = 0.875 },
        },
    },
    {
        id = 37,
        x = 0.796,
        y = 0.849,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_twilights_hammer_torturer"] = 2,
        }
    },
    {
        id = 38,
        x = 0.834,
        y = 0.825,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_twilights_hammer_torturer"] = 2,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 39,
        x = 0.805,
        y = 0.884,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_twilights_hammer_torturer"] = 2,
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_bloodhound"] = 1,
        }
    },
    {
        id = 40,
        x = 0.840,
        y = 0.868,
        mobs = {
            ["brd_anvilrage_warden"] = 2,
            ["brd_twilights_hammer_torturer"] = 2,
        }
    },
    {
        id = 41,
        x = 0.848,
        y = 0.921,
        mobs = {
            ["brd_anvilrage_warden"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },

    -------------------------------- Bosses --------------------------------
    {
        id = 1000,
        x = 0.826,
        y = 0.915,
        mobs = {
            ["brd_boss_high_interrogator_gerstahn"] = 1,
            ["brd_twilights_hammer_torturer"] = 1,
        },
    }
}

local prisonIdentifiers = {
    {
        id = 1,
        type = "dungeon-entrance",
        x = 0.175,
        y = 0.779,
        name = "Entrance Portal",
        description = "Main entrance",
    }
}

local upperCityIdentifiers = {
    {
        id = 1,
        type = "dungeon-entrance",
        x = 0.709,
        y = 0.604,
        name = "Entrance Portal",
        description = "Main entrance",
    }
}

local manufactoryIdentifiers = {
    {
        id = 1,
        type = "dungeon-entrance",
        x = 0.2,
        y = 0.1,
        name = "Entrance Portal",
        description = "Main entrance",
    }
}

local mapPrisonDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition,
    identifiers = prisonIdentifiers,
}

local mapUpperCityDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition,
    identifiers = upperCityIdentifiers,
}

local mapManufactoryDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition,
    identifiers = manufactoryIdentifiers,
}

RDT.Data:RegisterDungeon("Blackrock Depths Prison", mapPrisonDefinition)
RDT:DebugPrint("Loaded dungeon module: Blackrock Depths Prison")

RDT.Data:RegisterDungeon("Blackrock Depths Upper City", mapUpperCityDefinition)
RDT:DebugPrint("Loaded dungeon module: Blackrock Depths Upper City")

RDT.Data:RegisterDungeon("Blackrock Depths Manufactory", mapManufactoryDefinition)
RDT:DebugPrint("Loaded dungeon module: Blackrock Depths Manufactory")