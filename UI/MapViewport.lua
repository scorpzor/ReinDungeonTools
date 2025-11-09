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
        scrollH = 0,
        scrollV = 0,
        maxScrollH = 0,
        maxScrollV = 0,
        minZoom = 1.0,
        maxZoom = 5.0,
        isDragging = false,
        dragStartX = 0,
        dragStartY = 0,
        dragStartScrollH = 0,
        dragStartScrollV = 0,

        -- References
        container = container,
        mapTexture = mapTexture,
        scrollFrame = nil,
        canvas = nil,
    }

    local scrollFrame = CreateFrame("ScrollFrame", "RDT_MapScrollFrame", container)
    scrollFrame:SetAllPoints(container)
    scrollFrame:EnableMouse(true)
    scrollFrame:EnableMouseWheel(true)
    viewport.scrollFrame = scrollFrame

    viewport.canvas = CreateFrame("Frame", "RDT_MapCanvas", scrollFrame)
    viewport.canvas:SetSize(container:GetWidth(), container:GetHeight())

    scrollFrame:SetScrollChild(viewport.canvas)

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

    RDT:DebugPrint("Map viewport created with ScrollFrame clipping")

    return viewport
end

--------------------------------------------------------------------------------
-- Mouse Event Handlers
--------------------------------------------------------------------------------

function MapViewport:SetupMouseHandlers(viewport)
    local scrollFrame = viewport.scrollFrame
    local container = viewport.container

    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        if IsControlKeyDown() then
            -- Get cursor position relative to scroll frame
            local scale = UIParent:GetEffectiveScale()
            local cursorX, cursorY = GetCursorPosition()
            cursorX = cursorX / scale
            cursorY = cursorY / scale

            local frameLeft = scrollFrame:GetLeft()
            local frameTop = scrollFrame:GetTop()

            -- Calculate cursor position relative to scroll frame
            local relativeX = cursorX - frameLeft
            local relativeY = frameTop - cursorY

            if delta > 0 then
                MapViewport:ZoomIn(viewport, relativeX, relativeY)
            else
                MapViewport:ZoomOut(viewport, relativeX, relativeY)
            end
        end
    end)

    scrollFrame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            local scale = UIParent:GetEffectiveScale()
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

    scrollFrame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            MapViewport:StopDrag(viewport)
            self:SetScript("OnUpdate", nil)
        end
    end)

    scrollFrame:SetScript("OnLeave", function(self)
        if viewport.isDragging then
            MapViewport:StopDrag(viewport)
            self:SetScript("OnUpdate", nil)
        end
    end)
end

--------------------------------------------------------------------------------
-- Zoom Functions
--------------------------------------------------------------------------------

--- Set zoom level
-- @param viewport table The viewport object
-- @param newZoom number New zoom level
-- @param centerX number Optional X coordinate to zoom towards (scroll frame space)
-- @param centerY number Optional Y coordinate to zoom towards (scroll frame space)
function MapViewport:SetZoom(viewport, newZoom, centerX, centerY)
    -- Clamp zoom to valid range
    local oldZoom = viewport.zoom
    local clampedZoom = math.max(viewport.minZoom, math.min(viewport.maxZoom, newZoom))

    if clampedZoom ~= oldZoom then
        -- If zooming to 1.0x, reset to center position
        if clampedZoom == 1.0 then
            viewport.scrollH = 0
            viewport.scrollV = 0
        -- Otherwise, adjust scroll to keep zoom point stationary
        elseif centerX and centerY then
            local oldScrollH = viewport.scrollH
            local oldScrollV = viewport.scrollV

            local scaleChange = clampedZoom / oldZoom

            -- Calculate new scroll position to keep zoom point stationary
            viewport.scrollH = (scaleChange * centerX - centerX) / clampedZoom + oldScrollH
            viewport.scrollV = (scaleChange * centerY - centerY) / clampedZoom + oldScrollV
        end

        -- Update zoom level
        viewport.zoom = clampedZoom

        -- Apply the transform
        self:ApplyTransform(viewport)
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
    viewport.scrollH = 0
    viewport.scrollV = 0
    self:ApplyTransform(viewport)
end

--------------------------------------------------------------------------------
-- Pan Functions
--------------------------------------------------------------------------------

--- Set scroll offset
-- @param viewport table The viewport object
-- @param scrollH number Horizontal scroll offset
-- @param scrollV number Vertical scroll offset
function MapViewport:SetScroll(viewport, scrollH, scrollV)
    viewport.scrollH = scrollH
    viewport.scrollV = scrollV
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
    viewport.dragStartScrollH = viewport.scrollH
    viewport.dragStartScrollV = viewport.scrollV
end

--- Update drag position
-- @param viewport table The viewport object
-- @param x number Mouse X position
-- @param y number Mouse Y position
function MapViewport:UpdateDrag(viewport, x, y)
    if not viewport.isDragging then return end

    local deltaX = x - viewport.dragStartX
    local deltaY = y - viewport.dragStartY

    -- For ScrollFrame, dragging right/down should decrease scroll
    viewport.scrollH = viewport.dragStartScrollH - deltaX / viewport.zoom
    viewport.scrollV = viewport.dragStartScrollV + deltaY / viewport.zoom

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

--- Apply current zoom and scroll to the map canvas
-- @param viewport table The viewport object
function MapViewport:ApplyTransform(viewport)
    if not viewport.canvas or not viewport.scrollFrame then return end

    -- Apply scale to canvas (this scales all children)
    viewport.canvas:SetScale(viewport.zoom)

    -- Calculate scroll boundaries
    local canvasWidth = viewport.canvas:GetWidth() * viewport.zoom
    local canvasHeight = viewport.canvas:GetHeight() * viewport.zoom
    local frameWidth = viewport.scrollFrame:GetWidth()
    local frameHeight = viewport.scrollFrame:GetHeight()

    viewport.maxScrollH = math.max(0, (canvasWidth - frameWidth) / viewport.zoom)
    viewport.maxScrollV = math.max(0, (canvasHeight - frameHeight) / viewport.zoom)

    -- Clamp scroll position to boundaries
    viewport.scrollH = math.max(0, math.min(viewport.scrollH, viewport.maxScrollH))
    viewport.scrollV = math.max(0, math.min(viewport.scrollV, viewport.maxScrollV))

    -- Apply scroll position
    viewport.scrollFrame:SetHorizontalScroll(viewport.scrollH)
    viewport.scrollFrame:SetVerticalScroll(viewport.scrollV)

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
-- @return table Viewport state {zoom, scrollH, scrollV}
function MapViewport:GetState(viewport)
    return {
        zoom = viewport.zoom,
        scrollH = viewport.scrollH,
        scrollV = viewport.scrollV
    }
end

--- Get the canvas frame
-- @param viewport table The viewport object
-- @return Frame The canvas frame
function MapViewport:GetCanvas(viewport)
    return viewport.canvas
end

RDT:DebugPrint("MapViewport module loaded (ScrollFrame version)")
