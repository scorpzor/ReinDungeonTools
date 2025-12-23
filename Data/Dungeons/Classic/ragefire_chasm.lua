local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--------------------------------------------------------------------------------
-- Mob Definitions
--------------------------------------------------------------------------------

local mobs = {
    ["rfc_molten_elemental"] = {
        name = "Molten Elemental",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\molten_elemental",
        scale = 0.7,
    },
    ["rfc_earthborer"] = {
        name = "Earthborer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\earthborer",
        scale = 0.7,
    },
    ["rfc_ragefire_trogg"] = {
        name = "Ragefire Trogg",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ragefire_trogg",
        scale = 0.7,
    },
    ["rfc_ragefire_shaman"] = {
        name = "Ragefire Shaman",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\ragefire_shaman",
        scale = 0.7,
    },
    ["rfc_searing_blade_cultist"] = {
        name = "Searing Blade Cultist",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\searing_blade_cultist",
        scale = 0.7,
    },
    ["rfc_searing_blade_enforcer"] = {
        name = "Searing Blade Enforcer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\searing_blade_enforcer",
        scale = 0.7,
    },
    ["rfc_searing_blade_warlock"] = {
        name = "Searing Blade Enforcer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\searing_blade_warlock",
        scale = 0.7,
    },
    ["rfc_void_guardian"] = {
        name = "Void Guardian",
        count = 0,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\void_guardian",
        scale = 0.6,
    }
}

local bosses = {
    ["rfc_boss_oggleflint"] = {
        name = "Oggleflint",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\oggleflint",
        scale = 1.25,
    },
    ["rfc_boss_taragaman_the_hungerer"] = {
        name = "Taragaman the Hungerer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\taragaman_the_hungerer",
        scale = 1.25,
    },
    ["rfc_boss_bazzalan"] = {
        name = "Bazzalan",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\bazzalan",
        scale = 1.25,
    },
    ["rfc_boss_jergosh_the_invoker"] = {
        name = "Jergosh the Invoker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\jergosh_the_invoker",
        scale = 1.1,
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
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\ragefire_chasm\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\ragefire_chasm\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\ragefire_chasm\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\ragefire_chasm\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\ragefire_chasm\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\ragefire_chasm\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.670,
            y = 0.168,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
            patrol = {
                { x = 0.670, y = 0.168 },
                { x = 0.679, y = 0.150 },
                { x = 0.664, y = 0.158 },
            }
        },
        {
            id = 2,
            x = 0.671,
            y = 0.107,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.671, y = 0.107 },
                { x = 0.630, y = 0.139 },
                { x = 0.622, y = 0.202 },
            }
        },
        {
            id = 3,
            x = 0.687,
            y = 0.103,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.687, y = 0.103 },
                { x = 0.708, y = 0.119 },
            }
        },
        {
            id = 4,
            x = 0.699,
            y = 0.153,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.699, y = 0.153 },
                { x = 0.678, y = 0.180 },
            }
        },
        {
            id = 5,
            x = 0.648,
            y = 0.163,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.658, y = 0.184 },
                { x = 0.650, y = 0.164 },
                { x = 0.654, y = 0.149 },
            }
        },
        {
            id = 6,
            x = 0.661,
            y = 0.228,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.661, y = 0.228 },
                { x = 0.662, y = 0.289 },
            }
        },
        {
            id = 7,
            x = 0.651,
            y = 0.304,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.651, y = 0.304 },
                { x = 0.673, y = 0.311 },
            }
        },
        {
            id = 8,
            x = 0.663,
            y = 0.331,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.663, y = 0.331 },
                { x = 0.664, y = 0.357 },
            }
        },
        {
            id = 9,
            x = 0.652,
            y = 0.397,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
            }
        },
        {
            id = 10,
            x = 0.662,
            y = 0.379,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.662, y = 0.379 },
                { x = 0.655, y = 0.426 },
                { x = 0.663, y = 0.493 },
                { x = 0.664, y = 0.566 },
                { x = 0.670, y = 0.646 },
                { x = 0.682, y = 0.653 },
                { x = 0.663, y = 0.548 },
            }
        },
        {
            id = 11,
            x = 0.658,
            y = 0.528,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
            }
        },
        {
            id = 12,
            x = 0.659,
            y = 0.456,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
            }
        },
        {
            id = 13,
            x = 0.658,
            y = 0.577,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
            }
        },
        {
            id = 14,
            x = 0.678,
            y = 0.591,
            mobs = {
                ["rfc_ragefire_shaman"] = 2,
            },
            patrol = {
                { x = 0.678, y = 0.591 },
                { x = 0.675, y = 0.615 },
                { x = 0.686, y = 0.610 },
            }
        },
        {
            id = 15,
            x = 0.652,
            y = 0.621,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
                ["rfc_ragefire_shaman"] = 1,
            }
        },
        {
            id = 16,
            x = 0.686,
            y = 0.639,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.686, y = 0.639 },
                { x = 0.684, y = 0.629 },
                { x = 0.679, y = 0.636 },
            }
        },
        {
            id = 17,
            x = 0.699,
            y = 0.630,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
                ["rfc_ragefire_shaman"] = 1,
            }
        },
        {
            id = 18,
            x = 0.689,
            y = 0.662,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
            patrol = {
                { x = 0.689, y = 0.662 },
                { x = 0.716, y = 0.664 },
                { x = 0.734, y = 0.660 },
                { x = 0.743, y = 0.647 },
                { x = 0.746, y = 0.634 },
                { x = 0.737, y = 0.611 },
            }
        },
        {
            id = 19,
            x = 0.727,
            y = 0.605,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.727, y = 0.605 },
                { x = 0.702, y = 0.602 },
                { x = 0.693, y = 0.551 },
            }
        },
        {
            id = 20,
            x = 0.693,
            y = 0.548,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.693, y = 0.548 },
                { x = 0.707, y = 0.535 },
                { x = 0.706, y = 0.506 },
                { x = 0.708, y = 0.460 },
                { x = 0.700, y = 0.426 },
                { x = 0.698, y = 0.377 },
                { x = 0.681, y = 0.406 },
            }
        },
        {
            id = 21,
            x = 0.708,
            y = 0.532,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
        },
        {
            id = 22,
            x = 0.709,
            y = 0.470,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
        },
        {
            id = 23,
            x = 0.700,
            y = 0.408,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 24,
            x = 0.697,
            y = 0.373,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
                ["rfc_ragefire_trogg"] = 1,

            },
        },
        {
            id = 25,
            x = 0.682,
            y = 0.410,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 26,
            x = 0.628,
            y = 0.386,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 27,
            x = 0.636,
            y = 0.362,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
        },
        {
            id = 28,
            x = 0.623,
            y = 0.348,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
        },
        {
            id = 29,
            x = 0.623,
            y = 0.348,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.645, y = 0.380 },
                { x = 0.636, y = 0.363 },
                { x = 0.622, y = 0.362 },
            }
        },
        {
            id = 30,
            x = 0.708,
            y = 0.492,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.708, y = 0.492 },
                { x = 0.696, y = 0.561 },
                { x = 0.704, y = 0.602 },
                { x = 0.737, y = 0.610 },
            }
        },
        {
            id = 31,
            x = 0.687,
            y = 0.685,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.689, y = 0.651 },
                { x = 0.687, y = 0.685 },
                { x = 0.669, y = 0.693 },
                { x = 0.634, y = 0.705 },
                { x = 0.608, y = 0.682 },
            }
        },
        {
            id = 32,
            x = 0.651,
            y = 0.700,
            mobs = {
                ["rfc_ragefire_trogg"] = 2,
            },
        },
        {
            id = 33,
            x = 0.606,
            y = 0.677,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.606, y = 0.677 },
                { x = 0.630, y = 0.698 },
            }
        },
        {
            id = 34,
            x = 0.580,
            y = 0.308,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
            patrol = {
                { x = 0.580, y = 0.308 },
                { x = 0.599, y = 0.328 },
                { x = 0.598, y = 0.414 },
                { x = 0.607, y = 0.533 },
                { x = 0.599, y = 0.673 },
            }
        },
        {
            id = 35,
            x = 0.603,
            y = 0.566,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 36,
            x = 0.604,
            y = 0.339,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 37,
            x = 0.673,
            y = 0.672,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.673, y = 0.672 },
                { x = 0.650, y = 0.668 },
            }
        },
        {
            id = 38,
            x = 0.652,
            y = 0.666,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.652, y = 0.666 },
                { x = 0.636, y = 0.657 },
                { x = 0.624, y = 0.592 },
            }
        },
        {
            id = 39,
            x = 0.627,
            y = 0.637,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 40,
            x = 0.626,
            y = 0.583,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 41,
            x = 0.619,
            y = 0.527,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 42,
            x = 0.644,
            y = 0.533,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
            patrol = {
                { x = 0.619, y = 0.527 },
                { x = 0.644, y = 0.533 },
            }
        },
        {
            id = 43,
            x = 0.634,
            y = 0.518,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.642, y = 0.526 },
                { x = 0.622, y = 0.514 },
                { x = 0.618, y = 0.492 },
            }
        },
        {
            id = 44,
            x = 0.614,
            y = 0.440,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 45,
            x = 0.614,
            y = 0.459,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
            patrol = {
                { x = 0.614, y = 0.459 },
                { x = 0.607, y = 0.428 },
            }
        },
        {
            id = 46,
            x = 0.609,
            y = 0.401,
            mobs = {
                ["rfc_ragefire_shaman"] = 1,
            },
            patrol = {
                { x = 0.609, y = 0.401 },
                { x = 0.609, y = 0.388 },
            }
        },
        {
            id = 47,
            x = 0.612,
            y = 0.381,
            mobs = {
                ["rfc_ragefire_trogg"] = 1,
            },
        },
        {
            id = 48,
            x = 0.579,
            y = 0.278,
            mobs = {
                ["rfc_earthborer"] = 1,
            },
        },
        {
            id = 48,
            x = 0.525,
            y = 0.276,
            mobs = {
                ["rfc_molten_elemental"] = 3,
            },
        },
        {
            id = 49,
            x = 0.533,
            y = 0.358,
            mobs = {
                ["rfc_molten_elemental"] = 3,
            },
        },
        {
            id = 50,
            x = 0.507,
            y = 0.336,
            mobs = {
                ["rfc_molten_elemental"] = 1,
                ["rfc_earthborer"] = 1,
            },
        },
        {
            id = 51,
            x = 0.494,
            y = 0.277,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 52,
            x = 0.486,
            y = 0.238,
            mobs = {
                ["rfc_molten_elemental"] = 2,
            },
        },
        {
            id = 53,
            x = 0.524,
            y = 0.409,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 54,
            x = 0.494,
            y = 0.524,
            mobs = {
                ["rfc_searing_blade_cultist"] = 1,
                ["rfc_searing_blade_enforcer"] = 2,
            },
        },
        {
            id = 55,
            x = 0.469,
            y = 0.484,
            mobs = {
                ["rfc_searing_blade_cultist"] = 1,
                ["rfc_searing_blade_enforcer"] = 2,
            },
        },
        {
            id = 56,
            x = 0.490,
            y = 0.542,
            mobs = {
                ["rfc_void_guardian"] = 1,
                ["rfc_searing_blade_enforcer"] = 1,
            },
            patrol = {
                { x = 0.497, y = 0.512 },
                { x = 0.489, y = 0.593 },
                { x = 0.494, y = 0.630 },
                { x = 0.476, y = 0.628 },
                { x = 0.479, y = 0.613 },
            }
        },
        --{
        --    id = 57,
        --    x = 0.491,
        --    y = 0.543,
        --    mobs = {
        --        ["rfc_searing_blade_enforcer"] = 1,
        --    },
        --    patrol = {
        --        { x = 0.497, y = 0.514 },
        --        { x = 0.490, y = 0.607 },
        --    }
        --},
        {
            id = 58,
            x = 0.469,
            y = 0.501,
            mobs = {
                ["rfc_void_guardian"] = 1,
                ["rfc_searing_blade_enforcer"] = 1,
            },
            patrol = {
                { x = 0.483, y = 0.491 },
                { x = 0.415, y = 0.467 },
                { x = 0.399, y = 0.472 },
                { x = 0.399, y = 0.448 },
                { x = 0.410, y = 0.459 },
            }
        },
        --{
        --    id = 59,
        --    x = 0.469,
        --    y = 0.503,
        --    mobs = {
        --        ["rfc_searing_blade_enforcer"] = 1,
        --    },
        --    patrol = {
        --        { x = 0.477, y = 0.492 },
        --        { x = 0.415, y = 0.468 },
        --    },
        --},
        {
            id = 60,
            x = 0.404,
            y = 0.462,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
                ["rfc_searing_blade_cultist"] = 2,
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
        },
        {
            id = 61,
            x = 0.484,
            y = 0.617,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
                ["rfc_searing_blade_cultist"] = 2,
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
        },
        {
            id = 62,
            x = 0.464,
            y = 0.696,
            mobs = {
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.464, y = 0.696 },
                { x = 0.426, y = 0.706 },
            },
        },
        --{
        --    id = 63,
        --    x = 0.416,
        --    y = 0.681,
        --    mobs = {
        --        ["rfc_searing_blade_enforcer"] = 2,
        --        ["rfc_searing_blade_cultist"] = 1,
        --        ["rfc_searing_blade_warlock"] = 1,
        --        ["rfc_void_guardian"] = 1,
        --    },
        --},
        {
            id = 64,
            x = 0.382,
            y = 0.682,
            mobs = {
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.404, y = 0.683 },
                { x = 0.351, y = 0.682 },
            },
        },
        {
            id = 65,
            x = 0.349,
            y = 0.685,
            mobs = {
                ["rfc_void_guardian"] = 1,
                ["rfc_searing_blade_cultist"] = 2,
            },
            patrol = {
                { x = 0.404, y = 0.685 },
                { x = 0.357, y = 0.680 },
                { x = 0.334, y = 0.695 },
                { x = 0.317, y = 0.670 },
                { x = 0.319, y = 0.640 },
                { x = 0.344, y = 0.675 },
            },
        },
        --{
        --    id = 66,
        --    x = 0.356,
        --    y = 0.681,
        --    mobs = {
        --        ["rfc_searing_blade_cultist"] = 2,
        --    },
        --},
        {
            id = 67,
            x = 0.330,
            y = 0.628,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
            },
        },
        {
            id = 68,
            x = 0.314,
            y = 0.649,
            mobs = {
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.325, y = 0.643 },
                { x = 0.334, y = 0.576 },
                { x = 0.335, y = 0.534 },
                { x = 0.340, y = 0.562 },
            },
        },
        {
            id = 69,
            x = 0.328,
            y = 0.645,
            mobs = {
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.328, y = 0.635 },
                { x = 0.334, y = 0.573 },
            },
        },
        {
            id = 70,
            x = 0.416,
            y = 0.681,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
                ["rfc_searing_blade_cultist"] = 2,
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
        },
        {
            id = 71,
            x = 0.412,
            y = 0.626,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 1,
            },
            patrol = {
                { x = 0.403, y = 0.478 },
                { x = 0.409, y = 0.558 },
                { x = 0.397, y = 0.581 },
                { x = 0.413, y = 0.598 },
                { x = 0.415, y = 0.656 },
            },
        },
        {
            id = 72,
            x = 0.331,
            y = 0.551,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
                ["rfc_searing_blade_cultist"] = 2,
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
        },
        {
            id = 73,
            x = 0.274,
            y = 0.652,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
            },
        },
        {
            id = 74,
            x = 0.277,
            y = 0.735,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
            },
        },
        {
            id = 75,
            x = 0.269,
            y = 0.783,
            mobs = {
                ["rfc_searing_blade_cultist"] = 1,
            },
        },
        {
            id = 76,
            x = 0.270,
            y = 0.841,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.270, y = 0.841 },
                { x = 0.268, y = 0.789 },
                { x = 0.277, y = 0.727 },
                { x = 0.275, y = 0.640 },
                { x = 0.311, y = 0.561 },
            },
        },
        {
            id = 77,
            x = 0.299,
            y = 0.883,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
        },
        {
            id = 78,
            x = 0.374,
            y = 0.911,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
            },
        },
        {
            id = 79,
            x = 0.270,
            y = 0.841,
            mobs = {
                ["rfc_searing_blade_cultist"] = 1,
            },
            patrol = {
                { x = 0.298, y = 0.876 },
                { x = 0.336, y = 0.906 },
                { x = 0.383, y = 0.909 },
                { x = 0.417, y = 0.876 },
            },
        },
        {
            id = 80,
            x = 0.393,
            y = 0.900,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
            },
        },
        {
            id = 81,
            x = 0.312,
            y = 0.721,
            mobs = {
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_searing_blade_cultist"] = 1,
                ["rfc_void_guardian"] = 1,
            },
        },
        {
            id = 82,
            x = 0.314,
            y = 0.755,
            mobs = {
                ["rfc_searing_blade_enforcer"] = 2,
                ["rfc_searing_blade_cultist"] = 2,
            },
        },
        {
            id = 83,
            x = 0.326,
            y = 0.821,
            mobs = {
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.307, y = 0.741 },
                { x = 0.323, y = 0.806 },
                { x = 0.309, y = 0.838 },
            },
        },
        {
            id = 84,
            x = 0.372,
            y = 0.828,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
            },
            patrol = {
                { x = 0.317, y = 0.756 },
                { x = 0.372, y = 0.828 },
                { x = 0.339, y = 0.847 },
                { x = 0.316, y = 0.746 },
            },
        },
        {
            id = 85,
            x = 0.309,
            y = 0.835,
            mobs = {
                ["rfc_searing_blade_cultist"] = 1,
            },
            patrol = {
                { x = 0.309, y = 0.835 },
                { x = 0.347, y = 0.865 },
            },
        },
        {
            id = 86,
            x = 0.320,
            y = 0.800,
            mobs = {
                ["rfc_searing_blade_cultist"] = 1,
            },
            patrol = {
                { x = 0.320, y = 0.800 },
                { x = 0.359, y = 0.852 },
            },
        },
        {
            id = 87,
            x = 0.343,
            y = 0.778,
            mobs = {
                ["rfc_searing_blade_warlock"] = 1,
                ["rfc_void_guardian"] = 1,
            },
            patrol = {
                { x = 0.343, y = 0.778 },
                { x = 0.385, y = 0.822 },
            },
        },
        {
            id = 88,
            x = 0.388,
            y = 0.838,
            mobs = {
                ["rfc_searing_blade_cultist"] = 2,
            },
        },
        {
            id = 89,
            x = 0.379,
            y = 0.767,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 90,
            x = 0.373,
            y = 0.862,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 91,
            x = 0.288,
            y = 0.797,
            mobs = {
                ["rfc_molten_elemental"] = 1,
            },
        },
        {
            id = 92,
            x = 0.546,
            y = 0.499,
            mobs = {
                ["rfc_molten_elemental"] = 2,
            },
        },
        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.559,
            y = 0.384,
            mobs = {
                ["rfc_boss_oggleflint"] = 1,
                ["rfc_ragefire_trogg"] = 1,
                ["rfc_ragefire_shaman"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.409,
            y = 0.576,
            mobs = {
                ["rfc_boss_taragaman_the_hungerer"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.425,
            y = 0.857,
            mobs = {
                ["rfc_boss_bazzalan"] = 1,
                ["rfc_void_guardian"] = 3,
            }
        },
        {
            id = 1003,
            x = 0.331,
            y = 0.864,
            mobs = {
                ["rfc_boss_jergosh_the_invoker"] = 1,
                ["rfc_searing_blade_cultist"] = 2,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Ragefire Chasm", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Ragefire Chasm")
