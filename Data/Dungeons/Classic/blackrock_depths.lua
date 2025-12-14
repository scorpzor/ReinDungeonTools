local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["brd_blazing_fireguard"] = {
        name = "Blazing Fireguard",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blazing_fireguard",
        scale = 0.7,
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
    ["brd_anvilrage_soldier"] = {
        name = "Anvilrage Soldier",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_soldier",
        scale = 0.6,
    },
    ["brd_anvilrage_officer"] = {
        name = "Anvilrage Officer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_officer",
        scale = 0.6,
    },
    ["brd_anvilrage_medic"] = {
        name = "Anvilrage Medic",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_medic",
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
    ["brd_fireguard"] = {
        name = "Fireguard",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fireguard",
        scale = 0.6,
    },
    ["brd_warbringer_construct"] = {
        name = "Warbringer Construct",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warbringer_construct",
        scale = 0.7,
    },
    ["brd_doomforge_craftsman"] = {
        name = "Doomforge Craftsman",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\doomforge_craftsman",
        scale = 0.6,
    },
    ["brd_twilight_emissary"] = {
        name = "Twilight Emissary",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_emissary",
        scale = 0.6,
    },
    ["brd_shadowforge_peasant"] = {
        name = "Shadowforge Peasant",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\shadowforge_peasant",
        scale = 0.6,
    },
    ["brd_twilight_bodyguard"] = {
        name = "Twilight Bodyguard",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\twilight_bodyguard",
        scale = 0.6,
    },
    ["brd_bloodhound_mastiff"] = {
        name = "Bloodhound Mastiff",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\bloodhound_mastiff",
        scale = 0.6,
    },
    ["brd_fireguard_destroyer"] = {
        name = "Fireguard Destroyer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fireguard_destroyer",
        scale = 0.6,
    },
    ["brd_arena_spectator"] = {
        name = "Arena Spectator",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\arena_spectator",
        scale = 0.6,
    },
    ["brd_shadowforge_citizen"] = {
        name = "Shadowforge Citizen",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\shadowforge_citizen",
        scale = 0.6,
    },
    ["brd_shadowforge_senator"] = {
        name = "Shadowforge Senator",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\shadowforge_senator",
        scale = 0.6,
    },
    ["brd_anvilrage_marshal"] = {
        name = "Anvilrage Marshal",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_marshal",
        scale = 0.6,
    },
    ["brd_doomforge_dragoon"] = {
        name = "Doomforge Dragoon",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\doomforge_dragoon",
        scale = 0.6,
    },
    ["brd_weapon_technician"] = {
        name = "Weapon Technician",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\weapon_technician",
        scale = 0.6,
    },
    ["brd_doomforge_arcanasmith"] = {
        name = "Doomforge Arcanasmith",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\doomforge_arcanasmith",
        scale = 0.6,
    },
    ["brd_ragereaver_golem"] = {
        name = "Ragereaver Golem",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ragereaver_golem",
        scale = 0.7,
    },
    ["brd_wrath_hammer_construct"] = {
        name = "Wrath Hammer Construct",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wrath_hammer_construct",
        scale = 0.7,
    },
    ["brd_grim_patron"] = {
        name = "Grim Patron",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\grim_patron",
        scale = 0.4,
    },
    ["brd_guzzling_patron"] = {
        name = "Guzzling Patron",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\guzzling_patron",
        scale = 0.4,
    },
    ["brd_hammered_patron"] = {
        name = "Hammered Patron",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\hammered_patron",
        scale = 0.4,
    },
    ["brd_molten_war_golem"] = {
        name = "Molten War Golem",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\molten_war_golem",
        scale = 0.7,
    },
    ["brd_anvilrage_reservist"] = {
        name = "Anvilrage Reservist",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_reservist",
        scale = 0.5,
    },
    ["brd_shadowforge_flame_keeper"] = {
        name = "Shadowforge Flame Keeper",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\shadowforge_flame_keeper",
        scale = 0.7,
    },
}

local bosses = {
    ["brd_boss_high_interrogator_gerstahn"] = {
        name = "High Interrogator Gerstahn",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\high_interrogator_gerstahn",
        scale = 1.25,
    },
    ["brd_boss_lord_roccor"] = {
        name = "Lord Roccor",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lord_roccor",
        scale = 1.25,
    },
    ["brd_boss_houndmaster_grebmar"] = {
        name = "Houndmaster Grebmar",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\houndmaster_grebmar",
        scale = 1,
    },
    ["brd_boss_ring_of_the_law"] = {
        name = "Ring of the Law",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ring_of_the_law",
        scale = 1.25,
    },
    ["brd_boss_baelgar"] = {
        name = "Bael'Gar",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\baelgar",
        scale = 1.25,
    },
    ["brd_boss_lord_incendius"] = {
        name = "Lord Incendius",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lord_incendius",
        scale = 1.25,
    },
    ["brd_boss_fineous_darkvire"] = {
        name = "Fineous Darkvire",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\fineous_darkvire",
        scale = 1.25,
    },
    ["brd_boss_warder_stilgiss"] = {
        name = "Warder Stilgiss",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warder_stilgiss",
        scale = 1.25,
    },
    ["brd_boss_verek"] = {
        name = "Verek",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\verek",
        scale = 1.25,
    },
    ["brd_boss_pyromancer_loregrain"] = {
        name = "Pyromancer Loregrain",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\pyromancer_loregrain",
        scale = 1.25,
    },
    ["brd_boss_general_angerforge"] = {
        name = "General Angerforge",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\general_angerforge",
        scale = 1.25,
    },
    ["brd_boss_golem_lord_argelmach"] = {
        name = "Golem Lord Argelmach",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\golem_lord_argelmach",
        scale = 1.25,
    },
    ["brd_boss_plugger_spazzring"] = {
        name = "Plugger Spazzring",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\plugger_spazzring",
        scale = 0.7,
    },
    ["brd_boss_phalanx"] = {
        name = "Phalanx",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\phalanx",
        scale = 0.9,
    },
    ["brd_boss_ambassador_flemelash"] = {
        name = "Ambassador Flamelash",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ambassador_flemelash",
        scale = 1.25,
    },
    ["brd_boss_panzor_the_invincible"] = {
        name = "Panzor the Invincible",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\panzor_the_invincible",
        scale = 1.25,
    },
    ["brd_boss_chest_of_the_seven"] = {
        name = "Chest of the Seven",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\chest_of_the_seven",
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
    {
        id = 42,
        x = 0.877,
        y = 0.676,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_anvilrage_footman"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 43,
        x = 0.912,
        y = 0.659,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_anvilrage_footman"] = 1,
        }
    },
    {
        id = 44,
        x = 0.919,
        y = 0.604,
        mobs = {
            ["brd_fireguard"] = 1,
            ["brd_anvilrage_footman"] = 2,
        }
    },
    {
        id = 45,
        x = 0.926,
        y = 0.628,
        mobs = {
            ["brd_bloodhound"] = 3,
        },
        patrol = {
            { x = 0.861, y = 0.655 },
            { x = 0.926, y = 0.628 },
            { x = 0.950, y = 0.555 },
            { x = 0.899, y = 0.464 },
        },
    },
    {
        id = 46,
        x = 0.944,
        y = 0.607,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_anvilrage_footman"] = 3,
        }
    },
    {
        id = 47,
        x = 0.956,
        y = 0.562,
        mobs = {
            ["brd_anvilrage_footman"] = 4,
        }
    },
    {
        id = 48,
        x = 0.930,
        y = 0.546,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_anvilrage_footman"] = 2,
        }
    },
    {
        id = 49,
        x = 0.947,
        y = 0.512,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_bloodhound"] = 2,
            ["brd_fireguard"] = 1,
        }
    },
    {
        id = 50,
        x = 0.910,
        y = 0.514,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 51,
        x = 0.910,
        y = 0.484,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_anvilrage_footman"] = 2,
        }
    },
    {
        id = 52,
        x = 0.805,
        y = 0.573,
        mobs = {
            ["brd_bloodhound"] = 3,
        },
        patrol = {
            { x = 0.811, y = 0.577 },
            { x = 0.843, y = 0.473 },
            { x = 0.887, y = 0.460 },
            { x = 0.913, y = 0.479 },
        },
    },
    {
        id = 53,
        x = 0.874,
        y = 0.448,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_anvilrage_footman"] = 3,
        }
    },
    {
        id = 54,
        x = 0.867,
        y = 0.488,
        mobs = {
            ["brd_anvilrage_footman"] = 3,
        }
    },
    {
        id = 55,
        x = 0.831,
        y = 0.464,
        mobs = {
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_anvilrage_footman"] = 1,
            ["brd_fireguard"] = 2,
        }
    },
    {
        id = 56,
        x = 0.837,
        y = 0.498,
        mobs = {
            ["brd_anvilrage_guardsman"] = 4,
            ["brd_anvilrage_footman"] = 1,
        }
    },
    {
        id = 57,
        x = 0.804,
        y = 0.525,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_fireguard"] = 2,
        }
    },
    {
        id = 58,
        x = 0.822,
        y = 0.560,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 59,
        x = 0.683,
        y = 0.543,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
            ["brd_bloodhound"] = 2,
        }
    },
    {
        id = 60,
        x = 0.684,
        y = 0.490,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 2,
        }
    },
    {
        id = 61,
        x = 0.706,
        y = 0.509,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
        },
        patrol = {
            { x = 0.706, y = 0.502 },
            { x = 0.751, y = 0.454 },
        },
    },
    {
        id = 62,
        x = 0.655,
        y = 0.509,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 2,
        },
        patrol = {
            { x = 0.655, y = 0.509 },
            { x = 0.580, y = 0.437 },
        },
    },
    {
        id = 63,
        x = 0.737,
        y = 0.475,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
        },
        patrol = {
            { x = 0.779, y = 0.410 },
            { x = 0.737, y = 0.475 },
            { x = 0.684, y = 0.513 },
            { x = 0.632, y = 0.492 },
            { x = 0.560, y = 0.420 },
        },
    },
    {
        id = 64,
        x = 0.632,
        y = 0.492,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
        },
        patrol = {
            { x = 0.779, y = 0.410 },
            { x = 0.737, y = 0.475 },
            { x = 0.684, y = 0.513 },
            { x = 0.632, y = 0.492 },
            { x = 0.560, y = 0.420 },
        },
    },
    {
        id = 65,
        x = 0.754,
        y = 0.501,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 2,
        },
    },
    {
        id = 66,
        x = 0.772,
        y = 0.479,
        mobs = {
            ["brd_bloodhound"] = 3,
        },
    },
    {
        id = 67,
        x = 0.725,
        y = 0.440,
        mobs = {
            ["brd_anvilrage_soldier"] = 3,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
        },
    },
    {
        id = 68,
        x = 0.796,
        y = 0.459,
        mobs = {
            ["brd_anvilrage_soldier"] = 3,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
        },
    },
    {
        id = 69,
        x = 0.752,
        y = 0.369,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
            ["brd_bloodhound"] = 3,
        },
    },
    {
        id = 70,
        x = 0.770,
        y = 0.421,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
        },
        patrol = {
            { x = 0.796, y = 0.459 },
            { x = 0.752, y = 0.369 },
        },
    },
    {
        id = 71,
        x = 0.623,
        y = 0.530,
        mobs = {
            ["brd_anvilrage_soldier"] = 3,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
        },
    },
    {
        id = 72,
        x = 0.648,
        y = 0.465,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 2,
        },
    },
    {
        id = 73,
        x = 0.581,
        y = 0.494,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
            ["brd_bloodhound"] = 1,
        },
    },
    {
        id = 74,
        x = 0.608,
        y = 0.429,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 2,
            ["brd_bloodhound"] = 1,
        },
    },
    {
        id = 75,
        x = 0.530,
        y = 0.473,
        mobs = {
            ["brd_anvilrage_soldier"] = 2,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
        },
    },
    {
        id = 76,
        x = 0.577,
        y = 0.374,
        mobs = {
            ["brd_anvilrage_soldier"] = 1,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 2,
        },
    },
    {
        id = 77,
        x = 0.205,
        y = 0.697,
        mobs = {
            ["brd_anvilrage_soldier"] = 1,
            ["brd_anvilrage_officer"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_footman"] = 1,
        },
    },
    {
        id = 78,
        x = 0.218,
        y = 0.630,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
        },
    },
    {
        id = 79,
        x = 0.250,
        y = 0.592,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
        },
    },
    {
        id = 80,
        x = 0.274,
        y = 0.558,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
        },
    },
    {
        id = 81,
        x = 0.293,
        y = 0.535,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
        },
    },
    {
        id = 82,
        x = 0.370,
        y = 0.406,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
        },
    },
    {
        id = 83,
        x = 0.385,
        y = 0.349,
        mobs = {
            ["brd_doomforge_craftsman"] = 3,
            ["brd_warbringer_construct"] = 1,
        },
    },
    {
        id = 84,
        x = 0.399,
        y = 0.368,
        mobs = {
            ["brd_warbringer_construct"] = 1,
        },
        patrol = {
            { x = 0.399, y = 0.368 },
            { x = 0.422, y = 0.332 },
            { x = 0.470, y = 0.401 },
            { x = 0.444, y = 0.442 },
        },
    },
    {
        id = 85,
        x = 0.422,
        y = 0.307,
        mobs = {
            ["brd_doomforge_craftsman"] = 6,
            ["brd_warbringer_construct"] = 2,
        },
    },
    {
        id = 86,
        x = 0.451,
        y = 0.362,
        mobs = {
            ["brd_doomforge_craftsman"] = 3,
            ["brd_warbringer_construct"] = 1,
        },
    },
    {
        id = 87,
        x = 0.474,
        y = 0.405,
        mobs = {
            ["brd_doomforge_craftsman"] = 6,
            ["brd_warbringer_construct"] = 2,
        },
    },
    {
        id = 88,
        x = 0.452,
        y = 0.456,
        mobs = {
            ["brd_doomforge_craftsman"] = 3,
            ["brd_warbringer_construct"] = 1,
        },
    },
    {
        id = 89,
        x = 0.418,
        y = 0.462,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
        },
        patrol = {
            { x = 0.418, y = 0.462 },
            { x = 0.372, y = 0.461 },
            { x = 0.363, y = 0.503 },
            { x = 0.323, y = 0.519 },
        },
    },
    {
        id = 90,
        x = 0.376,
        y = 0.469,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
        },
    },
    {
        id = 91,
        x = 0.368,
        y = 0.448,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 2,
            ["brd_doomforge_craftsman"] = 1,
            ["brd_anvilrage_officer"] = 1,
        },
    },
    {
        id = 92,
        x = 0.359,
        y = 0.508,
        mobs = {
            ["brd_twilight_bodyguard"] = 1,
            ["brd_shadowforge_peasant"] = 3,
            ["brd_twilight_emissary"] = 2,
        },
    },
    {
        id = 93,
        x = 0.327,
        y = 0.527,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 2,
            ["brd_doomforge_craftsman"] = 1,
            ["brd_anvilrage_officer"] = 1,
        },
    },
    {
        id = 94,
        x = 0.381,
        y = 0.543,
        mobs = {
            ["brd_twilight_bodyguard"] = 1,
            ["brd_shadowforge_peasant"] = 3,
            ["brd_twilight_emissary"] = 2,
        },
    },
    {
        id = 95,
        x = 0.284,
        y = 0.607,
        mobs = {
            ["brd_twilight_bodyguard"] = 1,
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 1,
        },
    },
    {
        id = 96,
        x = 0.310,
        y = 0.635,
        mobs = {
            ["brd_anvilrage_medic"] = 1,
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 1,
            ["brd_bloodhound_mastiff"] = 1,
            ["brd_anvilrage_soldier"] = 1,
        },
    },
    {
        id = 97,
        x = 0.327,
        y = 0.600,
        mobs = {
            ["brd_twilight_bodyguard"] = 1,
            ["brd_anvilrage_medic"] = 1,
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 1,
            ["brd_bloodhound_mastiff"] = 1,
        },
    },
    {
        id = 98,
        x = 0.335,
        y = 0.662,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
            ["brd_shadowforge_peasant"] = 1,
            ["brd_twilight_emissary"] = 1,
            ["brd_bloodhound_mastiff"] = 1,
        },
    },
    {
        id = 99,
        x = 0.363,
        y = 0.647,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_shadowforge_peasant"] = 3,
            ["brd_bloodhound_mastiff"] = 1,
        },
    },
    {
        id = 100,
        x = 0.363,
        y = 0.614,
        mobs = {
            ["brd_anvilrage_medic"] = 1,
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 1,
            ["brd_bloodhound_mastiff"] = 1,
        },
    },
    {
        id = 101,
        x = 0.354,
        y = 0.581,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_shadowforge_peasant"] = 3,
            ["brd_bloodhound_mastiff"] = 1,
        },
    },
    {
        id = 102,
        x = 0.332,
        y = 0.709,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
        },
    },
    {
        id = 103,
        x = 0.340,
        y = 0.735,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
        },
        patrol = {
            { x = 0.337, y = 0.703 },
            { x = 0.341, y = 0.793 },
        },
    },
    {
        id = 104,
        x = 0.340,
        y = 0.767,
        mobs = {
            ["brd_blazing_fireguard"] = 2,
            ["brd_anvilrage_guardsman"] = 4,
        },
    },
    {
        id = 105,
        x = 0.344,
        y = 0.812,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_twilight_emissary"] = 1,
            ["brd_bloodhound_mastiff"] = 1,
        },
    },
    {
        id = 106,
        x = 0.344,
        y = 0.879,
        mobs = {
            ["brd_shadowforge_peasant"] = 3,
            ["brd_twilight_emissary"] = 2,
            ["brd_twilight_bodyguard"] = 1,
        },
    },
    {
        id = 107,
        x = 0.345,
        y = 0.930,
        mobs = {
            ["brd_shadowforge_peasant"] = 4,
            ["brd_doomforge_craftsman"] = 1,
            ["brd_anvilrage_medic"] = 1,
        },
    },
    {
        id = 108,
        x = 0.300,
        y = 0.853,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_arena_spectator"] = 2,
            ["brd_shadowforge_senator"] = 1,
            ["brd_shadowforge_citizen"] = 2,
            ["brd_anvilrage_soldier"] = 1,
            ["brd_anvilrage_officer"] = 1,
        },
    },
    {
        id = 109,
        x = 0.255,
        y = 0.814,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_arena_spectator"] = 2,
            ["brd_shadowforge_senator"] = 1,
            ["brd_shadowforge_citizen"] = 2,
            ["brd_anvilrage_soldier"] = 1,
            ["brd_anvilrage_officer"] = 1,
        },
    },
    {
        id = 110,
        x = 0.220,
        y = 0.845,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_arena_spectator"] = 3,
            ["brd_shadowforge_citizen"] = 2,
            ["brd_anvilrage_medic"] = 2,
        },
    },
    {
        id = 111,
        x = 0.210,
        y = 0.928,
        mobs = {
            ["brd_arena_spectator"] = 7,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_soldier"] = 1,
        },
    },
    {
        id = 112,
        x = 0.241,
        y = 0.970,
        mobs = {
            ["brd_shadowforge_peasant"] = 2,
            ["brd_arena_spectator"] = 3,
            ["brd_shadowforge_citizen"] = 2,
            ["brd_anvilrage_medic"] = 2,
        },
    },
    {
        id = 113,
        x = 0.291,
        y = 0.924,
        mobs = {
            ["brd_arena_spectator"] = 7,
            ["brd_anvilrage_medic"] = 1,
            ["brd_anvilrage_soldier"] = 1,
        },
    },
    {
        id = 114,
        x = 0.110,
        y = 0.910,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
            ["brd_anvilrage_guardsman"] = 1,
        },
    },
    {
        id = 115,
        x = 0.145,
        y = 0.882,
        mobs = {
            ["brd_fireguard"] = 1,
        },
        patrol = {
            { x = 0.158, y = 0.882 },
            { x = 0.137, y = 0.882 },
            { x = 0.137, y = 0.920 },
            { x = 0.125, y = 0.907 },
            { x = 0.125, y = 0.870 },
        },
    },
    {
        id = 116,
        x = 0.124,
        y = 0.895,
        mobs = {
            ["brd_anvilrage_guardsman"] = 3,
        },
    },
    {
        id = 117,
        x = 0.126,
        y = 0.850,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_fireguard"] = 1,
        },
    },
    {
        id = 118,
        x = 0.151,
        y = 0.922,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
            ["brd_anvilrage_guardsman"] = 2,
        },
    },
    {
        id = 119,
        x = 0.173,
        y = 0.922,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_guardsman"] = 1,
        },
    },
    {
        id = 120,
        x = 0.153,
        y = 0.831,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
            ["brd_anvilrage_guardsman"] = 1,
            ["brd_fireguard"] = 2,
        },
    },
    {
        id = 121,
        x = 0.171,
        y = 0.865,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_guardsman"] = 2,
        },
    },
    {
        id = 122,
        x = 0.167,
        y = 0.882,
        mobs = {
            ["brd_fireguard"] = 1,
        },
        patrol = {
            { x = 0.167, y = 0.915 },
            { x = 0.167, y = 0.882 },
            { x = 0.167, y = 0.837 },
            { x = 0.190, y = 0.837 },
        },
    },
    {
        id = 123,
        x = 0.177,
        y = 0.826,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_guardsman"] = 1,
        },
    },
    {
        id = 124,
        x = 0.188,
        y = 0.849,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
        },
    },
    {
        id = 125,
        x = 0.209,
        y = 0.781,
        mobs = {
            ["brd_anvilrage_guardsman"] = 2,
            ["brd_fireguard"] = 1,
        },
    },
    {
        id = 126,
        x = 0.203,
        y = 0.745,
        mobs = {
            ["brd_anvilrage_footman"] = 2,
            ["brd_anvilrage_guardsman"] = 1,
        },
    },
    {
        id = 127,
        x = 0.124,
        y = 0.661,
        mobs = {
            ["brd_doomforge_dragoon"] = 2,
            ["brd_anvilrage_marshal"] = 2,
        },
    },
    {
        id = 128,
        x = 0.090,
        y = 0.690,
        mobs = {
            ["brd_doomforge_dragoon"] = 2,
            ["brd_fireguard_destroyer"] = 1,
        },
    },
    {
        id = 129,
        x = 0.090,
        y = 0.745,
        mobs = {
            ["brd_doomforge_dragoon"] = 1,
            ["brd_fireguard_destroyer"] = 2,
            ["brd_anvilrage_marshal"] = 1,
        },
    },
    {
        id = 130,
        x = 0.054,
        y = 0.738,
        mobs = {
            ["brd_anvilrage_marshal"] = 2,
        },
    },
    {
        id = 131,
        x = 0.047,
        y = 0.714,
        mobs = {
            ["brd_fireguard_destroyer"] = 2,
            ["brd_anvilrage_marshal"] = 1,
        },
    },
    {
        id = 132,
        x = 0.023,
        y = 0.714,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
            ["brd_anvilrage_marshal"] = 2,
        },
    },
    {
        id = 133,
        x = 0.020,
        y = 0.752,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
            ["brd_anvilrage_marshal"] = 1,
            ["brd_doomforge_dragoon"] = 1,
        },
    },
    {
        id = 134,
        x = 0.072,
        y = 0.715,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
        },
        patrol = {
            { x = 0.072, y = 0.715 },
            { x = 0.054, y = 0.715 },
            { x = 0.081, y = 0.742 },
            { x = 0.090, y = 0.699 },
        },
    },
    {
        id = 135,
        x = 0.083,
        y = 0.774,
        mobs = {
            ["brd_anvilrage_marshal"] = 2,
            ["brd_doomforge_dragoon"] = 1,
        },
    },
    {
        id = 136,
        x = 0.024,
        y = 0.769,
        mobs = {
            ["brd_fireguard_destroyer"] = 2,
        },
    },
    {
        id = 137,
        x = 0.054,
        y = 0.586,
        mobs = {
            ["brd_weapon_technician"] = 1,
        },
        patrol = {
            { x = 0.030, y = 0.591 },
            { x = 0.089, y = 0.591 },
        },
    },
    {
        id = 138,
        x = 0.062,
        y = 0.586,
        mobs = {
            ["brd_weapon_technician"] = 1,
        },
        patrol = {
            { x = 0.030, y = 0.591 },
            { x = 0.089, y = 0.591 },
        },
    },
    {
        id = 139,
        x = 0.054,
        y = 0.600,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 1,
        },
        patrol = {
            { x = 0.030, y = 0.600 },
            { x = 0.089, y = 0.600 },
        },
    },
    {
        id = 140,
        x = 0.062,
        y = 0.600,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 1,
        },
        patrol = {
            { x = 0.030, y = 0.600 },
            { x = 0.089, y = 0.600 },
        },
    },
    {
        id = 141,
        x = 0.024,
        y = 0.586,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 2,
            ["brd_weapon_technician"] = 1,
            ["brd_wrath_hammer_construct"] = 1,
        },
    },
    {
        id = 142,
        x = 0.052,
        y = 0.645,
        mobs = {
            ["brd_weapon_technician"] = 1,
        },
        patrol = {
            { x = 0.029, y = 0.648 },
            { x = 0.074, y = 0.648 },
        },
    },
    {
        id = 143,
        x = 0.023,
        y = 0.663,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 3,
            ["brd_weapon_technician"] = 4,
        },
    },
    {
        id = 144,
        x = 0.018,
        y = 0.621,
        mobs = {
            ["brd_weapon_technician"] = 1,
        },
        patrol = {
            { x = 0.026, y = 0.650 },
            { x = 0.026, y = 0.595 },
        },
    },
    {
        id = 145,
        x = 0.037,
        y = 0.625,
        mobs = {
            ["brd_weapon_technician"] = 4,
            ["brd_ragereaver_golem"] = 1,
        },
    },
    {
        id = 146,
        x = 0.056,
        y = 0.627,
        mobs = {
            ["brd_weapon_technician"] = 1,
        },
        patrol = {
            { x = 0.053, y = 0.627 },
            { x = 0.023, y = 0.625 },
            { x = 0.096, y = 0.637 },
        },
    },
    {
        id = 147,
        x = 0.079,
        y = 0.621,
        mobs = {
            ["brd_weapon_technician"] = 2,
            ["brd_ragereaver_golem"] = 2,
            ["brd_wrath_hammer_construct"] = 2,
            ["brd_doomforge_arcanasmith"] = 1,
        },
    },
    {
        id = 148,
        x = 0.100,
        y = 0.638,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 1,
        },
    },
    {
        id = 149,
        x = 0.114,
        y = 0.608,
        mobs = {
            ["brd_weapon_technician"] = 4,
            ["brd_wrath_hammer_construct"] = 1,
            ["brd_doomforge_arcanasmith"] = 1,
        },
    },
    {
        id = 150,
        x = 0.095,
        y = 0.596,
        mobs = {
            ["brd_weapon_technician"] = 1,
        },
        patrol = {
            { x = 0.117, y = 0.607 },
            { x = 0.095, y = 0.596 },
            { x = 0.083, y = 0.615 },
        },
    },
    {
        id = 151,
        x = 0.150,
        y = 0.562,
        mobs = {
            ["brd_fireguard_destroyer"] = 2,
        },
    },
    {
        id = 152,
        x = 0.180,
        y = 0.549,
        mobs = {
            ["brd_fireguard_destroyer"] = 2,
        },
    },
    {
        id = 153,
        x = 0.205,
        y = 0.500,
        mobs = {
            ["brd_guzzling_patron"] = 3,
            ["brd_grim_patron"] = 3,
        },
    },
    {
        id = 154,
        x = 0.228,
        y = 0.508,
        mobs = {
            ["brd_guzzling_patron"] = 7,
            ["brd_grim_patron"] = 5,
            ["brd_hammered_patron"] = 1,
        },
    },
    {
        id = 155,
        x = 0.230,
        y = 0.562,
        mobs = {
            ["brd_guzzling_patron"] = 6,
            ["brd_grim_patron"] = 7,
            ["brd_hammered_patron"] = 4,
        },
    },
    {
        id = 156,
        x = 0.250,
        y = 0.538,
        mobs = {
            ["brd_hammered_patron"] = 2,
        },
    },
    {
        id = 157,
        x = 0.263,
        y = 0.518,
        mobs = {
            ["brd_guzzling_patron"] = 3,
            ["brd_grim_patron"] = 4,
        },
    },
    {
        id = 158,
        x = 0.264,
        y = 0.454,
        mobs = {
            ["brd_guzzling_patron"] = 4,
            ["brd_grim_patron"] = 6,
        },
    },
    {
        id = 159,
        x = 0.271,
        y = 0.488,
        mobs = {
            ["brd_guzzling_patron"] = 3,
            ["brd_grim_patron"] = 1,
            ["brd_hammered_patron"] = 5,
        },
    },
    {
        id = 160,
        x = 0.302,
        y = 0.507,
        mobs = {
            ["brd_shadowforge_citizen"] = 3,
            ["brd_doomforge_arcanasmith"] = 1,
            ["brd_fireguard_destroyer"] = 2,
        },
    },
    {
        id = 161,
        x = 0.306,
        y = 0.451,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
        },
        patrol = {
            { x = 0.300, y = 0.515 },
            { x = 0.306, y = 0.451 },
            { x = 0.363, y = 0.402 },
        },
    },
    {
        id = 162,
        x = 0.330,
        y = 0.407,
        mobs = {
            ["brd_shadowforge_citizen"] = 3,
            ["brd_doomforge_dragoon"] = 2,
            ["brd_weapon_technician"] = 1,
        },
    },
    {
        id = 163,
        x = 0.365,
        y = 0.408,
        mobs = {
            ["brd_shadowforge_citizen"] = 2,
            ["brd_doomforge_arcanasmith"] = 2,
            ["brd_anvilrage_marshal"] = 1,
        },
    },
    {
        id = 164,
        x = 0.245,
        y = 0.167,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 3,
            ["brd_molten_war_golem"] = 1,
        },
    },
    {
        id = 165,
        x = 0.256,
        y = 0.079,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 2,
            ["brd_molten_war_golem"] = 1,
        },
    },
    {
        id = 166,
        x = 0.217,
        y = 0.141,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 2,
            ["brd_molten_war_golem"] = 1,
        },
    },
    {
        id = 167,
        x = 0.200,
        y = 0.100,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 2,
            ["brd_molten_war_golem"] = 1,
        },
    },
    {
        id = 168,
        x = 0.227,
        y = 0.054,
        mobs = {
            ["brd_doomforge_arcanasmith"] = 3,
            ["brd_molten_war_golem"] = 1,
        },
    },
    {
        id = 169,
        x = 0.447,
        y = 0.166,
        mobs = {
            ["brd_fireguard_destroyer"] = 3,
        },
    },
    {
        id = 170,
        x = 0.474,
        y = 0.205,
        mobs = {
            ["brd_fireguard_destroyer"] = 3,
        },
    },
    {
        id = 171,
        x = 0.481,
        y = 0.169,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
        },
    },
    {
        id = 172,
        x = 0.587,
        y = 0.270,
        mobs = {
            ["brd_anvilrage_reservist"] = 9,
        },
    },
    {
        id = 173,
        x = 0.606,
        y = 0.298,
        mobs = {
            ["brd_anvilrage_reservist"] = 5,
        },
    },
    {
        id = 174,
        x = 0.630,
        y = 0.291,
        mobs = {
            ["brd_anvilrage_reservist"] = 10,
        },
    },
    {
        id = 175,
        x = 0.571,
        y = 0.237,
        mobs = {
            ["brd_anvilrage_reservist"] = 3,
        },
    },
    {
        id = 176,
        x = 0.587,
        y = 0.238,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 177,
        x = 0.617,
        y = 0.256,
        mobs = {
            ["brd_anvilrage_reservist"] = 3,
        },
    },
    {
        id = 178,
        x = 0.639,
        y = 0.252,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 179,
        x = 0.656,
        y = 0.254,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 180,
        x = 0.675,
        y = 0.225,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
        },
    },
    {
        id = 181,
        x = 0.675,
        y = 0.100,
        mobs = {
            ["brd_fireguard_destroyer"] = 1,
        },
    },
    {
        id = 182,
        x = 0.675,
        y = 0.259,
        mobs = {
            ["brd_anvilrage_reservist"] = 3,
        },
    },
    {
        id = 183,
        x = 0.697,
        y = 0.259,
        mobs = {
            ["brd_anvilrage_reservist"] = 4,
        },
    },
    {
        id = 184,
        x = 0.690,
        y = 0.232,
        mobs = {
            ["brd_anvilrage_reservist"] = 3,
        },
    },
    {
        id = 185,
        x = 0.646,
        y = 0.234,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 186,
        x = 0.617,
        y = 0.233,
        mobs = {
            ["brd_anvilrage_reservist"] = 3,
        },
    },
    {
        id = 187,
        x = 0.524,
        y = 0.209,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 188,
        x = 0.542,
        y = 0.217,
        mobs = {
            ["brd_anvilrage_reservist"] = 4,
        },
    },
    {
        id = 189,
        x = 0.590,
        y = 0.213,
        mobs = {
            ["brd_anvilrage_reservist"] = 5,
        },
    },
    {
        id = 190,
        x = 0.632,
        y = 0.212,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 191,
        x = 0.646,
        y = 0.212,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 192,
        x = 0.661,
        y = 0.209,
        mobs = {
            ["brd_anvilrage_reservist"] = 2,
        },
    },
    {
        id = 193,
        x = 0.711,
        y = 0.218,
        mobs = {
            ["brd_anvilrage_reservist"] = 3,
        },
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
    },
    {
        id = 1001,
        x = 0.885,
        y = 0.635,
        mobs = {
            ["brd_boss_lord_roccor"] = 1,
        },
        patrol = {
            { x = 0.880, y = 0.648 },
            { x = 0.938, y = 0.604 },
            { x = 0.946, y = 0.533 },
            { x = 0.893, y = 0.462 },
            { x = 0.823, y = 0.507 },
            { x = 0.811, y = 0.591 },
        },
    },
    {
        id = 1002,
        x = 0.958,
        y = 0.432,
        mobs = {
            ["brd_boss_houndmaster_grebmar"] = 1,
            ["brd_bloodhound"] = 19,
        },
    },
    {
        id = 1003,
        x = 0.958,
        y = 0.432,
        mobs = {
            ["brd_boss_ring_of_the_law"] = 1,
        },
    },
    {
        id = 1004,
        x = 0.564,
        y = 0.422,
        mobs = {
            ["brd_boss_baelgar"] = 1,
        },
    },
    {
        id = 1005,
        x = 0.333,
        y = 0.464,
        mobs = {
            ["brd_boss_lord_incendius"] = 1,
        },
    },
    {
        id = 1006,
        x = 0.422,
        y = 0.348,
        mobs = {
            ["brd_boss_fineous_darkvire"] = 1,
        },
        patrol = {
            { x = 0.399, y = 0.368 },
            { x = 0.422, y = 0.332 },
            { x = 0.470, y = 0.401 },
            { x = 0.444, y = 0.442 },
        },
    },
    {
        id = 1007,
        x = 0.402,
        y = 0.576,
        mobs = {
            ["brd_boss_warder_stilgiss"] = 1,
            ["brd_boss_verek"] = 1,
        },
    },
    {
        id = 1008,
        x = 0.311,
        y = 0.967,
        mobs = {
            ["brd_boss_pyromancer_loregrain"] = 1,
            ["brd_twilight_emissary"] = 2,
        },
    },
    {
        id = 1009,
        x = 0.060,
        y = 0.791,
        mobs = {
            ["brd_boss_general_angerforge"] = 1,
        },
    },
    {
        id = 1010,
        x = 0.058,
        y = 0.527,
        mobs = {
            ["brd_boss_golem_lord_argelmach"] = 1,
            ["brd_wrath_hammer_construct"] = 1,
            ["brd_ragereaver_golem"] = 1,
        },
    },
    {
        id = 1011,
        x = 0.246,
        y = 0.472,
        mobs = {
            ["brd_boss_plugger_spazzring"] = 1,
            ["brd_guzzling_patron"] = 2,
            ["brd_grim_patron"] = 2,
        },
    },
    {
        id = 1012,
        x = 0.281,
        y = 0.516,
        mobs = {
            ["brd_boss_phalanx"] = 1,
        },
    },
    {
        id = 1013,
        x = 0.310,
        y = 0.252,
        mobs = {
            ["brd_boss_ambassador_flemelash"] = 1,
        },
    },
    {
        id = 1014,
        x = 0.269,
        y = 0.116,
        mobs = {
            ["brd_boss_panzor_the_invincible"] = 1,
        },
        patrol = {
            { x = 0.251, y = 0.069 },
            { x = 0.269, y = 0.116 },
            { x = 0.230, y = 0.190 },
            { x = 0.200, y = 0.120 },
            { x = 0.232, y = 0.054 },
        },
    },
    {
        id = 1015,
        x = 0.374,
        y = 0.156,
        mobs = {
            ["brd_boss_chest_of_the_seven"] = 1,
        },
    },
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
        x = 0.1,
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