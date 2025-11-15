-- Modules/Map/Packs.lua
-- Pack icon rendering, pull borders, and pack interaction

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

local UIHelpers = RDT.UIHelpers
local Colors = RDT.Colors
local LibGraph = LibStub("LibGraph-2.0")

-- Pack button styling constants
local MOB_ICON_SIZE = 20
local MOB_ICON_SPACING = 16
local MOB_HIGHLIGHT_SIZE = 24
local MOB_PACK_HIGHLIGHT_SIZE = 28
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Object pools for reusing frames/textures
local packGroupPool = {}
local mobButtonPool = {}
local borderFramePool = {}  -- Pools border container frames
local patrolLinePool = {}   -- Pools patrol waypoint marker textures

local pullBorders = {}
local patrolLines = {}
local patrolLinesByPack = {}
local patrolOverlayFrame = nil

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

    for _, data in ipairs(packData) do
        if data.patrol and #data.patrol > 1 then
            RDT:DebugPrint(string.format("Rendering patrol path for pack %d with %d points", data.id, #data.patrol))
            self:RenderPatrolPath(data.id, data.patrol, mapWidth, mapHeight)
        end
    end

    self:UpdateLabels()

    RDT:DebugPrint("Pack mob icons created successfully")
end

--- Calculate hexagonal grid positions for mob icons
-- Arranges mobs in concentric hexagonal rings: center, then rings of 6, 12, 18, etc.
-- @param count number Number of mobs to position
-- @return table Array of {x, y} positions
function UI:CalculateHexPositions(count)
    local positions = {}

    if count == 0 then
        return positions
    end

    if count == 1 then
        tinsert(positions, {x = 0, y = 0})
        return positions
    end

    local spacing = MOB_ICON_SPACING
    local currentRing = 0
    local mobsPlaced = 0

    while mobsPlaced < count do
        if currentRing == 0 then
            tinsert(positions, {x = 0, y = 0})
            mobsPlaced = mobsPlaced + 1
        else
            -- Each ring holds currentRing * 6 mobs (ring 1 = 6, ring 2 = 12, etc.)
            local mobsInRing = math.min(currentRing * 6, count - mobsPlaced)
            local radius = currentRing * spacing

            for i = 0, mobsInRing - 1 do
                -- Determine which hexagon edge (0-5) and position along that edge
                local segment = math.floor(i / currentRing)
                local posInSegment = i % currentRing

                -- Hexagon vertices are at 0°, 60°, 120°, 180°, 240°, 300°
                local angle1 = math.rad(segment * 60)
                local angle2 = math.rad((segment + 1) * 60)

                -- Interpolate position along the hexagon edge
                local t = currentRing > 1 and posInSegment / currentRing or 0

                local x1 = radius * math.cos(angle1)
                local y1 = radius * math.sin(angle1)
                local x2 = radius * math.cos(angle2)
                local y2 = radius * math.sin(angle2)

                local x = x1 + (x2 - x1) * t
                local y = y1 + (y2 - y1) * t

                tinsert(positions, {x = x, y = y})
                mobsPlaced = mobsPlaced + 1

                if mobsPlaced >= count then
                    break
                end
            end
        end

        currentRing = currentRing + 1
    end

    return positions
end

function UI:CreatePackGroup(data, mapWidth, mapHeight)
    -- Try to reuse a pack group frame from the pool, or create a new one
    local packGroup = table.remove(packGroupPool)
    if not packGroup then
        -- No pooled frame available, create a new one
        packGroup = CreateFrame("Frame", nil, UI.mapCanvas)

        local labelFrame = CreateFrame("Frame", nil, UI.mapCanvas)
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
    packGroup:SetParent(UI.mapCanvas)
    packGroup:ClearAllPoints()
    packGroup:Show()
    packGroup.packId = data.id
    packGroup.count = data.count or 0
    packGroup.mobs = data.mobs or {}
    packGroup.isPatrol = data.patrol and #data.patrol > 1  -- Boolean flag for tooltip
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

    local positions = self:CalculateHexPositions(totalMobs)

    local maxDist = 0
    for _, pos in ipairs(positions) do
        local dist = math.sqrt(pos.x * pos.x + pos.y * pos.y)
        maxDist = math.max(maxDist, dist)
    end
    local containerSize = (maxDist + MOB_ICON_SIZE) * 2
    packGroup:SetSize(containerSize, containerSize)

    packGroup:SetPoint("CENTER", UI.mapTexture, "TOPLEFT", data.x * mapWidth, -(data.y * mapHeight))

    for iconIndex, mobInfo in ipairs(mobList) do
        local pos = positions[iconIndex]
        local mobButton = self:CreateMobIcon(packGroup, mobInfo, pos.x, pos.y)
        tinsert(packGroup.mobButtons, mobButton)
    end

    return packGroup
end

function UI:CreateMobIcon(parent, mobInfo, xOffset, yOffset)
    -- Try to reuse a mob button from the pool
    local button = table.remove(mobButtonPool)
    if not button then
        button = CreateFrame("Button", nil, parent)

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
    
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
        UI:OnMobIconLeave(self)
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

    GameTooltip:SetOwner(button, "ANCHOR_NONE")
    local x, y = GetCursorPosition()
    local scale = GameTooltip:GetEffectiveScale()
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (x / scale) + 30, (y / scale))

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
            local compositionText = "Pack Composition"
            if packGroup.isPatrol then
                compositionText = compositionText .. " (Patrol)"
            end
            GameTooltip:AddLine(compositionText .. ":", 1, 0.82, 0)

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
            GameTooltip:AddLine("Assigned to " .. L["PULL"] .. " " .. pullNum, unpack(UIHelpers:GetPullColor(pullNum)))
        end
    end

    GameTooltip:Show()

    button:SetScale(1.1)
    self:ShowPatrolLines(button.packId, true)
end

function UI:OnMobIconLeave(button)
    button:SetScale(1.0)
    self:ShowPatrolLines(button.packId, false)
end

--- Check if point a is more lower-left than point b
-- TOPLEFT anchor: X is positive right, Y is NEGATIVE down
-- "Lower" means more negative Y (visually down), "Left" means smaller X
-- @param a table Point {x, y}
-- @param b table Point {x, y}
-- @return boolean True if a is more lower-left
local function IsLowerLeft(a, b)
    if a.x < b.x then return true end
    if a.x > b.x then return false end
    if a.y < b.y then return true end
    if a.y > b.y then return false end
    return false
end

--- Check if point c is left of line a-b
-- Uses cross product to determine which side of the line the point is on
-- @param a table Point {x, y}
-- @param b table Point {x, y}
-- @param c table Point {x, y}
-- @return boolean True if c is left of line a-b
local function IsLeftOf(a, b, c)
    local u1 = b.x - a.x
    local v1 = b.y - a.y
    local u2 = c.x - a.x
    local v2 = c.y - a.y
    return u1 * v2 - v1 * u2 < 0
end

--- Calculate convex hull using Jarvis march algorithm
-- @param points table Array of points {x, y}
-- @return table Array of hull points {x, y}
local function CalculateConvexHull(points)
    if not points or #points == 0 then return nil end
    if #points < 3 then return points end

    -- Find the lower-left point as starting point
    local lowerLeft = 1
    for i = 2, #points do
        if not points[i].x or not points[lowerLeft].x then return nil end
        if IsLowerLeft(points[i], points[lowerLeft]) then
            lowerLeft = i
        end
    end

    -- Jarvis march: wrap around the points
    local hull = {}
    local currentIdx = lowerLeft
    local finalIdx = 1
    local tries = 0
    local maxTries = 100  -- Prevent infinite loops

    repeat
        tinsert(hull, currentIdx)
        finalIdx = 1

        -- Find the most counter-clockwise point from current
        for j = 2, #points do
            if currentIdx == finalIdx or IsLeftOf(points[currentIdx], points[finalIdx], points[j]) then
                finalIdx = j
            end
        end

        currentIdx = finalIdx
        tries = tries + 1
    until finalIdx == hull[1] or tries > maxTries

    -- Convert indices to actual points
    local hullPoints = {}
    for _, idx in ipairs(hull) do
        tinsert(hullPoints, {x = points[idx].x, y = points[idx].y})
    end

    return hullPoints
end

--- Calculate centroid of a polygon
-- @param points table Array of points {x, y}
-- @return table Centroid point {x, y} or nil
local function CalculateCentroid(points)
    if not points or #points == 0 then return nil end

    local cx, cy = 0, 0
    for _, p in ipairs(points) do
        if not p.x or not p.y then return nil end
        cx = cx + p.x
        cy = cy + p.y
    end

    cx = cx / #points
    cy = cy / #points

    return {x = cx, y = cy}
end

--- Calculate the center point of a pull (for label positioning)
-- @param packIds table Array of pack IDs in the pull
-- @return number, number Center X and Y coordinates, or nil, nil
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
    if not hull then
        return nil, nil
    end

    local centroid = CalculateCentroid(hull)
    if not centroid then
        return nil, nil
    end

    return centroid.x, centroid.y
end

--- Expand polygon by adding circular points around each vertex
-- Creates a circle of points around each vertex, with the number of points proportional to scale
-- @param poly table Array of {x, y, scale} points
-- @param numCirclePoints number Base number of points per circle (scaled by point's scale)
-- @return table Expanded polygon points {x, y, scale}
local function ExpandPolygonCircular(poly, numCirclePoints)
    if not poly or #poly == 0 then return nil end

    local res = {}
    local resIndex = 1

    for i = 1, #poly do
        local x = poly[i].x
        local y = poly[i].y
        local scale = poly[i].scale or 1.0

        -- Radius scales with the mob icon scale
        local r = scale * 12

        -- Adjust number of circle points based on scale (larger mobs = more points for smoothness)
        local adjustedNumPoints = math.max(1, math.floor(numCirclePoints * scale))

        if not x or not y or not r then
            return nil
        end

        -- Create circle of points around this vertex
        for j = 1, adjustedNumPoints do
            local angle = (2 * math.pi / adjustedNumPoints) * j
            local cx = x + r * math.cos(angle)
            local cy = y + r * math.sin(angle)
            res[resIndex] = {x = cx, y = cy, scale = scale}
            resIndex = resIndex + 1
        end
    end

    return res
end

local function UpdatePullBorder(pullNum, packIds, r, g, b, alpha)
    -- Hide and clear existing border textures for this pull
    if pullBorders[pullNum] then
        LibGraph:HideLines(pullBorders[pullNum])
    end

    if #packIds == 0 then
        return
    end

    local points = {}
    local totalMobs = 0
    local singleMobButton = nil

    for _, packId in ipairs(packIds) do
        local packGroup = RDT.State.packButtons["pack" .. packId]
        if packGroup and packGroup.mobButtons then
            local packPt, packRelTo, packRelPt, packX, packY = packGroup:GetPoint(1)

            if packX and packY then
                for mobIdx, mobBtn in ipairs(packGroup.mobButtons) do
                    local mobPt, mobRelTo, mobRelPt, mobX, mobY = mobBtn:GetPoint(1)

                    if mobX and mobY then
                        local absX = packX + mobX
                        -- TODO: I have no idea where I messed up but the Y coordinate is shifted 2px down.
                        -- Temp(yeah sure) +2 offset added to center everything
                        local absY = packY + mobY + 2
                        local mobScale = mobBtn.iconScale or 1.0

                        tinsert(points, {x = absX, y = absY, scale = mobScale})

                        totalMobs = totalMobs + 1
                        if totalMobs == 1 then
                            singleMobButton = mobBtn
                        end
                    end
                end
            end
        end
    end

    if #points == 0 then
        return
    end

    -- Two-pass approach:
    -- 1. Expand each point into a circle of points (higher value = smoother but more expensive)
    -- 2. Calculate convex hull of all expanded points
    -- 3. Calculate convex hull again for final smoothing
    local expanded = ExpandPolygonCircular(points, 30)
    if not expanded then
        return
    end

    local hull = CalculateConvexHull(expanded)
    if not hull or #hull < 2 then
        return
    end

    if not pullBorders[pullNum] then
        local borderFrame = table.remove(borderFramePool)
        if not borderFrame then
            borderFrame = CreateFrame("Frame", nil, UI.mapCanvas)
        end
        borderFrame:SetParent(UI.mapCanvas)
        borderFrame:SetFrameLevel(UI.mapCanvas:GetFrameLevel() + 1)
        borderFrame:SetAllPoints(UI.mapCanvas)
        pullBorders[pullNum] = borderFrame
    end

    local borderFrame = pullBorders[pullNum]
    borderFrame:Show()

    local lineWidth = 30
    local color = {r, g, b, alpha}

    local mapWidth = UI.mapTexture:GetWidth()
    local mapHeight = UI.mapTexture:GetHeight()

    for i = 1, #hull do
        local p1 = hull[i]
        local p2 = hull[(i % #hull) + 1]  -- Wrap around to first point

        -- Hull coordinates are TOPLEFT-relative offsets from GetPoint() (X positive, Y negative)
        local x1 = p1.x
        local y1 = mapHeight + p1.y
        local x2 = p2.x
        local y2 = mapHeight + p2.y

        LibGraph:DrawLine(
            borderFrame,
            x1, y1,
            x2, y2,
            lineWidth,
            color,
            "OVERLAY"
        )
    end
end

local function ClearAllPullBorders()
    for _, border in pairs(pullBorders) do
        LibGraph:HideLines(border)
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
                    local r, g, b = unpack(UIHelpers:GetPullColor(pullNum))
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
                local r, g, b = unpack(UIHelpers:GetPullColor(pullNum))
                UpdatePullBorder(pullNum, packIds, r, g, b, 1.0)

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

    local borderFrame = pullBorders[pullNum]
    if borderFrame and borderFrame.GraphLib_Lines_Used then
        if enable then
            for _, tex in ipairs(borderFrame.GraphLib_Lines_Used) do
                tex:SetVertexColor(1, 1, 0, 1)
            end
        else
            local r, g, b = unpack(UIHelpers:GetPullColor(pullNum))
            for _, tex in ipairs(borderFrame.GraphLib_Lines_Used) do
                tex:SetVertexColor(r, g, b, 1.0)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Patrol Path Rendering
--------------------------------------------------------------------------------

--- Render patrol path for a pack with patrol points
-- @param packId number Pack ID for tracking
-- @param patrolPoints table Array of {x, y} patrol waypoints (normalized 0-1 coordinates)
-- @param mapWidth number Map width in pixels
-- @param mapHeight number Map height in pixels
function UI:RenderPatrolPath(packId, patrolPoints, mapWidth, mapHeight)
    if not patrolPoints or #patrolPoints < 2 then
        return  -- Need at least 2 points to draw a path
    end

    if not patrolOverlayFrame then
        patrolOverlayFrame = CreateFrame("Frame", nil, self.mapCanvas)
        patrolOverlayFrame:SetFrameStrata("HIGH")
        patrolOverlayFrame:SetFrameLevel(999)
        patrolOverlayFrame:SetAllPoints(self.mapCanvas)
    else
        LibGraph:HideLines(patrolOverlayFrame)
    end

    -- Create a larger dot to mark the waypoint
    local packPatrolMarkers = {}
    for i, point in ipairs(patrolPoints) do
        local x = point.x * mapWidth
        local y = point.y * mapHeight

        local marker = table.remove(patrolLinePool)
        if not marker then
            marker = patrolOverlayFrame:CreateTexture(nil, "OVERLAY")
            marker:SetTexture("Interface\\Buttons\\WHITE8X8")
        end

        marker:SetSize(6, 6)
        marker:ClearAllPoints()
        local color = Colors.Patrol
        marker:SetVertexColor(color[1], color[2], color[3], color[4])
        marker:SetPoint("CENTER", self.mapTexture, "TOPLEFT", x, -y)
        marker:Hide()

        table.insert(patrolLines, marker)
        table.insert(packPatrolMarkers, marker)
    end

    for i = 1, #patrolPoints - 1 do
        local point1 = patrolPoints[i]
        local point2 = patrolPoints[i + 1]

        -- Convert normalized coordinates to screen space
        local x1 = point1.x * mapWidth
        local y1 = point1.y * mapHeight
        local x2 = point2.x * mapWidth
        local y2 = point2.y * mapHeight

        y1 = mapHeight - y1
        y2 = mapHeight - y2

        LibGraph:DrawLine(
            patrolOverlayFrame,  -- Canvas frame
            x1, y1,              -- Start coordinates
            x2, y2,              -- End coordinates
            20,                  -- Line width
            Colors.Patrol,       -- Color {r, g, b, a}
            "OVERLAY"            -- Draw layer
        )
    end

    patrolLinesByPack[packId] = packPatrolMarkers
end

--- Show or hide patrol lines for a pack
-- @param packId number Pack ID
-- @param show boolean True to show, false to hide
function UI:ShowPatrolLines(packId, show)
    local markers = patrolLinesByPack[packId]
    if not markers then
        return
    end

    -- Show/hide waypoint markers (manually created textures)
    for _, marker in ipairs(markers) do
        if show then
            marker:Show()
        else
            marker:Hide()
        end
    end
end

--------------------------------------------------------------------------------
-- Pack Cleanup
--------------------------------------------------------------------------------

function UI:ClearPacks()
    RDT:DebugPrint("Clearing pack groups")

    -- Return patrol waypoint marker textures to pool
    for _, marker in ipairs(patrolLines) do
        marker:Hide()
        marker:ClearAllPoints()
        table.insert(patrolLinePool, marker)
    end
    wipe(patrolLines)
    wipe(patrolLinesByPack)

    if patrolOverlayFrame then
        LibGraph:HideLines(patrolOverlayFrame)
    end

    for _, border in pairs(pullBorders) do
        LibGraph:HideLines(border)
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