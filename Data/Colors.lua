-- Data/Colors.lua
-- Centralized color definitions for the addon

local ADDON_NAME = "ReinDungeonTools"
local RDT = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)

--------------------------------------------------------------------------------
-- Color Definitions (RGB format: 0-1 range)
--------------------------------------------------------------------------------

RDT.Colors = {
    -- Pull border colors (6-color repeating cycle)
    PullBorders = {
        {0.0, 0.8, 1.0},  -- Bright Cyan
        {0.4, 1.0, 0.4},  -- Bright Green
        {1.0, 0.0, 0.8},  -- Hot Magenta
        {0.3, 0.6, 1.0},  -- Electric Blue
        {1.0, 0.2, 0.2},  -- Bright Red
        {0.6, 0.2, 1.0},  -- Deep Purple
    },

    -- Unassigned pack color
    Unassigned = {0.5, 0.5, 0.5},  -- Gray

    -- Patrol line colors
    Patrol = {
        Normal = {0, 0.176, 0.451, 0.8}, -- Dark blue
        Highlight = {0.4, 1.0, 1.0, 1.0}, -- Bright cyan
    },

    -- Identifier connection line color
    Identifier = {0.5, 0.8, 1.0, 0.6},  -- Light blue
}

RDT:DebugPrint("Colors.lua loaded")
