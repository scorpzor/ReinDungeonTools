local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

--local mobs = {
--    ["trash"] = {
--        name = "Trash",
--        count = 0.5,
--        displayIcon = "Interface\\Icons\\Achievement_Character_Undead_Male",
--        scale = 0.7,
--    },
--}
--
--RDT.Data:RegisterMobs(mobs)

local mapDefinition = {
    tiles = {
        tileWidth = 512,
        tileHeight = 512,
        cols = 3,
        rows = 2,
        tiles = {
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\deadmines\\tile_0",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\deadmines\\tile_1",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\deadmines\\tile_2",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\deadmines\\tile_3",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\deadmines\\tile_4",
            "Interface\\AddOns\\ReinDungeonTools\\Dungeons\\Classic\\Textures\\deadmines\\tile_5",
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
    identifiers = {
        -- Entrance area
        {
            id = 1,
            type = "door",
            x = 0.15,
            y = 0.1,
            name = "Main Entrance",
            description = "Main entrance to the Deadmines",
        },
        {
            id = 2,
            type = "door",
            x = 0.3,
            y = 0.2,
            name = "Security Gate",
            description = "Locked gate requiring a key",
        },
        {
            id = 3,
            type = "door",
            x = 0.45,
            y = 0.15,
            name = "Side Door",
            description = "Alternative entrance",
        },

        -- Stairs
        {
            id = 4,
            type = "stairs",
            x = 0.25,
            y = 0.35,
            name = "Stairs Down",
            description = "Leads to the foundry level",
        },
        {
            id = 5,
            type = "stairs",
            x = 0.6,
            y = 0.3,
            name = "Spiral Staircase",
            description = "Leads to upper mining shaft",
        },
        {
            id = 6,
            type = "stairs",
            x = 0.7,
            y = 0.5,
            name = "Ladder",
            description = "Climb down to the shipyard",
            scale = 0.9,
        },

        -- Portal pair 1 (Red portals)
        {
            id = 7,
            type = "portal",
            x = 0.2,
            y = 0.5,
            name = "Red Portal A",
            description = "Teleports to Red Portal B in the mines",
            linkedTo = 8,
        },
        {
            id = 8,
            type = "portal",
            x = 0.8,
            y = 0.6,
            name = "Red Portal B",
            description = "Teleports back to Red Portal A",
            linkedTo = 7,
        },

        -- Portal pair 2 (Blue portals)
        {
            id = 9,
            type = "portal",
            x = 0.35,
            y = 0.65,
            name = "Blue Portal A",
            description = "Teleports to Blue Portal B near the ship",
            linkedTo = 10,
        },
        {
            id = 10,
            type = "portal",
            x = 0.65,
            y = 0.75,
            name = "Blue Portal B",
            description = "Teleports back to Blue Portal A",
            linkedTo = 9,
        },

        -- Portal pair 3 (Green portals)
        {
            id = 11,
            type = "portal",
            x = 0.5,
            y = 0.25,
            name = "Green Portal A",
            description = "Shortcut to Green Portal B",
            linkedTo = 12,
            scale = 1.1,
        },
        {
            id = 12,
            type = "portal",
            x = 0.85,
            y = 0.35,
            name = "Green Portal B",
            description = "Returns to Green Portal A",
            linkedTo = 11,
            scale = 1.1,
        },

        -- Actions
        {
            id = 13,
            type = "action",
            x = 0.4,
            y = 0.45,
            name = "Mining Cart Lever",
            description = "Activates the mining cart transport",
            scale = 0.8,
        },
        {
            id = 14,
            type = "action",
            x = 0.55,
            y = 0.55,
            name = "Cannon Controls",
            description = "Fire the ship's cannons",
            scale = 0.85,
        },
        {
            id = 15,
            type = "action",
            x = 0.75,
            y = 0.8,
            name = "Anchor Winch",
            description = "Raise or lower the ship's anchor",
        },
    },
}

RDT.Data:RegisterDungeon("Deadmines", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Deadmines")
