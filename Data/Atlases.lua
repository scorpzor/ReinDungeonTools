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

Atlases.Scrollbar = {
    texture = "Interface\\AddOns\\ReinDungeonTools\\Textures\\Atlas\\minimalscrollbarsmallproportional",
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

--------------------------------------------------------------------------------
-- Accessor Methods (for backward compatibility)
--------------------------------------------------------------------------------

--- Get the scrollbar atlas configuration
-- @return table Atlas configuration with texture, size, and arrow coordinates
function Atlases:GetScrollbarAtlas()
    return self.Scrollbar
end

RDT:DebugPrint("Atlases module loaded")
