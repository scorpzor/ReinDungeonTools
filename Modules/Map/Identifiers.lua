-- Modules/Map/Identifiers.lua
-- Rendering of identifier icons (doors, stairs, portals, etc.) on the map

local RDT = _G.RDT
if not RDT then
    error("RDT not found!")
end

local UI = RDT.UI
if not UI then
    error("UI module not found!")
end

local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

local UIHelpers = RDT.UIHelpers

-- Constants
local IDENTIFIER_ICON_SIZE = 32  -- Base size for identifier icons

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
    if RDT.State.identifierLines then
        for _, line in ipairs(RDT.State.identifierLines) do
            line:Hide()
            line:ClearAllPoints()
            -- Return to pool for reuse
            table.insert(lineTexturePool, line)
        end
    end
    RDT.State.identifierLines = {}
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

    -- Try to reuse a frame from the pool
    local frame = table.remove(identifierButtonPool)
    if not frame then
        -- No pooled frame available, create a new one
        frame = CreateFrame("Frame", nil, self.mapCanvas)

        local icon = frame:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(frame)
        local atlasTexture = RDT.Atlases:GetIdentifierAtlasTexture()
        icon:SetTexture(atlasTexture)
        frame.icon = icon
    end

    -- Reset frame parent in case it was pooled
    frame:SetParent(self.mapCanvas)
    frame:ClearAllPoints()

    -- Apply scale from type definition or data override
    local scale = data.scale or identifierType.scale or 1.0
    local iconSize = IDENTIFIER_ICON_SIZE * scale

    frame:SetSize(iconSize, iconSize)

    -- Position on map using normalized coordinates
    local mapWidth, mapHeight = self:GetMapDimensions()
    frame:SetPoint("CENTER", self.mapTexture, "TOPLEFT",
        data.x * mapWidth,
        -(data.y * mapHeight))

    if identifierType.texCoords then
        frame.icon:SetTexCoord(unpack(identifierType.texCoords))
    else
        frame.icon:SetTexCoord(0, 1, 0, 1)
    end

    -- Store reference data
    frame.identifierId = data.id
    frame.identifierType = data.type
    frame.identifierData = data
    frame.typeDefinition = identifierType

    -- Setup interaction handlers
    self:SetupIdentifierIconHandlers(frame)

    -- Store frame reference
    if not RDT.State.identifierButtons then
        RDT.State.identifierButtons = {}
    end
    RDT.State.identifierButtons[data.id] = frame

    frame:Show()
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
    if RDT.State.identifierLines then
        for _, line in ipairs(RDT.State.identifierLines) do
            line:Hide()
            line:SetParent(nil)
        end
    end
    RDT.State.identifierLines = {}

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

    UIHelpers:DrawDottedLine({
        mapCanvas = self.mapCanvas,
        mapTexture = self.mapTexture,
        x1 = x1,
        y1 = y1,
        x2 = x2,
        y2 = y2,
        texturePool = lineTexturePool,
        outputTable = RDT.State.identifierLines,
        dotSize = 4,
        dotSpacing = 15,
        color = {0.5, 0.8, 1.0, 0.6}
    })
end
