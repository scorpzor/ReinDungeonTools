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

-- Object pools for reusing frames/textures
local identifierButtonPool = {}
local lineTexturePool = {}

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

    -- Draw connection lines between linked identifiers
    self:DrawIdentifierConnections(dungeon.identifiers)
end

--- Clear all identifier icons from the map
function UI:ClearIdentifierIcons()
    -- Return buttons to pool
    if RDT.State.identifierButtons then
        for _, button in pairs(RDT.State.identifierButtons) do
            button:Hide()
            button:ClearAllPoints()
            -- Clear references
            button.identifierId = nil
            button.identifierType = nil
            button.identifierData = nil
            button.typeDefinition = nil
            -- Return to pool for reuse
            table.insert(identifierButtonPool, button)
        end
    end
    RDT.State.identifierButtons = {}

    -- Return line textures to pool
    if RDT.State.portalLines then
        for _, line in ipairs(RDT.State.portalLines) do
            line:Hide()
            line:ClearAllPoints()
            -- Return to pool for reuse
            table.insert(lineTexturePool, line)
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

    local identifierType = RDT.Data:GetIdentifierType(data.type)
    if not identifierType then
        RDT:PrintError("Unknown identifier type: " .. tostring(data.type))
        return
    end

    -- Try to reuse a button from the pool
    local button = table.remove(identifierButtonPool)
    if not button then
        -- No pooled button available, create a new one
        button = CreateFrame("Button", nil, self.mapContainer)

        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(button)
        local atlasTexture = RDT.Data:GetIdentifierAtlasTexture()
        icon:SetTexture(atlasTexture)
        button.icon = icon
    end

    -- Reset button parent in case it was pooled
    button:SetParent(self.mapContainer)
    button:ClearAllPoints()

    -- Apply scale from type definition or data override
    local scale = data.scale or identifierType.scale or 1.0
    local iconSize = IDENTIFIER_ICON_SIZE * scale

    button:SetSize(iconSize, iconSize)

    -- Position on map using normalized coordinates
    local mapWidth, mapHeight = self:GetMapDimensions()
    button:SetPoint("CENTER", self.mapTexture, "TOPLEFT",
        data.x * mapWidth,
        -(data.y * mapHeight))

    if identifierType.texCoords then
        button.icon:SetTexCoord(unpack(identifierType.texCoords))
    else
        button.icon:SetTexCoord(0, 1, 0, 1)
    end

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

    -- Show linked identifier information
    if data.linkedTo then
        GameTooltip:AddLine(" ", 1, 1, 1)

        -- Get friendly name based on identifier type
        local linkTypeName = "Identifier"
        if data.type == "portal" then
            linkTypeName = "Portal"
        elseif data.type == "stairs-up" or data.type == "stairs-down" or data.type == "stairs" then
            linkTypeName = "Stairs"
        elseif data.type == "door-in" or data.type == "door-out" or data.type == "door" then
            linkTypeName = "Door"
        end

        GameTooltip:AddLine("Linked to " .. linkTypeName .. " #" .. data.linkedTo, 0.5, 0.8, 1)
    end

    GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- Identifier Connection Lines
--------------------------------------------------------------------------------

--- Draw lines connecting linked identifiers (portals, stairs, doors, etc.)
-- @param identifiers table Array of identifier data
function UI:DrawIdentifierConnections(identifiers)
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

    -- Find all identifiers with links
    local linkedIdentifiers = {}
    for _, identifier in ipairs(identifiers) do
        if identifier.linkedTo then
            linkedIdentifiers[identifier.id] = identifier
        end
    end

    -- Draw lines between linked identifiers
    local drawnPairs = {}
    for id, identifier in pairs(linkedIdentifiers) do
        local linkedIdentifier = linkedIdentifiers[identifier.linkedTo]
        if linkedIdentifier then
            -- Create a unique key for this pair (sorted to avoid duplicates)
            local pairKey = id < identifier.linkedTo and (id .. "_" .. identifier.linkedTo) or (identifier.linkedTo .. "_" .. id)

            if not drawnPairs[pairKey] then
                self:DrawConnectionLine(identifier, linkedIdentifier)
                drawnPairs[pairKey] = true
            end
        end
    end
end

--- Draw a line between two linked identifiers
-- @param identifier1 table First identifier data {x, y, type, ...}
-- @param identifier2 table Second identifier data {x, y, type, ...}
function UI:DrawConnectionLine(identifier1, identifier2)
    local mapWidth, mapHeight = self:GetMapDimensions()

    -- Convert normalized coordinates to screen space
    local x1 = identifier1.x * mapWidth
    local y1 = identifier1.y * mapHeight
    local x2 = identifier2.x * mapWidth
    local y2 = identifier2.y * mapHeight

    -- Calculate line properties
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx * dx + dy * dy)

    if length < 1 then
        return  -- Identifiers are too close
    end

    -- Create dotted line effect with multiple small textures
    local numDots = math.max(5, math.floor(length / 15))  -- One dot every 15 pixels

    for i = 0, numDots do
        local t = i / numDots
        local x = x1 + dx * t
        local y = y1 + dy * t

        -- Try to reuse a texture from the pool, or create a new one
        local dot = table.remove(lineTexturePool)
        if not dot then
            -- No pooled texture available, create a new one
            dot = self.mapContainer:CreateTexture(nil, "OVERLAY")
            dot:SetSize(4, 4)
            dot:SetTexture("Interface\\Buttons\\WHITE8X8")
        end

        -- Update properties
        dot:ClearAllPoints()
        dot:SetVertexColor(0.5, 0.8, 1.0, 0.6)  -- Light blue, semi-transparent
        dot:SetPoint("CENTER", self.mapTexture, "TOPLEFT", x, -y)
        dot:Show()

        table.insert(RDT.State.portalLines, dot)
    end
end
