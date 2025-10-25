-- UI/PackButtons.lua
-- Pack button creation, interaction, and visual updates
-- Now displays individual mob portraits for each pack

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- Pack button styling constants
local MOB_ICON_SIZE = 20  -- Reduced from 32 to 20 for better scaling on larger maps
local MOB_ICON_SPACING = 1  -- Reduced spacing
local MOB_HIGHLIGHT_SIZE = 24  -- Adjusted to match new icon size
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Pull border frames (one per pull, encompasses all packs)
local pullBorders = {}

--------------------------------------------------------------------------------
-- Pack Button Creation
--------------------------------------------------------------------------------

--- Create pack buttons on the map (now creates multiple mob icons per pack)
-- @param packData table Array of pack definitions with {id, x, y, mobs, count}
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
    
    -- Update labels after all buttons created
    self:UpdateLabels()
    
    RDT:DebugPrint("Pack mob icons created successfully")
end

--- Create a pack group with individual mob icons
-- @param data table Pack data {id, x, y, mobs, count}
-- @param mapWidth number Map width for positioning
-- @param mapHeight number Map height for positioning
-- @return Frame The created pack group frame
function UI:CreatePackGroup(data, mapWidth, mapHeight)
    -- Create container frame for the pack
    local packGroup = CreateFrame("Frame", "RDT_Pack" .. data.id, UI.mapContainer)
    packGroup.packId = data.id
    packGroup.count = data.count or 0
    packGroup.mobs = data.mobs or {}
    packGroup.mobButtons = {}
    
    -- Convert mobs table to array for consistent ordering (sort by scale descending)
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
                    scale = mobDef.scale or 1.0, -- Default to full size
                })
            end
        end
    end
    
    -- Sort by scale descending (largest/most important first)
    table.sort(mobList, function(a, b) return (a.scale or 1.0) > (b.scale or 1.0) end)
    
    -- Calculate layout: biggest mob in center, others in clockwise circle
    local totalMobs = #mobList
    local radius = 12 + (totalMobs * 1.2) -- Dynamic radius based on mob count
    
    -- Set container size to encompass the circle
    local containerSize = radius * 2 + MOB_ICON_SIZE
    packGroup:SetSize(containerSize, containerSize)
    
    -- Anchor to TOPLEFT (standard UI coordinates: 0,0 = top-left, 1,1 = bottom-right)
    -- Use the passed mapWidth/mapHeight which come from GetMapDimensions (container size)
    packGroup:SetPoint("CENTER", UI.mapTexture, "TOPLEFT", data.x * mapWidth, -(data.y * mapHeight))
    
    -- Create individual mob icons
    for iconIndex, mobInfo in ipairs(mobList) do
        local xOffset, yOffset
        
        if iconIndex == 1 then
            -- First mob (biggest): place in center
            xOffset, yOffset = 0, 0
        else
            -- Remaining mobs: arrange in clockwise circle starting from top (12 o'clock)
            local satelliteMobs = totalMobs - 1 -- Number of mobs in the circle
            local angleStep = 360 / satelliteMobs
            local satelliteIndex = iconIndex - 2 -- Index in the satellite circle (0-based)
            local angle = 270 - (angleStep * satelliteIndex) -- Clockwise from top
            local radians = math.rad(angle)
            
            xOffset = radius * math.cos(radians)
            yOffset = radius * math.sin(radians)
        end
        
        local mobButton = self:CreateMobIcon(packGroup, mobInfo, xOffset, yOffset)
        tinsert(packGroup.mobButtons, mobButton)
    end
    
    -- Pack ID label (below pack)
    local idLabel = packGroup:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    idLabel:SetPoint("TOP", packGroup, "BOTTOM", 0, -2)
    idLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    idLabel:SetText(tostring(data.id))
    idLabel:SetTextColor(0.7, 0.7, 0.7)
    packGroup.idLabel = idLabel
    
    return packGroup
end

--- Create a single mob icon button
-- @param parent Frame Parent pack group frame
-- @param mobInfo table Mob information {key, name, count, creatureId, displayIcon, scale}
-- @param xOffset number X offset from parent center
-- @param yOffset number Y offset from parent center
-- @return Frame The created mob button
function UI:CreateMobIcon(parent, mobInfo, xOffset, yOffset)
    local button = CreateFrame("Button", nil, parent)
    
    -- Apply scale to icon size
    local scale = mobInfo.scale or 1.0
    local scaledSize = MOB_ICON_SIZE * scale
    
    button:SetSize(scaledSize, scaledSize)
    button:SetPoint("CENTER", parent, "CENTER", xOffset, yOffset)
    button.packId = parent.packId
    button.mobInfo = mobInfo
    button.iconScale = scale
    
    -- Background/border
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    bg:SetVertexColor(0.8, 0.8, 0.8)
    button.bg = bg
    
    -- Portrait/Icon texture (scaled)
    local icon = button:CreateTexture(nil, "ARTWORK")
    local scaledIconSize = (MOB_ICON_SIZE - 4) * scale
    icon:SetSize(scaledIconSize, scaledIconSize)
    icon:SetPoint("CENTER")
    
    -- Set icon based on displayIcon type
    local iconSet = false
    
    if mobInfo.displayIcon == "portrait" and mobInfo.creatureId then
        -- Try to use 3D portrait (may not work with creature IDs in 3.3.5a)
        -- SetPortraitTexture only works with unit tokens, not creature IDs
        -- So we'll skip this and fall through to fallback
        iconSet = false
    elseif mobInfo.displayIcon and mobInfo.displayIcon ~= "portrait" and mobInfo.displayIcon ~= "" then
        -- Use explicit texture path
        icon:SetTexture(mobInfo.displayIcon)
        -- Check if texture was actually set
        if icon:GetTexture() then
            iconSet = true
        end
    end
    
    -- Fallback to question mark if icon wasn't set
    if not iconSet then
        icon:SetTexture(FALLBACK_ICON)
    end
    
    button.icon = icon
    
    -- Selection highlight (scaled)
    local highlight = button:CreateTexture(nil, "OVERLAY")
    highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    highlight:SetBlendMode("ADD")
    local scaledHighlightSize = MOB_HIGHLIGHT_SIZE * scale
    highlight:SetSize(scaledHighlightSize, scaledHighlightSize)
    highlight:SetPoint("CENTER")
    highlight:Hide()
    button.highlight = highlight
    
    -- Pull number label (overlay on icon, scaled font)
    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("CENTER", 0, 0)
    local scaledFontSize = math.max(9, 12 * scale) -- Min font size of 9
    label:SetFont("Fonts\\FRIZQT__.TTF", scaledFontSize, "OUTLINE")
    label:SetTextColor(1, 1, 1)
    button.label = label
    
    -- Set up interaction
    self:SetupMobIconHandlers(button)
    
    return button
end

--------------------------------------------------------------------------------
-- Mob Icon Interaction
--------------------------------------------------------------------------------

--- Set up click and tooltip handlers for a mob icon
-- @param button Frame The mob icon button
function UI:SetupMobIconHandlers(button)
    -- Click handler
    button:SetScript("OnClick", function(self, mouseButton)
        UI:OnMobIconClick(self, mouseButton)
    end)

    -- Register for clicks
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    -- Tooltip handlers
    button:SetScript("OnEnter", function(self)
        UI:OnMobIconEnter(self)
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

--- Handle mob icon click (adds pack to current pull)
-- @param button Frame The clicked mob icon button
-- @param mouseButton string "LeftButton" or "RightButton"
function UI:OnMobIconClick(button, mouseButton)
    local packId = button.packId
    local packGroup = RDT.State.packButtons["pack" .. packId]
    
    if mouseButton == "RightButton" then
        -- Right-click: Remove pack from pull
        if RDT.RouteManager then
            RDT.RouteManager:UnassignPack(packId)
        end
    else
        -- Left-click: Add pack to current pull (or toggle if already in same pull)
        if RDT.State.currentRoute and RDT.State.currentRoute.pulls[packId] == RDT.State.currentPull then
            -- Already in current pull, remove it
            if RDT.RouteManager then
                RDT.RouteManager:UnassignPack(packId)
            end
        else
            -- Add to current pull
            if RDT.RouteManager then
                RDT.RouteManager:AddPackToPull(packId)
            end
        end
    end
end

--- Show tooltip when hovering over mob icon
-- @param button Frame The mob icon button
function UI:OnMobIconEnter(button)
    local packGroup = RDT.State.packButtons["pack" .. button.packId]
    
    GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
    
    -- Mob name as title
    if button.mobInfo then
        GameTooltip:SetText(button.mobInfo.name, 1, 1, 0.5, 1, true)
        GameTooltip:AddLine(string.format("Enemy Forces: %.1f", button.mobInfo.count), 1, 1, 1)
    end
    
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["PACK"] .. " " .. button.packId, 0.7, 0.7, 0.7)
    
    -- Show pack total with percentage
    if packGroup then
        -- Calculate percentage based on dungeon's required count
        local requiredCount = 100
        if RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon and RDT.Data then
            requiredCount = RDT.Data:GetDungeonRequiredCount(RDT.db.profile.currentDungeon)
        end
        local percentage = (packGroup.count / requiredCount) * 100
        GameTooltip:AddLine(string.format("Pack Total: %.1f (%.1f%%)", packGroup.count, percentage), 1, 1, 1)
        
        -- Show pack composition
        if packGroup.mobs and next(packGroup.mobs) then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Pack Composition:", 1, 0.82, 0)
            
            -- Sort mobs by quantity
            local mobList = {}
            for mobKey, quantity in pairs(packGroup.mobs) do
                tinsert(mobList, {key = mobKey, quantity = quantity})
            end
            table.sort(mobList, function(a, b) return a.quantity > b.quantity end)
            
            -- Display each mob type
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
    
    -- Show current pull assignment if any
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
-- Pull Border Management
--------------------------------------------------------------------------------

--- Create or update a border that encompasses all packs in a pull
local function UpdatePullBorder(pullNum, packIds, r, g, b, alpha)
    if #packIds == 0 then
        -- No packs, hide border
        if pullBorders[pullNum] then
            pullBorders[pullNum]:Hide()
        end
        return
    end
    
    -- Calculate bounding box of all packs in this pull (using map-relative coordinates)
    local minX, minY, maxX, maxY = nil, nil, nil, nil
    local validPacks = 0
    
    local mapWidth, mapHeight = UI:GetMapDimensions()
    
    for _, packId in ipairs(packIds) do
        local packGroup = RDT.State.packButtons["pack" .. packId]
        if packGroup then
            -- Get pack size
            local packWidth = packGroup:GetWidth() or 0
            local packHeight = packGroup:GetHeight() or 0
            
            -- Get pack center position relative to map
            local points = {packGroup:GetPoint()}
            if points[1] and points[3] then
                local x = points[4] or 0
                local y = points[5] or 0
                
                -- Calculate bounds (center +/- half size)
                local left = x - packWidth / 2
                local right = x + packWidth / 2
                local bottom = y - packHeight / 2
                local top = y + packHeight / 2
                
                minX = minX and math.min(minX, left) or left
                maxX = maxX and math.max(maxX, right) or right
                minY = minY and math.min(minY, bottom) or bottom
                maxY = maxY and math.max(maxY, top) or top
                validPacks = validPacks + 1
            end
        end
    end
    
    if validPacks == 0 or not minX then return end
    
    -- Add padding around the bounding box
    local padding = 0
    minX = minX - padding
    maxX = maxX + padding
    minY = minY - padding
    maxY = maxY + padding
    
    local width = maxX - minX
    local height = maxY - minY
    local centerX = (minX + maxX) / 2
    local centerY = (minY + maxY) / 2
    
    -- Create or reuse border frame
    local border = pullBorders[pullNum]
    if not border then
        border = CreateFrame("Frame", "RDT_PullBorder" .. pullNum, UI.mapContainer)
        border:SetFrameLevel(UI.mapContainer:GetFrameLevel() + 1)
        border:SetBackdrop({
            bgFile = nil,
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        pullBorders[pullNum] = border
    end
    
    -- Position and size the border (relative to map)
    border:SetSize(width, height)
    border:ClearAllPoints()
    border:SetPoint("CENTER", UI.mapTexture, "TOPLEFT", centerX, centerY)
    border:SetBackdropBorderColor(r, g, b, alpha)
    border:Show()
end

--- Clear all pull borders
local function ClearAllPullBorders()
    for _, border in pairs(pullBorders) do
        border:Hide()
    end
end

--------------------------------------------------------------------------------
-- Pack Visual Updates
--------------------------------------------------------------------------------

--- Update all pack labels with pull numbers and colors (for all mob icons)
function UI:UpdateLabels()
    if not RDT.State.currentRoute then return end
    
    RDT:DebugPrint("Updating pack labels")
    
    -- Clear all pull borders first
    ClearAllPullBorders()
    
    -- Update pack labels
    for _, packGroup in pairs(RDT.State.packButtons) do
        local pullNum = RDT.State.currentRoute.pulls[packGroup.packId] or 0
        packGroup.pullNum = pullNum
        
        -- Update label on each mob icon in the pack
        if packGroup.mobButtons then
            for _, mobBtn in ipairs(packGroup.mobButtons) do
                mobBtn.label:SetText(pullNum > 0 and tostring(pullNum) or "")
                mobBtn.label:SetTextColor(unpack(RDT:GetPullColor(pullNum)))
            end
        end
    end
    
    -- Create borders for each pull
    if RDT.RouteManager then
        local pulls = RDT.RouteManager:GetUsedPulls(RDT.State.currentRoute.pulls)
        for _, pullNum in ipairs(pulls) do
            local packIds = RDT.RouteManager:GetPacksInPull(pullNum)
            if #packIds > 0 then
                local r, g, b = unpack(RDT:GetPullColor(pullNum))
                UpdatePullBorder(pullNum, packIds, r, g, b, 0.8)
            end
        end
    end
end

--- Update a single pack's labels
-- @param packId number Pack ID to update
function UI:UpdatePackLabel(packId)
    -- Just call UpdateLabels to refresh everything including borders
    self:UpdateLabels()
end

--- Highlight packs in a specific pull
-- @param pullNum number Pull number to highlight
-- @param enable boolean True to enable, false to disable
function UI:HighlightPull(pullNum, enable)
    if not RDT.State.currentRoute then return end
    
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            local packGroup = RDT.State.packButtons["pack" .. packId]
            if packGroup and packGroup.mobButtons then
                -- Highlight mob icons
                for _, mobBtn in ipairs(packGroup.mobButtons) do
                    if mobBtn.highlight then
                        if enable then
                            mobBtn.highlight:Show()
                            mobBtn.highlight:SetVertexColor(1, 1, 0, 0.5) -- Yellow tint
                        else
                            mobBtn.highlight:Hide()
                            mobBtn.highlight:SetVertexColor(1, 1, 1, 1) -- Reset
                        end
                    end
                end
            end
        end
    end
    
    -- Highlight pull border
    local border = pullBorders[pullNum]
    if border and border:IsShown() then
        if enable then
            border:SetBackdropBorderColor(1, 1, 0, 1) -- Bright yellow
        else
            -- Restore original pull color
            local r, g, b = unpack(RDT:GetPullColor(pullNum))
            border:SetBackdropBorderColor(r, g, b, 0.8)
        end
    end
end

--------------------------------------------------------------------------------
-- Pack Cleanup
--------------------------------------------------------------------------------

--- Clear all pack groups from the map
function UI:ClearPacks()
    RDT:DebugPrint("Clearing pack groups")
    
    -- Clear all pull borders
    for _, border in pairs(pullBorders) do
        border:Hide()
        border:SetParent(nil)
    end
    wipe(pullBorders)
    
    for name, packGroup in pairs(RDT.State.packButtons) do
        if packGroup then
            -- Clean up mob buttons
            if packGroup.mobButtons then
                for _, mobBtn in ipairs(packGroup.mobButtons) do
                    mobBtn:Hide()
                    mobBtn:SetParent(nil)
                end
            end
            packGroup:Hide()
            packGroup:SetParent(nil)
        end
    end
    
    wipe(RDT.State.packButtons)
end

--- Hide all pack groups (without destroying)
function UI:HideAllPacks()
    for _, packGroup in pairs(RDT.State.packButtons) do
        if packGroup then
            packGroup:Hide()
        end
    end
end

--- Show all pack groups
function UI:ShowAllPacks()
    for _, packGroup in pairs(RDT.State.packButtons) do
        if packGroup then
            packGroup:Show()
        end
    end
end

--- Get pack group by ID
-- @param packId number Pack ID
-- @return Frame Pack group or nil
function UI:GetPackButton(packId)
    return RDT.State.packButtons["pack" .. packId]
end

--- Get all pack groups
-- @return table Map of packId -> packGroup
function UI:GetAllPackButtons()
    return RDT.State.packButtons
end

--------------------------------------------------------------------------------
-- Pack Filters (Future Feature)
--------------------------------------------------------------------------------

--- Filter pack groups by criteria (placeholder for future)
-- @param filterFunc function Filter function(packGroup) returns boolean
function UI:FilterPacks(filterFunc)
    for _, packGroup in pairs(RDT.State.packButtons) do
        if filterFunc(packGroup) then
            packGroup:Show()
        else
            packGroup:Hide()
        end
    end
end

--- Show only unassigned packs
function UI:ShowUnassignedPacks()
    self:FilterPacks(function(packGroup)
        if not RDT.State.currentRoute then return true end
        local pullNum = RDT.State.currentRoute.pulls[packGroup.packId]
        return not pullNum or pullNum == 0
    end)
end

--- Show only assigned packs
function UI:ShowAssignedPacks()
    self:FilterPacks(function(packGroup)
        if not RDT.State.currentRoute then return false end
        local pullNum = RDT.State.currentRoute.pulls[packGroup.packId]
        return pullNum and pullNum > 0
    end)
end

--- Reset pack visibility filter (show all)
function UI:ResetPackFilter()
    self:ShowAllPacks()
end

RDT:DebugPrint("PackButtons.lua loaded with mob portraits and dynamic pull borders")
