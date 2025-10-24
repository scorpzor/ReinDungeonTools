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
local pullsTitleText
local totalForcesLabel
local fontStringPool

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
    
    -- Pulls panel title
    pullsTitleText = pullsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    pullsTitleText:SetPoint("TOP", 0, -10)
    pullsTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    pullsTitleText:SetText(L["CURRENT_PULLS"])

    -- Total forces display
    totalForcesLabel = pullsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    totalForcesLabel:SetPoint("TOP", pullsTitleText, "BOTTOM", 0, -5)
    totalForcesLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    totalForcesLabel:SetText(L["TOTAL_FORCES"] .. ": 0%")

    -- ScrollFrame for pulls list
    pullsScrollFrame = CreateFrame("ScrollFrame", "RDT_PullsScroll", pullsPanel, "UIPanelScrollFrameTemplate")
    pullsScrollFrame:SetPoint("TOPLEFT", 8, -50)
    pullsScrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)

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
    
    pullsScrollChild:SetHeight(1)
    local yOffset = -5
    
    -- Check if route manager is available
    if not RDT.RouteManager then
        self:ShowEmptyMessage()
        return
    end
    
    -- Get all pulls in use
    local pulls = RDT.RouteManager:GetUsedPulls(RDT.State.currentRoute.pulls)
    
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
    
    if #packs == 0 then
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
    
    -- Create pull header (clickable)
    local header = fontStringPool:Acquire()
    header:SetPoint("TOPLEFT", 5, yOffset)
    header:SetWidth(PULLS_PANEL_WIDTH - 40)
    header:SetJustifyH("LEFT")
    header:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    
    local headerText = string.format("|cFFFFFFFF%s %d|r (%d%%)", L["PULL"], pullNum, totalCount)
    header:SetText(headerText)
    header:SetTextColor(unpack(RDT:GetPullColor(pullNum)))
    
    -- Make header interactive (future: click to select pull)
    -- This would require converting FontString to Button, TBD
    
    yOffset = yOffset - 18
    
    -- Create pack list (multiple lines if needed)
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
    
    -- Add spacing between pulls
    yOffset = yOffset - 8
    
    return yOffset
end

--- Show "No pulls defined" message
function UI:ShowEmptyMessage()
    pullsScrollChild:SetHeight(1)
    
    local noPullsText = fontStringPool:Acquire()
    noPullsText:SetPoint("TOP", 0, -50)
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
    
    RDT:DebugPrint("Pulls list cleaned up")
end

RDT:DebugPrint("PullsList.lua loaded")
