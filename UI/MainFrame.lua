-- UI/MainFrame.lua
-- Main addon window creation and management

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- UI Constants
local FRAME_WIDTH, FRAME_HEIGHT = 1000, 700
local MAP_WIDTH, MAP_HEIGHT = 700, 600
local PULLS_PANEL_WIDTH, PULLS_PANEL_HEIGHT = 250, 600

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
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 12 }
    })
    mainFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    mainFrame:Hide()

    -- Title bar background
    local titleBg = mainFrame:CreateTexture(nil, "BACKGROUND")
    titleBg:SetPoint("TOPLEFT", 12, -12)
    titleBg:SetPoint("TOPRIGHT", -12, -12)
    titleBg:SetHeight(60)
    titleBg:SetColorTexture(0.1, 0.1, 0.15, 0.9)

    -- Title text
    titleText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOP", 0, -18)
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    titleText:SetText(L["TITLE"])

    -- Version text
    versionText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versionText:SetPoint("TOP", titleText, "BOTTOM", 0, -3)
    versionText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    versionText:SetText("v" .. RDT.Version)
    versionText:SetTextColor(0.5, 0.5, 0.5)

    -- Close button
    local closeButton = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -8, -8)
    closeButton:SetScript("OnClick", function() mainFrame:Hide() end)

    -- Create dungeon dropdown
    self:CreateDungeonDropdown(mainFrame)
    
    -- Create map container
    self:CreateMapContainer(mainFrame)
    
    -- Create pulls panel (right side)
    self:CreatePullsPanel(mainFrame)
    
    -- Create button container at bottom
    self:CreateButtonContainer(mainFrame)
    
    -- Help text at bottom
    local helpText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    helpText:SetPoint("BOTTOM", 0, 52)
    helpText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    helpText:SetText("Left-Click: Select | Right-Click: Remove | Type /rdt help for commands")
    helpText:SetTextColor(0.6, 0.6, 0.6)

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
    dropdownFrame:SetPoint("TOPLEFT", 8, -50)
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
    mapContainer:SetPoint("TOPLEFT", 20, -85)
    mapContainer:SetSize(MAP_WIDTH, MAP_HEIGHT)
    mapContainer:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    mapContainer:SetBackdropColor(0, 0, 0, 1)
    mapContainer:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Map texture
    mapTexture = mapContainer:CreateTexture(nil, "BACKGROUND")
    mapTexture:SetPoint("TOPLEFT", 4, -4)
    mapTexture:SetPoint("BOTTOMRIGHT", -4, 4)
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
    pullsPanel:SetPoint("TOPLEFT", mapContainer, "TOPRIGHT", 10, 0)
    pullsPanel:SetSize(PULLS_PANEL_WIDTH, PULLS_PANEL_HEIGHT)
    pullsPanel:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    pullsPanel:SetBackdropColor(0.0, 0.0, 0.0, 0.9)
    pullsPanel:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

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

--- Create bottom button container
-- @param parent Frame Parent frame
function UI:CreateButtonContainer(parent)
    buttonContainer = CreateFrame("Frame", "RDT_ButtonContainer", parent)
    buttonContainer:SetPoint("BOTTOMLEFT", 20, 15)
    buttonContainer:SetPoint("BOTTOMRIGHT", -20, 15)
    buttonContainer:SetHeight(35)

    -- Group button (center)
    local groupButton = CreateFrame("Button", "RDT_GroupButton", buttonContainer, "UIPanelButtonTemplate")
    groupButton:SetPoint("CENTER", 0, 0)
    groupButton:SetSize(140, 30)
    groupButton:SetText(L["GROUP_PULL"])
    groupButton:SetScript("OnClick", function()
        if RDT.RouteManager then
            RDT.RouteManager:GroupPull()
        end
    end)
    UI.groupButton = groupButton

    -- Clear selection button (left of group)
    local clearSelButton = CreateFrame("Button", "RDT_ClearSelButton", buttonContainer, "UIPanelButtonTemplate")
    clearSelButton:SetPoint("RIGHT", groupButton, "LEFT", -5, 0)
    clearSelButton:SetSize(120, 30)
    clearSelButton:SetText(L["CLEAR_SEL"])
    clearSelButton:SetScript("OnClick", function()
        if UI.ClearSelection then
            UI:ClearSelection()
        end
        if UI.UpdatePullList then
            UI:UpdatePullList()
        end
    end)

    -- Reset button (right of group)
    local resetButton = CreateFrame("Button", "RDT_ResetButton", buttonContainer, "UIPanelButtonTemplate")
    resetButton:SetPoint("LEFT", groupButton, "RIGHT", 5, 0)
    resetButton:SetSize(120, 30)
    resetButton:SetText(L["RESET_ALL"])
    resetButton:SetScript("OnClick", function()
        if RDT.RouteManager then
            RDT.RouteManager:ResetPulls()
        end
    end)

    -- Export button (above buttons, left)
    local exportButton = CreateFrame("Button", "RDT_ExportButton", buttonContainer, "UIPanelButtonTemplate")
    exportButton:SetPoint("BOTTOM", buttonContainer, "TOP", -65, 5)
    exportButton:SetSize(120, 25)
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

    -- Import button (above buttons, right)
    local importButton = CreateFrame("Button", "RDT_ImportButton", buttonContainer, "UIPanelButtonTemplate")
    importButton:SetPoint("BOTTOM", buttonContainer, "TOP", 65, 5)
    importButton:SetSize(120, 25)
    importButton:SetText("Import")
    importButton:SetScript("OnClick", function()
        if RDT.Dialogs and RDT.Dialogs.ShowImport then
            RDT.Dialogs:ShowImport()
        else
            RDT:PrintError("Import dialog not available")
        end
    end)
end

--- Update the group button text with selection count
-- @param count number Number of selected packs (optional, auto-detects if nil)
function UI:UpdateGroupButton(count)
    if not UI.groupButton then return end
    
    count = count or #RDT.State.selectedPacks
    
    if count > 0 then
        UI.groupButton:SetText(L["GROUP_PULL"] .. " (" .. count .. ")")
    else
        UI.groupButton:SetText(L["GROUP_PULL"])
    end
end

--------------------------------------------------------------------------------
-- Title and Display Updates
--------------------------------------------------------------------------------

--- Update the title text
-- @param dungeonName string Optional dungeon name to display
function UI:UpdateTitle(dungeonName)
    if not titleText then return end
    
    if dungeonName then
        titleText:SetText(L["TITLE"] .. "\n|cFFFFAA00" .. dungeonName .. "|r")
    else
        titleText:SetText(L["TITLE"])
    end
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