-- Core/Commands.lua
-- Slash command handlers and help text

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

--------------------------------------------------------------------------------
-- Command Handlers
--------------------------------------------------------------------------------

local commands = {
    -- Toggle main window
    [""] = function()
        local frame = _G["RDT_MainFrame"]
        if not frame then
            RDT:PrintError("UI not initialized yet")
            return
        end
        
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
            if RDT.UI and RDT.UI.UpdatePullList then
                RDT.UI:UpdatePullList()
            end
        end
    end,
    
    -- Toggle debug mode
    ["debug"] = function()
        RDT.db.profile.debug = not RDT.db.profile.debug
        RDT:Print("Debug mode: " .. (RDT.db.profile.debug and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"))
    end,
    
    -- Reset all pulls
    ["reset"] = function()
        if RDT.RouteManager then
            RDT.RouteManager:ResetPulls()
        end
    end,
    
    -- Show version info
    ["version"] = function()
        RDT:Print(string.format(L["VERSION_INFO"], RDT.Version))
    end,
    
    ["v"] = function()
        RDT:Print(string.format(L["VERSION_INFO"], RDT.Version))
    end,
    
    -- Export current route
    ["export"] = function()
        if not RDT.ImportExport then
            RDT:PrintError("ImportExport module not loaded")
            return
        end
        
        local exportString = RDT.ImportExport:Export()
        if exportString then
            if not RDT.Dialogs or not RDT.Dialogs.ShowExport then
                RDT:PrintError("Export dialog not available")
                return
            end
            RDT.Dialogs:ShowExport(exportString)
        end
    end,
    
    -- Import from command line or show dialog
    ["import"] = function(args)
        if not RDT.ImportExport then
            RDT:PrintError("ImportExport module not loaded")
            return
        end
        
        local importString = args and strtrim(args) or ""
        
        if importString ~= "" then
            -- Import directly from command
            RDT.ImportExport:Import(importString)
        else
            -- Show import dialog
            if not RDT.Dialogs or not RDT.Dialogs.ShowImport then
                RDT:PrintError("Import dialog not available")
                return
            end
            RDT.Dialogs:ShowImport()
        end
    end,
    
    -- Minimap button management
    ["minimap"] = function(args)
        if not args or args == "" then
            RDT:Print("Usage: /rdt minimap <show|hide|toggle|reset>")
            return
        end
        
        local subCmd = string.lower(strtrim(args))
        
        if not RDT.MinimapButton then
            RDT:PrintError("Minimap button module not loaded")
            return
        end
        
        if subCmd == "show" then
            RDT.MinimapButton:Show()
            RDT:Print("Minimap button shown")
            
        elseif subCmd == "hide" then
            RDT.MinimapButton:Hide()
            RDT:Print("Minimap button hidden")
            
        elseif subCmd == "toggle" then
            RDT.MinimapButton:Toggle()
            if RDT.MinimapButton:IsShown() then
                RDT:Print("Minimap button shown")
            else
                RDT:Print("Minimap button hidden")
            end
            
        elseif subCmd == "reset" then
            RDT.MinimapButton:ResetPosition()
            
        else
            RDT:PrintError("Unknown minimap command: " .. subCmd)
            RDT:Print("Available: show, hide, toggle, reset")
        end
    end,
    
    -- Profile management
    ["profile"] = function(args)
        if not args or args == "" then
            RDT:Print("Usage: /rdt profile <list|use|create|delete|copy|reset>")
            return
        end
        
        local subCmd, arg1, arg2 = strsplit(" ", args, 3)
        subCmd = string.lower(subCmd or "")
        
        if subCmd == "list" then
            RDT:Print("Available profiles:")
            local profiles = RDT:GetProfiles()
            local current = RDT:GetCurrentProfile()
            for _, name in ipairs(profiles) do
                local marker = (name == current) and " |cFF00FF00(current)|r" or ""
                RDT:Print("  - " .. name .. marker)
            end
            
        elseif subCmd == "use" then
            if not arg1 or arg1 == "" then
                RDT:PrintError("Usage: /rdt profile use <name>")
                return
            end
            RDT:SetProfile(arg1)
            
        elseif subCmd == "create" then
            if not arg1 or arg1 == "" then
                RDT:PrintError("Usage: /rdt profile create <name>")
                return
            end
            RDT:CreateProfile(arg1)
            
        elseif subCmd == "delete" then
            if not arg1 or arg1 == "" then
                RDT:PrintError("Usage: /rdt profile delete <name>")
                return
            end
            RDT:DeleteProfile(arg1)
            
        elseif subCmd == "copy" then
            if not arg1 or arg1 == "" then
                RDT:PrintError("Usage: /rdt profile copy <source>")
                return
            end
            RDT:CopyProfile(arg1)
            
        elseif subCmd == "reset" then
            RDT:ResetProfile()
            
        else
            RDT:PrintError("Unknown profile command: " .. subCmd)
            RDT:Print("Available: list, use, create, delete, copy, reset")
        end
    end,
    
    -- Help text
    ["help"] = function()
        RDT:Print(L["SLASH_HELP"])
        RDT:Print(L["SLASH_TOGGLE"])
        RDT:Print(L["SLASH_DEBUG"])
        RDT:Print(L["SLASH_RESET"])
        RDT:Print(L["SLASH_VERSION"])
        RDT:Print("/rdt export - Export current route")
        RDT:Print("/rdt import [string] - Import route")
        RDT:Print("/rdt minimap <command> - Minimap button control")
        RDT:Print("  show - Show minimap button")
        RDT:Print("  hide - Hide minimap button")
        RDT:Print("  toggle - Toggle minimap button")
        RDT:Print("  reset - Reset button position")
        RDT:Print("/rdt profile <command> - Profile management")
        RDT:Print("  list - Show all profiles")
        RDT:Print("  use <name> - Switch to profile")
        RDT:Print("  create <name> - Create new profile")
        RDT:Print("  delete <name> - Delete profile")
        RDT:Print("  copy <source> - Copy from profile")
        RDT:Print("  reset - Reset current profile")
    end,
    
    ["?"] = function()
        commands["help"]()
    end,
}

--------------------------------------------------------------------------------
-- Main Slash Command Handler
--------------------------------------------------------------------------------

--- Handle slash commands
-- @param input string Full command input after /rdt
function RDT:SlashCommand(input)
    input = input or ""
    local cmd, args = input:match("^(%S*)%s*(.-)$")
    cmd = string.lower(cmd or "")
    
    local handler = commands[cmd]
    if handler then
        handler(args)
    else
        RDT:PrintError("Unknown command: " .. cmd)
        RDT:Print("Type /rdt help for available commands")
    end
end

--------------------------------------------------------------------------------
-- Register Additional Slash Commands (optional)
--------------------------------------------------------------------------------

-- You can register more slash command variants here if needed
-- Example: /rdtools, /reindungeon, etc.

RDT:DebugPrint("Commands.lua loaded")
