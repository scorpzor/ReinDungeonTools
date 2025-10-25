-- UI/MainFrame.lua
-- Main addon window creation and management

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- UI Constants
local FRAME_WIDTH, FRAME_HEIGHT = 1350, 820
local MAP_WIDTH, MAP_HEIGHT = 1050, 760
local PULLS_PANEL_WIDTH, PULLS_PANEL_HEIGHT = 260, 580
local BUTTON_PANEL_HEIGHT = 140

-- Local frame references
local mainFrame
local mapContainer
local mapTexture
local titleText
local versionText
local dropdownFrame
local buttonContainer

--------------------------------------------------------------------------------
-- Main Frame Creation
--------------------------------------------------------------------------------

--- Create the main addon window
function UI:CreateMainFrame()
    if mainFrame then
        RDT:DebugPrint("MainFrame already exists")
        -- Make sure textures are visible after reload
        mainFrame:Show()
        return mainFrame
    end
    
    RDT:DebugPrint("Creating main frame")
    
    -- Main frame
    mainFrame = CreateFrame("Frame", "RDT_MainFrame", UIParent)
    mainFrame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    mainFrame:SetPoint("CENTER")
    mainFrame:SetMovable(true)
    mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
    mainFrame:SetClampedToScreen(true)
    mainFrame:SetFrameStrata("HIGH")
    mainFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 2,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    mainFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    mainFrame:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
    mainFrame:Hide()

    -- Title bar background
    local titleBg = mainFrame:CreateTexture(nil, "ARTWORK")
    titleBg:SetPoint("TOPLEFT", 2, -2)
    titleBg:SetPoint("TOPRIGHT", -2, -2)
    titleBg:SetHeight(36)
    titleBg:SetColorTexture(0.1, 0.1, 0.15, 0.9)
    mainFrame.titleBg = titleBg  -- Store reference

    -- Title text (centered)
    titleText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOP", 0, -18)
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    titleText:SetText(L["TITLE"])
    titleText:SetJustifyH("CENTER")

    -- Close button (in title bar)
    local closeButton = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -5, -5)
    closeButton:SetSize(24, 24)
    closeButton:SetScript("OnClick", function() mainFrame:Hide() end)

    -- Create dungeon dropdown
    self:CreateDungeonDropdown(mainFrame)
    
    -- Create map container
    self:CreateMapContainer(mainFrame)
    
    -- Create button container (top right)
    self:CreateButtonContainer(mainFrame)
    
    -- Create pulls panel (below button container, right side)
    self:CreatePullsPanel(mainFrame)
    
    -- Bottom bar background
    local bottomBg = mainFrame:CreateTexture(nil, "ARTWORK")
    bottomBg:SetPoint("BOTTOMLEFT", 2, 2)
    bottomBg:SetPoint("BOTTOMRIGHT", -2, 2)
    bottomBg:SetHeight(16)
    bottomBg:SetColorTexture(0.1, 0.1, 0.15, 0.9)
    mainFrame.bottomBg = bottomBg  -- Store reference

    -- Help text at bottom (left side)
    local helpText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    helpText:SetPoint("BOTTOMLEFT", 7, 6)
    helpText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    helpText:SetText("Left-Click Pack: Add to Pull | Click Pull Sidebar: Switch Pull | Right-Click: Remove")
    helpText:SetTextColor(0.6, 0.6, 0.6)
    
    -- Version text (bottom right)
    versionText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versionText:SetPoint("BOTTOMRIGHT", -7, 6)
    versionText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    versionText:SetText("|cFF888888v" .. RDT.Version .. "|r")
    versionText:SetTextColor(0.5, 0.5, 0.5)

    RDT:DebugPrint("Main frame created successfully")
    return mainFrame
end

--------------------------------------------------------------------------------
-- Dungeon Dropdown
--------------------------------------------------------------------------------

--- Create dungeon selection dropdown
-- @param parent Frame Parent frame
function UI:CreateDungeonDropdown(parent)
    dropdownFrame = CreateFrame("Frame", "RDT_DungeonDropdown", parent, "UIDropDownMenuTemplate")
    dropdownFrame:SetPoint("TOPLEFT", -10, -10)
    UIDropDownMenu_SetWidth(dropdownFrame, 220)
    
    local currentDungeon = RDT.db and RDT.db.profile.currentDungeon or "Test Dungeon"
    UIDropDownMenu_SetText(dropdownFrame, currentDungeon)

    UIDropDownMenu_Initialize(dropdownFrame, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        
        if not RDT.Data then
            info.text = "No dungeons available"
            info.disabled = true
            UIDropDownMenu_AddButton(info)
            return
        end
        
        local activeDungeon = RDT.db and RDT.db.profile.currentDungeon or "Test Dungeon"
        local dungeonNames = RDT.Data:GetDungeonNames()
        
        for _, name in ipairs(dungeonNames) do
            info.text = name
            info.func = function()
                if RDT:LoadDungeon(name) then
                    UIDropDownMenu_SetText(dropdownFrame, name)
                end
            end
            info.checked = (name == activeDungeon)
            UIDropDownMenu_AddButton(info)
        end
    end)
end

--- Update the dungeon dropdown text
-- @param dungeonName string Name to display
function UI:UpdateDropdownText(dungeonName)
    if dropdownFrame and dungeonName then
        UIDropDownMenu_SetText(dropdownFrame, dungeonName)
    end
end

--------------------------------------------------------------------------------
-- Map Container
--------------------------------------------------------------------------------

--- Create map display container
-- @param parent Frame Parent frame
function UI:CreateMapContainer(parent)
    mapContainer = CreateFrame("Frame", "RDT_MapContainer", parent)
    mapContainer:SetPoint("TOPLEFT", 5, -42)
    mapContainer:SetSize(MAP_WIDTH, MAP_HEIGHT)
    mapContainer:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    mapContainer:SetBackdropColor(0, 0, 0, 1)
    mapContainer:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Map texture
    mapTexture = mapContainer:CreateTexture(nil, "BACKGROUND")
    mapTexture:SetPoint("TOPLEFT", 1, -1)
    mapTexture:SetPoint("BOTTOMRIGHT", -1, 1)
    mapTexture:SetTexture("Interface\\WorldMap\\UI-WorldMap-Background")
    mapTexture:SetVertexColor(0.9, 0.9, 0.9)
    
    -- Store reference for pack buttons to anchor to
    UI.mapContainer = mapContainer
    UI.mapTexture = mapTexture
end

--- Update the map texture
-- @param texturePath string Path to texture file
function UI:UpdateMapTexture(texturePath)
    if not mapTexture then return end
    
    RDT:DebugPrint("Updating map texture: " .. tostring(texturePath))
    
    mapTexture:SetTexture(texturePath or "Interface\\WorldMap\\UI-WorldMap-Background")
    mapTexture:SetVertexColor(0.9, 0.9, 0.9)
end

--- Get map dimensions for pack button positioning
-- @return number width, number height
function UI:GetMapDimensions()
    return MAP_WIDTH, MAP_HEIGHT
end

--- Get map container frame
-- @return Frame The map container
function UI:GetMapContainer()
    return mapContainer
end

--------------------------------------------------------------------------------
-- Pulls Panel (created by PullsList.lua)
--------------------------------------------------------------------------------

--- Create pulls panel container (panel content handled by PullsList.lua)
-- @param parent Frame Parent frame
function UI:CreatePullsPanel(parent)
    local pullsPanel = CreateFrame("Frame", "RDT_PullsPanel", parent)
    pullsPanel:SetPoint("TOPLEFT", buttonContainer, "BOTTOMLEFT", 0, -4)
    pullsPanel:SetPoint("BOTTOMLEFT", mapContainer, "BOTTOMRIGHT", 4, 0)
    pullsPanel:SetPoint("BOTTOMRIGHT", -5, 22)
    pullsPanel:SetWidth(PULLS_PANEL_WIDTH)
    pullsPanel:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    pullsPanel:SetBackdropColor(0.0, 0.0, 0.0, 0.9)
    pullsPanel:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Store reference for PullsList module
    UI.pullsPanel = pullsPanel
    
    -- PullsList.lua will populate this panel
    if UI.InitializePullsList then
        UI:InitializePullsList(pullsPanel)
    end
end

--------------------------------------------------------------------------------
-- Button Container
--------------------------------------------------------------------------------

--- Create button container (top right)
-- @param parent Frame Parent frame
function UI:CreateButtonContainer(parent)
    buttonContainer = CreateFrame("Frame", "RDT_ButtonContainer", parent)
    buttonContainer:SetPoint("TOPLEFT", mapContainer, "TOPRIGHT", 4, 0)
    buttonContainer:SetPoint("TOPRIGHT", -5, -42)
    buttonContainer:SetHeight(BUTTON_PANEL_HEIGHT)
    buttonContainer:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    buttonContainer:SetBackdropColor(0.0, 0.0, 0.0, 0.9)
    buttonContainer:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- New Pull button (top)
    local newPullButton = CreateFrame("Button", "RDT_NewPullButton", buttonContainer, "UIPanelButtonTemplate")
    newPullButton:SetPoint("TOP", buttonContainer, "TOP", 0, -14)
    newPullButton:SetSize(240, 28)
    newPullButton:SetText("New Pull")
    newPullButton:SetScript("OnClick", function()
        if RDT.RouteManager then
            RDT.RouteManager:NewPull()
        end
    end)
    UI.newPullButton = newPullButton

    -- Reset button
    local resetButton = CreateFrame("Button", "RDT_ResetButton", buttonContainer, "UIPanelButtonTemplate")
    resetButton:SetPoint("TOP", newPullButton, "BOTTOM", 0, -5)
    resetButton:SetSize(240, 26)
    resetButton:SetText(L["RESET_ALL"])
    resetButton:SetScript("OnClick", function()
        if RDT.RouteManager then
            RDT.RouteManager:ResetPulls()
        end
    end)

    -- Export button (left side of pair)
    local exportButton = CreateFrame("Button", "RDT_ExportButton", buttonContainer, "UIPanelButtonTemplate")
    exportButton:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -5)
    exportButton:SetSize(117, 24)
    exportButton:SetText("Export")
    exportButton:SetScript("OnClick", function()
        if not RDT.ImportExport then
            RDT:PrintError("ImportExport module not loaded")
            return
        end
        
        local exportString = RDT.ImportExport:Export()
        if exportString and RDT.Dialogs and RDT.Dialogs.ShowExport then
            RDT.Dialogs:ShowExport(exportString)
        end
    end)

    -- Import button (right side of pair)
    local importButton = CreateFrame("Button", "RDT_ImportButton", buttonContainer, "UIPanelButtonTemplate")
    importButton:SetPoint("TOPRIGHT", resetButton, "BOTTOMRIGHT", 0, -5)
    importButton:SetSize(117, 24)
    importButton:SetText("Import")
    importButton:SetScript("OnClick", function()
        if RDT.Dialogs and RDT.Dialogs.ShowImport then
            RDT.Dialogs:ShowImport()
        else
            RDT:PrintError("Import dialog not available")
        end
    end)
end

--- Update pull display (removed - no longer needed)
function UI:UpdatePullIndicator()
    -- Placeholder for backward compatibility
    -- Pull number is now shown in the pulls list with ">" prefix
end

--------------------------------------------------------------------------------
-- Title and Display Updates
--------------------------------------------------------------------------------

--- Update the title text
-- @param dungeonName string Optional dungeon name to display
function UI:UpdateTitle(dungeonName)
    if not titleText then return end
    
    -- Title is always just the addon name (dungeon shown in dropdown)
    titleText:SetText(L["TITLE"])
end

--------------------------------------------------------------------------------
-- Frame Visibility
--------------------------------------------------------------------------------

--- Show the main frame
function UI:Show()
    if mainFrame then
        mainFrame:Show()
    else
        RDT:PrintError("Main frame not created yet")
    end
end

--- Hide the main frame
function UI:Hide()
    if mainFrame then
        mainFrame:Hide()
    end
end

--- Check if main frame is visible
-- @return boolean True if shown
function UI:IsShown()
    return mainFrame and mainFrame:IsShown()
end

--- Toggle main frame visibility
function UI:Toggle()
    if self:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

--------------------------------------------------------------------------------
-- Frame Position Management
--------------------------------------------------------------------------------

--- Save current frame position to database
function UI:SavePosition()
    if not mainFrame or not RDT.db then return end
    
    local point, _, relativePoint, xOfs, yOfs = mainFrame:GetPoint()
    RDT.db.profile.windowPosition = {
        point = point,
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs,
    }
    
    RDT:DebugPrint(string.format("Saved window position: %s, %d, %d", point, xOfs, yOfs))
end

--- Restore frame position from database
function UI:RestorePosition()
    if not mainFrame or not RDT.db then return end
    
    local pos = RDT.db.profile.windowPosition
    if pos and pos.point then
        mainFrame:ClearAllPoints()
        mainFrame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
        RDT:DebugPrint(string.format("Restored window position: %s, %d, %d", pos.point, pos.xOfs, pos.yOfs))
    end
end

--- Reset frame to center of screen
function UI:ResetPosition()
    if not mainFrame then return end
    
    mainFrame:ClearAllPoints()
    mainFrame:SetPoint("CENTER")
    
    if RDT.db then
        RDT.db.profile.windowPosition = {
            point = "CENTER",
            relativePoint = "CENTER",
            xOfs = 0,
            yOfs = 0,
        }
    end
    
    RDT:Print("Window position reset to center")
end

--------------------------------------------------------------------------------
-- Cleanup
--------------------------------------------------------------------------------

--- Clear all UI elements (for reload/disable)
function UI:Cleanup()
    -- PackButtons.lua handles pack cleanup
    if self.ClearPacks then
        self:ClearPacks()
    end
    
    -- PullsList.lua handles pull list cleanup
    if self.CleanupPullsList then
        self:CleanupPullsList()
    end
    
    -- Hide main frame
    if mainFrame then
        mainFrame:Hide()
    end
    
    RDT:DebugPrint("UI cleanup complete")
end

RDT:DebugPrint("MainFrame.lua loaded")