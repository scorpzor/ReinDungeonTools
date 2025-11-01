local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--------------------------------------------------------------------------------
-- Mob Definitions
--------------------------------------------------------------------------------

--local mobs = {
--    -- Generic example mobs (replace with actual Stratholme mobs)
--    ["strat_trash"] = {
--        name = "Stratholme Trash",
--        count = 1.0,
--        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
--        scale = 0.8,
--    },
--    ["strat_elite"] = {
--        name = "Stratholme Elite",
--        count = 2.0,
--        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
--        scale = 1.0,
--    },
--    ["strat_abomination"] = {
--        name = "Abomination",
--        count = 3.0,
--        displayIcon = "Interface\\Icons\\Spell_Shadow_AnimateDead",
--        scale = 1.0,
--    },
--}
--
--RDT.Data:RegisterMobs(mobs)

--------------------------------------------------------------------------------
-- Stratholme - Main Gate
--------------------------------------------------------------------------------

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\stratholme_main_gate\\tile_5",
        }
    },
    totalCount = 110,
    packData = {
        {
            id = 1,
            x = 0.5,
            y = 0.15,
            mobs = {
                ["generic_trash_mob"] = 2,
                ["generic_elite_mob"] = 1,
            }
        },
        {
            id = 2,
            x = 0.45,
            y = 0.25,
            mobs = {
                ["generic_trash_mob"] = 3,
                ["generic_elite_mob"] = 1,
                ["generic_big_mob"] = 1,
            }
        },
    },
}

RDT.Data:RegisterDungeon("Stratholme Main Gate", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Stratholme Main Gate")
