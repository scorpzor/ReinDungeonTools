-- UI/IdentifierIcons.lua
-- Handles rendering of identifier icons (doors, stairs, portals, etc.) on the map

local RDT = _G.RDT
if not RDT then
    error("RDT not found!")
end

local UI = RDT.UI
if not UI then
    error("UI module not found!")
end

local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- Constants
local IDENTIFIER_ICON_SIZE = 24  -- Base size for identifier icons

--------------------------------------------------------------------------------
-- Identifier Icon Rendering
--------------------------------------------------------------------------------

--- Create all identifier icons for the current dungeon
function UI:CreateIdentifierIcons()
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName then
        return
    end

    local dungeon = RDT.Data:GetDungeon(dungeonName)
    if not dungeon or not dungeon.identifiers then
        return
    end

    -- Clear existing identifier icons
    self:ClearIdentifierIcons()

    -- Create each identifier icon
    for _, identifierData in ipairs(dungeon.identifiers) do
        self:CreateIdentifierIcon(identifierData)
    end

    -- Draw portal connection lines
    self:DrawPortalConnections(dungeon.identifiers)
end

--- Clear all identifier icons from the map
function UI:ClearIdentifierIcons()
    if RDT.State.identifierButtons then
        for _, button in pairs(RDT.State.identifierButtons) do
            button:Hide()
            button:SetParent(nil)
        end
    end
    RDT.State.identifierButtons = {}

    -- Clear portal connection lines
    if RDT.State.portalLines then
        for _, line in ipairs(RDT.State.portalLines) do
            line:Hide()
            line:SetParent(nil)
        end
    end
    RDT.State.portalLines = {}
end

--- Create a single identifier icon
-- @param data table Identifier data {id, type, x, y, name, description, linkedTo}
function UI:CreateIdentifierIcon(data)
    if not data.id or not data.type or not data.x or not data.y then
        RDT:PrintError("Invalid identifier data: missing required fields")
        return
    end

    -- Validate coordinates
    if data.x < 0 or data.x > 1 or data.y < 0 or data.y > 1 then
        RDT:PrintError(string.format("Invalid identifier coordinates for ID %s: (%.2f, %.2f)",
            tostring(data.id), data.x, data.y))
        return
    end

    -- Get identifier type definition
    local identifierType = RDT.Data:GetIdentifierType(data.type)
    if not identifierType then
        RDT:PrintError("Unknown identifier type: " .. tostring(data.type))
        return
    end

    -- Create button frame
    local button = CreateFrame("Button", "RDT_Identifier" .. data.id, self.mapContainer)

    -- Apply scale from type definition or data override
    local scale = data.scale or identifierType.scale or 1.0
    local iconSize = IDENTIFIER_ICON_SIZE * scale

    button:SetSize(iconSize, iconSize)

    -- Position on map using normalized coordinates
    local mapWidth, mapHeight = self:GetMapDimensions()
    button:SetPoint("CENTER", self.mapTexture, "TOPLEFT",
        data.x * mapWidth,
        -(data.y * mapHeight))

    -- Create icon texture
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(button)
    icon:SetTexture(identifierType.icon)

    -- Store reference data
    button.identifierId = data.id
    button.identifierType = data.type
    button.identifierData = data
    button.typeDefinition = identifierType

    -- Setup interaction handlers
    self:SetupIdentifierIconHandlers(button)

    -- Store button reference
    if not RDT.State.identifierButtons then
        RDT.State.identifierButtons = {}
    end
    RDT.State.identifierButtons[data.id] = button

    button:Show()
end

--- Setup mouse interaction handlers for identifier icons
-- @param button Frame The identifier icon button
function UI:SetupIdentifierIconHandlers(button)
    button:EnableMouse(true)

    -- Tooltip on hover
    button:SetScript("OnEnter", function(self)
        UI:OnIdentifierIconEnter(self)
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

--- Handle mouse enter event for identifier icons
-- @param button Frame The identifier icon button
function UI:OnIdentifierIconEnter(button)
    local data = button.identifierData
    local typeDef = button.typeDefinition

    if not data or not typeDef then
        return
    end

    GameTooltip:SetOwner(button, "ANCHOR_CURSOR")

    -- Use custom name if provided, otherwise use type name
    local displayName = data.name or typeDef.name
    GameTooltip:SetText(displayName, 1, 0.82, 0, 1, true)

    -- Use custom description if provided, otherwise use type description
    local displayDescription = data.description or typeDef.description
    if displayDescription and displayDescription ~= "" then
        GameTooltip:AddLine(displayDescription, 1, 1, 1, true)
    end

    -- Show linked portal information if this is a portal
    if data.type == "portal" and data.linkedTo then
        GameTooltip:AddLine(" ", 1, 1, 1)
        GameTooltip:AddLine("Linked to Portal #" .. data.linkedTo, 0.5, 0.8, 1)
    end

    GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- Portal Connection Lines
--------------------------------------------------------------------------------

--- Draw lines connecting linked portals
-- @param identifiers table Array of identifier data
function UI:DrawPortalConnections(identifiers)
    if not identifiers then
        return
    end

    -- Clear existing lines
    if RDT.State.portalLines then
        for _, line in ipairs(RDT.State.portalLines) do
            line:Hide()
            line:SetParent(nil)
        end
    end
    RDT.State.portalLines = {}

    -- Find all portal pairs
    local portals = {}
    for _, identifier in ipairs(identifiers) do
        if identifier.type == "portal" and identifier.linkedTo then
            portals[identifier.id] = identifier
        end
    end

    -- Draw lines between linked portals
    local drawnPairs = {}
    for id, portal in pairs(portals) do
        local linkedPortal = portals[portal.linkedTo]
        if linkedPortal then
            -- Create a unique key for this pair (sorted to avoid duplicates)
            local pairKey = id < portal.linkedTo and (id .. "_" .. portal.linkedTo) or (portal.linkedTo .. "_" .. id)

            if not drawnPairs[pairKey] then
                self:DrawPortalLine(portal, linkedPortal)
                drawnPairs[pairKey] = true
            end
        end
    end
end

--- Draw a line between two portals
-- @param portal1 table First portal data {x, y, ...}
-- @param portal2 table Second portal data {x, y, ...}
function UI:DrawPortalLine(portal1, portal2)
    local mapWidth, mapHeight = self:GetMapDimensions()

    -- Convert normalized coordinates to screen space
    local x1 = portal1.x * mapWidth
    local y1 = portal1.y * mapHeight
    local x2 = portal2.x * mapWidth
    local y2 = portal2.y * mapHeight

    -- Calculate line properties
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx * dx + dy * dy)

    if length < 1 then
        return  -- Portals are too close
    end

    -- Create dotted line effect with multiple small textures
    local numDots = math.max(5, math.floor(length / 15))  -- One dot every 15 pixels

    for i = 0, numDots do
        local t = i / numDots
        local x = x1 + dx * t
        local y = y1 + dy * t

        -- Create dot texture
        local dot = self.mapContainer:CreateTexture(nil, "OVERLAY")
        dot:SetSize(4, 4)
        dot:SetTexture("Interface\\Buttons\\WHITE8X8")
        dot:SetVertexColor(0.5, 0.8, 1.0, 0.6)  -- Light blue, semi-transparent
        dot:SetPoint("CENTER", self.mapTexture, "TOPLEFT", x, -y)

        table.insert(RDT.State.portalLines, dot)
    end
end
