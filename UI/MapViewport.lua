-- UI/MapViewport.lua
-- Handles map zoom and pan functionality

local RDT = _G.RDT
if not RDT then
    error("RDT not found!")
end

-- MapViewport namespace
RDT.MapViewport = RDT.MapViewport or {}
local MapViewport = RDT.MapViewport

--------------------------------------------------------------------------------
-- Viewport Constructor
--------------------------------------------------------------------------------

--- Create a new map viewport with zoom and pan support
-- @param container Frame The container frame for the map
-- @param mapTexture Texture The map texture to be scaled
-- @return table Viewport object with methods
function MapViewport:Create(container, mapTexture)
    local viewport = {
        -- State
        zoom = 1.0,
        panX = 0,
        panY = 0,
        minZoom = 1.0,
        maxZoom = 5.0,
        isDragging = false,
        dragStartX = 0,
        dragStartY = 0,
        dragStartPanX = 0,
        dragStartPanY = 0,

        -- References
        container = container,
        mapTexture = mapTexture,
        canvas = nil,
    }

    -- Create a clipping frame to contain the canvas
    local clipFrame = CreateFrame("Frame", "RDT_MapClipFrame", container)
    clipFrame:SetAllPoints(container)
    clipFrame:SetFrameLevel(container:GetFrameLevel())
    -- Note: SetClipsChildren() not available in WoW 3.3.5a API

    -- Create the canvas frame inside the clip frame
    viewport.canvas = CreateFrame("Frame", "RDT_MapCanvas", clipFrame)
    viewport.canvas:SetSize(container:GetWidth(), container:GetHeight())
    viewport.canvas:SetPoint("TOPLEFT", clipFrame, "TOPLEFT", 0, 0)
    viewport.canvas:EnableMouse(true)
    viewport.canvas:EnableMouseWheel(true)

    -- Store clip frame reference
    viewport.clipFrame = clipFrame

    -- Reparent map texture to canvas and re-anchor it to fill the canvas
    if mapTexture then
        mapTexture:SetParent(viewport.canvas)
        mapTexture:ClearAllPoints()
        -- Anchor all four corners so the texture scales with the canvas
        mapTexture:SetPoint("TOPLEFT", viewport.canvas, "TOPLEFT", 1, -1)
        mapTexture:SetPoint("BOTTOMRIGHT", viewport.canvas, "BOTTOMRIGHT", -1, 1)
    end

    -- Set up mouse interactions
    self:SetupMouseHandlers(viewport)

    RDT:DebugPrint("Map viewport created")

    return viewport
end

--------------------------------------------------------------------------------
-- Mouse Event Handlers
--------------------------------------------------------------------------------

function MapViewport:SetupMouseHandlers(viewport)
    local canvas = viewport.canvas
    local container = viewport.container

    -- Mouse wheel for zooming (Ctrl+Wheel)
    canvas:SetScript("OnMouseWheel", function(self, delta)
        if IsControlKeyDown() then
            -- Zoom toward center of container for now
            local containerWidth = container:GetWidth()
            local containerHeight = container:GetHeight()
            local centerX = containerWidth / 2
            local centerY = containerHeight / 2

            RDT:DebugPrint(string.format("Container size: %.1fx%.1f, Center: (%.1f, %.1f)",
                containerWidth, containerHeight, centerX, centerY))

            if delta > 0 then
                MapViewport:ZoomIn(viewport, centerX, centerY)
            else
                MapViewport:ZoomOut(viewport, centerX, centerY)
            end
        end
    end)

    -- Left-click drag for panning
    canvas:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            local scale = self:GetEffectiveScale()
            local x, y = GetCursorPosition()
            x = x / scale
            y = y / scale

            MapViewport:StartDrag(viewport, x, y)

            -- Update cursor position during drag
            self:SetScript("OnUpdate", function(self)
                if viewport.isDragging then
                    local cx, cy = GetCursorPosition()
                    cx = cx / scale
                    cy = cy / scale
                    MapViewport:UpdateDrag(viewport, cx, cy)
                end
            end)
        end
    end)

    canvas:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            MapViewport:StopDrag(viewport)
            self:SetScript("OnUpdate", nil)
        end
    end)

    -- Stop dragging if mouse leaves canvas
    canvas:SetScript("OnLeave", function(self)
        if viewport.isDragging then
            MapViewport:StopDrag(viewport)
            self:SetScript("OnUpdate", nil)
        end
    end)
end

--------------------------------------------------------------------------------
-- Zoom Functions
--------------------------------------------------------------------------------

--- Set zoom level (clamped to min/max range)
-- @param viewport table The viewport object
-- @param newZoom number New zoom level
-- @param centerX number Optional X coordinate to zoom towards (container space)
-- @param centerY number Optional Y coordinate to zoom towards (container space)
function MapViewport:SetZoom(viewport, newZoom, centerX, centerY)
    -- Clamp zoom to valid range
    local oldZoom = viewport.zoom
    local clampedZoom = math.max(viewport.minZoom, math.min(viewport.maxZoom, newZoom))

    if clampedZoom ~= oldZoom then
        -- If center point provided, adjust pan to keep that point stationary
        if centerX and centerY then
            local oldPanX = viewport.panX
            local oldPanY = viewport.panY

            -- MDT-style zoom formula adapted for SetPoint:
            -- Calculate scale change ratio
            local scaleChange = clampedZoom / oldZoom

            -- Calculate new pan offset to keep center point stationary
            -- X formula: inverted from MDT (positive moves down/right)
            viewport.panX = oldPanX + (centerX - scaleChange * centerX) / clampedZoom
            -- Y formula: NOT inverted because Y increases downward in WoW
            viewport.panY = oldPanY + (scaleChange * centerY - centerY) / clampedZoom

            RDT:DebugPrint(string.format("Zoom: %.2f -> %.2f (ratio %.2f)",
                oldZoom, clampedZoom, scaleChange))
            RDT:DebugPrint(string.format("Center: (%.1f, %.1f)", centerX, centerY))
            RDT:DebugPrint(string.format("Pan: (%.1f, %.1f) -> (%.1f, %.1f)",
                oldPanX, oldPanY, viewport.panX, viewport.panY))
        end

        -- Update zoom level
        viewport.zoom = clampedZoom

        -- Apply the transform
        self:ApplyTransform(viewport)

        RDT:DebugPrint(string.format("Zoom: %.2fx, Pan: (%.1f, %.1f)",
            viewport.zoom, viewport.panX, viewport.panY))
    end
end

--- Zoom in by a step
-- @param viewport table The viewport object
-- @param centerX number Optional X coordinate to zoom towards
-- @param centerY number Optional Y coordinate to zoom towards
function MapViewport:ZoomIn(viewport, centerX, centerY)
    local newZoom = viewport.zoom * 1.2  -- 20% increase
    self:SetZoom(viewport, newZoom, centerX, centerY)
end

--- Zoom out by a step
-- @param viewport table The viewport object
-- @param centerX number Optional X coordinate to zoom towards
-- @param centerY number Optional Y coordinate to zoom towards
function MapViewport:ZoomOut(viewport, centerX, centerY)
    local newZoom = viewport.zoom / 1.2  -- 20% decrease
    self:SetZoom(viewport, newZoom, centerX, centerY)
end

--- Reset zoom and pan to default
-- @param viewport table The viewport object
function MapViewport:Reset(viewport)
    viewport.zoom = 1.0
    viewport.panX = 0
    viewport.panY = 0
    self:ApplyTransform(viewport)
end

--------------------------------------------------------------------------------
-- Pan Functions
--------------------------------------------------------------------------------

--- Set pan offset
-- @param viewport table The viewport object
-- @param panX number X offset
-- @param panY number Y offset
function MapViewport:SetPan(viewport, panX, panY)
    viewport.panX = panX
    viewport.panY = panY
    self:ApplyTransform(viewport)
end

--- Start dragging to pan
-- @param viewport table The viewport object
-- @param x number Mouse X position
-- @param y number Mouse Y position
function MapViewport:StartDrag(viewport, x, y)
    viewport.isDragging = true
    viewport.dragStartX = x
    viewport.dragStartY = y
    viewport.dragStartPanX = viewport.panX
    viewport.dragStartPanY = viewport.panY
end

--- Update drag position
-- @param viewport table The viewport object
-- @param x number Mouse X position
-- @param y number Mouse Y position
function MapViewport:UpdateDrag(viewport, x, y)
    if not viewport.isDragging then return end

    local deltaX = x - viewport.dragStartX
    local deltaY = y - viewport.dragStartY

    viewport.panX = viewport.dragStartPanX + deltaX
    viewport.panY = viewport.dragStartPanY + deltaY

    self:ApplyTransform(viewport)
end

--- Stop dragging
-- @param viewport table The viewport object
function MapViewport:StopDrag(viewport)
    viewport.isDragging = false
end

--------------------------------------------------------------------------------
-- Transform Application
--------------------------------------------------------------------------------

--- Apply current zoom and pan to the map canvas
-- @param viewport table The viewport object
function MapViewport:ApplyTransform(viewport)
    if not viewport.canvas then return end

    -- Apply scale to canvas (this scales all children)
    viewport.canvas:SetScale(viewport.zoom)

    -- Apply pan offset directly without division
    viewport.canvas:ClearAllPoints()
    viewport.canvas:SetPoint("TOPLEFT", viewport.clipFrame, "TOPLEFT",
        viewport.panX, viewport.panY)

    -- Trigger UI refresh if callback exists
    if RDT.UI and RDT.UI.RefreshPackButtons then
        RDT.UI:RefreshPackButtons()
    end
    if RDT.UI and RDT.UI.CreateIdentifierIcons then
        RDT.UI:CreateIdentifierIcons()
    end
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

--- Get current viewport state
-- @param viewport table The viewport object
-- @return table Viewport state {zoom, panX, panY}
function MapViewport:GetState(viewport)
    return {
        zoom = viewport.zoom,
        panX = viewport.panX,
        panY = viewport.panY
    }
end

--- Get the canvas frame
-- @param viewport table The viewport object
-- @return Frame The canvas frame
function MapViewport:GetCanvas(viewport)
    return viewport.canvas
end

RDT:DebugPrint("MapViewport module loaded")
