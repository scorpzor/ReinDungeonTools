-- UI/PackButtons.lua

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- Pack button styling constants
local MOB_ICON_SIZE = 20
local MOB_ICON_SPACING = 1
local MOB_HIGHLIGHT_SIZE = 24
local MOB_PACK_HIGHLIGHT_SIZE = 28
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Object pools for reusing frames/textures
local packGroupPool = {}
local mobButtonPool = {}
local borderFramePool = {}
local borderLinePool = {}

local pullBorders = {}

--------------------------------------------------------------------------------
-- Pack Button Creation
--------------------------------------------------------------------------------

function UI:CreatePacks(packData)
    if not packData then
        RDT:PrintError("No pack data provided to CreatePacks")
        return
    end
    
    if not UI.mapTexture or not UI.mapContainer then
        RDT:PrintError("Map not initialized, cannot create packs")
        return
    end
    
    local mapWidth, mapHeight = UI:GetMapDimensions()
    
    RDT:DebugPrint("Creating " .. #packData .. " packs with mob icons")
    
    for _, data in ipairs(packData) do
        -- Validate coordinates
        if not data.x or data.x < 0 or data.x > 1 or not data.y or data.y < 0 or data.y > 1 then
            RDT:PrintError(string.format(L["ERROR_INVALID_COORDS"], data.id or 0))
            return
        end
        
        local packGroup = self:CreatePackGroup(data, mapWidth, mapHeight)
        RDT.State.packButtons["pack" .. data.id] = packGroup
    end

    self:UpdateLabels()
    
    RDT:DebugPrint("Pack mob icons created successfully")
end

function UI:CreatePackGroup(data, mapWidth, mapHeight)
    -- Try to reuse a pack group frame from the pool, or create a new one
    local packGroup = table.remove(packGroupPool)
    if not packGroup then
        -- No pooled frame available, create a new one
        packGroup = CreateFrame("Frame", nil, UI.mapContainer)

        local labelFrame = CreateFrame("Frame", nil, UI.mapContainer)
        labelFrame:SetFrameStrata("HIGH")
        labelFrame:SetFrameLevel(1000)
        labelFrame:SetSize(40, 40)

        local pullLabel = labelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
        pullLabel:SetAllPoints(labelFrame)
        pullLabel:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
        pullLabel:SetTextColor(0.5, 0.5, 0.5, 1)
        pullLabel:SetShadowColor(0, 0, 0, 0.5)
        pullLabel:SetShadowOffset(1, -1)
        pullLabel:SetJustifyH("CENTER")
        pullLabel:SetJustifyV("MIDDLE")

        labelFrame:Hide()
        labelFrame.text = pullLabel
        packGroup.pullLabel = labelFrame
    end

    -- Reset/set pack group properties
    packGroup:SetParent(UI.mapContainer)
    packGroup:ClearAllPoints()
    packGroup:Show()
    packGroup.packId = data.id
    packGroup.count = data.count or 0
    packGroup.mobs = data.mobs or {}
    packGroup.mobButtons = {}

    local mobList = {}
    for mobKey, quantity in pairs(data.mobs) do
        local mobDef = RDT.Data:GetMob(mobKey)
        if mobDef then
            for i = 1, quantity do
                tinsert(mobList, {
                    key = mobKey,
                    name = mobDef.name,
                    count = mobDef.count,
                    creatureId = mobDef.creatureId,
                    displayIcon = mobDef.displayIcon,
                    scale = mobDef.scale or 1.0,
                })
            end
        end
    end

    table.sort(mobList, function(a, b) return (a.scale or 1.0) > (b.scale or 1.0) end)

    local totalMobs = #mobList
    local minRadius = 16
    local triRadius = 8
    local dynamicRadius = 14 + (totalMobs * 0.6)
    local radius = math.max(minRadius, dynamicRadius)

    local containerSize = radius * 2 + MOB_ICON_SIZE
    packGroup:SetSize(containerSize, containerSize)

    packGroup:SetPoint("CENTER", UI.mapTexture, "TOPLEFT", data.x * mapWidth, -(data.y * mapHeight))

    for iconIndex, mobInfo in ipairs(mobList) do
        local xOffset, yOffset

        if totalMobs == 3 then
            local angleStep = 360 / 3
            local angle = 270 - (angleStep * (iconIndex - 1))
            local radians = math.rad(angle)

            xOffset = triRadius * math.cos(radians)
            yOffset = triRadius * math.sin(radians)
        elseif iconIndex == 1 then
            xOffset, yOffset = 0, 0
        else
            local satelliteMobs = totalMobs - 1
            local angleStep = 360 / satelliteMobs
            local satelliteIndex = iconIndex - 2
            local angle = 270 - (angleStep * satelliteIndex)
            local radians = math.rad(angle)

            xOffset = radius * math.cos(radians)
            yOffset = radius * math.sin(radians)
        end

        local mobButton = self:CreateMobIcon(packGroup, mobInfo, xOffset, yOffset)
        tinsert(packGroup.mobButtons, mobButton)
    end

    return packGroup
end

function UI:CreateMobIcon(parent, mobInfo, xOffset, yOffset)
    -- Try to reuse a mob button from the pool, or create a new one
    local button = table.remove(mobButtonPool)
    if not button then
        -- No pooled button available, create a new one
        button = CreateFrame("Button", nil, parent)

        -- Create textures only once when creating new button
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("CENTER")
        button.icon = icon

        local bg = button:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("CENTER")
        bg:SetTexture("Interface\\AddOns\\ReinDungeonTools\\Textures\\Borders\\icon_border_gradient")
        button.bg = bg

        local highlight = button:CreateTexture(nil, "OVERLAY")
        highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        highlight:SetBlendMode("ADD")
        highlight:SetPoint("CENTER")
        highlight:Hide()
        button.highlight = highlight

        local glowBorder = button:CreateTexture(nil, "OVERLAY")
        glowBorder:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        glowBorder:SetBlendMode("ADD")
        glowBorder:SetPoint("CENTER")
        glowBorder:Hide()
        button.glowBorder = glowBorder

        -- Setup handlers once
        self:SetupMobIconHandlers(button)
    end

    -- Reset parent and position
    button:SetParent(parent)
    button:ClearAllPoints()

    local scale = mobInfo.scale or 1.0
    local scaledSize = MOB_ICON_SIZE * scale

    button:SetSize(scaledSize, scaledSize)
    button:SetPoint("CENTER", parent, "CENTER", xOffset, yOffset)
    button.packId = parent.packId
    button.mobInfo = mobInfo
    button.iconScale = scale

    -- Update icon texture and size
    local icon = button.icon
    local scaledIconSize = MOB_ICON_SIZE * scale
    icon:SetSize(scaledIconSize, scaledIconSize)

    local iconSet = false
    
    if mobInfo.displayIcon == "portrait" and mobInfo.creatureId then
        -- Portrait support not available: SetPortraitTexture requires unit tokens, not creature IDs
        iconSet = false
    elseif mobInfo.displayIcon and mobInfo.displayIcon ~= "portrait" and mobInfo.displayIcon ~= "" then
        SetPortraitToTexture(icon, mobInfo.displayIcon)
        if icon:GetTexture() then
            iconSet = true
        end
    end

    if not iconSet then
        SetPortraitToTexture(icon, FALLBACK_ICON)
    end

    -- Update background size
    local bg = button.bg
    local bgSize = scaledSize * 1.20
    bg:SetSize(bgSize, bgSize)

    -- Update highlight size
    local highlight = button.highlight
    local scaledHighlightSize = MOB_HIGHLIGHT_SIZE * scale
    highlight:SetSize(scaledHighlightSize, scaledHighlightSize)

    -- Update glow border size
    local glowBorder = button.glowBorder
    local scaledGlowSize = MOB_PACK_HIGHLIGHT_SIZE * scale
    glowBorder:SetSize(scaledGlowSize, scaledGlowSize)

    -- Show the button
    button:Show()

    return button
end

--------------------------------------------------------------------------------
-- Mob Icon Interaction
--------------------------------------------------------------------------------

function UI:SetupMobIconHandlers(button)
    button:SetScript("OnClick", function(self, mouseButton)
        UI:OnMobIconClick(self, mouseButton)
    end)

    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    button:SetScript("OnEnter", function(self)
        UI:OnMobIconEnter(self)
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function UI:OnMobIconClick(button, mouseButton)
    local packId = button.packId
    local packGroup = RDT.State.packButtons["pack" .. packId]
    
    if mouseButton == "RightButton" then
        if RDT.RouteManager then
            RDT.RouteManager:UnassignPack(packId)
        end
    else
        if RDT.State.currentRoute and RDT.State.currentRoute.pulls[packId] == RDT.State.currentPull then
            if RDT.RouteManager then
                RDT.RouteManager:UnassignPack(packId)
            end
        else
            if RDT.RouteManager then
                RDT.RouteManager:AddPackToPull(packId)
            end
        end
    end
end

function UI:OnMobIconEnter(button)
    local packGroup = RDT.State.packButtons["pack" .. button.packId]
    
    GameTooltip:SetOwner(button, "ANCHOR_CURSOR")

    if button.mobInfo then
        GameTooltip:SetText(button.mobInfo.name, 1, 1, 0.5, 1, true)
        GameTooltip:AddLine(string.format("Enemy Forces: %.1f", button.mobInfo.count), 1, 1, 1)
    end
    
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["PACK"] .. " " .. button.packId, 0.7, 0.7, 0.7)

    if packGroup then
        local requiredCount = 100
        if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.Data then
            requiredCount = RDT.Data:GetDungeonRequiredCount(RDT.db.profile.currentDungeon)
        end
        local percentage = (packGroup.count / requiredCount) * 100
        GameTooltip:AddLine(string.format("Pack Total: %.1f (%.1f%%)", packGroup.count, percentage), 1, 1, 1)

        if packGroup.mobs and next(packGroup.mobs) then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Pack Composition:", 1, 0.82, 0)

            local mobList = {}
            for mobKey, quantity in pairs(packGroup.mobs) do
                tinsert(mobList, {key = mobKey, quantity = quantity})
            end
            table.sort(mobList, function(a, b) return a.quantity > b.quantity end)

            for _, mobData in ipairs(mobList) do
                local mobDef = RDT.Data:GetMob(mobData.key)
                if mobDef then
                    local mobTotalCount = mobData.quantity * mobDef.count
                    GameTooltip:AddDoubleLine(
                        string.format("%dx %s", mobData.quantity, mobDef.name),
                        string.format("%.1f", mobTotalCount),
                        0.8, 0.8, 0.8,
                        0.8, 0.8, 0.8
                    )
                end
            end
        end
    end

    if RDT.State.currentRoute then
        local pullNum = RDT.State.currentRoute.pulls[button.packId]
        if pullNum then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Assigned to " .. L["PULL"] .. " " .. pullNum, unpack(RDT:GetPullColor(pullNum)))
        end
    end
    
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["TOOLTIP_CLICK_ADD"], 0.5, 0.5, 0.5)
    GameTooltip:AddLine(L["TOOLTIP_RIGHT_CLICK"], 0.5, 0.5, 0.5)
    GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- Pull Border Management (Convex Hull Algorithm)
--------------------------------------------------------------------------------

local function CalculateConvexHull(points)
    if #points < 3 then return points end

    local pointsCopy = {}
    for i, p in ipairs(points) do
        pointsCopy[i] = {x = p.x, y = p.y}
    end

    local start = 1
    for i = 2, #pointsCopy do
        if pointsCopy[i].y > pointsCopy[start].y or 
           (pointsCopy[i].y == pointsCopy[start].y and pointsCopy[i].x < pointsCopy[start].x) then
            start = i
        end
    end

    local startPoint = pointsCopy[start]

    local sorted = {}
    for i, p in ipairs(pointsCopy) do
        if i ~= start then
            local dx = p.x - startPoint.x
            local dy = p.y - startPoint.y
            local angle = math.atan2(dy, dx)
            local dist = math.sqrt(dx * dx + dy * dy)
            tinsert(sorted, {x = p.x, y = p.y, angle = angle, dist = dist})
        end
    end
    
    table.sort(sorted, function(a, b)
        if math.abs(a.angle - b.angle) < 0.001 then
            return a.dist < b.dist
        end
        return a.angle < b.angle
    end)

    local hull = {startPoint}

    local function ccw(p1, p2, p3)
        return (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x)
    end

    for _, point in ipairs(sorted) do
        while #hull >= 2 and ccw(hull[#hull - 1], hull[#hull], point) <= 0 do
            tremove(hull)
        end
        tinsert(hull, point)
    end
    
    return hull
end

local function ExpandHull(hull, padding)
    if #hull < 3 then return hull end

    local cx, cy = 0, 0
    for _, p in ipairs(hull) do
        cx = cx + p.x
        cy = cy + p.y
    end
    cx = cx / #hull
    cy = cy / #hull

    local expanded = {}
    for _, p in ipairs(hull) do
        local dx = p.x - cx
        local dy = p.y - cy
        local len = math.sqrt(dx * dx + dy * dy)
        
        if len > 0 then
            tinsert(expanded, {
                x = p.x + (dx / len) * padding,
                y = p.y + (dy / len) * padding
            })
        else
            tinsert(expanded, {x = p.x, y = p.y})
        end
    end
    
    return expanded
end

local function CalculatePullCenter(packIds)
    if #packIds == 0 then
        return nil, nil
    end

    -- Collect all mob button positions
    local points = {}
    for _, packId in ipairs(packIds) do
        local packGroup = RDT.State.packButtons["pack" .. packId]
        if packGroup and packGroup.mobButtons then
            local packPt, packRelTo, packRelPt, packX, packY = packGroup:GetPoint(1)

            if packX and packY then
                for mobIdx, mobBtn in ipairs(packGroup.mobButtons) do
                    local mobPt, mobRelTo, mobRelPt, mobX, mobY = mobBtn:GetPoint(1)

                    if mobX and mobY then
                        local absX = packX + mobX
                        local absY = packY + mobY
                        tinsert(points, {x = absX, y = absY})
                    end
                end
            end
        end
    end

    if #points < 1 then
        return nil, nil
    end

    local hull = CalculateConvexHull(points)

    -- Calculate center of convex hull
    local cx, cy = 0, 0
    for _, p in ipairs(hull) do
        cx = cx + p.x
        cy = cy + p.y
    end
    cx = cx / #hull
    cy = cy / #hull

    return cx, cy
end

local function UpdatePullBorder(pullNum, packIds, r, g, b, alpha)
    if #packIds == 0 then
        if pullBorders[pullNum] then
            pullBorders[pullNum]:Hide()
        end
        return
    end
    
    local points = {}

    for _, packId in ipairs(packIds) do
        local packGroup = RDT.State.packButtons["pack" .. packId]
        if packGroup and packGroup.mobButtons then
            local packPt, packRelTo, packRelPt, packX, packY = packGroup:GetPoint(1)

            if packX and packY then
                for mobIdx, mobBtn in ipairs(packGroup.mobButtons) do
                    local mobPt, mobRelTo, mobRelPt, mobX, mobY = mobBtn:GetPoint(1)

                    if mobX and mobY then
                        local absX = packX + mobX
                        local absY = packY + mobY
                        tinsert(points, {x = absX, y = absY})
                    end
                end
            end
        end
    end
    
    if #points < 3 then
        if pullBorders[pullNum] then
            pullBorders[pullNum]:Hide()
        end
        return
    end
    
    local hull = CalculateConvexHull(points)

    local padding = 15
    hull = ExpandHull(hull, padding)

    local border = pullBorders[pullNum]
    if not border then
        -- Try to reuse a border frame from the pool, or create a new one
        border = table.remove(borderFramePool)
        if not border then
            -- No pooled border available, create a new one
            border = CreateFrame("Frame", nil, UI.mapContainer)
            border:SetFrameLevel(UI.mapContainer:GetFrameLevel() + 1)
            border.segments = {}
        else
            -- Reset pooled border properties
            border:SetParent(UI.mapContainer)
            border:SetFrameLevel(UI.mapContainer:GetFrameLevel() + 1)
            -- Ensure segments are reparented to the border
            if border.segments then
                for _, seg in ipairs(border.segments) do
                    seg:SetParent(border)
                end
            end
        end
        pullBorders[pullNum] = border
    end

    for _, seg in ipairs(border.segments) do
        seg:Hide()
    end
    
    local pixelsPerDot = 4
    local dotSize = 3

    local segmentIdx = 1
    for i = 1, #hull do
        local p1 = hull[i]
        local p2 = hull[(i % #hull) + 1]
        
        local dx = p2.x - p1.x
        local dy = p2.y - p1.y
        local lineLength = math.sqrt(dx * dx + dy * dy)
        
        local dotsForThisLine = math.max(2, math.floor(lineLength / pixelsPerDot))

        for j = 0, dotsForThisLine do
            local t = j / dotsForThisLine
            local x = p1.x + (p2.x - p1.x) * t
            local y = p1.y + (p2.y - p1.y) * t

            local seg = border.segments[segmentIdx]
            if not seg then
                seg = CreateFrame("Frame", nil, border)
                seg:SetSize(dotSize, dotSize)
                seg:SetFrameLevel(border:GetFrameLevel() + 1)
                
                local tex = seg:CreateTexture(nil, "OVERLAY")
                tex:SetAllPoints()
                tex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
                seg.texture = tex
                
                border.segments[segmentIdx] = seg
            end
            
            seg:ClearAllPoints()
            seg:SetPoint("CENTER", UI.mapTexture, "TOPLEFT", x, y)
            seg.texture:SetVertexColor(r, g, b, alpha)
            seg:Show()
            
            segmentIdx = segmentIdx + 1
        end
    end
    
    border:Show()
end

local function ClearAllPullBorders()
    for _, border in pairs(pullBorders) do
        border:Hide()
    end
end

--------------------------------------------------------------------------------
-- Pack Visual Updates
--------------------------------------------------------------------------------

function UI:UpdateLabels()
    if not RDT.State.currentRoute then return end

    RDT:DebugPrint("Updating pack labels")

    ClearAllPullBorders()

    for _, packGroup in pairs(RDT.State.packButtons) do
        if packGroup.pullLabel then
            packGroup.pullLabel:Hide()
        end

        local pullNum = RDT.State.currentRoute.pulls[packGroup.packId] or 0
        packGroup.pullNum = pullNum

        if packGroup.mobButtons then
            for _, mobBtn in ipairs(packGroup.mobButtons) do
                if pullNum > 0 then
                    local r, g, b = unpack(RDT:GetPullColor(pullNum))
                    mobBtn.glowBorder:SetVertexColor(r, g, b, 0.9)
                    mobBtn.glowBorder:Show()
                else
                    mobBtn.glowBorder:Hide()
                end
            end
        end
    end

    if RDT.RouteManager then
        local pulls = RDT.RouteManager:GetUsedPulls(RDT.State.currentRoute.pulls)
        for _, pullNum in ipairs(pulls) do
            local packIds = RDT.RouteManager:GetPacksInPull(pullNum)
            if #packIds > 0 then
                local r, g, b = unpack(RDT:GetPullColor(pullNum))
                UpdatePullBorder(pullNum, packIds, r, g, b, 0.8)

                local centerX, centerY = CalculatePullCenter(packIds)

                if centerX and centerY then
                    -- Position the label on the first pack in the pull (arbitrary choice for label parent)
                    local firstPackGroup = RDT.State.packButtons["pack" .. packIds[1]]

                    if firstPackGroup and firstPackGroup.pullLabel then
                        local labelFrame = firstPackGroup.pullLabel
                        labelFrame:ClearAllPoints()
                        labelFrame:SetPoint("CENTER", UI.mapTexture, "TOPLEFT", centerX, centerY)
                        labelFrame.text:SetText(tostring(pullNum))

                        if pullNum == RDT.State.currentPull then
                            labelFrame.text:SetTextColor(1, 1, 1, 1)
                        else
                            labelFrame.text:SetTextColor(0.5, 0.5, 0.5, 1)
                        end

                        labelFrame:Show()
                    end
                end
            end
        end
    end
end

function UI:UpdatePackLabel(packId)
    self:UpdateLabels()
end

function UI:HighlightPull(pullNum, enable)
    if not RDT.State.currentRoute then return end
    
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            local packGroup = RDT.State.packButtons["pack" .. packId]
            if packGroup and packGroup.mobButtons then
                for _, mobBtn in ipairs(packGroup.mobButtons) do
                    if mobBtn.highlight then
                        if enable then
                            mobBtn.highlight:Show()
                            mobBtn.highlight:SetVertexColor(1, 1, 0, 0.5)
                        else
                            mobBtn.highlight:Hide()
                            mobBtn.highlight:SetVertexColor(1, 1, 1, 1)
                        end
                    end
                end
            end
        end
    end

    local border = pullBorders[pullNum]
    if border and border:IsShown() then
        if enable then
            for _, line in ipairs(border.lines or {}) do
                line:SetVertexColor(1, 1, 0, 1)
            end
        else
            local r, g, b = unpack(RDT:GetPullColor(pullNum))
            for _, line in ipairs(border.lines or {}) do
                line:SetVertexColor(r, g, b, 0.8)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Pack Cleanup
--------------------------------------------------------------------------------

function UI:ClearPacks()
    RDT:DebugPrint("Clearing pack groups")

    -- Return pull border frames to pool
    for _, border in pairs(pullBorders) do
        -- Hide all segments but keep them attached to the border for reuse
        if border.segments then
            for _, seg in ipairs(border.segments) do
                seg:Hide()
            end
        end
        border:Hide()
        border:ClearAllPoints()
        table.insert(borderFramePool, border)
    end
    wipe(pullBorders)

    -- Return pack groups and mob buttons to pool
    for name, packGroup in pairs(RDT.State.packButtons) do
        if packGroup then
            if packGroup.mobButtons then
                for _, mobBtn in ipairs(packGroup.mobButtons) do
                    mobBtn:Hide()
                    mobBtn:ClearAllPoints()
                    -- Clear mob button references
                    mobBtn.packId = nil
                    mobBtn.mobInfo = nil
                    mobBtn.iconScale = nil
                    -- Return to pool
                    table.insert(mobButtonPool, mobBtn)
                end
            end

            if packGroup.pullLabel then
                packGroup.pullLabel:Hide()
                packGroup.pullLabel:ClearAllPoints()
            end

            packGroup:Hide()
            packGroup:ClearAllPoints()
            -- Clear pack group references
            packGroup.packId = nil
            packGroup.count = nil
            packGroup.mobs = nil
            packGroup.mobButtons = nil
            -- Return to pool
            table.insert(packGroupPool, packGroup)
        end
    end

    wipe(RDT.State.packButtons)
end

function UI:HideAllPacks()
    for _, packGroup in pairs(RDT.State.packButtons) do
        if packGroup then
            packGroup:Hide()
        end
    end
end

function UI:ShowAllPacks()
    for _, packGroup in pairs(RDT.State.packButtons) do
        if packGroup then
            packGroup:Show()
        end
    end
end

function UI:GetPackButton(packId)
    return RDT.State.packButtons["pack" .. packId]
end

function UI:GetAllPackButtons()
    return RDT.State.packButtons
end

--------------------------------------------------------------------------------
-- Pack Filters (Future Feature)
--------------------------------------------------------------------------------

function UI:FilterPacks(filterFunc)
    for _, packGroup in pairs(RDT.State.packButtons) do
        if filterFunc(packGroup) then
            packGroup:Show()
        else
            packGroup:Hide()
        end
    end
end

function UI:ShowUnassignedPacks()
    self:FilterPacks(function(packGroup)
        if not RDT.State.currentRoute then return true end
        local pullNum = RDT.State.currentRoute.pulls[packGroup.packId]
        return not pullNum or pullNum == 0
    end)
end

function UI:ShowAssignedPacks()
    self:FilterPacks(function(packGroup)
        if not RDT.State.currentRoute then return false end
        local pullNum = RDT.State.currentRoute.pulls[packGroup.packId]
        return pullNum and pullNum > 0
    end)
end

function UI:ResetPackFilter()
    self:ShowAllPacks()
end

RDT:DebugPrint("PackButtons.lua loaded")