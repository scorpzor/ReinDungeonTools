local RDT = _G.RDT
if not RDT or not RDT.Data then
    error("RDT.Data not initialized! Dungeon modules must load after Data.lua")
end

local mobs = {
    ["brd_blazing_fireguard"] = {
        name = "Blazing Fireguard",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\blazing_fireguard",
        scale = 0.7,
    },
    ["brd_anvilrage_footman"] = {
        name = "Anvilrage Footman",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_footman",
        scale = 0.7,
    },
    ["brd_anvilrage_warden"] = {
        name = "Anvilrage Warden",
        count = 0.5,
        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\anvilrage_warden",
        scale = 0.7,
    },
}

--local bosses = {
--    ["brd_boss_"] = {
--        name = "",
--        count = 2,
--        displayIcon = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Mobs\\",
--        scale = 1.25,
--    },
--}

RDT.Data:RegisterMobs(mobs)
--RDT.Data:RegisterMobs(bosses)

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
        x = 0.190,
        y = 0.673,
        mobs = {
            ["brd_blazing_fireguard"] = 1,
        }
    },
    {
        id = 2,
        x = 0.232,
        y = 0.734,
        mobs = {
            ["brd_anvilrage_footman"] = 1,
            ["brd_anvilrage_warden"] = 1,
        }
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
        x = 0.2,
        y = 0.1,
        name = "Entrance Portal",
        description = "Main entrance",
    }
}

local mapPrisonDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition
    identifiers = prisonIdentifiers,
}

local mapUpperCityDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition
    identifiers = upperCityIdentifiers,
}

local mapManufactoryDefinition = {
    tiles = tilesDefinition,
    totalCount = 110,
    packData = packDefinition
    identifiers = manufactoryIdentifiers,
}

RDT.Data:RegisterDungeon("Blackrock Depths Prison", mapPrisonDefinition)
RDT:DebugPrint("Loaded dungeon module: Blackrock Depths Prison")

RDT.Data:RegisterDungeon("Blackrock Depths Upper City", mapUpperCityDefinition)
RDT:DebugPrint("Loaded dungeon module: Blackrock Depths Upper City")

RDT.Data:RegisterDungeon("Blackrock Depths Manufactory", mapManufactoryDefinition)
RDT:DebugPrint("Loaded dungeon module: Blackrock Depths Manufactory")