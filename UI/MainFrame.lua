-- UI/MainFrame.lua
-- Main addon window creation and management

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- Local reference to UIHelpers
local UIHelpers = RDT.UIHelpers

-- UI Constants
local FRAME_WIDTH, FRAME_HEIGHT = 1440, 820
local MAP_WIDTH, MAP_HEIGHT = 1140, 760
local PULLS_PANEL_WIDTH, PULLS_PANEL_HEIGHT = 260, 580
local BUTTON_PANEL_HEIGHT = 140

-- Local frame references
local mainFrame
local mapContainer
local mapTexture  -- Legacy single texture (kept for compatibility)
local mapTiles = {}  -- New: tile system for high-res maps
local titleText
local versionText
local dungeonDropdown  -- Dungeon dropdown object
local routeDropdown  -- Route dropdown object
local buttonContainer

-- Local convenience wrapper for button styling
local function StyleSquareButton(button)
    UIHelpers:StyleSquareButton(button)
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
    local closeButton = UIHelpers:CreateModernCloseButton(mainFrame)
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
    local currentDungeon = RDT.db and RDT.db.profile.currentDungeon or "Test Dungeon"
    
    -- Create dropdown using the generic component
    dungeonDropdown = UIHelpers:CreateModernDropdown({
        parent = parent,
        name = "RDT_DungeonDropdown",
        point = "TOPLEFT",
        x = 5,
        y = -8,
        width = 220,
        height = 24,
        menuHeight = 200,
        defaultText = currentDungeon,
        onItemClick = function(item)
            -- Switch to selected dungeon
            if item.value and RDT.LoadDungeon then
                RDT:LoadDungeon(item.value)
            end
        end
    })
    
    -- Override the button's OnClick to populate items before showing
    local originalButton = dungeonDropdown.button
    local originalMenuFrame = dungeonDropdown.menuFrame
    originalButton:SetScript("OnClick", function(self)
        if originalMenuFrame:IsShown() then
            originalMenuFrame:Hide()
        else
            -- Position menu below button
            originalMenuFrame:ClearAllPoints()
            originalMenuFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
            
            -- Populate with dungeons
            UI:PopulateDungeonDropdown()
            originalMenuFrame:Show()
        end
    end)
end

--- Populate the dungeon dropdown with current dungeons
function UI:PopulateDungeonDropdown()
    if not dungeonDropdown or not RDT.Data then return end
    
    local activeDungeon = RDT.db and RDT.db.profile.currentDungeon or "Test Dungeon"
    local dungeonNames = RDT.Data:GetDungeonNames()
    table.sort(dungeonNames)
    
    local items = {}
    for _, name in ipairs(dungeonNames) do
        table.insert(items, {
            value = name,
            text = name,
            isSelected = (name == activeDungeon)
        })
    end
    
    dungeonDropdown:SetItems(items)
end

--- Update the dungeon dropdown text
-- @param dungeonName string Name to display
function UI:UpdateDropdownText(dungeonName)
    if dungeonDropdown and dungeonName then
        dungeonDropdown:SetText(dungeonName)
    end
end

--------------------------------------------------------------------------------
-- Route Dropdown
--------------------------------------------------------------------------------

--- Create route selection dropdown and buttons in button container
--- @param container Frame Button container frame
function UI:CreateRouteDropdown(container)
    -- Create dropdown using the generic component
    routeDropdown = UIHelpers:CreateModernDropdown({
        parent = container,
        name = "RDT_RouteDropdown",
        point = "TOPLEFT",
        x = 0,
        y = -8,
        width = 290,  -- Default width, will be adjusted
        height = 26,
        menuHeight = 150,
        defaultText = "Route 1",
        onItemClick = function(item)
            -- Switch to selected route
            local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
            if dungeonName and item.value and RDT.RouteManager then
                if RDT.RouteManager:SwitchRoute(dungeonName, item.value) then
                    UI:UpdateRouteDropdown()
                    UI:RefreshUI()
                end
            end
        end
    })
    
    -- Override positioning to use full width
    routeDropdown.button:ClearAllPoints()
    routeDropdown.button:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -8)
    routeDropdown.button:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, -8)
    routeDropdown.button:SetHeight(26)
    
    -- Update menu width when dropdown is shown
    local originalButton = routeDropdown.button
    local originalMenuFrame = routeDropdown.menuFrame
    originalButton:SetScript("OnClick", function(self)
        if originalMenuFrame:IsShown() then
            originalMenuFrame:Hide()
        else
            -- Update menu width to match button
            originalMenuFrame:SetWidth(self:GetWidth())
            
            -- Position menu below button
            originalMenuFrame:ClearAllPoints()
            originalMenuFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
            
            -- Populate with routes
            UI:PopulateRouteDropdown()
            originalMenuFrame:Show()
        end
    end)
    
    -- Row 1: Route action buttons (New, Rename, Delete)
    local spacing = 3
    local totalSpacing = spacing * 2  -- Two gaps between three buttons
    
    -- Calculate initial button width (will be recalculated on resize)
    local containerWidth = container:GetWidth() or 290
    local buttonWidth = (containerWidth - totalSpacing) / 3
    
    -- New Route button (left side, 1/3 width)
    local newRouteBtn = CreateFrame("Button", "RDT_NewRouteButton", container)
    newRouteBtn:SetPoint("TOPLEFT", routeDropdown.button, "BOTTOMLEFT", 0, -5)
    newRouteBtn:SetSize(buttonWidth, 24)
    StyleSquareButton(newRouteBtn)
    newRouteBtn.text = newRouteBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    newRouteBtn.text:SetAllPoints()
    newRouteBtn.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    newRouteBtn.text:SetText("New")
    newRouteBtn.text:SetTextColor(0.2, 1, 0.2)
    
    newRouteBtn:SetScript("OnClick", function()
        if RDT.Dialogs and RDT.Dialogs.ShowNewRoute then
            RDT.Dialogs:ShowNewRoute()
        else
            -- Fallback: create route with default name
            local dungeonName = RDT.db.profile.currentDungeon
            if dungeonName and RDT.RouteManager then
                local newRouteName = RDT.RouteManager:CreateRoute(dungeonName)
                if newRouteName then
                    UI:UpdateRouteDropdown()
                    UI:RefreshUI()
                end
            end
        end
    end)
    
    -- Rename Route button (middle, 1/3 width)
    local renameRouteBtn = CreateFrame("Button", "RDT_RenameRouteButton", container)
    renameRouteBtn:SetPoint("LEFT", newRouteBtn, "RIGHT", spacing, 0)
    renameRouteBtn:SetSize(buttonWidth, 24)
    StyleSquareButton(renameRouteBtn)
    renameRouteBtn.text = renameRouteBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    renameRouteBtn.text:SetAllPoints()
    renameRouteBtn.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    renameRouteBtn.text:SetText("Rename")
    renameRouteBtn.text:SetTextColor(0.8, 0.8, 1)
    
    renameRouteBtn:SetScript("OnClick", function()
        if RDT.Dialogs and RDT.Dialogs.ShowRenameRoute then
            RDT.Dialogs:ShowRenameRoute()
        end
    end)
    
    -- Delete Route button (right side, 1/3 width)
    local deleteRouteBtn = CreateFrame("Button", "RDT_DeleteRouteButton", container)
    deleteRouteBtn:SetPoint("LEFT", renameRouteBtn, "RIGHT", spacing, 0)
    deleteRouteBtn:SetSize(buttonWidth, 24)
    StyleSquareButton(deleteRouteBtn)
    deleteRouteBtn.text = deleteRouteBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    deleteRouteBtn.text:SetAllPoints()
    deleteRouteBtn.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    deleteRouteBtn.text:SetText("Delete")
    deleteRouteBtn.text:SetTextColor(1, 0.3, 0.3)  -- Red color for danger
    
    deleteRouteBtn:SetScript("OnClick", function()
        if RDT.Dialogs and RDT.Dialogs.ShowDeleteRoute then
            RDT.Dialogs:ShowDeleteRoute()
        end
    end)
    
    -- Update button widths when container resizes
    local function UpdateRouteButtonWidths()
        local width = container:GetWidth()
        local btnWidth = (width - totalSpacing) / 3
        newRouteBtn:SetWidth(btnWidth)
        renameRouteBtn:SetWidth(btnWidth)
        deleteRouteBtn:SetWidth(btnWidth)
    end
    
    container:HookScript("OnSizeChanged", UpdateRouteButtonWidths)
    
    return newRouteBtn  -- Return first button for anchoring next row
end

--- Populate the route dropdown with current routes
function UI:PopulateRouteDropdown()
    if not routeDropdown or not RDT.RouteManager then return end
    
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName then return end
    
    local routes = RDT.RouteManager:GetRouteNames(dungeonName)
    local currentRouteName = RDT.RouteManager:GetCurrentRouteName(dungeonName)
    
    local items = {}
    for _, routeName in ipairs(routes) do
        table.insert(items, {
            value = routeName,
            text = routeName,
            isSelected = (routeName == currentRouteName)
        })
    end
    
    routeDropdown:SetItems(items)
end

--- Update the route dropdown text to show current route
function UI:UpdateRouteDropdown()
    if not routeDropdown or not RDT.RouteManager then return end
    
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName then return end
    
    local currentRouteName = RDT.RouteManager:GetCurrentRouteName(dungeonName)
    if currentRouteName then
        routeDropdown:SetText(currentRouteName)
    end
end

--- Refresh all UI elements after route change
function UI:RefreshUI()
    -- Reload current dungeon to refresh all packs/pulls
    if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.LoadDungeon then
        RDT:LoadDungeon(RDT.db.profile.currentDungeon)
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

    -- Map texture (legacy single texture - will be hidden when tiles are active)
    mapTexture = mapContainer:CreateTexture(nil, "ARTWORK")
    mapTexture:SetPoint("TOPLEFT", 1, -1)
    mapTexture:SetPoint("TOPRIGHT", -1, -1)
    mapTexture:SetHeight(MAP_HEIGHT - 2)
    mapTexture:SetTexture("Interface\\WorldMap\\UI-WorldMap-Background")
    mapTexture:SetVertexColor(0.9, 0.9, 0.9)
    mapTexture:SetTexCoord(0, 1, 0, 0.67)
    
    -- Store reference for pack buttons to anchor to
    UI.mapContainer = mapContainer
    UI.mapTexture = mapTexture
end

--------------------------------------------------------------------------------
-- Tile-based Map Rendering (for high-res and multi-floor maps)
--------------------------------------------------------------------------------

--- Clear all map tiles
function UI:ClearMapTiles()
    for _, tile in pairs(mapTiles) do
        tile:Hide()
        tile:SetTexture(nil)
    end
end

--- Load and display a tiled map
-- @param tileData table Table with tile information (tileWidth, tileHeight, cols, rows, tiles)
function UI:LoadTiledMap(tileData)
    if not mapContainer then return end
    
    -- Hide legacy single texture
    if mapTexture then
        mapTexture:Hide()
    end
    
    -- Clear existing tiles
    self:ClearMapTiles()
    
    local tiles = tileData.tiles
    if not tiles then
        RDT:PrintError("No tiles found in tile data")
        return
    end
    
    -- Get tile configuration
    local tileWidth = tileData.tileWidth or 1024
    local tileHeight = tileData.tileHeight or 1024
    local cols = tileData.cols or 2
    local rows = tileData.rows or 2
    
    -- Calculate display size for each tile
    local displayTileWidth = MAP_WIDTH / cols
    local displayTileHeight = MAP_HEIGHT / rows
    
    -- Create and position tiles
    for i, tileInfo in ipairs(tiles) do
        local tile = mapTiles[i]
        if not tile then
            tile = mapContainer:CreateTexture(nil, "ARTWORK")
            mapTiles[i] = tile
        end
        
        -- Calculate grid position (0-indexed)
        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        
        -- Position tile
        local x = col * displayTileWidth + 1
        local y = -(row * displayTileHeight) - 1
        
        tile:SetSize(displayTileWidth, displayTileHeight)
        tile:ClearAllPoints()
        tile:SetPoint("TOPLEFT", mapContainer, "TOPLEFT", x, y)
        
        -- Set texture
        local texturePath = tileInfo.texture or tileInfo
        tile:SetTexture(texturePath)
        tile:SetVertexColor(0.9, 0.9, 0.9)
        
        -- Apply texture coordinates if specified
        if tileInfo.texCoord then
            tile:SetTexCoord(unpack(tileInfo.texCoord))
        else
            tile:SetTexCoord(0, 1, 0, 1)
        end
        
        tile:Show()
    end
    
    RDT:DebugPrint(string.format("Loaded %d tiles", #tiles))
end

--- Load a single texture map (legacy mode)
-- @param texturePath string Path to texture
function UI:LoadSingleTextureMap(texturePath)
    if not mapTexture then
        RDT:PrintError("LoadSingleTextureMap: mapTexture is nil!")
        return
    end
    
    if not mapContainer then
        RDT:PrintError("LoadSingleTextureMap: mapContainer is nil!")
        return
    end
    
    RDT:Print("Loading single texture map: " .. tostring(texturePath))
    
    -- Hide all tiles
    self:ClearMapTiles()
    
    -- Clear all points and reanchor (in case it got disconnected)
    mapTexture:ClearAllPoints()
    mapTexture:SetPoint("TOPLEFT", mapContainer, "TOPLEFT", 1, -1)
    mapTexture:SetPoint("TOPRIGHT", mapContainer, "TOPRIGHT", -1, -1)
    mapTexture:SetHeight(MAP_HEIGHT - 2)
    
    -- Show and set legacy texture
    mapTexture:Show()
    mapTexture:SetTexture(texturePath or "Interface\\WorldMap\\UI-WorldMap-Background")
    mapTexture:SetVertexColor(0.9, 0.9, 0.9)
    mapTexture:SetTexCoord(0, 1, 0, 0.67)
    
    RDT:Print("Map texture loaded, shown, size: " .. mapTexture:GetWidth() .. "x" .. mapTexture:GetHeight())
end


--- Update the map for a dungeon (handles both tiled and single-texture maps)
-- @param dungeonName string Name of the dungeon
function UI:UpdateMapForDungeon(dungeonName)
    if not RDT.Data or not dungeonName then
        RDT:PrintError("UpdateMapForDungeon: Invalid parameters")
        return
    end
    
    -- Use the proper Data module method to get dungeon data
    local dungeonData = RDT.Data:GetDungeon(dungeonName)
    if not dungeonData then
        RDT:PrintError("Dungeon data not found: " .. dungeonName)
        return
    end
    
    RDT:Print("UpdateMapForDungeon: " .. dungeonName)
    
    -- Check if this dungeon uses tiles
    if dungeonData.tiles then
        RDT:Print("Using tiled map")
        -- Load tiled map
        self:LoadTiledMap(dungeonData.tiles)
    elseif dungeonData.texture then
        RDT:Print("Using single texture: " .. dungeonData.texture)
        -- Load single texture (legacy mode)
        self:LoadSingleTextureMap(dungeonData.texture)
    else
        RDT:PrintError("No map data found for: " .. dungeonName)
    end
end

--- Update the map texture (legacy method, kept for compatibility)
-- @param texturePath string Path to texture file
function UI:UpdateMapTexture(texturePath)
    self:LoadSingleTextureMap(texturePath)
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
    -- No backdrop - buttons will be visible directly

    -- Create route dropdown and buttons at the top (returns first route button for anchoring)
    local firstRouteBtn = UI:CreateRouteDropdown(buttonContainer)
    
    -- Row 2: New Pull and Reset All (on same line, split 50/50)
    local spacing = 3
    
    -- New Pull button (left side)
    local newPullButton = CreateFrame("Button", "RDT_NewPullButton", buttonContainer)
    newPullButton:SetPoint("TOPLEFT", firstRouteBtn, "BOTTOMLEFT", 0, -5)
    newPullButton:SetHeight(26)
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

    -- Reset All button (right side)
    local resetButton = CreateFrame("Button", "RDT_ResetButton", buttonContainer)
    resetButton:SetPoint("LEFT", newPullButton, "RIGHT", spacing, 0)
    resetButton:SetHeight(26)
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

    -- Row 3: Export and Import (on same line, split 50/50)
    -- Export button (left side)
    local exportButton = CreateFrame("Button", "RDT_ExportButton", buttonContainer)
    exportButton:SetPoint("TOPLEFT", newPullButton, "BOTTOMLEFT", 0, -5)
    exportButton:SetHeight(24)
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

    -- Import button (right side)
    local importButton = CreateFrame("Button", "RDT_ImportButton", buttonContainer)
    importButton:SetPoint("LEFT", exportButton, "RIGHT", spacing, 0)
    importButton:SetHeight(24)
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
    
    -- Calculate initial widths
    local containerWidth = buttonContainer:GetWidth() or 290
    local halfWidth = (containerWidth - spacing) / 2
    
    -- Set initial widths for all buttons
    newPullButton:SetWidth(halfWidth)
    resetButton:SetWidth(halfWidth)
    exportButton:SetWidth(halfWidth)
    importButton:SetWidth(halfWidth)
    
    -- Update widths dynamically when container resizes
    local function UpdatePullExportButtonWidths()
        local width = buttonContainer:GetWidth()
        local btnHalfWidth = (width - spacing) / 2
        
        -- Row 2: New Pull and Reset All
        newPullButton:SetWidth(btnHalfWidth)
        resetButton:SetWidth(btnHalfWidth)
        
        -- Row 3: Export and Import
        exportButton:SetWidth(btnHalfWidth)
        importButton:SetWidth(btnHalfWidth)
    end
    
    buttonContainer:HookScript("OnSizeChanged", UpdatePullExportButtonWidths)
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