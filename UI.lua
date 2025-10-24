-- UI creation and management
local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI constants
local FRAME_WIDTH, FRAME_HEIGHT = 1000, 700
local MAP_WIDTH, MAP_HEIGHT = 700, 600
local PULLS_PANEL_WIDTH, PULLS_PANEL_HEIGHT = 250, 600

-- UI namespace
RDT.UI = {}
local UI = RDT.UI

-- Local references
local mainFrame
local mapTexture
local titleText
local pullsScrollChild
local fontStringPool
local dropdownFrame
local groupButton
local totalForcesLabel

-- FontString pool for efficient text rendering
local function CreateFontStringPool(parent)
    local pool = {
        strings = {},
        activeStrings = {},
        parent = parent,
    }
    
    function pool:Acquire()
        local fs = tremove(self.strings)
        if not fs then
            fs = self.parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            fs.pool = self
        end
        fs:Show()
        tinsert(self.activeStrings, fs)
        return fs
    end
    
    function pool:Release(fs)
        if not fs then return end
        fs:Hide()
        fs:ClearAllPoints()
        fs:SetText("")
        
        for i, f in ipairs(self.activeStrings) do
            if f == fs then
                tremove(self.activeStrings, i)
                break
            end
        end
        
        tinsert(self.strings, fs)
    end
    
    function pool:ReleaseAll()
        for i = #self.activeStrings, 1, -1 do
            self:Release(self.activeStrings[i])
        end
    end
    
    return pool
end

-- Update pack labels with pull numbers and colors
function UI:UpdateLabels()
    if not RDT.State.currentRoute then return end
    
    RDT:DebugPrint("Updating pack labels")
    
    for _, button in pairs(RDT.State.packButtons) do
        local pullNum = RDT.State.currentRoute.pulls[button.packId] or 0
        button.pullNum = pullNum
        button.label:SetText(pullNum > 0 and tostring(pullNum) or "")
        button.label:SetTextColor(unpack(RDT:GetPullColor(pullNum)))
    end
end

-- Clear current selection
function UI:ClearSelection()
    RDT:DebugPrint("Clearing selection")
    
    for _, id in ipairs(RDT.State.selectedPacks) do
        local button = RDT.State.packButtons["pack" .. id]
        if button then 
            button.highlight:Hide() 
        end
    end
    
    wipe(RDT.State.selectedPacks)
    
    if groupButton then
        groupButton:SetText(L["GROUP_PULL"])
    end
end

-- Update group button text with selection count
function UI:UpdateGroupButton()
    if not groupButton then return end
    
    if #RDT.State.selectedPacks > 0 then
        groupButton:SetText(L["GROUP_PULL"] .. " (" .. #RDT.State.selectedPacks .. ")")
    else
        groupButton:SetText(L["GROUP_PULL"])
    end
end

-- Update total forces display
function UI:UpdateTotalForces()
    if not totalForcesLabel then return end
    
    local totalForces = RDT:CalculateTotalForces()
    totalForcesLabel:SetText(string.format("%s: %d%%", L["TOTAL_FORCES"], totalForces))
    
    -- Color based on completion (100% is the goal)
    if totalForces < 100 then
        totalForcesLabel:SetTextColor(1.0, 0.3, 0.3)  -- Red - under 100%
    elseif totalForces == 100 then
        totalForcesLabel:SetTextColor(0.3, 1.0, 0.3)  -- Green - exactly 100%
    else
        totalForcesLabel:SetTextColor(1.0, 0.8, 0.2)  -- Yellow - over 100%
    end
end

-- Update the pulls list panel
function UI:UpdatePullList()
    if not RDT.State.currentRoute or not pullsScrollChild or not fontStringPool then 
        return 
    end
    
    RDT:DebugPrint("Updating pull list")
    
    -- Release all FontStrings back to pool
    fontStringPool:ReleaseAll()
    
    pullsScrollChild:SetHeight(1)
    local yOffset = -5
    local maxPull = RDT:GetNextPull(RDT.State.currentRoute.pulls) - 1
    local hasPulls = false
    
    -- Build reverse index for efficiency (pull -> packs)
    local pullToPacks = {}
    for _, button in pairs(RDT.State.packButtons) do
        local pullNum = RDT.State.currentRoute.pulls[button.packId]
        if pullNum and pullNum > 0 then
            pullToPacks[pullNum] = pullToPacks[pullNum] or {}
            tinsert(pullToPacks[pullNum], {id = button.packId, count = button.count or 0})
        end
    end
    
    -- Generate pull entries
    for pullNum = 1, maxPull do
        local packsInPull = pullToPacks[pullNum]
        
        if packsInPull and #packsInPull > 0 then
            hasPulls = true
            
            -- Sort by pack ID for consistent display
            table.sort(packsInPull, function(a, b) return a.id < b.id end)
            
            -- Calculate total count and build ID list
            local totalCount = 0
            local packIds = {}
            for _, pack in ipairs(packsInPull) do
                totalCount = totalCount + pack.count
                tinsert(packIds, tostring(pack.id))
            end
            
            -- Create pull header
            local header = fontStringPool:Acquire()
            header:SetPoint("TOPLEFT", 5, yOffset)
            header:SetWidth(PULLS_PANEL_WIDTH - 40)
            header:SetJustifyH("LEFT")
            header:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            header:SetText(string.format("|cFFFFFFFF%s %d|r (%d%%)", L["PULL"], pullNum, totalCount))
            header:SetTextColor(unpack(RDT:GetPullColor(pullNum)))
            
            yOffset = yOffset - 18
            
            -- Create pack list
            local packList = fontStringPool:Acquire()
            packList:SetPoint("TOPLEFT", 15, yOffset)
            packList:SetWidth(PULLS_PANEL_WIDTH - 50)
            packList:SetJustifyH("LEFT")
            packList:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
            packList:SetText(table.concat(packIds, ", "))
            packList:SetTextColor(0.8, 0.8, 0.8)
            
            yOffset = yOffset - 18
            
            -- Add spacing between pulls
            yOffset = yOffset - 5
        end
    end
    
    -- Show "No pulls" message if empty
    if not hasPulls then
        local noPullsText = fontStringPool:Acquire()
        noPullsText:SetPoint("TOP", 0, -50)
        noPullsText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
        noPullsText:SetText(L["NO_PULLS"])
        noPullsText:SetTextColor(0.5, 0.5, 0.5)
        yOffset = yOffset - 30
    end
    
    pullsScrollChild:SetHeight(math.max(math.abs(yOffset) + 10, PULLS_PANEL_HEIGHT - 50))
    
    -- Update total forces display
    self:UpdateTotalForces()
end

-- Create pack buttons on the map
function UI:CreatePacks(packData)
    if not packData or not mapTexture then return end
    
    RDT:DebugPrint("Creating " .. #packData .. " pack buttons")
    
    for _, data in ipairs(packData) do
        -- Validate coordinates
        if not data.x or data.x < 0 or data.x > 1 or not data.y or data.y < 0 or data.y > 1 then
            RDT:PrintError(string.format(L["ERROR_INVALID_COORDS"], data.id or 0))
            return
        end
        
        local button = CreateFrame("Button", "RDTPack" .. data.id, mainFrame)
        button:SetSize(28, 28)
        button:SetPoint("CENTER", mapTexture, "BOTTOMLEFT", data.x * MAP_WIDTH, data.y * MAP_HEIGHT)
        button.packId = data.id
        button.count = data.count or 0

        -- Background circle
        local bg = button:CreateTexture(nil, "BACKGROUND")
        bg:SetSize(28, 28)
        bg:SetPoint("CENTER")
        bg:SetTexture("Interface\\AddOns\\ReinDungeonTools\\Textures\\PackCircle")
        bg:SetVertexColor(0.2, 0.2, 0.2, 0.8)
        button.bg = bg

        -- Icon
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetSize(20, 20)
        icon:SetPoint("CENTER")
        icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_7")
        button.icon = icon

        -- Highlight
        local highlight = button:CreateTexture(nil, "OVERLAY")
        highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
        highlight:SetBlendMode("ADD")
        highlight:SetSize(32, 32)
        highlight:SetPoint("CENTER")
        highlight:Hide()
        button.highlight = highlight

        -- Label (pull number)
        local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("CENTER", 0, 0)
        label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        label:SetTextColor(1, 1, 1)
        button.label = label

        -- Pack ID label (small, bottom)
        local idLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        idLabel:SetPoint("TOP", button, "BOTTOM", 0, 2)
        idLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        idLabel:SetText(tostring(data.id))
        idLabel:SetTextColor(0.7, 0.7, 0.7)
        button.idLabel = idLabel

        -- Click handler
        button:SetScript("OnClick", function(self, mouseButton)
            local id = self.packId
            
            if mouseButton == "RightButton" then
                -- Right-click: Remove from pull
                if RDT.State.currentRoute.pulls[id] then
                    RDT.State.currentRoute.pulls[id] = nil
                    UI:UpdateLabels()
                    UI:UpdatePullList()
                    RDT:Print("Pack " .. id .. " removed from pull")
                end
            else
                -- Left-click: Toggle selection
                local idx
                for i, v in ipairs(RDT.State.selectedPacks) do
                    if v == id then idx = i break end
                end
                
                if idx then
                    tremove(RDT.State.selectedPacks, idx)
                    self.highlight:Hide()
                else
                    tinsert(RDT.State.selectedPacks, id)
                    self.highlight:Show()
                end
                UI:UpdateGroupButton()
            end
        end)

        -- Register for right-click
        button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        -- Tooltip
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText(L["PACK"] .. " " .. self.packId, 1, 1, 1, 1, true)
            GameTooltip:AddLine(L["ENEMY_FORCES"] .. ": " .. self.count .. "%", 1, 1, 1)
            
            -- Show current pull assignment if any
            local pullNum = RDT.State.currentRoute.pulls[self.packId]
            if pullNum then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("Assigned to " .. L["PULL"] .. " " .. pullNum, unpack(RDT:GetPullColor(pullNum)))
            end
            
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L["TOOLTIP_CLICK_SELECT"], 0.5, 0.5, 0.5)
            GameTooltip:AddLine(L["TOOLTIP_RIGHT_CLICK"], 0.5, 0.5, 0.5)
            GameTooltip:Show()
        end)
        
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        RDT.State.packButtons["pack" .. data.id] = button
    end
    
    self:UpdateLabels()
end

-- Update map texture
function UI:UpdateMapTexture(texturePath)
    if not mapTexture then return end
    
    RDT:DebugPrint("Updating map texture: " .. tostring(texturePath))
    
    mapTexture:SetTexture(texturePath or "Interface\\WorldMap\\UI-WorldMap-Background")
    mapTexture:SetVertexColor(0.9, 0.9, 0.9)
end

-- Update title text
function UI:UpdateTitle(dungeonName)
    if not titleText then return end
    
    titleText:SetText(L["TITLE"])
    
    if dungeonName then
        titleText:SetText(L["TITLE"] .. "\n|cFFFFAA00" .. dungeonName .. "|r")
    end
end

-- Clear all pack buttons
function UI:ClearPacks()
    RDT:DebugPrint("Clearing pack buttons")
    
    for name, button in pairs(RDT.State.packButtons) do
        if button then
            button:Hide()
            button:SetParent(nil)
        end
    end
    
    wipe(RDT.State.packButtons)
end

-- Hide main frame
function UI:Hide()
    if mainFrame then
        mainFrame:Hide()
    end
end

-- Create main UI
function RDT_CreateUI()
    RDT:DebugPrint("Creating main UI")
    
    -- Main frame
    mainFrame = CreateFrame("Frame", "RDT_Frame", UIParent)
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

    -- Title
    titleText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOP", 0, -18)
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    titleText:SetText(L["TITLE"])

    -- Version text
    local versionText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versionText:SetPoint("TOP", titleText, "BOTTOM", 0, -3)
    versionText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    versionText:SetText("v" .. RDT.Version)
    versionText:SetTextColor(0.5, 0.5, 0.5)

    -- Close button
    local closeButton = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -8, -8)
    closeButton:SetScript("OnClick", function() mainFrame:Hide() end)

    -- Dungeon dropdown
    dropdownFrame = CreateFrame("Frame", "RDTDungeonDropdown", mainFrame, "UIDropDownMenuTemplate")
    dropdownFrame:SetPoint("TOPLEFT", 8, -50)
    UIDropDownMenu_SetWidth(dropdownFrame, 220)
    UIDropDownMenu_SetText(dropdownFrame, RDT.db.profile.currentDungeon)

    UIDropDownMenu_Initialize(dropdownFrame, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        local dungeonNames = RDT.Data:GetDungeonNames()
        
        for _, name in ipairs(dungeonNames) do
            info.text = name
            info.func = function()
                if RDT:LoadDungeon(name) then
                    UIDropDownMenu_SetText(dropdownFrame, name)
                end
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    -- Map container frame
    local mapContainer = CreateFrame("Frame", nil, mainFrame)
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

    -- Pulls panel (right side)
    local pullsPanel = CreateFrame("Frame", "RDTPullsPanel", mainFrame)
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

    -- Pulls panel title
    local pullsTitle = pullsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    pullsTitle:SetPoint("TOP", 0, -10)
    pullsTitle:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    pullsTitle:SetText(L["CURRENT_PULLS"])

    -- Total forces display
    totalForcesLabel = pullsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    totalForcesLabel:SetPoint("TOP", pullsTitle, "BOTTOM", 0, -5)
    totalForcesLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    totalForcesLabel:SetText(L["TOTAL_FORCES"] .. ": 0%")

    -- ScrollFrame for pulls list
    local scrollFrame = CreateFrame("ScrollFrame", "RDTPullsScroll", pullsPanel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -50)
    scrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)

    pullsScrollChild = CreateFrame("Frame", "RDTPullsChild", scrollFrame)
    pullsScrollChild:SetSize(PULLS_PANEL_WIDTH - 40, 1)
    scrollFrame:SetScrollChild(pullsScrollChild)

    -- Initialize FontString pool
    fontStringPool = CreateFontStringPool(pullsScrollChild)

    -- Button container at bottom
    local buttonContainer = CreateFrame("Frame", nil, mainFrame)
    buttonContainer:SetPoint("BOTTOMLEFT", 20, 15)
    buttonContainer:SetPoint("BOTTOMRIGHT", -20, 15)
    buttonContainer:SetHeight(35)

    -- Group button (center)
    groupButton = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    groupButton:SetPoint("CENTER", 0, 0)
    groupButton:SetSize(140, 30)
    groupButton:SetText(L["GROUP_PULL"])
    groupButton:SetScript("OnClick", function()
        RDT:GroupPull()
    end)

    -- Clear selection button (left)
    local clearSelButton = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    clearSelButton:SetPoint("RIGHT", groupButton, "LEFT", -5, 0)
    clearSelButton:SetSize(120, 30)
    clearSelButton:SetText(L["CLEAR_SEL"])
    clearSelButton:SetScript("OnClick", function()
        UI:ClearSelection()
        UI:UpdatePullList()
    end)

    -- Reset button (right)
    local resetButton = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    resetButton:SetPoint("LEFT", groupButton, "RIGHT", 5, 0)
    resetButton:SetSize(120, 30)
    resetButton:SetText(L["RESET_ALL"])
    resetButton:SetScript("OnClick", function()
        RDT:ResetPulls()
    end)

    -- Export button
    local exportButton = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    exportButton:SetPoint("BOTTOM", buttonContainer, "TOP", -65, 5)
    exportButton:SetSize(120, 25)
    exportButton:SetText("Export")
    exportButton:SetScript("OnClick", function()
        local exportString = RDT:ExportRoute()
        if exportString then
            if not RDT.ExportFrame then
                RDT:CreateExportFrame()
            end
            RDT.ExportFrame.editBox:SetText(exportString)
            RDT.ExportFrame.editBox:HighlightText()
            RDT.ExportFrame:Show()
        end
    end)

    -- Import button
    local importButton = CreateFrame("Button", nil, buttonContainer, "UIPanelButtonTemplate")
    importButton:SetPoint("BOTTOM", buttonContainer, "TOP", 65, 5)
    importButton:SetSize(120, 25)
    importButton:SetText("Import")
    importButton:SetScript("OnClick", function()
        if not RDT.ImportFrame then
            RDT:CreateImportFrame()
        end
        RDT.ImportFrame:Show()
    end)

    -- Help text at bottom
    local helpText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    helpText:SetPoint("BOTTOM", 0, 52)
    helpText:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    helpText:SetText("Left-Click: Select | Right-Click: Remove | Type /rdt help for commands")
    helpText:SetTextColor(0.6, 0.6, 0.6)

    RDT:DebugPrint("UI created successfully")
end

-- Create Export Frame
function RDT:CreateExportFrame()
    local frame = CreateFrame("Frame", "RDT_ExportFrame", UIParent)
    frame:SetSize(500, 200)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()
    
    -- Backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Export Route")
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)
    
    -- Instructions
    local instructions = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    instructions:SetPoint("TOP", 0, -40)
    instructions:SetText("Copy this string and share it:")
    
    -- Scroll frame for the export string
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOP", instructions, "BOTTOM", 0, -10)
    scrollFrame:SetSize(460, 80)
    
    -- Edit box
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetSize(460, 200)
    editBox:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    editBox:SetAutoFocus(false)
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    scrollFrame:SetScrollChild(editBox)
    frame.editBox = editBox
    
    -- Copy button
    local copyButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    copyButton:SetSize(100, 25)
    copyButton:SetPoint("BOTTOM", 0, 40)
    copyButton:SetText("Select All")
    copyButton:SetScript("OnClick", function()
        editBox:HighlightText()
        editBox:SetFocus()
    end)
    
    -- Close button (bottom)
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    closeButton:SetSize(100, 25)
    closeButton:SetPoint("BOTTOM", 0, 10)
    closeButton:SetText("Close")
    closeButton:SetScript("OnClick", function() frame:Hide() end)
    
    self.ExportFrame = frame
end

-- Create Import Frame
function RDT:CreateImportFrame()
    local frame = CreateFrame("Frame", "RDT_ImportFrame", UIParent)
    frame:SetSize(500, 250)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()
    
    -- Backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Import Route")
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)
    
    -- Instructions
    local instructions = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    instructions:SetPoint("TOP", 0, -40)
    instructions:SetText("Paste the import string below:")
    
    -- Scroll frame for the import string
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOP", instructions, "BOTTOM", 0, -10)
    scrollFrame:SetSize(460, 100)
    
    -- Edit box
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetSize(460, 200)
    editBox:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    editBox:SetAutoFocus(true)
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    scrollFrame:SetScrollChild(editBox)
    frame.editBox = editBox
    
    -- Warning text
    local warning = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    warning:SetPoint("TOP", scrollFrame, "BOTTOM", 0, -10)
    warning:SetText("|cFFFFFF00Warning:|r This will overwrite your current route!")
    warning:SetTextColor(1, 0.8, 0)
    
    -- Import button
    local importButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    importButton:SetSize(100, 25)
    importButton:SetPoint("BOTTOM", 50, 10)
    importButton:SetText("Import")
    importButton:SetScript("OnClick", function()
        local importString = editBox:GetText()
        if RDT:ImportRoute(importString) then
            frame:Hide()
            editBox:SetText("")
        end
    end)
    
    -- Cancel button
    local cancelButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    cancelButton:SetSize(100, 25)
    cancelButton:SetPoint("BOTTOM", -50, 10)
    cancelButton:SetText("Cancel")
    cancelButton:SetScript("OnClick", function() 
        frame:Hide()
        editBox:SetText("")
    end)
    
    self.ImportFrame = frame
end