-- Modules/UI/PullsList.lua
-- Pull list sidebar panel with efficient rendering

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

RDT.UI = RDT.UI or {}
local UI = RDT.UI

local UIHelpers = RDT.UIHelpers

local pullsPanel
local pullsScrollFrame
local pullsScrollChild
local totalForcesLabel

local PULLS_PANEL_WIDTH = 250
local PULLS_PANEL_HEIGHT = 600

local pullEntryPool = {}
local activePullEntries = {}

--- Get a pull entry frame from the pool or create a new one
-- @param parent Frame Parent frame
-- @return Frame The pull entry frame
function UI:GetPullEntry(parent)
    local entry = table.remove(pullEntryPool)
    
    if not entry then
        entry = CreateFrame("Button", nil, parent)
        entry:SetHeight(34)
        
        local bgTexture = entry:CreateTexture(nil, "BACKGROUND")
        bgTexture:SetAllPoints(entry)
        bgTexture:SetColorTexture(0, 0, 0, 0)
        entry.bgTexture = bgTexture

        local leftGradient = entry:CreateTexture(nil, "BORDER")
        leftGradient:SetPoint("TOPLEFT", entry, "TOPLEFT", 0, 0)
        leftGradient:SetPoint("BOTTOMLEFT", entry, "BOTTOMLEFT", 0, 0)
        leftGradient:SetWidth(20)
        leftGradient:SetTexture("Interface\\Buttons\\WHITE8X8")
        leftGradient:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 0)
        entry.leftGradient = leftGradient

        local rightGradient = entry:CreateTexture(nil, "BORDER")
        rightGradient:SetPoint("TOPRIGHT", entry, "TOPRIGHT", 0, 0)
        rightGradient:SetPoint("BOTTOMRIGHT", entry, "BOTTOMRIGHT", 0, 0)
        rightGradient:SetWidth(20)
        rightGradient:SetTexture("Interface\\Buttons\\WHITE8X8")
        rightGradient:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, 0.5)
        entry.rightGradient = rightGradient

        local selectionOverlay = entry:CreateTexture(nil, "OVERLAY")
        selectionOverlay:SetAllPoints(entry)
        selectionOverlay:SetTexture("Interface\\Buttons\\WHITE8X8")
        selectionOverlay:SetBlendMode("ADD")
        selectionOverlay:SetAlpha(0)
        entry.selectionOverlay = selectionOverlay

        local pullLabel = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        pullLabel:SetPoint("LEFT", entry, "LEFT", 8, 0)
        pullLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        pullLabel:SetJustifyH("LEFT")
        entry.pullLabel = pullLabel

        local packList = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        packList:SetPoint("CENTER", entry, "CENTER", 0, 0)
        packList:SetWidth(120)
        packList:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
        packList:SetJustifyH("CENTER")
        entry.packList = packList
        
        local percentLabel = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        percentLabel:SetPoint("RIGHT", entry, "RIGHT", -8, 0)
        percentLabel:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        percentLabel:SetJustifyH("RIGHT")
        entry.percentLabel = percentLabel

        entry:SetScript("OnEnter", function(self)
            if UI.HighlightPull then
                UI:HighlightPull(self.pullNum, true)
            end
        end)
        
        entry:SetScript("OnLeave", function(self)
            if UI.HighlightPull then
                UI:HighlightPull(self.pullNum, false)
            end
        end)
        
        entry:SetScript("OnClick", function(self, button)
            if button == "LeftButton" then
                RDT.State.currentPull = self.pullNum
                if RDT.UI and RDT.UI.UpdatePullList then
                    RDT.UI:UpdatePullList()
                end
                if RDT.UI and RDT.UI.UpdateLabels then
                    RDT.UI:UpdateLabels()
                end
                RDT:Print(string.format("Switched to pull #%d", self.pullNum))
            end
        end)
        entry:RegisterForClicks("LeftButtonUp")
    end
    
    entry:SetParent(parent)
    entry:Show()
    tinsert(activePullEntries, entry)
    
    return entry
end

--- Release all active pull entries back to the pool
function UI:ReleasePullEntries()
    for _, entry in ipairs(activePullEntries) do
        entry:Hide()
        entry:ClearAllPoints()
        entry:SetParent(nil)
        table.insert(pullEntryPool, entry)
    end
    wipe(activePullEntries)
end

--------------------------------------------------------------------------------
-- Panel Initialization
--------------------------------------------------------------------------------

--- Initialize the pulls list panel (called from MainFrame.lua)
-- @param panel Frame The pulls panel container
function UI:InitializePullsList(panel)
    pullsPanel = panel

    local progressBarFrame = CreateFrame("Frame", "RDT_ForcesProgressBar", pullsPanel)
    progressBarFrame:SetPoint("TOP", 0, -8)
    progressBarFrame:SetSize(240, 24)

    progressBarFrame:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        bgFile = "Interface\\Buttons\\WHITE8X8", 
    })
    progressBarFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    progressBarFrame.fill = progressBarFrame:CreateTexture(nil, "ARTWORK")
    progressBarFrame.fill:SetPoint("LEFT", 1, 0)
    progressBarFrame.fill:SetHeight(22)
    progressBarFrame.fill:SetWidth(0)
    progressBarFrame.fill:SetColorTexture(0.3, 1.0, 0.3, 0.6)

    progressBarFrame.text = progressBarFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    progressBarFrame.text:SetPoint("CENTER")
    progressBarFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    progressBarFrame.text:SetText("0/100 (0.0%)")
    progressBarFrame.text:SetTextColor(1.0, 1.0, 1.0)

    totalForcesLabel = progressBarFrame

    progressBarFrame.fill:SetWidth(0)
    progressBarFrame.fill:SetColorTexture(1.0, 0.3, 0.3, 0.7)

    pullsScrollFrame = CreateFrame("ScrollFrame", "RDT_PullsScroll", pullsPanel, "UIPanelScrollFrameTemplate")
    pullsScrollFrame:SetPoint("TOPLEFT", 2, -40)
    pullsScrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)

    pullsScrollChild = CreateFrame("Frame", "RDT_PullsScrollChild", pullsScrollFrame)

    local scrollWidth = pullsScrollFrame:GetWidth() or (PULLS_PANEL_WIDTH - 28)
    pullsScrollChild:SetSize(scrollWidth, 1)
    pullsScrollFrame:SetScrollChild(pullsScrollChild)

    if RDT.UIHelpers and RDT.UIHelpers.StyleScrollBar then
        RDT.UIHelpers:StyleScrollBar(pullsScrollFrame)
    end

    --local pullsBg = pullsPanel:CreateTexture(nil, "BACKGROUND")
    --pullsBg:SetPoint("TOPLEFT", pullsScrollFrame, "TOPLEFT", 0, 0)
    --pullsBg:SetPoint("BOTTOMRIGHT", pullsPanel, "BOTTOMRIGHT", 0, 0)
    --pullsBg:SetColorTexture(0, 0, 0, 0.5)

    local emptyLabel = pullsScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    emptyLabel:SetPoint("TOP", 0, -20)
    emptyLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
    emptyLabel:SetText(L["NO_PULLS"])
    emptyLabel:SetTextColor(0.5, 0.5, 0.5)
    emptyLabel:Hide()
    UI.emptyPullsLabel = emptyLabel
    
    RDT:DebugPrint("Pulls list panel initialized")
end

--------------------------------------------------------------------------------
-- Pull List Rendering
--------------------------------------------------------------------------------

--- Update the entire pull list display
function UI:UpdatePullList()
    if not RDT.State.currentRoute or not pullsScrollChild then 
        return 
    end
    
    RDT:DebugPrint("Updating pull list")

    self:ReleasePullEntries()
    
    if UI.emptyPullsLabel then
        UI.emptyPullsLabel:Hide()
    end
    
    pullsScrollChild:SetHeight(1)
    local yOffset = -5
    
    -- Check if route manager is available
    if not RDT.RouteManager then
        self:ShowEmptyMessage()
        return
    end

    local pulls = RDT.RouteManager:GetUsedPulls(RDT.State.currentRoute.pulls)

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
        if self.UpdateLabels then
            self:UpdateLabels()
        end
        return
    end
    
    for _, pullNum in ipairs(pulls) do
        yOffset = self:ConfigurePullEntry(pullNum, yOffset)
    end
    pullsScrollChild:SetHeight(math.max(math.abs(yOffset) + 10, PULLS_PANEL_HEIGHT - 50))

    self:UpdateTotalForces()

    if self.UpdateLabels then
        self:UpdateLabels()
    end
end

--- Configure a single pull entry from the pool
-- @param pullNum number Pull number to render
-- @param yOffset number Current Y offset for positioning
-- @return number New Y offset after rendering
function UI:ConfigurePullEntry(pullNum, yOffset)
    local packs = RDT.RouteManager:GetPacksInPull(pullNum)

    local isCurrentPull = (pullNum == RDT.State.currentPull)
    if #packs == 0 and not isCurrentPull then
        return yOffset
    end

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

    table.sort(packDetails, function(a, b) return a.id < b.id end)

    local entryHeight = 34
    local r, g, b = unpack(UIHelpers:GetPullColor(pullNum))
    if isCurrentPull then
        r, g, b = math.min(1, r * 1.3), math.min(1, g * 1.3), math.min(1, b * 1.3)
    end
    
    local entry = self:GetPullEntry(pullsScrollChild)
    entry.pullNum = pullNum
    
    entry:ClearAllPoints()
    entry:SetPoint("TOPLEFT", pullsScrollChild, "TOPLEFT", 0, yOffset)
    entry:SetPoint("TOPRIGHT", pullsScrollChild, "TOPRIGHT", 0, yOffset)
    
    if entry.bgTexture then
        local bgR, bgG, bgB = unpack(UIHelpers:GetPullColor(pullNum))
        local fadeAlpha = isCurrentPull and 0.55 or 0.25
        entry.bgTexture:SetColorTexture(bgR, bgG, bgB, fadeAlpha)
    end
    
    if entry.selectionOverlay then
        if isCurrentPull then
            local overlayR, overlayG, overlayB = unpack(UIHelpers:GetPullColor(pullNum))
            entry.selectionOverlay:SetVertexColor(overlayR, overlayG, overlayB)
            entry.selectionOverlay:SetAlpha(0.25)
        else
            entry.selectionOverlay:SetAlpha(0)
        end
    end
    
    if entry.pullLabel then
        entry.pullLabel:SetText(string.format("|cFFFFFFFF%s %d|r", L["PULL"], pullNum))
        entry.pullLabel:SetTextColor(r, g, b)
    end
    
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
    
    if entry.packList then
        entry.packList:SetText(centerText)
        entry.packList:SetTextColor(0.8, 0.8, 0.8)
    end
    
    local percentText
    if #packs == 0 then
        percentText = "(0%)"
    else
        local requiredCount = 100
        if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.Data then
            requiredCount = RDT.Data:GetDungeonRequiredCount(RDT.db.profile.currentDungeon)
        end
        
        local percentage = (totalCount / requiredCount) * 100
        percentText = string.format("(%.1f%%)", percentage)
    end
    
    if entry.percentLabel then
        entry.percentLabel:SetText(percentText)
        entry.percentLabel:SetTextColor(r, g, b)
    end
    
    yOffset = yOffset - entryHeight - 2
    
    return yOffset
end

function UI:ShowEmptyMessage()
    pullsScrollChild:SetHeight(1)
    
    if UI.emptyPullsLabel then
        UI.emptyPullsLabel:Show()
    end
end

--------------------------------------------------------------------------------
-- Total Forces Display
--------------------------------------------------------------------------------

--- Update the total forces counter
function UI:UpdateTotalForces()
    if not totalForcesLabel or not totalForcesLabel.fill or not totalForcesLabel.text then 
        return 
    end

    local currentCount = 0
    if RDT.RouteManager then
        currentCount = RDT.RouteManager:CalculateTotalForces()
    end

    local requiredCount = 100
    if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.Data then
        requiredCount = RDT.Data:GetDungeonRequiredCount(RDT.db.profile.currentDungeon)
    end

    local percentage = (currentCount / requiredCount) * 100

    local maxBarWidth = 238
    local barWidth = math.min(maxBarWidth, (percentage / 100) * maxBarWidth)
    
    if barWidth < 1 then
        totalForcesLabel.fill:Hide()
        totalForcesLabel.fill:SetWidth(1)
    else
        totalForcesLabel.fill:Show()
        totalForcesLabel.fill:SetWidth(barWidth)
    end
    
    -- Update text: "50.5/100 (50.5%)"
    totalForcesLabel.text:SetText(string.format("%.1f/%.0f (%.1f%%)", currentCount, requiredCount, percentage))
    
    local r, g, b
    if percentage < 100 then
        r, g, b = 1.0, 0.3, 0.3  -- Red - under 100%
    elseif percentage >= 100 and percentage <= 105 then
        r, g, b = 0.3, 1.0, 0.3  -- Green - around 100%
    else
        r, g, b = 1.0, 0.8, 0.2  -- Yellow/Orange - over 105%
    end
    totalForcesLabel.fill:SetColorTexture(r, g, b, 0.7)
    
    totalForcesLabel:SetBackdropColor(r * 0.15, g * 0.15, b * 0.15, 0.6)

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
    self:ReleasePullEntries()
    
    for _, frame in ipairs(pullEntryPool) do
        frame:Hide()
        frame:SetParent(nil)
    end
    
    RDT:DebugPrint("Pulls list cleaned up")
end

RDT:DebugPrint("PullsList.lua loaded")
