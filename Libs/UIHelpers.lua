-- Libs/UIHelpers.lua
-- Reusable UI component library (buttons, dropdowns, scrollbars, etc.)

local RDT = _G.RDT

-- UIHelpers namespace
RDT.UIHelpers = RDT.UIHelpers or {}
local UIHelpers = RDT.UIHelpers

local scrollbarAtlas, dropdownAtlas

local function GetScrollbarAtlas()
    if not scrollbarAtlas then
        scrollbarAtlas = RDT.Atlases and RDT.Atlases:GetScrollbarAtlas() or {}
    end
    return scrollbarAtlas
end

local function GetDropdownAtlas()
    if not dropdownAtlas then
        dropdownAtlas = RDT.Atlases and RDT.Atlases:GetDropdownAtlas() or {}
    end
    return dropdownAtlas
end

--------------------------------------------------------------------------------
-- Button Styling
--------------------------------------------------------------------------------

--- Style a button with modern square gray appearance
-- @param button Button Button to style
function UIHelpers:StyleSquareButton(button)
    button:SetNormalFontObject("GameFontNormal")
    button:SetHighlightFontObject("GameFontHighlight")
    button:SetDisabledFontObject("GameFontDisable")
    
    -- Set backdrop for square gray appearance
    button:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    
    -- Normal state: lighter gray for better visibility
    button:SetBackdropColor(0.25, 0.25, 0.25, 1)
    button:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
    
    -- Hover effect
    button:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.35, 0.35, 0.35, 1)
    end)
    
    button:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.25, 0.25, 0.25, 1)
    end)
    
    -- Pressed state
    button:HookScript("OnMouseDown", function(self)
        self:SetBackdropColor(0.18, 0.18, 0.18, 1)
    end)
    
    button:HookScript("OnMouseUp", function(self)
        self:SetBackdropColor(0.35, 0.35, 0.35, 1)
    end)
end

--- Create a square styled button
-- @param config table Configuration with:
--   - parent: Frame - Parent frame
--   - name: string - Unique name for the button
--   - text: string - Button text
--   - width: number - Button width
--   - height: number - Button height (default 24)
--   - fontSize: number - Font size (default 10)
--   - tooltip: string - Tooltip text (optional)
--   - onClick: function(button) - Click callback
-- @return Button The created button
function UIHelpers:CreateSquareButton(config)
    local button = CreateFrame("Button", config.name, config.parent)
    button:SetSize(config.width or 100, config.height or 24)
    button:SetText(config.text or "")
    button:RegisterForClicks("LeftButtonUp")
    
    self:StyleSquareButton(button)
    
    local fontString = button:GetFontString()
    if fontString then
        fontString:SetFont("Fonts\\FRIZQT__.TTF", config.fontSize or 10, "")
    end
    
    if config.onClick then
        button:SetScript("OnClick", function(self, btn, ...)
            config.onClick(self, btn, ...)
        end)
    end
    
    if config.tooltip then
        button:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.35, 0.35, 0.35, 1)
            
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(config.text, 1, 1, 1)
            GameTooltip:AddLine(config.tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 1)
            
            GameTooltip:Hide()
        end)
    end
    
    return button
end

--- Create a square styled close button
-- @param parent Frame Parent frame
-- @return Button The created close button
function UIHelpers:CreateSquareCloseButton(parent)
    local closeBtn = CreateFrame("Button", nil, parent)
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("TOPRIGHT", -8, -8)

    self:StyleSquareButton(closeBtn)
    
    -- X text
    local text = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetAllPoints()
    text:SetText("×")
    text:SetTextColor(0.8, 0.8, 0.8)
    
    closeBtn:HookScript("OnEnter", function(self)
        text:SetTextColor(1, 0.2, 0.2)  -- Red on hover
    end)
    
    closeBtn:HookScript("OnLeave", function(self)
        text:SetTextColor(0.8, 0.8, 0.8)  -- Gray default
    end)
    
    return closeBtn
end

--------------------------------------------------------------------------------
-- ScrollBar Styling
--------------------------------------------------------------------------------

--- Style a scrollbar
-- @param scrollFrame ScrollFrame The scroll frame to style
function UIHelpers:StyleScrollBar(scrollFrame)
    local scrollbarAtlas = GetScrollbarAtlas()

    -- Try to get scrollbar by name (for named frames) or directly (for unnamed frames)
    local scrollBar
    local frameName = scrollFrame:GetName()

    if frameName then
        -- Named frame - use global lookup
        scrollBar = _G[frameName.."ScrollBar"]
    else
        -- Unnamed frame - try direct property access (UIPanelScrollFrameTemplate)
        scrollBar = scrollFrame.ScrollBar
    end

    if not scrollBar then return end

    -- Get child elements (try both methods)
    local scrollUpButton, scrollDownButton, thumbTexture

    if frameName then
        scrollUpButton = _G[frameName.."ScrollBarScrollUpButton"]
        scrollDownButton = _G[frameName.."ScrollBarScrollDownButton"]
        thumbTexture = _G[frameName.."ScrollBarThumbTexture"]
    else
        scrollUpButton = scrollBar.ScrollUpButton
        scrollDownButton = scrollBar.ScrollDownButton
        thumbTexture = scrollBar.ThumbTexture
    end

    if scrollUpButton then
        scrollUpButton:SetSize(unpack(scrollbarAtlas.size))

        local normalTex = scrollUpButton:CreateTexture(nil, "ARTWORK")
        normalTex:SetAllPoints()
        normalTex:SetTexture(scrollbarAtlas.texture)
        normalTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-up"]))
        scrollUpButton:SetNormalTexture(normalTex)

        local hoverTex = scrollUpButton:CreateTexture(nil, "ARTWORK")
        hoverTex:SetAllPoints()
        hoverTex:SetTexture(scrollbarAtlas.texture)
        hoverTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-up-over"]))
        scrollUpButton:SetHighlightTexture(hoverTex)

        local pushedTex = scrollUpButton:CreateTexture(nil, "ARTWORK")
        pushedTex:SetAllPoints()
        pushedTex:SetTexture(scrollbarAtlas.texture)
        pushedTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-up-down"]))
        scrollUpButton:SetPushedTexture(pushedTex)

        local disabledTex = scrollUpButton:CreateTexture(nil, "ARTWORK")
        disabledTex:SetSize(unpack(scrollbarAtlas.sizeEnd))
        disabledTex:SetPoint("BOTTOM")
        disabledTex:SetTexture(scrollbarAtlas.texture)
        disabledTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-up-end"]))
        scrollUpButton:SetDisabledTexture(disabledTex)
    end
    
    if scrollDownButton then
        scrollDownButton:SetSize(unpack(scrollbarAtlas.size))

        local normalTex = scrollDownButton:CreateTexture(nil, "ARTWORK")
        normalTex:SetAllPoints()
        normalTex:SetTexture(scrollbarAtlas.texture)
        normalTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-down"]))
        scrollDownButton:SetNormalTexture(normalTex)

        local hoverTex = scrollDownButton:CreateTexture(nil, "ARTWORK")
        hoverTex:SetAllPoints()
        hoverTex:SetTexture(scrollbarAtlas.texture)
        hoverTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-down-over"]))
        scrollDownButton:SetHighlightTexture(hoverTex)

        local pushedTex = scrollDownButton:CreateTexture(nil, "ARTWORK")
        pushedTex:SetAllPoints()
        pushedTex:SetTexture(scrollbarAtlas.texture)
        pushedTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-down-down"]))
        scrollDownButton:SetPushedTexture(pushedTex)

        local disabledTex = scrollDownButton:CreateTexture(nil, "ARTWORK")
        disabledTex:SetSize(unpack(scrollbarAtlas.sizeEnd))
        disabledTex:SetPoint("TOP")
        disabledTex:SetTexture(scrollbarAtlas.texture)
        disabledTex:SetTexCoord(unpack(scrollbarAtlas.arrows["arrow-down-end"]))
        scrollDownButton:SetDisabledTexture(disabledTex)
    end
    
    if thumbTexture then
        thumbTexture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
        thumbTexture:SetVertexColor(0.4, 0.4, 0.4, 1)
        thumbTexture:SetWidth(16)
    end
    
    -- Style the track background
    local trackBG = scrollBar:CreateTexture(nil, "BACKGROUND")
    trackBG:SetAllPoints(scrollBar)
    trackBG:SetColorTexture(0.15, 0.15, 0.15, 0.8)
end

--------------------------------------------------------------------------------
-- StaticPopup Styling
--------------------------------------------------------------------------------

--- Style a StaticPopup dialog with square appearance
-- @param dialog Frame The StaticPopup dialog to style
function UIHelpers:StyleStaticPopup(dialog)
    if not dialog or dialog.rdtStyled then return end
    
    -- Mark as styled to avoid re-styling
    dialog.rdtStyled = true
    
    -- Restyle backdrop
    dialog:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    dialog:SetBackdropColor(0.05, 0.05, 0.05, 0.98)
    dialog:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
    
    -- Style buttons
    for i = 1, 4 do
        local button = dialog["button" .. i]
        if button and button:IsShown() then
            self:StyleSquareButton(button)
        end
    end
    
    -- Style editbox if present
    if dialog.editBox then
        dialog.editBox:SetTextColor(1, 1, 1)
        dialog.editBox:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            edgeSize = 1,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        dialog.editBox:SetBackdropColor(0, 0, 0, 0.8)
        dialog.editBox:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
    end
end

--------------------------------------------------------------------------------
-- Frame Styling
--------------------------------------------------------------------------------

--- Create a square backdrop for a frame
-- @param frame Frame The frame to apply backdrop to
-- @param options table Optional settings { bgAlpha, borderColor }
function UIHelpers:ApplySquareBackdrop(frame, options)
    options = options or {}
    local bgAlpha = options.bgAlpha or 0.98
    local borderR, borderG, borderB = 0.2, 0.2, 0.2

    if options.borderColor then
        borderR, borderG, borderB = unpack(options.borderColor)
    end

    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    frame:SetBackdropColor(0.05, 0.05, 0.05, bgAlpha)
    frame:SetBackdropBorderColor(borderR, borderG, borderB, 1)
end

--- Create a simple dialog frame with square styling
-- @param config table Configuration with:
--   - name: string - Unique frame name
--   - title: string - Dialog title
--   - width: number - Dialog width (default 400)
--   - height: number - Dialog height (default 150)
--   - hasEditBox: boolean - Whether to include an edit box (default false)
--   - message: string - Message text to display (optional)
--   - button1Text: string - Text for button 1 (left)
--   - button2Text: string - Text for button 2 (right, default "Cancel")
--   - onButton1Click: function(frame) - Callback for button 1
--   - onButton2Click: function(frame) - Callback for button 2 (optional, defaults to hide)
-- @return Frame The dialog frame with properties:
--   - editBox: EditBox (if hasEditBox is true)
--   - messageText: FontString (if message is provided)
--   - button1: Button
--   - button2: Button
function UIHelpers:CreateSimpleDialog(config)
    local frame = CreateFrame("Frame", config.name, UIParent)
    frame:SetSize(config.width or 400, config.height or 150)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()

    self:ApplySquareBackdrop(frame)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText(config.title or "Dialog")
    frame.titleText = title

    local closeBtn = self:CreateSquareCloseButton(frame)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    if config.message then
        local messageText = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        messageText:SetPoint("TOP", 0, -45)
        messageText:SetText(config.message)
        frame.messageText = messageText
    end

    if config.hasEditBox then
        local editBox = CreateFrame("EditBox", nil, frame)
        editBox:SetSize(360, 30)
        editBox:SetPoint("TOP", 0, -70)
        editBox:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
        editBox:SetAutoFocus(true)
        editBox:SetTextColor(1, 1, 1)
        editBox:SetMaxLetters(50)
        editBox:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            edgeSize = 1,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        editBox:SetBackdropColor(0, 0, 0, 0.8)
        editBox:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
        editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
        frame.editBox = editBox
    end

    local button1 = CreateFrame("Button", nil, frame)
    button1:SetSize(120, 30)
    button1:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -5, 10)
    button1:SetText(config.button1Text or "OK")
    self:StyleSquareButton(button1)
    if config.onButton1Click then
        button1:SetScript("OnClick", function() config.onButton1Click(frame) end)
    end
    frame.button1 = button1

    local button2 = CreateFrame("Button", nil, frame)
    button2:SetSize(120, 30)
    button2:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 5, 10)
    button2:SetText(config.button2Text or "Cancel")
    self:StyleSquareButton(button2)
    if config.onButton2Click then
        button2:SetScript("OnClick", function() config.onButton2Click(frame) end)
    else
        button2:SetScript("OnClick", function() frame:Hide() end)
    end
    frame.button2 = button2

    if config.hasEditBox and frame.editBox then
        frame.editBox:SetScript("OnEnterPressed", function() button1:Click() end)
    end

    return frame
end

--------------------------------------------------------------------------------
-- Dropdown Component
--------------------------------------------------------------------------------

--- Create a square dropdown menu component
-- @param config table Configuration with:
--   - parent: Frame - Parent frame
--   - name: string - Unique name for the dropdown
--   - point: string - Anchor point (e.g., "TOPLEFT")
--   - x: number - X offset
--   - y: number - Y offset
--   - width: number - Button width
--   - height: number - Button height (default 24)
--   - menuHeight: number - Menu height (default 200)
--   - defaultText: string - Initial text
--   - onItemClick: function(itemData) - Called when item is selected
-- @return table Dropdown object with methods:
--   - SetItems(items): Update dropdown items
--   - SetText(text): Update button text
--   - GetButton(): Get the main button frame
--   - Show/Hide(): Control visibility
function UIHelpers:CreateSquareDropdown(config)
    local dropdownAtlas = GetDropdownAtlas()
    local dropdown = {}

    -- Create main button
    local button = CreateFrame("Button", config.name, config.parent)
    button:SetPoint(config.point or "TOPLEFT", config.x or 0, config.y or 0)
    button:SetSize(config.width or 200, config.height or 24)
    self:StyleSquareButton(button)
    
    -- Dropdown text
    local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", 8, 0)
    text:SetPoint("RIGHT", -20, 0)
    text:SetJustifyH("LEFT")
    text:SetText(config.defaultText or "Select...")
    text:SetTextColor(1, 1, 1, 1)
    button.text = text

    -- Dropdown arrow (using dropdown atlas down arrow)
    local arrow = button:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(12, 5)
    arrow:SetPoint("RIGHT", -5, 0)
    arrow:SetTexture(dropdownAtlas.texture)
    arrow:SetTexCoord(unpack(dropdownAtlas.icons["icon-down-small"]))
    arrow:SetVertexColor(1, 1, 0.5)

    -- Create dropdown menu frame
    local menuFrame = CreateFrame("Frame", config.name.."Menu", config.parent)
    menuFrame:SetSize(config.width or 200, config.menuHeight or 200)
    menuFrame:SetFrameStrata("DIALOG")
    menuFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    menuFrame:SetBackdropColor(0.2, 0.2, 0.2, 0.98)
    menuFrame:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
    menuFrame:Hide()
    
    -- Scroll frame for menu items
    local scrollFrame = CreateFrame("ScrollFrame", config.name.."Scroll", menuFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 4, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize((config.width or 200) - 30, 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Style the scrollbar
    self:StyleScrollBar(scrollFrame)
    
    menuFrame.scrollFrame = scrollFrame
    menuFrame.scrollChild = scrollChild
    menuFrame.buttons = {}
    
    -- Frame level management
    menuFrame:SetScript("OnShow", function(self)
        self:SetFrameLevel(button:GetFrameLevel() + 10)
        self:EnableMouse(true)
    end)
    
    menuFrame:SetScript("OnHide", function(self)
        self:EnableMouse(false)
    end)
    
    -- Click handler to toggle menu
    button:SetScript("OnClick", function(self)
        if menuFrame:IsShown() then
            menuFrame:Hide()
        else
            -- Position menu below button
            menuFrame:ClearAllPoints()
            menuFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
            
            -- Show menu
            menuFrame:Show()
        end
    end)
    
    button.menuFrame = menuFrame
    
    -- Public API
    dropdown.button = button
    dropdown.menuFrame = menuFrame
    
    --- Update dropdown items
    -- @param items table Array of items, each with: { value = any, text = string, isSelected = boolean }
    function dropdown:SetItems(items)
        local scrollChild = menuFrame.scrollChild
        
        -- Clear existing buttons
        for _, btn in ipairs(menuFrame.buttons) do
            btn:Hide()
        end
        
        local yOffset = 0
        local itemWidth = (config.width or 200) - 30
        
        for i, item in ipairs(items) do
            local btn = menuFrame.buttons[i]
            if not btn then
                btn = CreateFrame("Button", nil, scrollChild)
                btn:SetSize(itemWidth, 22)
                
                btn:SetBackdrop({
                    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                    edgeFile = nil,
                    tile = false,
                    insets = { left = 0, right = 0, top = 0, bottom = 0 }
                })
                btn:SetBackdropColor(0, 0, 0, 0)
                
                local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                btnText:SetPoint("LEFT", 8, 0)
                btnText:SetJustifyH("LEFT")
                btnText:SetTextColor(1, 1, 1, 1)
                btn.text = btnText

                local checkmark = btn:CreateTexture(nil, "OVERLAY")
                checkmark:SetSize(12, 12)
                checkmark:SetPoint("RIGHT", -5, 0)
                checkmark:SetTexture(dropdownAtlas.texture)
                checkmark:SetTexCoord(unpack(dropdownAtlas.icons["icon-left"]))
                checkmark:SetVertexColor(0, 1, 0)
                btn.checkmark = checkmark

                btn:SetScript("OnEnter", function(self)
                    self:SetBackdropColor(0.4, 0.4, 0.4, 0.8)
                end)
                
                btn:SetScript("OnLeave", function(self)
                    if self.isSelected then
                        self:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
                    else
                        self:SetBackdropColor(0, 0, 0, 0)
                    end
                end)
                
                menuFrame.buttons[i] = btn
            end
            
            btn:SetPoint("TOPLEFT", 0, yOffset)
            btn.text:SetText(item.text or tostring(item.value))
            btn.itemData = item
            
            -- Update selection state
            btn.isSelected = item.isSelected
            btn.checkmark:SetShown(item.isSelected)
            if item.isSelected then
                btn:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
            else
                btn:SetBackdropColor(0, 0, 0, 0)
            end
            
            -- Click handler
            btn:SetScript("OnClick", function(self)
                if config.onItemClick then
                    config.onItemClick(self.itemData)
                end
                menuFrame:Hide()
            end)
            
            btn:Show()
            yOffset = yOffset - 22
        end
        
        scrollChild:SetHeight(math.max(math.abs(yOffset), 1))
    end
    
    --- Update button text
    function dropdown:SetText(newText)
        text:SetText(newText)
    end
    
    --- Get the main button
    function dropdown:GetButton()
        return button
    end
    
    --- Show the dropdown
    function dropdown:Show()
        button:Show()
    end
    
    --- Hide the dropdown
    function dropdown:Hide()
        button:Hide()
        menuFrame:Hide()
    end
    
    return dropdown
end

--- Create a square styled checkbox
-- @param config table Configuration with:
--   - parent: Frame - Parent frame
--   - name: string - Unique name for the checkbox
--   - label: string - Label text
--   - tooltip: string - Tooltip text (optional)
--   - initialValue: boolean - Initial checked state (default false)
--   - fontSize: number - Font size (default 10)
--   - onClick: function(checked) - Click callback
-- @return CheckButton The created checkbox
function UIHelpers:CreateSquareCheckbox(config)
    local checkButton = CreateFrame("CheckButton", config.name, config.parent, "ChatConfigCheckButtonTemplate")
    checkButton:SetSize(24, 24)
    
    if config.label then
        checkButton.text = checkButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        checkButton.text:SetPoint("LEFT", checkButton, "RIGHT", 5, 0)
        checkButton.text:SetText(config.label)
        checkButton.text:SetTextColor(1, 1, 1)
        checkButton.text:SetFont("Fonts\\FRIZQT__.TTF", config.fontSize or 10, "")
    end
    
    checkButton:SetNormalTexture(nil)
    checkButton:SetPushedTexture(nil)
    checkButton:SetHighlightTexture(nil)
    checkButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
    
    checkButton:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    checkButton:SetBackdropColor(0, 0, 0, 1)
    checkButton:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
    
    checkButton:SetChecked(config.initialValue or false)
    
    checkButton:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if config.onClick then
            config.onClick(isChecked)
        end
    end)
    
    if config.tooltip then
        checkButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(config.label, 1, 1, 1)
            GameTooltip:AddLine(config.tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        checkButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end
    
    return checkButton
end

--------------------------------------------------------------------------------
-- Line Drawing Utilities
--------------------------------------------------------------------------------

--- Draw a dotted line between two points on the map
-- @param config table Configuration:
--   - mapCanvas: Frame to draw on
--   - mapTexture: Frame to anchor points to
--   - x1, y1: Start point (pixel coordinates)
--   - x2, y2: End point (pixel coordinates)
--   - texturePool: Pool to reuse textures from (optional)
--   - outputTable: Table to store created textures in
--   - dotSize: Size of each dot (default: 4)
--   - dotSpacing: Pixels between dots (default: 15)
--   - color: {r, g, b, a} color (default: {1, 1, 1, 1})
--- Draw a dotted line between two points
-- @param config table Configuration table with:
--   - mapCanvas: Frame to create textures on
--   - mapTexture: Texture to anchor points to
--   - x1, y1: Start coordinates (pixels)
--   - x2, y2: End coordinates (pixels)
--   - texturePool: Optional table to reuse textures from
--   - outputTable: Optional table to store created textures in
--   - dotSize: Optional size of each dot (default 4)
--   - dotSpacing: Optional spacing between dots (default 15)
--   - color: Optional {r, g, b, a} color table (default white)
-- @return table Array of texture objects created for this line
function UIHelpers:DrawDottedLine(config)
    local x1, y1 = config.x1, config.y1
    local x2, y2 = config.x2, config.y2

    -- Calculate line properties
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx * dx + dy * dy)

    if length < 1 then
        return {}  -- Points are too close, return empty table
    end

    -- Create dotted line effect with multiple small textures
    local dotSpacing = config.dotSpacing or 15
    local numDots = math.max(2, math.floor(length / dotSpacing))
    local createdTextures = {}
    local dotSize = config.dotSize or 4

    for i = 0, numDots do
        local t = i / numDots
        local x = x1 + dx * t
        local y = y1 + dy * t

        -- Try to reuse a texture from the pool, or create a new one
        local dot = config.texturePool and table.remove(config.texturePool)
        if not dot then
            -- No pooled texture available, create a new one
            local drawLayer = config.drawLayer or "OVERLAY"
            dot = config.mapCanvas:CreateTexture(nil, drawLayer)
            dot:SetTexture("Interface\\Buttons\\WHITE8X8")
        end

        -- Update properties
        dot:SetSize(dotSize, dotSize)
        dot:ClearAllPoints()
        local color = config.color or {1, 1, 1, 1}
        dot:SetVertexColor(color[1], color[2], color[3], color[4])
        dot:SetPoint("CENTER", config.mapTexture, "TOPLEFT", x, -y)
        dot:Show()

        -- Track this texture
        table.insert(createdTextures, dot)

        -- Store in output table if provided (for backwards compatibility)
        if config.outputTable then
            table.insert(config.outputTable, dot)
        end
    end

    return createdTextures
end

--------------------------------------------------------------------------------
-- Color Utilities
--------------------------------------------------------------------------------

local colorCache = {}

--- Get color for a pull number (cached)
-- @param pullNum number Pull number (0 = unassigned)
-- @return table RGB color table {r, g, b}
function UIHelpers:GetPullColor(pullNum)
    -- Handle unassigned packs
    if not pullNum or pullNum == 0 then
        return RDT.Colors.Unassigned
    end

    if colorCache[pullNum] then
        return colorCache[pullNum]
    end

    local colorIndex = ((pullNum - 1) % #RDT.Colors.PullBorders) + 1
    local color = RDT.Colors.PullBorders[colorIndex]

    colorCache[pullNum] = color

    return color
end

RDT:DebugPrint("UIHelpers module loaded")

