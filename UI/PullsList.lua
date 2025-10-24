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

    -- Total forces display (at top)
    totalForcesLabel = pullsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    totalForcesLabel:SetPoint("TOP", 0, -12)
    totalForcesLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    totalForcesLabel:SetText(L["TOTAL_FORCES"] .. ": 0%")

    -- ScrollFrame for pulls list
    pullsScrollFrame = CreateFrame("ScrollFrame", "RDT_PullsScroll", pullsPanel, "UIPanelScrollFrameTemplate")
    pullsScrollFrame:SetPoint("TOPLEFT", 4, -35)
    pullsScrollFrame:SetPoint("BOTTOMRIGHT", -28, 4)

    pullsScrollChild = CreateFrame("Frame", "RDT_PullsScrollChild", pullsScrollFrame)
    pullsScrollChild:SetSize(PULLS_PANEL_WIDTH - 40, 1)
    pullsScrollFrame:SetScrollChild(pullsScrollChild)

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
    
    -- Create pull header (clickable, highlight if current)
    local header = fontStringPool:Acquire()
    header:SetPoint("TOPLEFT", 5, yOffset)
    header:SetWidth(PULLS_PANEL_WIDTH - 40)
    header:SetJustifyH("LEFT")
    header:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    
    local prefix = isCurrentPull and "> " or ""
    local headerText
    if #packs == 0 then
        -- Empty pull (current pull only)
        headerText = string.format("|cFFFFFFFF%s%s %d|r (empty)", prefix, L["PULL"], pullNum)
    else
        headerText = string.format("|cFFFFFFFF%s%s %d|r (%d%%)", prefix, L["PULL"], pullNum, totalCount)
    end
    header:SetText(headerText)
    
    -- Brighten color if this is the current pull
    local r, g, b = unpack(RDT:GetPullColor(pullNum))
    if isCurrentPull then
        r, g, b = math.min(1, r * 1.5), math.min(1, g * 1.5), math.min(1, b * 1.5)
    end
    header:SetTextColor(r, g, b)
    
    yOffset = yOffset - 18
    
    -- Create pack list (only if there are packs)
    if #packs > 0 then
        local packIds = {}
        for _, pack in ipairs(packDetails) do
            tinsert(packIds, string.format("#%d (%d%%)", pack.id, pack.count))
        end
        
        local packListText = table.concat(packIds, ", ")
        
        -- Word wrap if too long
        local maxCharsPerLine = 35
        if #packListText > maxCharsPerLine then
            packListText = self:WrapText(packListText, maxCharsPerLine)
        end
        
        local packList = fontStringPool:Acquire()
        packList:SetPoint("TOPLEFT", 15, yOffset)
        packList:SetWidth(PULLS_PANEL_WIDTH - 50)
        packList:SetJustifyH("LEFT")
        packList:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
        packList:SetText(packListText)
        packList:SetTextColor(0.8, 0.8, 0.8)
        
        -- Calculate height of text (approximate)
        local lines = select(2, packListText:gsub("\n", "\n")) + 1
        yOffset = yOffset - (lines * 12)
    else
        -- Empty pull - show "Click packs to add" message
        local emptyMsg = fontStringPool:Acquire()
        emptyMsg:SetPoint("TOPLEFT", 15, yOffset)
        emptyMsg:SetWidth(PULLS_PANEL_WIDTH - 50)
        emptyMsg:SetJustifyH("LEFT")
        emptyMsg:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
        emptyMsg:SetText("|cFF888888Click packs to add...|r")
        emptyMsg:SetTextColor(0.5, 0.5, 0.5)
        yOffset = yOffset - 12
    end
    
    -- Add spacing between pulls
    yOffset = yOffset - 8
    
    -- Create invisible button overlay for hover/click interactions
    local entryHeight = math.abs(startYOffset - yOffset)
    local pullButton = pullButtons[pullNum]
    
    if not pullButton then
        pullButton = CreateFrame("Button", "RDT_PullEntry" .. pullNum, pullsScrollChild)
        pullButtons[pullNum] = pullButton
        
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
    
    -- Position and size the button
    pullButton.pullNum = pullNum
    pullButton:SetSize(PULLS_PANEL_WIDTH - 40, entryHeight)
    pullButton:SetPoint("TOPLEFT", 5, startYOffset)
    pullButton:Show()
    
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
    if not totalForcesLabel then return end
    
    local totalForces = 0
    if RDT.RouteManager then
        totalForces = RDT.RouteManager:CalculateTotalForces()
    end
    
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
-- Pull List Interaction (Future Feature)
--------------------------------------------------------------------------------

--- Scroll to a specific pull in the list
-- @param pullNum number Pull number to scroll to
function UI:ScrollToPull(pullNum)
    -- TODO: Calculate position and scroll
    RDT:DebugPrint("ScrollToPull not yet implemented: " .. pullNum)
end

--- Highlight a pull in the list
-- @param pullNum number Pull number to highlight
-- @param enable boolean True to enable, false to disable
function UI:HighlightPullInList(pullNum, enable)
    -- TODO: Add visual highlight to pull entry
    -- This would require tracking FontString positions
    RDT:DebugPrint("HighlightPullInList not yet implemented: " .. pullNum)
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
