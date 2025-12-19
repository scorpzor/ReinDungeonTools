local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["dme_warpwood_treant"] = {
        name = "Warpwood Treant",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_treant",
        scale = 0.7,
    },
    ["dme_warpwood_tangler"] = {
        name = "Warpwood Tangler",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_tangler",
        scale = 0.7,
    },
    ["dme_warpwood_crusher"] = {
        name = "Warpwood Crusher",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\warpwood_crusher",
        scale = 0.8,
    },
    ["dme_phase_lasher"] = {
        name = "Phase Lasher",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\phase_lasher",
        scale = 0.7,
    },
    ["dme_whip_lasher"] = {
        name = "Whip Lasher",
        count = 1,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\whip_lasher",
        scale = 0.6,
    },
    ["dme_wildspawn_shadowstalker"] = {
        name = "Wildspawn Shadowstalker",
        count = 2,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\wildspawn_shadowstalker",
        scale = 0.7,
    },
}

--local bosses = {
--    ["dme_boss_"] = {
--        name = "",
--        count = 2,
--        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\",
--        scale = 1.25,
--    },
--}

RDT.Data:RegisterMobs(mobs)
--RDT.Data:RegisterMobs(bosses)

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Textures\\Maps\\Classic\\dire_maul_east\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.110,
            y = 0.323,
            mobs = {
                ["dme_warpwood_treant"] = 1,
            },
            patrol = {
                {x = 0.115, y = 0.323},
                {x = 0.115, y = 0.617},
            },
        },
        {
            id = 2,
            x = 0.110,
            y = 0.414,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 3,
            x = 0.099,
            y = 0.441,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 4,
            x = 0.092,
            y = 0.567,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 5,
            x = 0.105,
            y = 0.625,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 6,
            x = 0.115,
            y = 0.686,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 7,
            x = 0.151,
            y = 0.693,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 8,
            x = 0.193,
            y = 0.657,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 9,
            x = 0.280,
            y = 0.678,
            mobs = {
                ["dme_phase_lasher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 10,
            x = 0.280,
            y = 0.621,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 11,
            x = 0.290,
            y = 0.562,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 12,
            x = 0.290,
            y = 0.479,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 13,
            x = 0.277,
            y = 0.421,
            mobs = {
                ["dme_warpwood_tangler"] = 1,
                ["dme_warpwood_treant"] = 2,
            }
        },
        {
            id = 14,
            x = 0.290,
            y = 0.365,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 15,
            x = 0.294,
            y = 0.280,
            mobs = {
                ["dme_phase_lasher"] = 1,
            }
        },
        {
            id = 16,
            x = 0.255,
            y = 0.245,
            mobs = {
                ["dme_whip_lasher"] = 6,
            }
        },
        {
            id = 17,
            x = 0.270,
            y = 0.185,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            }
        },
        {
            id = 18,
            x = 0.214,
            y = 0.185,
            mobs = {
                ["dme_warpwood_crusher"] = 1,
            }
        },
        {
            id = 19,
            x = 0.426,
            y = 0.235,
            mobs = {
                ["dme_wildspawn_shadowstalker"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Dire Maul East", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Dire Maul East")
