-- UI/PackButtons.lua
-- Pack button creation, interaction, and visual updates

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- UI namespace
RDT.UI = RDT.UI or {}
local UI = RDT.UI

-- Pack button styling constants
local PACK_BUTTON_SIZE = 28
local PACK_ICON_SIZE = 20
local PACK_HIGHLIGHT_SIZE = 32

--------------------------------------------------------------------------------
-- Pack Button Creation
--------------------------------------------------------------------------------

--- Create pack buttons on the map
-- @param packData table Array of pack definitions with {id, x, y, count}
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
    
    RDT:DebugPrint("Creating " .. #packData .. " pack buttons")
    
    for _, data in ipairs(packData) do
        -- Validate coordinates
        if not data.x or data.x < 0 or data.x > 1 or not data.y or data.y < 0 or data.y > 1 then
            RDT:PrintError(string.format(L["ERROR_INVALID_COORDS"], data.id or 0))
            return
        end
        
        local button = self:CreatePackButton(data, mapWidth, mapHeight)
        RDT.State.packButtons["pack" .. data.id] = button
    end
    
    -- Update labels after all buttons created
    self:UpdateLabels()
    
    RDT:DebugPrint("Pack buttons created successfully")
end

--- Create a single pack button
-- @param data table Pack data {id, x, y, count}
-- @param mapWidth number Map width for positioning
-- @param mapHeight number Map height for positioning
-- @return Frame The created button
function UI:CreatePackButton(data, mapWidth, mapHeight)
    local button = CreateFrame("Button", "RDT_Pack" .. data.id, UI.mapContainer)
    button:SetSize(PACK_BUTTON_SIZE, PACK_BUTTON_SIZE)
    button:SetPoint("CENTER", UI.mapTexture, "BOTTOMLEFT", data.x * mapWidth, data.y * mapHeight)
    button.packId = data.id
    button.count = data.count or 0

    -- Background circle
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(PACK_BUTTON_SIZE, PACK_BUTTON_SIZE)
    bg:SetPoint("CENTER")
    bg:SetTexture("Interface\\AddOns\\ReinDungeonTools\\Textures\\PackCircle")
    bg:SetVertexColor(0.2, 0.2, 0.2, 0.8)
    button.bg = bg

    -- Icon (skull)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(PACK_ICON_SIZE, PACK_ICON_SIZE)
    icon:SetPoint("CENTER")
    icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_7") -- Skull
    button.icon = icon

    -- Selection highlight
    local highlight = button:CreateTexture(nil, "OVERLAY")
    highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    highlight:SetBlendMode("ADD")
    highlight:SetSize(PACK_HIGHLIGHT_SIZE, PACK_HIGHLIGHT_SIZE)
    highlight:SetPoint("CENTER")
    highlight:Hide()
    button.highlight = highlight

    -- Pull number label (center)
    local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("CENTER", 0, 0)
    label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    label:SetTextColor(1, 1, 1)
    button.label = label

    -- Pack ID label (below button)
    local idLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    idLabel:SetPoint("TOP", button, "BOTTOM", 0, 2)
    idLabel:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
    idLabel:SetText(tostring(data.id))
    idLabel:SetTextColor(0.7, 0.7, 0.7)
    button.idLabel = idLabel

    -- Set up interaction
    self:SetupPackButtonHandlers(button)

    return button
end

--------------------------------------------------------------------------------
-- Pack Button Interaction
--------------------------------------------------------------------------------

--- Set up click and tooltip handlers for a pack button
-- @param button Frame The pack button
function UI:SetupPackButtonHandlers(button)
    -- Click handler
    button:SetScript("OnClick", function(self, mouseButton)
        UI:OnPackButtonClick(self, mouseButton)
    end)

    -- Register for clicks
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    -- Tooltip handlers
    button:SetScript("OnEnter", function(self)
        UI:OnPackButtonEnter(self)
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

--- Handle pack button click
-- @param button Frame The clicked button
-- @param mouseButton string "LeftButton" or "RightButton"
function UI:OnPackButtonClick(button, mouseButton)
    local packId = button.packId
    
    if mouseButton == "RightButton" then
        -- Right-click: Remove from pull
        if RDT.RouteManager then
            RDT.RouteManager:UnassignPack(packId)
        end
    else
        -- Left-click: Toggle selection
        self:TogglePackSelection(packId, button)
    end
end

--- Toggle pack selection state
-- @param packId number Pack ID
-- @param button Frame Pack button frame
function UI:TogglePackSelection(packId, button)
    local idx = nil
    
    -- Find if already selected
    for i, id in ipairs(RDT.State.selectedPacks) do
        if id == packId then
            idx = i
            break
        end
    end
    
    if idx then
        -- Deselect
        tremove(RDT.State.selectedPacks, idx)
        button.highlight:Hide()
    else
        -- Select
        tinsert(RDT.State.selectedPacks, packId)
        button.highlight:Show()
    end
    
    self:UpdateGroupButton()
end

--- Show tooltip when hovering over pack button
-- @param button Frame The pack button
function UI:OnPackButtonEnter(button)
    GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
    GameTooltip:SetText(L["PACK"] .. " " .. button.packId, 1, 1, 1, 1, true)
    GameTooltip:AddLine(L["ENEMY_FORCES"] .. ": " .. button.count .. "%", 1, 1, 1)
    
    -- Show current pull assignment if any
    if RDT.State.currentRoute then
        local pullNum = RDT.State.currentRoute.pulls[button.packId]
        if pullNum then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Assigned to " .. L["PULL"] .. " " .. pullNum, unpack(RDT:GetPullColor(pullNum)))
        end
    end
    
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["TOOLTIP_CLICK_SELECT"], 0.5, 0.5, 0.5)
    GameTooltip:AddLine(L["TOOLTIP_RIGHT_CLICK"], 0.5, 0.5, 0.5)
    GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- Pack Button Visual Updates
--------------------------------------------------------------------------------

--- Update all pack labels with pull numbers and colors
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

--- Update a single pack button's label
-- @param packId number Pack ID to update
function UI:UpdatePackLabel(packId)
    if not RDT.State.currentRoute then return end
    
    local button = RDT.State.packButtons["pack" .. packId]
    if not button then return end
    
    local pullNum = RDT.State.currentRoute.pulls[packId] or 0
    button.pullNum = pullNum
    button.label:SetText(pullNum > 0 and tostring(pullNum) or "")
    button.label:SetTextColor(unpack(RDT:GetPullColor(pullNum)))
end

--- Highlight packs in a specific pull
-- @param pullNum number Pull number to highlight
-- @param enable boolean True to enable, false to disable
function UI:HighlightPull(pullNum, enable)
    if not RDT.State.currentRoute then return end
    
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            local button = RDT.State.packButtons["pack" .. packId]
            if button and button.highlight then
                if enable then
                    button.highlight:Show()
                    button.highlight:SetVertexColor(1, 1, 0, 0.5) -- Yellow tint
                else
                    button.highlight:Hide()
                    button.highlight:SetVertexColor(1, 1, 1, 1) -- Reset
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Selection Management
--------------------------------------------------------------------------------

--- Clear current pack selection
function UI:ClearSelection()
    RDT:DebugPrint("Clearing pack selection")
    
    -- Hide highlights
    for _, id in ipairs(RDT.State.selectedPacks) do
        local button = RDT.State.packButtons["pack" .. id]
        if button then 
            button.highlight:Hide()
        end
    end
    
    -- Clear selection array
    wipe(RDT.State.selectedPacks)
    
    -- Update group button
    self:UpdateGroupButton()
end

--- Select all packs in a pull
-- @param pullNum number Pull number to select
function UI:SelectPull(pullNum)
    if not RDT.State.currentRoute then return end
    
    self:ClearSelection()
    
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            local button = RDT.State.packButtons["pack" .. packId]
            if button then
                tinsert(RDT.State.selectedPacks, packId)
                button.highlight:Show()
            end
        end
    end
    
    self:UpdateGroupButton()
end

--- Select multiple packs by ID
-- @param packIds table Array of pack IDs to select
function UI:SelectPacks(packIds)
    self:ClearSelection()
    
    for _, packId in ipairs(packIds) do
        local button = RDT.State.packButtons["pack" .. packId]
        if button then
            tinsert(RDT.State.selectedPacks, packId)
            button.highlight:Show()
        end
    end
    
    self:UpdateGroupButton()
end

--- Check if a pack is selected
-- @param packId number Pack ID
-- @return boolean True if selected
function UI:IsPackSelected(packId)
    for _, id in ipairs(RDT.State.selectedPacks) do
        if id == packId then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Pack Button Cleanup
--------------------------------------------------------------------------------

--- Clear all pack buttons from the map
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

--- Hide all pack buttons (without destroying)
function UI:HideAllPacks()
    for _, button in pairs(RDT.State.packButtons) do
        if button then
            button:Hide()
        end
    end
end

--- Show all pack buttons
function UI:ShowAllPacks()
    for _, button in pairs(RDT.State.packButtons) do
        if button then
            button:Show()
        end
    end
end

--- Get pack button by ID
-- @param packId number Pack ID
-- @return Frame Pack button or nil
function UI:GetPackButton(packId)
    return RDT.State.packButtons["pack" .. packId]
end

--- Get all pack buttons
-- @return table Map of packId -> button
function UI:GetAllPackButtons()
    return RDT.State.packButtons
end

--------------------------------------------------------------------------------
-- Pack Button Filters (Future Feature)
--------------------------------------------------------------------------------

--- Filter pack buttons by criteria (placeholder for future)
-- @param filterFunc function Filter function(button) returns boolean
function UI:FilterPacks(filterFunc)
    for _, button in pairs(RDT.State.packButtons) do
        if filterFunc(button) then
            button:Show()
        else
            button:Hide()
        end
    end
end

--- Show only unassigned packs
function UI:ShowUnassignedPacks()
    self:FilterPacks(function(button)
        if not RDT.State.currentRoute then return true end
        local pullNum = RDT.State.currentRoute.pulls[button.packId]
        return not pullNum or pullNum == 0
    end)
end

--- Show only assigned packs
function UI:ShowAssignedPacks()
    self:FilterPacks(function(button)
        if not RDT.State.currentRoute then return false end
        local pullNum = RDT.State.currentRoute.pulls[button.packId]
        return pullNum and pullNum > 0
    end)
end

--- Reset pack visibility filter (show all)
function UI:ResetPackFilter()
    self:ShowAllPacks()
end

RDT:DebugPrint("PackButtons.lua loaded")
