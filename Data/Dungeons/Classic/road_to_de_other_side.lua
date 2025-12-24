local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["rtdos_interstitial_wanderer"] = {
        name = "Interstitial Wanderer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\interstitial_wanderer",
        scale = 0.7,
    },
    ["rtdos_lifedrinker"] = {
        name = "Lifedrinker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\lifedrinker",
        scale = 0.5,
    },
    ["rtdos_bat_of_the_other_side"] = {
        name = "Bat of the Other Side",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\bat_of_the_other_side",
        scale = 0.5,
    },
    ["rtdos_gutdevourer"] = {
        name = "Gutdevourer",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\gutdevourer",
        scale = 0.8,
    },
    ["rtdos_spider_of_the_other_side"] = {
        name = "Spider of the Other Side",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\spider_of_the_other_side",
        scale = 0.5,
    },
    ["rtdos_deathweaver_matriarch"] = {
        name = "Deathweaver Matriarch",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\deathweaver_matriarch",
        scale = 0.7,
    },
    ["rtdos_violent_swarm"] = {
        name = "Violent Swarm",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\violent_swarm",
        scale = 0.5,
    },
}

local bosses = {
    ["rtdos_boss_muzah"] = {
        name = "Muzah, the Shadow Hunter",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\muzah",
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
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\road_to_de_other_side\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.677,
            y = 0.314,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 5,
            }
        },
        {
            id = 2,
            x = 0.748,
            y = 0.356,
            mobs = {
                ["rtdos_lifedrinker"] = 3,
            }
        },
        {
            id = 3,
            x = 0.717,
            y = 0.440,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 1,
            }
        },
        {
            id = 4,
            x = 0.744,
            y = 0.473,
            mobs = {
                ["rtdos_gutdevourer"] = 1,
            },
            patrol = {
                { x = 0.744, y = 0.473 },
                { x = 0.711, y = 0.463 },
                { x = 0.703, y = 0.489 },
                { x = 0.729, y = 0.502 },
                { x = 0.766, y = 0.445 },
                { x = 0.786, y = 0.457 },
                { x = 0.777, y = 0.482 },
                { x = 0.744, y = 0.473 },
            },
        },
        {
            id = 5,
            x = 0.709,
            y = 0.487,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 3,
                ["rtdos_bat_of_the_other_side"] = 1,
                ["rtdos_lifedrinker"] = 1,
            }
        },
        {
            id = 6,
            x = 0.777,
            y = 0.453,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 3,
                ["rtdos_bat_of_the_other_side"] = 3,
            }
        },
        {
            id = 7,
            x = 0.771,
            y = 0.500,
            mobs = {
                ["rtdos_gutdevourer"] = 1,
                ["rtdos_lifedrinker"] = 1,
            }
        },
        {
            id = 8,
            x = 0.771,
            y = 0.573,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 1,
            }
        },
        {
            id = 9,
            x = 0.827,
            y = 0.597,
            mobs = {
                ["rtdos_lifedrinker"] = 2,
            }
        },
        {
            id = 10,
            x = 0.833,
            y = 0.690,
            mobs = {
                ["rtdos_lifedrinker"] = 2,
            }
        },
        {
            id = 11,
            x = 0.763,
            y = 0.688,
            mobs = {
                ["rtdos_lifedrinker"] = 2,
            }
        },
        {
            id = 12,
            x = 0.787,
            y = 0.641,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 1,
            }
        },
        {
            id = 13,
            x = 0.733,
            y = 0.568,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 2,
            }
        },
        {
            id = 14,
            x = 0.704,
            y = 0.664,
            mobs = {
                ["rtdos_lifedrinker"] = 1,
            }
        },
        {
            id = 15,
            x = 0.694,
            y = 0.637,
            mobs = {
                ["rtdos_lifedrinker"] = 4,
            }
        },
        {
            id = 16,
            x = 0.686,
            y = 0.691,
            mobs = {
                ["rtdos_gutdevourer"] = 1,
            }
        },
        {
            id = 17,
            x = 0.653,
            y = 0.674,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 2,
                ["rtdos_bat_of_the_other_side"] = 2,
                ["rtdos_lifedrinker"] = 3,
            }
        },
        {
            id = 18,
            x = 0.728,
            y = 0.704,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 3,
                ["rtdos_lifedrinker"] = 3,
            }
        },
        {
            id = 19,
            x = 0.691,
            y = 0.749,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 1,
                ["rtdos_bat_of_the_other_side"] = 2,
                ["rtdos_lifedrinker"] = 5,
            }
        },
        {
            id = 20,
            x = 0.635,
            y = 0.747,
            mobs = {
                ["rtdos_lifedrinker"] = 1,
            }
        },
        {
            id = 21,
            x = 0.591,
            y = 0.759,
            mobs = {
                ["rtdos_lifedrinker"] = 2,
            }
        },
        {
            id = 22,
            x = 0.628,
            y = 0.803,
            mobs = {
                ["rtdos_lifedrinker"] = 2,
            }
        },
        {
            id = 23,
            x = 0.613,
            y = 0.841,
            mobs = {
                ["rtdos_lifedrinker"] = 3,
            }
        },
        {
            id = 24,
            x = 0.598,
            y = 0.873,
            mobs = {
                ["rtdos_gutdevourer"] = 1,
            }
        },
        {
            id = 25,
            x = 0.572,
            y = 0.834,
            mobs = {
                ["rtdos_lifedrinker"] = 10,
            }
        },
        {
            id = 26,
            x = 0.540,
            y = 0.820,
            mobs = {
                ["rtdos_interstitial_wanderer"] = 2,
            }
        },
        {
            id = 27,
            x = 0.425,
            y = 0.843,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 28,
            x = 0.411,
            y = 0.837,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 3,
            }
        },
        {
            id = 29,
            x = 0.377,
            y = 0.869,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 30,
            x = 0.406,
            y = 0.870,
            mobs = {
                ["rtdos_deathweaver_matriarch"] = 1,
            },
            patrol = {
                { x = 0.406, y = 0.870 },
                { x = 0.395, y = 0.834 },
                { x = 0.380, y = 0.837 },
                { x = 0.387, y = 0.882 },
            },
        },
        {
            id = 31,
            x = 0.366,
            y = 0.915,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 4,
                ["rtdos_violent_swarm"] = 1,
            }
        },
        {
            id = 32,
            x = 0.365,
            y = 0.843,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 33,
            x = 0.356,
            y = 0.869,
            mobs = {
                ["rtdos_deathweaver_matriarch"] = 1,
            },
            patrol = {
                { x = 0.367, y = 0.902 },
                { x = 0.356, y = 0.869 },
                { x = 0.347, y = 0.808 },
            },
        },
        {
            id = 34,
            x = 0.355,
            y = 0.814,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 35,
            x = 0.332,
            y = 0.792,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 36,
            x = 0.426,
            y = 0.776,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 3,
            }
        },
        {
            id = 37,
            x = 0.390,
            y = 0.799,
            mobs = {
                ["rtdos_deathweaver_matriarch"] = 1,
                ["rtdos_spider_of_the_other_side"] = 2,
            }
        },
        {
            id = 38,
            x = 0.372,
            y = 0.776,
            mobs = {
                ["rtdos_deathweaver_matriarch"] = 1,
                ["rtdos_spider_of_the_other_side"] = 2,
            }
        },
        {
            id = 39,
            x = 0.414,
            y = 0.740,
            mobs = {
                ["rtdos_violent_swarm"] = 2,
            }
        },
        {
            id = 40,
            x = 0.372,
            y = 0.733,
            mobs = {
                ["rtdos_violent_swarm"] = 1,
            }
        },
        {
            id = 41,
            x = 0.343,
            y = 0.740,
            mobs = {
                ["rtdos_deathweaver_matriarch"] = 1,
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 42,
            x = 0.324,
            y = 0.695,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 43,
            x = 0.297,
            y = 0.704,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
            }
        },
        {
            id = 44,
            x = 0.294,
            y = 0.673,
            mobs = {
                ["rtdos_spider_of_the_other_side"] = 1,
                ["rtdos_violent_swarm"] = 3,
            }
        },

        -------------------------------- Bosses --------------------------------
        {
            id = 1000,
            x = 0.493,
            y = 0.812,
            mobs = {
                ["generic_boss"] = 1,
            }
        },
        {
            id = 1001,
            x = 0.202,
            y = 0.516,
            mobs = {
                ["generic_boss"] = 1,
            }
        },
        {
            id = 1002,
            x = 0.578,
            y = 0.492,
            mobs = {
                ["generic_boss"] = 1,
            }
        },
    },
    identifiers = {
        {
            id = 1,
            type = "dungeon-entrance",
            x = 0.600,
            y = 0.210,
            name = "Entrance Portal",
            description = "Main entrance",
        },
    },
}

RDT.Data:RegisterDungeon("Road to De Other Side", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Road to De Other Side")
