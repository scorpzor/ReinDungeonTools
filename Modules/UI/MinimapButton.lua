-- Modules/UI/MinimapButton.lua
-- Minimap button integration using LibDBIcon

local ADDON_NAME = "ReinDungeonTools"
local RDT = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local MinimapButton = {}
RDT.MinimapButton = MinimapButton

-- Icon for the minimap button
local MINIMAP_ICON = "Interface\\Icons\\INV_Misc_Map_01"

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

--- Initialize the minimap button
function MinimapButton:Initialize()
    if self.initialized then return end
    
    -- Create LibDataBroker data source
    local RDT_LDB = LDB:NewDataObject("ReinDungeonTools", {
        type = "launcher",
        icon = MINIMAP_ICON,
        OnClick = function(_, button)
            MinimapButton:OnClick(button)
        end,
        OnTooltipShow = function(tooltip)
            MinimapButton:OnTooltipShow(tooltip)
        end,
    })
    
    -- Register with LibDBIcon for minimap button
    if not RDT.db.profile.minimap then
        RDT.db.profile.minimap = {
            hide = false,
            minimapPos = 225,
        }
    end
    
    LDBIcon:Register("ReinDungeonTools", RDT_LDB, RDT.db.profile.minimap)
    
    self.initialized = true
    RDT:DebugPrint("Minimap button initialized")
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

--- Handle minimap button clicks
-- @param button string Mouse button clicked ("LeftButton", "RightButton", etc.)
function MinimapButton:OnClick(button)
    if button == "LeftButton" then
        -- Left click: Toggle main window
        if RDT.UI then
            if RDT.UI.mainFrame and RDT.UI.mainFrame:IsShown() then
                RDT.UI:Hide()
            else
                RDT.UI:Show()
            end
        end
    elseif button == "RightButton" then
        -- Right click: Show options menu or perform other action
        RDT:Print("Right-click options menu (future feature)")
    end
end

--- Show tooltip when hovering over minimap button
-- @param tooltip GameTooltip The tooltip frame
function MinimapButton:OnTooltipShow(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    
    tooltip:SetText("|cFF00FF00Rein Dungeon Tools|r")
    tooltip:AddLine(" ")
    tooltip:AddLine("|cFFFFFFFFLeft-click:|r Toggle window", 1, 1, 1)
    tooltip:AddLine("|cFFFFFFFFRight-click:|r Options (coming soon)", 1, 1, 1)
    tooltip:AddLine(" ")
    tooltip:AddLine("|cFF888888Version " .. (RDT.Version or "1.0.0") .. "|r", 0.5, 0.5, 0.5)
    
    -- Add dungeon info if available
    local currentDungeon = RDT.db and RDT.db.profile.currentDungeon
    if currentDungeon then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cFFFFAA00Current Dungeon:|r " .. currentDungeon, 1, 1, 0.7)
        
        -- Add pull count if available
        if RDT.State and RDT.State.currentRoute and RDT.State.currentRoute.pulls then
            local pullCount = 0
            for _ in pairs(RDT.State.currentRoute.pulls) do
                pullCount = pullCount + 1
            end
            tooltip:AddLine("|cFFFFAA00Pulls Planned:|r " .. pullCount, 1, 1, 0.7)
        end
        
        -- Add total forces if available
        if RDT.RouteManager and RDT.Data then
            local currentCount = RDT.RouteManager:CalculateTotalForces()
            local requiredCount = RDT.Data:GetDungeonRequiredCount(currentDungeon)
            local percentage = (currentCount / requiredCount) * 100
            
            local colorCode = "|cFFFF4444"  -- Red
            if percentage >= 100 and percentage < 101 then
                colorCode = "|cFF44FF44"  -- Green
            elseif percentage > 100 then
                colorCode = "|cFFFFCC44"  -- Yellow
            end
            
            tooltip:AddLine(string.format("|cFFFFAA00Enemy Forces:|r %s%.1f/%.0f (%.1f%%)|r", 
                colorCode, currentCount, requiredCount, percentage), 1, 1, 0.7)
        end
    end
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

--- Show the minimap button
function MinimapButton:Show()
    if self.initialized then
        LDBIcon:Show("ReinDungeonTools")
        RDT.db.profile.minimap.hide = false
    end
end

--- Hide the minimap button
function MinimapButton:Hide()
    if self.initialized then
        LDBIcon:Hide("ReinDungeonTools")
        RDT.db.profile.minimap.hide = true
    end
end

--- Toggle minimap button visibility
function MinimapButton:Toggle()
    if self.initialized then
        if RDT.db.profile.minimap.hide then
            self:Show()
        else
            self:Hide()
        end
    end
end

--- Check if minimap button is shown
-- @return boolean True if button is shown
function MinimapButton:IsShown()
    return self.initialized and not RDT.db.profile.minimap.hide
end

--- Reset minimap button position to default
function MinimapButton:ResetPosition()
    if self.initialized then
        RDT.db.profile.minimap.minimapPos = 225
        LDBIcon:Refresh("ReinDungeonTools", RDT.db.profile.minimap)
        RDT:Print("Minimap button position reset")
    end
end

RDT:DebugPrint("MinimapButton.lua loaded")

