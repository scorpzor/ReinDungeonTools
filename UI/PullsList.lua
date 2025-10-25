-- UI/PullsList.lua
-- Pull list panel display and management with efficient rendering

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- Local references
local pullsPanel
local pullsScrollFrame
local pullsScrollChild
local totalForcesLabel
local fontStringPool
local pullButtons = {} -- Store pull entry buttons

-- Constants
local PULLS_PANEL_WIDTH = 250
local PULLS_PANEL_HEIGHT = 600

--------------------------------------------------------------------------------
-- FontString Pool for Efficient Rendering
--------------------------------------------------------------------------------

--- Create a pool of reusable FontStrings
-- @param parent Frame Parent frame for the FontStrings
-- @return table Pool object with Acquire/Release methods
local function CreateFontStringPool(parent)
    local pool = {
        strings = {},           -- Available FontStrings
        activeStrings = {},     -- Currently in-use FontStrings
        parent = parent,
        layer = "OVERLAY",
        fontObject = "GameFontHighlightSmall",
    }
    
    function pool:Acquire()
        local fs = tremove(self.strings)
        if not fs then
            fs = self.parent:CreateFontString(nil, self.layer, self.fontObject)
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

--------------------------------------------------------------------------------
-- Panel Initialization
--------------------------------------------------------------------------------

--- Initialize the pulls list panel (called from MainFrame.lua)
-- @param panel Frame The pulls panel container
function UI:InitializePullsList(panel)
    pullsPanel = panel

    -- Total forces progress bar (at top)
    local progressBarFrame = CreateFrame("Frame", "RDT_ForcesProgressBar", pullsPanel)
    progressBarFrame:SetPoint("TOP", 0, -8)
    progressBarFrame:SetSize(240, 24)
    
    -- Background
    progressBarFrame.bg = progressBarFrame:CreateTexture(nil, "BACKGROUND")
    progressBarFrame.bg:SetAllPoints()
    progressBarFrame.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    
    -- Border
    progressBarFrame.border = progressBarFrame:CreateTexture(nil, "BORDER")
    progressBarFrame.border:SetAllPoints()
    progressBarFrame.border:SetColorTexture(0.3, 0.3, 0.3, 1)
    progressBarFrame.bg:SetPoint("TOPLEFT", 1, -1)
    progressBarFrame.bg:SetPoint("BOTTOMRIGHT", -1, 1)
    
    -- Progress fill bar (starts at 0 width)
    progressBarFrame.fill = progressBarFrame:CreateTexture(nil, "ARTWORK")
    progressBarFrame.fill:SetPoint("LEFT", 1, 0)
    progressBarFrame.fill:SetHeight(22)
    progressBarFrame.fill:SetWidth(0)
    progressBarFrame.fill:SetColorTexture(0.3, 1.0, 0.3, 0.6)
    
    -- Text overlay
    progressBarFrame.text = progressBarFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    progressBarFrame.text:SetPoint("CENTER")
    progressBarFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    progressBarFrame.text:SetText("0/100 (0.0%)")
    progressBarFrame.text:SetTextColor(1.0, 1.0, 1.0)
    
    -- Store reference for compatibility
    totalForcesLabel = progressBarFrame
    
    -- Initialize the bar to 0
    progressBarFrame.fill:SetWidth(0)
    progressBarFrame.fill:SetColorTexture(1.0, 0.3, 0.3, 0.7)

    -- ScrollFrame for pulls list
    pullsScrollFrame = CreateFrame("ScrollFrame", "RDT_PullsScroll", pullsPanel, "UIPanelScrollFrameTemplate")
    pullsScrollFrame:SetPoint("TOPLEFT", 2, -40)
    pullsScrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)

    pullsScrollChild = CreateFrame("Frame", "RDT_PullsScrollChild", pullsScrollFrame)
    -- Use width of scroll frame viewport
    local scrollWidth = pullsScrollFrame:GetWidth() or (PULLS_PANEL_WIDTH - 28)
    pullsScrollChild:SetSize(scrollWidth, 1)
    pullsScrollFrame:SetScrollChild(pullsScrollChild)
    
    -- Style the scrollbar (use UI.StyleScrollBar from MainFrame)
    if RDT.UI and RDT.UI.StyleScrollBar then
        RDT.UI:StyleScrollBar(pullsScrollFrame)
    end

    -- Initialize FontString pool
    fontStringPool = CreateFontStringPool(pullsScrollChild)
    
    RDT:DebugPrint("Pulls list panel initialized")
end

--------------------------------------------------------------------------------
-- Pull List Rendering
--------------------------------------------------------------------------------

--- Update the entire pull list display
function UI:UpdatePullList()
    if not RDT.State.currentRoute or not pullsScrollChild or not fontStringPool then 
        return 
    end
    
    RDT:DebugPrint("Updating pull list")
    
    -- Release all FontStrings back to pool
    fontStringPool:ReleaseAll()
    
    -- Hide all pull buttons
    for _, btn in pairs(pullButtons) do
        btn:Hide()
    end
    
    pullsScrollChild:SetHeight(1)
    local yOffset = -5
    
    -- Check if route manager is available
    if not RDT.RouteManager then
        self:ShowEmptyMessage()
        return
    end
    
    -- Get all pulls in use
    local pulls = RDT.RouteManager:GetUsedPulls(RDT.State.currentRoute.pulls)
    
    -- Always include the current pull if it's not already in the list
    local currentPullExists = false
    for _, pullNum in ipairs(pulls) do
        if pullNum == RDT.State.currentPull then
            currentPullExists = true
            break
        end
    end
    
    if not currentPullExists and RDT.State.currentPull then
        tinsert(pulls, RDT.State.currentPull)
        table.sort(pulls)
    end
    
    if #pulls == 0 then
        self:ShowEmptyMessage()
        self:UpdateTotalForces()
        return
    end
    
    -- Build pull entries
    for _, pullNum in ipairs(pulls) do
        yOffset = self:RenderPullEntry(pullNum, yOffset)
    end
    
    -- Set scroll child height
    pullsScrollChild:SetHeight(math.max(math.abs(yOffset) + 10, PULLS_PANEL_HEIGHT - 50))
    
    -- Update total forces display
    self:UpdateTotalForces()
end

--- Render a single pull entry
-- @param pullNum number Pull number to render
-- @param yOffset number Current Y offset for positioning
-- @return number New Y offset after rendering
function UI:RenderPullEntry(pullNum, yOffset)
    -- Get packs in this pull
    local packs = RDT.RouteManager:GetPacksInPull(pullNum)
    
    -- Show empty pulls if it's the current pull (for better UX)
    local isCurrentPull = (pullNum == RDT.State.currentPull)
    if #packs == 0 and not isCurrentPull then
        return yOffset
    end
    
    -- Calculate total forces for this pull
    local totalCount = 0
    local packDetails = {}
    
    for _, packId in ipairs(packs) do
        local button = RDT.State.packButtons["pack" .. packId]
        if button and button.count then
            totalCount = totalCount + button.count
            tinsert(packDetails, {
                id = packId,
                count = button.count
            })
        end
    end
    
    -- Sort by pack ID
    table.sort(packDetails, function(a, b) return a.id < b.id end)
    
    local startYOffset = yOffset
    local entryHeight = 34  -- Fixed height for each pull entry
    
    -- Get pull color
    local r, g, b = unpack(RDT:GetPullColor(pullNum))
    if isCurrentPull then
        -- Brighten the text color for selected pull
        r, g, b = math.min(1, r * 1.3), math.min(1, g * 1.3), math.min(1, b * 1.3)
    end
    
    -- Create/get the button first (so we can anchor text to it)
    local pullButton = pullButtons[pullNum]
    
    if not pullButton then
        pullButton = CreateFrame("Button", "RDT_PullEntry" .. pullNum, pullsScrollChild)
        pullButtons[pullNum] = pullButton
        
        -- Create background texture for this pull
        local bgTexture = pullButton:CreateTexture(nil, "BACKGROUND")
        bgTexture:SetAllPoints(pullButton)
        bgTexture:SetColorTexture(0, 0, 0, 0)
        pullButton.bgTexture = bgTexture
        
        -- Create selection highlight border (left edge indicator)
        local highlightBorder = pullButton:CreateTexture(nil, "OVERLAY")
        highlightBorder:SetPoint("TOPLEFT", pullButton, "TOPLEFT", 0, 0)
        highlightBorder:SetPoint("BOTTOMLEFT", pullButton, "BOTTOMLEFT", 0, 0)
        highlightBorder:SetWidth(4)
        highlightBorder:SetColorTexture(1, 1, 1, 0)  -- Start hidden
        pullButton.highlightBorder = highlightBorder
        
        -- Set up hover handlers with tooltip
        pullButton:SetScript("OnEnter", function(self)
            if UI.HighlightPull then
                UI:HighlightPull(self.pullNum, true)
            end
            
            -- Show tooltip
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Pull #" .. self.pullNum, 1, 1, 1)
            GameTooltip:AddLine("Click to switch to this pull", 0.7, 0.7, 0.7)
            if self.pullNum == RDT.State.currentPull then
                GameTooltip:AddLine("|cFF00FF00Currently active|r", 0, 1, 0)
            end
            GameTooltip:Show()
        end)
        
        pullButton:SetScript("OnLeave", function(self)
            if UI.HighlightPull then
                UI:HighlightPull(self.pullNum, false)
            end
            GameTooltip:Hide()
        end)
        
        -- Click to switch to this pull
        pullButton:SetScript("OnClick", function(self, button)
            if button == "LeftButton" then
                RDT.State.currentPull = self.pullNum
                if RDT.UI and RDT.UI.UpdatePullIndicator then
                    RDT.UI:UpdatePullIndicator()
                end
                if RDT.UI and RDT.UI.UpdatePullList then
                    RDT.UI:UpdatePullList()
                end
                RDT:Print(string.format("Switched to pull #%d", self.pullNum))
            end
        end)
        pullButton:RegisterForClicks("LeftButtonUp")
    end
    
    -- Position and size the button (full width - anchor to both sides)
    pullButton.pullNum = pullNum
    pullButton:SetHeight(entryHeight)
    pullButton:ClearAllPoints()
    pullButton:SetPoint("TOPLEFT", pullsScrollChild, "TOPLEFT", 0, startYOffset)
    pullButton:SetPoint("TOPRIGHT", pullsScrollChild, "TOPRIGHT", 0, startYOffset)
    
    -- Update background color (faded pull color)
    if pullButton.bgTexture then
        local bgR, bgG, bgB = unpack(RDT:GetPullColor(pullNum))
        -- Fade the color significantly for background
        local fadeAlpha = isCurrentPull and 0.35 or 0.15
        pullButton.bgTexture:SetColorTexture(bgR, bgG, bgB, fadeAlpha)
    end
    
    -- Update selection highlight border
    if pullButton.highlightBorder then
        if isCurrentPull then
            local highlightR, highlightG, highlightB = unpack(RDT:GetPullColor(pullNum))
            pullButton.highlightBorder:SetColorTexture(highlightR, highlightG, highlightB, 1.0)
        else
            pullButton.highlightBorder:SetColorTexture(1, 1, 1, 0)  -- Hide
        end
    end
    
    pullButton:Show()
    
    -- Now add text elements anchored to the button
    -- Left: Pull number
    local pullLabel = fontStringPool:Acquire()
    pullLabel:SetParent(pullButton)
    pullLabel:SetPoint("LEFT", pullButton, "LEFT", 8, 0)
    pullLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    pullLabel:SetJustifyH("LEFT")
    pullLabel:SetText(string.format("|cFFFFFFFF%s %d|r", L["PULL"], pullNum))
    pullLabel:SetTextColor(r, g, b)
    
    -- Center: Pack list or "empty"
    local centerText
    if #packs == 0 then
        centerText = "|cFF888888empty|r"
    else
        local packIds = {}
        for _, pack in ipairs(packDetails) do
            tinsert(packIds, string.format("#%d", pack.id))
        end
        centerText = "(" .. table.concat(packIds, ", ") .. ")"
    end
    
    local packList = fontStringPool:Acquire()
    packList:SetParent(pullButton)
    packList:SetPoint("CENTER", pullButton, "CENTER", 0, 0)
    packList:SetWidth(120)  -- Fixed width for center section
    packList:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    packList:SetJustifyH("CENTER")
    packList:SetText(centerText)
    packList:SetTextColor(0.8, 0.8, 0.8)
    
    -- Right: Percentage (calculated based on dungeon's required count)
    local percentText
    if #packs == 0 then
        percentText = "(0%)"
    else
        -- Get required count for this dungeon
        local requiredCount = 100  -- Default
        if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.Data then
            requiredCount = RDT.Data:GetDungeonRequiredCount(RDT.db.profile.currentDungeon)
        end
        
        local percentage = (totalCount / requiredCount) * 100
        percentText = string.format("(%.1f%%)", percentage)
    end
    
    local percentLabel = fontStringPool:Acquire()
    percentLabel:SetParent(pullButton)
    percentLabel:SetPoint("RIGHT", pullButton, "RIGHT", -8, 0)
    percentLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    percentLabel:SetJustifyH("RIGHT")
    percentLabel:SetText(percentText)
    percentLabel:SetTextColor(r, g, b)
    
    -- Update yOffset for next entry
    yOffset = yOffset - entryHeight - 2  -- 1px spacing
    
    return yOffset
end

--- Show "No pulls defined" message
function UI:ShowEmptyMessage()
    pullsScrollChild:SetHeight(1)
    
    local noPullsText = fontStringPool:Acquire()
    noPullsText:SetPoint("TOP", 0, -20)
    noPullsText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
    noPullsText:SetText(L["NO_PULLS"])
    noPullsText:SetTextColor(0.5, 0.5, 0.5)
end

--------------------------------------------------------------------------------
-- Total Forces Display
--------------------------------------------------------------------------------

--- Update the total forces counter
function UI:UpdateTotalForces()
    -- Safety check: ensure progress bar is initialized
    if not totalForcesLabel or not totalForcesLabel.fill or not totalForcesLabel.text then 
        return 
    end
    
    -- Get current count
    local currentCount = 0
    if RDT.RouteManager then
        currentCount = RDT.RouteManager:CalculateTotalForces()
    end
    
    -- Get required count for this dungeon
    local requiredCount = 100  -- Default
    if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.Data then
        requiredCount = RDT.Data:GetDungeonRequiredCount(RDT.db.profile.currentDungeon)
    end
    
    -- Calculate percentage
    local percentage = (currentCount / requiredCount) * 100
    
    -- Calculate bar width (max 238 pixels to account for 1px border on each side)
    local maxBarWidth = 238
    local barWidth = math.min(maxBarWidth, (percentage / 100) * maxBarWidth)
    totalForcesLabel.fill:SetWidth(barWidth)
    
    -- Update text: "50.5/100 (50.5%)"
    totalForcesLabel.text:SetText(string.format("%.1f/%.0f (%.1f%%)", currentCount, requiredCount, percentage))
    
    -- Color the fill bar based on completion (100% is the goal)
    local r, g, b
    if percentage < 100 then
        r, g, b = 1.0, 0.3, 0.3  -- Red - under 100%
    elseif percentage >= 100 and percentage <= 105 then
        r, g, b = 0.3, 1.0, 0.3  -- Green - around 100%
    else
        r, g, b = 1.0, 0.8, 0.2  -- Yellow/Orange - over 105%
    end
    totalForcesLabel.fill:SetColorTexture(r, g, b, 0.7)
    
    -- Text color (always white with outline for readability)
    totalForcesLabel.text:SetTextColor(1.0, 1.0, 1.0)
end

--- Get current total forces value
-- @return number Total forces percentage
function UI:GetTotalForces()
    if RDT.RouteManager then
        return RDT.RouteManager:CalculateTotalForces()
    end
    return 0
end

--------------------------------------------------------------------------------
-- Text Formatting Helpers
--------------------------------------------------------------------------------

--- Wrap text to fit within character limit
-- @param text string Text to wrap
-- @param maxChars number Maximum characters per line
-- @return string Wrapped text with newlines
function UI:WrapText(text, maxChars)
    local lines = {}
    local currentLine = ""
    
    -- Split by commas (pack separators)
    for segment in text:gmatch("[^,]+") do
        segment = segment:gsub("^%s+", "") -- Trim leading space
        
        if #currentLine + #segment + 2 > maxChars then
            if currentLine ~= "" then
                tinsert(lines, currentLine)
                currentLine = segment
            else
                tinsert(lines, segment)
            end
        else
            if currentLine == "" then
                currentLine = segment
            else
                currentLine = currentLine .. ", " .. segment
            end
        end
    end
    
    if currentLine ~= "" then
        tinsert(lines, currentLine)
    end
    
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Statistics Display (Optional Enhancement)
--------------------------------------------------------------------------------

--- Show detailed statistics for current route
function UI:ShowRouteStatistics()
    if not RDT.RouteManager then return end
    
    local stats = RDT.RouteManager:GetRouteStats()
    
    -- Could create a popup or side panel with:
    -- - Total forces
    -- - Pull count
    -- - Pack count
    -- - Average forces per pull
    -- - Max/min pull forces
    -- - Unassigned packs
    
    RDT:Print("Route Statistics:")
    RDT:Print(string.format("  Total Forces: %d%%", stats.totalForces))
    RDT:Print(string.format("  Pulls: %d", stats.pullCount))
    RDT:Print(string.format("  Packs: %d", stats.packCount))
    if stats.pullCount > 0 then
        RDT:Print(string.format("  Avg per Pull: %.1f%%", stats.avgForcesPerPull))
        RDT:Print(string.format("  Max Pull: %d%%", stats.maxPullForces))
        RDT:Print(string.format("  Min Pull: %d%%", stats.minPullForces))
    end
end

--------------------------------------------------------------------------------
-- Cleanup
--------------------------------------------------------------------------------

--- Cleanup pulls list resources
function UI:CleanupPullsList()
    if fontStringPool then
        fontStringPool:ReleaseAll()
    end
    
    -- Clean up pull buttons
    for _, btn in pairs(pullButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(pullButtons)
    
    RDT:DebugPrint("Pulls list cleaned up")
end

RDT:DebugPrint("PullsList.lua loaded")
