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
        {
            id = 1,
            type = "door",
            x = 0.3,
            y = 0.2,
            name = "Entrance Door",
            description = "Main entrance to the mines",
        },
        {
            id = 2,
            type = "stairs",
            x = 0.6,
            y = 0.3,
            name = "Stairs Down",
            description = "Leads to the lower level",
        },
        {
            id = 3,
            type = "portal",
            x = 0.25,
            y = 0.5,
            name = "Portal A",
            description = "Teleports to Portal B",
            linkedTo = 4,
        },
        {
            id = 4,
            type = "portal",
            x = 0.75,
            y = 0.6,
            name = "Portal B",
            description = "Teleports to Portal A",
            linkedTo = 3,
        },
        {
            id = 5,
            type = "action",
            x = 0.5,
            y = 0.7,
            name = "Lever",
            description = "Activates the mining cart",
            scale = 0.8,
        },
    },
}

RDT.Data:RegisterDungeon("Deadmines", mapDefinition)

RDT:DebugPrint("Loaded dungeon module: Deadmines")
