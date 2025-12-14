-- Data/Atlases.lua
-- UI texture atlas definitions
-- Contains atlas coordinates for icons, scrollbars, dropdowns, etc.

local RDT = _G.RDT
if not RDT then
    error("RDT object not found! Data/Atlases.lua must load after Core/Init.lua")
end

-- Atlases namespace
RDT.Atlases = {}
local Atlases = RDT.Atlases

--------------------------------------------------------------------------------
-- Atlas Definitions
--------------------------------------------------------------------------------

--- Identifier icon atlas (map markers: doors, stairs, portals, etc.)
Atlases.Identifier = {
    texture = "Interface\\Minimap\\ObjectIconsAtlas",
    icons = {
        ["stairs-up"] = {0.027344, 0.051758, 0.969727, 0.993164},
        ["stairs-down"] = {0.734375, 0.758789, 0.09668, 0.120117},
        ["door-in"] = {0.000977, 0.025391, 0.969727, 0.993164},
        ["door-out"] = {0.760742, 0.785156, 0.09668, 0.120117},
        ["gate"] = {0.708008, 0.732422, 0.09668, 0.120117},
        ["portal"] = {0.000977, 0.063477, 0.454102, 0.516602},
        ["dungeon-entrance"] = {0.198242, 0.24707, 0.44043, 0.489258},
        ["action"] = {0.766602, 0.797852, 0.46582, 0.49707},
    }
}

--- Scrollbar atlas (UI scrollbar components)
Atlases.Scrollbar = {
    texture = "Interface\\buttons\\minimalscrollbarsmallproportional",
    size = {17, 11},
    sizeEnd = {17, 15},
    arrows = {
        ["arrow-up"] = {0.015625, 0.28125, 0.484375, 0.64225},
        ["arrow-up-over"] = {0.3125, 0.578125, 0.484375, 0.64225},
        ["arrow-up-down"] = {0.015625, 0.28125, 0.6875, 0.845375},
        ["arrow-down"] = {0.015625, 0.28125, 0.28125, 0.453125},
        ["arrow-down-over"] = {0.609375, 0.875, 0.28125, 0.453125},
        ["arrow-down-down"] = {0.3125, 0.578125, 0.28125, 0.453125},
        ["arrow-up-end"] = {0.015625, 0.28125, 0.25, 0.015625},
        ["arrow-down-end"] = {0.015625, 0.28125, 0.015625, 0.25},
    }
}

--- Dropdown atlas (UI dropdown arrow icons)
Atlases.Dropdown = {
    texture = "Interface\\common\\commondropdown2x",
    size = {34, 34},
    icons = {
        ["icon-left"] = {0.767578, 0.833984, 0.357422, 0.423828},
        ["icon-down-small"] = {0.626953, 0.673828, 0.322266, 0.341797},
    }
}

--------------------------------------------------------------------------------
-- Accessor Methods (for backward compatibility)
--------------------------------------------------------------------------------

--- Get the atlas texture path for identifier icons
-- @return string Atlas texture path
function Atlases:GetIdentifierAtlasTexture()
    return self.Identifier.texture
end

--- Get the identifier atlas configuration
-- @return table Atlas configuration
function Atlases:GetIdentifierAtlas()
    return self.Identifier
end

--- Get the scrollbar atlas configuration
-- @return table Atlas configuration with texture, size, and arrow coordinates
function Atlases:GetScrollbarAtlas()
    return self.Scrollbar
end

--- Get the dropdown atlas configuration
-- @return table Atlas configuration with texture, size, and icon coordinates
function Atlases:GetDropdownAtlas()
    return self.Dropdown
end

RDT:DebugPrint("Atlases module loaded")
