-- UI/UIHelpers.lua
-- Shared UI styling and helper functions

local RDT = _G.RDT

-- UIHelpers namespace
RDT.UIHelpers = RDT.UIHelpers or {}
local UIHelpers = RDT.UIHelpers

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
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    
    -- Normal state: lighter gray for better visibility
    button:SetBackdropColor(0.25, 0.25, 0.25, 1)
    button:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    
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

--- Create a modern styled close button
-- @param parent Frame Parent frame
-- @return Button The created close button
function UIHelpers:CreateModernCloseButton(parent)
    local closeBtn = CreateFrame("Button", nil, parent)
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("TOPRIGHT", -8, -8)
    
    -- Style as modern button
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

--- Style a scrollbar with modern square gray appearance
-- @param scrollFrame ScrollFrame The scroll frame to style
function UIHelpers:StyleScrollBar(scrollFrame)
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
        scrollUpButton:SetNormalTexture(nil)
        scrollUpButton:SetPushedTexture(nil)
        scrollUpButton:SetHighlightTexture(nil)
        scrollUpButton:SetDisabledTexture(nil)
        scrollUpButton:SetSize(16, 16)
        
        -- Style as square button
        scrollUpButton:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            edgeSize = 1,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        scrollUpButton:SetBackdropColor(0.25, 0.25, 0.25, 1)
        scrollUpButton:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        
        -- Add arrow text (check if it already exists to avoid duplicates)
        if not scrollUpButton.styledArrow then
            local upArrow = scrollUpButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            upArrow:SetPoint("CENTER", 0, 0)
            upArrow:SetText("^")
            upArrow:SetTextColor(0.7, 0.7, 0.7)
            scrollUpButton.styledArrow = upArrow
        end
        
        scrollUpButton:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.35, 0.35, 0.35, 1)
        end)
        scrollUpButton:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 1)
        end)
    end
    
    if scrollDownButton then
        scrollDownButton:SetNormalTexture(nil)
        scrollDownButton:SetPushedTexture(nil)
        scrollDownButton:SetHighlightTexture(nil)
        scrollDownButton:SetDisabledTexture(nil)
        scrollDownButton:SetSize(16, 16)
        
        -- Style as square button
        scrollDownButton:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            edgeSize = 1,
            insets = { left = 1, right = 1, top = 1, bottom = 1 }
        })
        scrollDownButton:SetBackdropColor(0.25, 0.25, 0.25, 1)
        scrollDownButton:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        
        -- Add arrow text (check if it already exists to avoid duplicates)
        if not scrollDownButton.styledArrow then
            local downArrow = scrollDownButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            downArrow:SetPoint("CENTER", 0, 0)
            downArrow:SetText("v")
            downArrow:SetTextColor(0.7, 0.7, 0.7)
            scrollDownButton.styledArrow = downArrow
        end
        
        scrollDownButton:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.35, 0.35, 0.35, 1)
        end)
        scrollDownButton:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 1)
        end)
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

--- Style a StaticPopup dialog with modern appearance
-- @param dialog Frame The StaticPopup dialog to style
function UIHelpers:StyleStaticPopup(dialog)
    if not dialog or dialog.rdtStyled then return end
    
    -- Mark as styled to avoid re-styling
    dialog.rdtStyled = true
    
    -- Restyle backdrop
    dialog:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    dialog:SetBackdropColor(0.05, 0.05, 0.05, 0.98)
    dialog:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    
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

--- Create a modern backdrop for a frame
-- @param frame Frame The frame to apply backdrop to
-- @param options table Optional settings { bgAlpha, borderColor }
function UIHelpers:ApplyModernBackdrop(frame, options)
    options = options or {}
    local bgAlpha = options.bgAlpha or 0.98
    local borderR, borderG, borderB = 0.5, 0.5, 0.5
    
    if options.borderColor then
        borderR, borderG, borderB = unpack(options.borderColor)
    end
    
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    frame:SetBackdropColor(0.05, 0.05, 0.05, bgAlpha)
    frame:SetBackdropBorderColor(borderR, borderG, borderB, 1)
end

--------------------------------------------------------------------------------
-- Dropdown Component
--------------------------------------------------------------------------------

--- Create a modern dropdown menu component
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
function UIHelpers:CreateModernDropdown(config)
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
    text:SetTextColor(1, 1, 1, 1)  -- White text
    button.text = text
    
    -- Dropdown arrow
    local arrow = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arrow:SetPoint("RIGHT", -5, 0)
    arrow:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    arrow:SetText("v")
    arrow:SetTextColor(0.7, 0.7, 0.7)
    
    -- Create dropdown menu frame
    local menuFrame = CreateFrame("Frame", config.name.."Menu", UIParent)
    menuFrame:SetSize(config.width or 200, config.menuHeight or 200)
    menuFrame:SetFrameStrata("DIALOG")
    menuFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    menuFrame:SetBackdropColor(0.2, 0.2, 0.2, 0.98)
    menuFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
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
                btnText:SetTextColor(1, 1, 1, 1)  -- White text
                btn.text = btnText
                
                local checkmark = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                checkmark:SetPoint("RIGHT", -5, 0)
                checkmark:SetText("<")
                checkmark:SetTextColor(0, 1, 0)
                btn.checkmark = checkmark
                
                btn:SetScript("OnEnter", function(self)
                    self:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
                end)
                
                btn:SetScript("OnLeave", function(self)
                    if self.isSelected then
                        self:SetBackdropColor(0.1, 0.15, 0.2, 0.5)
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
                btn:SetBackdropColor(0.1, 0.15, 0.2, 0.5)
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

RDT:DebugPrint("UIHelpers module loaded")

