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
    
    -- Normal state: dark gray
    button:SetBackdropColor(0.15, 0.15, 0.15, 1)
    button:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    
    -- Hover effect
    button:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.25, 0.25, 0.25, 1)
    end)
    
    button:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.15, 0.15, 0.15, 1)
    end)
    
    -- Pressed state: darker gray
    button:HookScript("OnMouseDown", function(self)
        self:SetBackdropColor(0.1, 0.1, 0.1, 1)
    end)
    
    button:HookScript("OnMouseUp", function(self)
        self:SetBackdropColor(0.25, 0.25, 0.25, 1)
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
    local scrollBar = _G[scrollFrame:GetName().."ScrollBar"]
    if not scrollBar then return end
    
    -- Remove default textures
    local scrollUpButton = _G[scrollFrame:GetName().."ScrollBarScrollUpButton"]
    local scrollDownButton = _G[scrollFrame:GetName().."ScrollBarScrollDownButton"]
    local thumbTexture = _G[scrollFrame:GetName().."ScrollBarThumbTexture"]
    
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
        scrollUpButton:SetBackdropColor(0.15, 0.15, 0.15, 1)
        scrollUpButton:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
        
        -- Add arrow text
        local upArrow = scrollUpButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        upArrow:SetPoint("CENTER", 0, 0)
        upArrow:SetText("^")
        upArrow:SetTextColor(0.7, 0.7, 0.7)
        
        scrollUpButton:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 1)
        end)
        scrollUpButton:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.15, 0.15, 0.15, 1)
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
        scrollDownButton:SetBackdropColor(0.15, 0.15, 0.15, 1)
        scrollDownButton:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
        
        -- Add arrow text
        local downArrow = scrollDownButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        downArrow:SetPoint("CENTER", 0, 0)
        downArrow:SetText("v")
        downArrow:SetTextColor(0.7, 0.7, 0.7)
        
        scrollDownButton:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 1)
        end)
        scrollDownButton:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.15, 0.15, 0.15, 1)
        end)
    end
    
    if thumbTexture then
        thumbTexture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
        thumbTexture:SetVertexColor(0.3, 0.3, 0.3, 1)
        thumbTexture:SetWidth(16)
    end
    
    -- Style the track background
    local trackBG = scrollBar:CreateTexture(nil, "BACKGROUND")
    trackBG:SetAllPoints(scrollBar)
    trackBG:SetColorTexture(0.05, 0.05, 0.05, 0.8)
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

RDT:DebugPrint("UIHelpers module loaded")

