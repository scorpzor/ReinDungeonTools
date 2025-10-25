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
-- Helper Functions
--------------------------------------------------------------------------------

--- Style a button with square gray appearance
-- @param button Button Button to style
local function StyleSquareButton(button)
    button:SetNormalFontObject("GameFontNormal")
    button:SetHighlightFontObject("GameFontHighlight")
    button:SetDisabledFontObject("GameFontDisable")
    
    -- Set backdrop for square gray appearance
    button:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    
    -- Normal state: dark gray
    button:SetBackdropColor(0.15, 0.15, 0.15, 1)
    button:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    
    -- Hover state: lighter gray
    button:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.25, 0.25, 0.25, 1)
        self:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
    end)
    
    button:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.15, 0.15, 0.15, 1)
        self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    end)
    
    -- Pressed state: darker gray
    button:SetScript("OnMouseDown", function(self)
        self:SetBackdropColor(0.1, 0.1, 0.1, 1)
    end)
    
    button:SetScript("OnMouseUp", function(self)
        self:SetBackdropColor(0.25, 0.25, 0.25, 1)
    end)
end

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

    -- Title bar background (matches main window)
    local titleBg = mainFrame:CreateTexture(nil, "ARTWORK")
    titleBg:SetPoint("TOPLEFT", 2, -2)
    titleBg:SetPoint("TOPRIGHT", -2, -2)
    titleBg:SetHeight(36)
    titleBg:SetColorTexture(0.05, 0.05, 0.05, 0.95)
    mainFrame.titleBg = titleBg  -- Store reference

    -- Title text (centered)
    titleText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOP", 0, -18)
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    titleText:SetText(L["TITLE"])
    titleText:SetJustifyH("CENTER")

    -- Close button (in title bar)
    local closeButton = CreateFrame("Button", nil, mainFrame)
    closeButton:SetPoint("TOPRIGHT", -8, -8)
    closeButton:SetSize(20, 20)
    closeButton:SetText("×")
    closeButton:SetNormalFontObject("GameFontNormalLarge")
    StyleSquareButton(closeButton)
    -- Make the X bigger and override font color
    local closeFont = closeButton:GetFontString()
    closeFont:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
    closeFont:SetTextColor(0.8, 0.8, 0.8)
    local origCloseOnEnter = closeButton:GetScript("OnEnter")
    closeButton:SetScript("OnEnter", function(self)
        if origCloseOnEnter then origCloseOnEnter(self) end
        self:GetFontString():SetTextColor(1, 0.3, 0.3)  -- Red on hover
    end)
    local origCloseOnLeave = closeButton:GetScript("OnLeave")
    closeButton:SetScript("OnLeave", function(self)
        if origCloseOnLeave then origCloseOnLeave(self) end
        self:GetFontString():SetTextColor(0.8, 0.8, 0.8)  -- Gray when not hovering
    end)
    closeButton:SetScript("OnClick", function() mainFrame:Hide() end)

    -- Create dungeon dropdown
    self:CreateDungeonDropdown(mainFrame)
    
    -- Create map container
    self:CreateMapContainer(mainFrame)
    
    -- Create button container (top right)
    self:CreateButtonContainer(mainFrame)
    
    -- Create pulls panel (below button container, right side)
    self:CreatePullsPanel(mainFrame)
    
    -- Bottom bar background (matches main window)
    local bottomBg = mainFrame:CreateTexture(nil, "ARTWORK")
    bottomBg:SetPoint("BOTTOMLEFT", 2, 2)
    bottomBg:SetPoint("BOTTOMRIGHT", -2, 2)
    bottomBg:SetHeight(16)
    bottomBg:SetColorTexture(0.05, 0.05, 0.05, 0.95)
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

--- Create dungeon selection dropdown (custom modern design)
-- @param parent Frame Parent frame
function UI:CreateDungeonDropdown(parent)
    -- Create main button
    dropdownFrame = CreateFrame("Button", "RDT_DungeonDropdown", parent)
    dropdownFrame:SetPoint("TOPLEFT", 5, -8)
    dropdownFrame:SetSize(220, 24)
    StyleSquareButton(dropdownFrame)
    
    -- Dropdown text
    local dropdownText = dropdownFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dropdownText:SetPoint("LEFT", 8, 0)
    dropdownText:SetPoint("RIGHT", -20, 0)
    dropdownText:SetJustifyH("LEFT")
    dropdownFrame.text = dropdownText
    
    -- Dropdown arrow (using simple triangle made with text)
    local arrow = dropdownFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arrow:SetPoint("RIGHT", -5, 0)
    arrow:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    arrow:SetText("v")  -- Simple 'v' character works on all clients
    arrow:SetTextColor(0.7, 0.7, 0.7)
    
    -- Set initial text
    local currentDungeon = RDT.db and RDT.db.profile.currentDungeon or "Test Dungeon"
    dropdownText:SetText(currentDungeon)
    
    -- Create dropdown menu frame
    local menuFrame = CreateFrame("Frame", "RDT_DropdownMenu", UIParent)
    menuFrame:SetSize(220, 200)
    menuFrame:SetFrameStrata("DIALOG")
    menuFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    menuFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.98)
    menuFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    menuFrame:Hide()
    menuFrame:SetScript("OnShow", function(self)
        self:SetFrameLevel(dropdownFrame:GetFrameLevel() + 10)
    end)
    
    -- Scroll frame for menu items
    local scrollFrame = CreateFrame("ScrollFrame", "RDT_DropdownScroll", menuFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 4, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(190, 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    menuFrame.scrollFrame = scrollFrame
    menuFrame.scrollChild = scrollChild
    menuFrame.buttons = {}
    
    -- Click handler to toggle menu
    dropdownFrame:SetScript("OnClick", function(self)
        if menuFrame:IsShown() then
            menuFrame:Hide()
        else
            -- Position menu below button
            menuFrame:ClearAllPoints()
            menuFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
            
            -- Populate menu
            UI:PopulateDropdownMenu(menuFrame)
            menuFrame:Show()
        end
    end)
    
    -- Close menu when clicking outside
    menuFrame:SetScript("OnShow", function(self)
        self:SetFrameLevel(dropdownFrame:GetFrameLevel() + 10)
        self:EnableMouse(true)
    end)
    
    menuFrame:SetScript("OnHide", function(self)
        self:EnableMouse(false)
    end)
    
    dropdownFrame.menuFrame = menuFrame
end

--- Populate the dropdown menu with dungeons
-- @param menuFrame Frame The menu frame to populate
function UI:PopulateDropdownMenu(menuFrame)
    local scrollChild = menuFrame.scrollChild
    
    -- Clear existing buttons
    for _, btn in ipairs(menuFrame.buttons) do
        btn:Hide()
    end
    
    if not RDT.Data then
        return
    end
    
    local activeDungeon = RDT.db and RDT.db.profile.currentDungeon or "Test Dungeon"
    local dungeonNames = RDT.Data:GetDungeonNames()
    table.sort(dungeonNames)
    
    local yOffset = 0
    for i, name in ipairs(dungeonNames) do
        local btn = menuFrame.buttons[i]
        if not btn then
            btn = CreateFrame("Button", nil, scrollChild)
            btn:SetSize(190, 22)
            
            btn:SetBackdrop({
                bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                edgeFile = nil,
                tile = false,
                insets = { left = 0, right = 0, top = 0, bottom = 0 }
            })
            btn:SetBackdropColor(0, 0, 0, 0)
            
            local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("LEFT", 8, 0)
            text:SetJustifyH("LEFT")
            btn.text = text
            
            local checkmark = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            checkmark:SetPoint("RIGHT", -5, 0)
            checkmark:SetText("<")
            checkmark:SetTextColor(0, 1, 0)
            btn.checkmark = checkmark
            
            btn:SetScript("OnEnter", function(self)
                self:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
            end)
            
            btn:SetScript("OnLeave", function(self)
                if self.isSelected then
                    self:SetBackdropColor(0.1, 0.15, 0.2, 0.5)
                else
                    self:SetBackdropColor(0, 0, 0, 0)
                end
            end)
            
            menuFrame.buttons[i] = btn
        end
        
        btn:SetPoint("TOPLEFT", 0, -yOffset)
        btn.text:SetText(name)
        btn.dungeonName = name
        btn.isSelected = (name == activeDungeon)
        
        if btn.isSelected then
            btn.checkmark:Show()
            btn:SetBackdropColor(0.1, 0.15, 0.2, 0.5)
        else
            btn.checkmark:Hide()
            btn:SetBackdropColor(0, 0, 0, 0)
        end
        
        btn:SetScript("OnClick", function(self)
            if RDT:LoadDungeon(self.dungeonName) then
                dropdownFrame.text:SetText(self.dungeonName)
                menuFrame:Hide()
            end
        end)
        
        btn:Show()
        yOffset = yOffset + 22
    end
    
    scrollChild:SetHeight(math.max(yOffset, 1))
end

--- Update the dungeon dropdown text
-- @param dungeonName string Name to display
function UI:UpdateDropdownText(dungeonName)
    if dropdownFrame and dropdownFrame.text and dungeonName then
        dropdownFrame.text:SetText(dungeonName)
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
    local newPullButton = CreateFrame("Button", "RDT_NewPullButton", buttonContainer)
    newPullButton:SetPoint("TOP", buttonContainer, "TOP", 0, -14)
    newPullButton:SetSize(240, 28)
    newPullButton:SetText("New Pull")
    newPullButton:RegisterForClicks("LeftButtonUp")
    StyleSquareButton(newPullButton)
    -- Hook click after styling
    local origOnClick = newPullButton:GetScript("OnClick")
    newPullButton:SetScript("OnClick", function(self, button, ...)
        if origOnClick then origOnClick(self, button, ...) end
        if RDT.RouteManager then
            RDT.RouteManager:NewPull()
        end
    end)
    UI.newPullButton = newPullButton

    -- Reset button
    local resetButton = CreateFrame("Button", "RDT_ResetButton", buttonContainer)
    resetButton:SetPoint("TOP", newPullButton, "BOTTOM", 0, -5)
    resetButton:SetSize(240, 26)
    resetButton:SetText(L["RESET_ALL"])
    resetButton:RegisterForClicks("LeftButtonUp")
    StyleSquareButton(resetButton)
    local origResetClick = resetButton:GetScript("OnClick")
    resetButton:SetScript("OnClick", function(self, button, ...)
        if origResetClick then origResetClick(self, button, ...) end
        if RDT.RouteManager then
            RDT.RouteManager:ResetPulls()
        end
    end)

    -- Export button (left side of pair)
    local exportButton = CreateFrame("Button", "RDT_ExportButton", buttonContainer)
    exportButton:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -5)
    exportButton:SetSize(117, 24)
    exportButton:SetText("Export")
    exportButton:RegisterForClicks("LeftButtonUp")
    StyleSquareButton(exportButton)
    local origExportClick = exportButton:GetScript("OnClick")
    exportButton:SetScript("OnClick", function(self, button, ...)
        if origExportClick then origExportClick(self, button, ...) end
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
    local importButton = CreateFrame("Button", "RDT_ImportButton", buttonContainer)
    importButton:SetPoint("TOPRIGHT", resetButton, "BOTTOMRIGHT", 0, -5)
    importButton:SetSize(117, 24)
    importButton:SetText("Import")
    importButton:RegisterForClicks("LeftButtonUp")
    StyleSquareButton(importButton)
    local origImportClick = importButton:GetScript("OnClick")
    importButton:SetScript("OnClick", function(self, button, ...)
        if origImportClick then origImportClick(self, button, ...) end
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