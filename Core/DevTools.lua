-- DevTools.lua
-- Development and debugging tools for ReinDungeonTools
-- Provides utilities for easier content creation and debugging

local RDT = _G.RDT
if not RDT then
    error("RDT object not found! DevTools.lua must load after Core/Init.lua")
end

-- DevTools namespace
RDT.DevTools = {}
local DevTools = RDT.DevTools

-- State
local coordPickerEnabled = false
local coordPickerFrame = nil
local coordPickerLabel = nil
local crosshair = nil

--------------------------------------------------------------------------------
-- Coordinate Picker
--------------------------------------------------------------------------------

--- Create visual indicator for coordinate picker mode
local function CreateCoordPickerUI()
    if coordPickerFrame then return end
    
    local UI = RDT.UI
    if not UI or not UI.mapContainer then
        RDT:PrintError("Cannot create coordinate picker - UI not initialized")
        return
    end
    
    -- Status label (top-right corner of map)
    coordPickerLabel = UI.mapContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    coordPickerLabel:SetPoint("TOPRIGHT", UI.mapContainer, "TOPRIGHT", -10, -10)
    coordPickerLabel:SetText("|cFF00FF00Coordinate Picker Active|r\nClick map for coordinates")
    coordPickerLabel:SetJustifyH("RIGHT")
    coordPickerLabel:Hide()
    
    -- Crosshair indicator (follows mouse)
    crosshair = CreateFrame("Frame", "RDT_CoordPickerCrosshair", UI.mapContainer)
    crosshair:SetSize(32, 32)
    crosshair:SetFrameLevel(UI.mapContainer:GetFrameLevel() + 100)
    
    -- Create crosshair texture
    local hLine = crosshair:CreateTexture(nil, "OVERLAY")
    hLine:SetColorTexture(0, 1, 0, 0.8)
    hLine:SetSize(24, 2)
    hLine:SetPoint("CENTER")
    
    local vLine = crosshair:CreateTexture(nil, "OVERLAY")
    vLine:SetColorTexture(0, 1, 0, 0.8)
    vLine:SetSize(2, 24)
    vLine:SetPoint("CENTER")
    
    local center = crosshair:CreateTexture(nil, "OVERLAY")
    center:SetColorTexture(1, 1, 0, 1)
    center:SetSize(4, 4)
    center:SetPoint("CENTER")
    
    crosshair:Hide()
    
    coordPickerFrame = crosshair
end

--- Update crosshair position to follow mouse
local function UpdateCrosshairPosition(mapTexture)
    if not crosshair or not crosshair:IsShown() then return end
    
    local container = RDT.UI.mapContainer
    if not container then return end
    
    local scale = container:GetEffectiveScale()
    local left = container:GetLeft()
    local top = container:GetTop()
    local width = container:GetWidth()
    local height = container:GetHeight()
    
    if not left or not top or not width or not height then return end
    
    local cursorX, cursorY = GetCursorPosition()
    cursorX = cursorX / scale
    cursorY = cursorY / scale
    
    -- Check if cursor is over the map container
    local right = left + width
    local bottom = top - height
    
    if cursorX >= left and cursorX <= right and cursorY >= bottom and cursorY <= top then
        -- Position crosshair at cursor (relative to container TOPLEFT)
        local relX = cursorX - left
        local relY = top - cursorY
        -- Clear previous point to avoid anchoring issues
        crosshair:ClearAllPoints()
        crosshair:SetPoint("CENTER", container, "TOPLEFT", relX, -relY)
        crosshair:SetAlpha(1)
    else
        -- Fade out when not over map
        crosshair:SetAlpha(0.3)
    end
end

--- Enable coordinate picker mode
function DevTools:EnableCoordinatePicker()
    local UI = RDT.UI
    if not UI or not UI.mapTexture then
        RDT:PrintError("Cannot enable coordinate picker - map not loaded. Open a dungeon first.")
        return false
    end
    
    -- Create UI if needed
    CreateCoordPickerUI()
    
    if coordPickerEnabled then
        RDT:Print("Coordinate picker is already enabled")
        return true
    end
    
    coordPickerEnabled = true
    
    -- Show indicators
    if coordPickerLabel then coordPickerLabel:Show() end
    if crosshair then crosshair:Show() end

    -- Disable drag detection while coord picker is active
    if UI.mapViewport and UI.mapViewport.DisableDragDetection then
        UI.mapViewport.DisableDragDetection()
    end

    -- Enable mouse interaction on map container (textures don't support mouse events)
    UI.mapContainer:EnableMouse(true)

    -- Click handler (on container, but calculate relative to texture)
    UI.mapContainer:SetScript("OnMouseDown", function(frame, button)
        if not coordPickerEnabled then return end
        
        if button == "LeftButton" then
            -- Calculate coordinates to match pack positioning system
            -- The texture is STRETCHED to fill the container (SetPoint to both TOPLEFT and TOPRIGHT)
            -- So we use CONTAINER dimensions for calculations, with border offsets
            -- Packs use: SetPoint("CENTER", UI.mapTexture, "TOPLEFT", data.x * mapWidth, -(data.y * mapHeight))
            
            local container = UI.mapContainer
            local mapTex = UI.mapTexture
            
            local scale = container:GetEffectiveScale()
            
            -- Get container position and size
            local containerLeft = container:GetLeft()
            local containerTop = container:GetTop()
            local mapWidth, mapHeight = UI:GetMapDimensions()
            
            if not containerLeft or not containerTop or not mapWidth or not mapHeight then
                RDT:PrintError("Cannot calculate coordinates - invalid dimensions")
                return
            end
            
            -- The texture is inset by 1 pixel border (see MainFrame.lua:481)
            local borderInset = 1
            local renderLeft = containerLeft + borderInset
            local renderTop = containerTop - borderInset
            local renderWidth = mapWidth - (borderInset * 2)
            local renderHeight = mapHeight - (borderInset * 2)
            
            local cursorX, cursorY = GetCursorPosition()
            cursorX = cursorX / scale
            cursorY = cursorY / scale
            
            -- Calculate position relative to the rendered texture area
            local relX = cursorX - renderLeft
            local relY = renderTop - cursorY
            
            -- Convert to normalized coordinates (0-1)
            local normX = relX / renderWidth
            local normY = relY / renderHeight
            
            -- Debug output
            if RDT.db.profile.debug then
                print(string.format("|cFFFF8800[DEBUG]|r Container: %.0fx%.0f, Render area: %.0fx%.0f", 
                                  mapWidth, mapHeight, renderWidth, renderHeight))
                print(string.format("|cFFFF8800[DEBUG]|r RenderLeft: %.0f, ContainerLeft: %.0f", 
                                  renderLeft, containerLeft))
                print(string.format("|cFFFF8800[DEBUG]|r Cursor: (%.0f, %.0f), Relative: (%.0f, %.0f)", 
                                  cursorX, cursorY, relX, relY))
                print(string.format("|cFFFF8800[DEBUG]|r Normalized: x=%.3f (%.0f/%.0f), y=%.3f (%.0f/%.0f)",
                                  normX, relX, renderWidth, normY, relY, renderHeight))
            end
            
            -- Clamp to valid range
            normX = math.max(0, math.min(1, normX))
            normY = math.max(0, math.min(1, normY))
            
            -- Format output for easy copy/paste
            local coordString = string.format("x = %.3f, y = %.3f", normX, normY)
            
            -- Print to chat with visual formatting
            print("|cFF00FF00[RDT Coordinates]|r " .. coordString)
            
            -- Also show as a more complete pack entry template
            print("  |cFFFFFF00{ id = ?, x = " .. string.format("%.3f", normX) .. 
                  ", y = " .. string.format("%.3f", normY) .. ", mobs = {} }|r")
            
            -- Visual feedback
            PlaySound(SOUNDKIT.ACHIEVEMENT_MENU_OPEN)
            
        elseif button == "RightButton" then
            -- Right-click to disable
            DevTools:DisableCoordinatePicker()
        end
    end)
    
    -- Update crosshair position on mouse move
    UI.mapContainer:SetScript("OnUpdate", function(frame)
        if coordPickerEnabled then
            UpdateCrosshairPosition(UI.mapTexture)
        end
    end)
    
    RDT:Print("|cFF00FF00Coordinate Picker enabled!|r")
    RDT:Print("  • |cFFFFFF00Left-click|r on map to get coordinates")
    RDT:Print("  • |cFFFFFF00Right-click|r map or type |cFFFFFF00/rdt coords|r again to disable")
    
    return true
end

--- Disable coordinate picker mode
function DevTools:DisableCoordinatePicker()
    if not coordPickerEnabled then
        RDT:Print("Coordinate picker is already disabled")
        return
    end
    
    coordPickerEnabled = false
    
    -- Hide indicators
    if coordPickerLabel then coordPickerLabel:Hide() end
    if crosshair then crosshair:Hide() end
    
    -- Restore map mouse behavior
    local UI = RDT.UI
    if UI and UI.mapContainer then
        UI.mapContainer:EnableMouse(false)
        UI.mapContainer:SetScript("OnMouseDown", nil)
        UI.mapContainer:SetScript("OnUpdate", nil)
    end

    -- Re-enable drag detection
    if UI.mapViewport and UI.mapViewport.EnableDragDetection then
        UI.mapViewport.EnableDragDetection()
    end

    RDT:Print("|cFFFF0000Coordinate Picker disabled|r")
end

--- Toggle coordinate picker mode
function DevTools:ToggleCoordinatePicker()
    if coordPickerEnabled then
        self:DisableCoordinatePicker()
    else
        self:EnableCoordinatePicker()
    end
end

--- Check if coordinate picker is enabled
function DevTools:IsCoordinatePickerEnabled()
    return coordPickerEnabled
end

--------------------------------------------------------------------------------
-- Grid Overlay (Future Feature)
--------------------------------------------------------------------------------

function DevTools:ShowCoordinateGrid()
    RDT:Print("Coordinate grid overlay coming soon!")
    -- TODO: Implement 10x10 grid with labeled axes
end

function DevTools:HideCoordinateGrid()
    -- TODO: Implement
end

--------------------------------------------------------------------------------
-- Coordinate Utilities
--------------------------------------------------------------------------------

--- Snap coordinate to grid
-- @param coord number Coordinate value (0-1)
-- @param gridSize number Grid increment size (default 0.05 = 5%)
-- @return number Snapped coordinate
function DevTools:SnapToGrid(coord, gridSize)
    gridSize = gridSize or 0.05
    return math.floor(coord / gridSize + 0.5) * gridSize
end

--- Format coordinates for pack data
-- @param x number X coordinate (0-1)
-- @param y number Y coordinate (0-1)
-- @param packId number Pack ID (optional)
-- @return string Formatted pack entry
function DevTools:FormatPackEntry(x, y, packId)
    packId = packId or "?"
    return string.format("{ id = %s, x = %.3f, y = %.3f, mobs = {} }", 
                        tostring(packId), x, y)
end

--------------------------------------------------------------------------------
-- Debug Info
--------------------------------------------------------------------------------

--- Print current map dimensions and info
function DevTools:PrintMapInfo()
    local UI = RDT.UI
    if not UI or not UI.mapTexture then
        RDT:PrintError("No map loaded")
        return
    end
    
    local width = UI.mapTexture:GetWidth()
    local height = UI.mapTexture:GetHeight()
    -- Use container's scale (textures don't have GetEffectiveScale)
    local scale = UI.mapContainer:GetEffectiveScale()
    
    RDT:Print("=== Map Information ===")
    RDT:Print(string.format("  Size: %.0f x %.0f pixels", width, height))
    RDT:Print(string.format("  Scale: %.2f", scale))
    RDT:Print(string.format("  Aspect Ratio: %.2f", width / height))
    
    local dungeon = RDT.State.currentDungeon
    if dungeon then
        RDT:Print(string.format("  Current Dungeon: %s", dungeon))
        
        local data = RDT.Data:GetDungeon(dungeon)
        if data then
            if data.texture then
                RDT:Print("  Type: Single texture")
            elseif data.tiles then
                RDT:Print(string.format("  Type: Tiled (%dx%d)", 
                                      data.tiles.cols or 0, data.tiles.rows or 0))
            end
        end
    end
end

--- Print all packs and their coordinates
function DevTools:ListPackCoordinates()
    local dungeon = RDT.State.currentDungeon
    if not dungeon then
        RDT:PrintError("No dungeon loaded")
        return
    end
    
    local data = RDT.Data:GetDungeon(dungeon)
    if not data or not data.packData then
        RDT:PrintError("No pack data found")
        return
    end
    
    RDT:Print(string.format("=== Pack Coordinates for %s ===", dungeon))
    for _, pack in ipairs(data.packData) do
        RDT:Print(string.format("  Pack %d: x=%.3f, y=%.3f", 
                               pack.id, pack.x or 0, pack.y or 0))
    end
end

RDT:DebugPrint("DevTools module loaded")

