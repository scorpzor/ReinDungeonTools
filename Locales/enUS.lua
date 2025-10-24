-- English (US) localization
local L = LibStub("AceLocale-3.0"):NewLocale("ReinDungeonTools", "enUS", true)

if not L then return end

-- Main UI
L["TITLE"] = "Rein Dungeon Tools"
L["CURRENT_PULLS"] = "Current Pulls"

-- Buttons
L["GROUP_PULL"] = "Group Pull"
L["CLEAR_SEL"] = "Clear Sel"
L["RESET_ALL"] = "Reset All"

-- Messages
L["NO_PULLS"] = "No pulls defined"
L["PACK"] = "Pack"
L["PULL"] = "Pull"
L["ENEMY_FORCES"] = "Enemy Forces"
L["TOTAL_FORCES"] = "Total Forces"

-- Errors
L["ERROR_UNKNOWN_DUNGEON"] = "Error: Unknown dungeon '%s'"
L["ERROR_INVALID_COORDS"] = "Warning: Invalid coordinates for pack %d"
L["ERROR_NO_PACKS"] = "Error: No pack data for dungeon"
L["ERROR_INIT"] = "Error during initialization"

-- Tooltips
L["TOOLTIP_CLICK_SELECT"] = "Click to select/deselect"
L["TOOLTIP_SHIFT_CLICK"] = "Shift+Click to assign to pull"
L["TOOLTIP_RIGHT_CLICK"] = "Right-Click to remove from pull"

-- Slash commands
L["SLASH_HELP"] = "Available commands:"
L["SLASH_TOGGLE"] = "/rdt - Toggle addon window"
L["SLASH_DEBUG"] = "/rdt debug - Toggle debug mode"
L["SLASH_RESET"] = "/rdt reset - Reset all pulls"
L["SLASH_VERSION"] = "/rdt version - Show version info"

-- Version info
L["VERSION_INFO"] = "Rein Dungeon Tools v%s"
L["VERSION_LOADED"] = "loaded successfully"

-- Profiles
L["PROFILE_CREATED"] = "Profile '%s' created"
L["PROFILE_SWITCHED"] = "Switched to profile '%s'"
L["PROFILE_DELETED"] = "Profile '%s' deleted"
L["PROFILE_COPIED"] = "Copied profile '%s' to '%s'"