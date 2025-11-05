-- UI/Dialogs.lua
-- Export and Import dialog windows

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- Module namespace
RDT.Dialogs = {}
local Dialogs = RDT.Dialogs

-- Local reference to UIHelpers
local UIHelpers = RDT.UIHelpers

-- Local references
local exportFrame
local importFrame
local newRouteFrame
local renameRouteFrame
local deleteRouteFrame

-- Dialog constants
local DIALOG_WIDTH = 600
local DIALOG_HEIGHT = 300
local IMPORT_DIALOG_HEIGHT = 350
local SIMPLE_DIALOG_WIDTH = 400
local SIMPLE_DIALOG_HEIGHT = 150

--------------------------------------------------------------------------------
-- Styling Helper Functions (Use UIHelpers)
--------------------------------------------------------------------------------

local function StyleModernButton(button)
    UIHelpers:StyleSquareButton(button)
end

local function CreateModernCloseButton(parent)
    return UIHelpers:CreateModernCloseButton(parent)
end

local function CreateSimpleDialog(config)
    return UIHelpers:CreateSimpleDialog(config)
end

--------------------------------------------------------------------------------
-- Export Dialog
--------------------------------------------------------------------------------

--- Create the export dialog window
-- @return Frame The export dialog frame
function Dialogs:CreateExportDialog()
    if exportFrame then
        return exportFrame
    end
    
    local frame = CreateFrame("Frame", "RDT_ExportDialog", UIParent)
    frame:SetSize(DIALOG_WIDTH, DIALOG_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()
    
    -- Modern backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    frame:SetBackdropColor(0.05, 0.05, 0.05, 0.98)
    frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Export Route")
    
    -- Modern close button (X)
    local closeBtn = CreateModernCloseButton(frame)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)
    
    -- Instructions
    local instructions = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    instructions:SetPoint("TOP", 0, -40)
    instructions:SetText("Copy this string and share it:")
    
    -- Scroll frame for the export string (with proper insets for scrollbar)
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -70)
    scrollFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -35, -70)  -- Extra space for scrollbar
    scrollFrame:SetHeight(150)
    
    -- Style the scrollbar with modern appearance
    if UIHelpers and UIHelpers.StyleScrollBar then
        UIHelpers:StyleScrollBar(scrollFrame)
    end
    
    -- Edit box (multiline) - width will be set by scrollFrame's width
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetWidth(scrollFrame:GetWidth() or 540)
    editBox:SetHeight(300)
    editBox:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    editBox:SetAutoFocus(false)
    editBox:SetTextColor(1, 1, 1)
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    editBox:SetScript("OnTextChanged", function(self)
        -- Auto-select text when content changes
        self:HighlightText()
    end)
    -- Dark background for editbox
    editBox:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = nil,
        tile = false,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    editBox:SetBackdropColor(0, 0, 0, 0.8)
    scrollFrame:SetScrollChild(editBox)
    frame.editBox = editBox
    
    -- Copy hint text (Ctrl+C) - positioned above buttons
    local copyHint = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    copyHint:SetPoint("BOTTOM", frame, "BOTTOM", 0, 45)
    copyHint:SetText("Press Ctrl+C to copy")
    copyHint:SetTextColor(0.7, 0.7, 0.7)
    
    -- Buttons horizontally aligned at the bottom
    -- Select All button (left side)
    local selectAllButton = CreateFrame("Button", nil, frame)
    selectAllButton:SetSize(120, 30)
    selectAllButton:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 5, 10)
    selectAllButton:SetText("Select All")
    StyleModernButton(selectAllButton)
    selectAllButton:SetScript("OnClick", function()
        editBox:HighlightText()
        editBox:SetFocus()
    end)
    
    -- Close button (right side)
    local closeButton = CreateFrame("Button", nil, frame)
    closeButton:SetSize(120, 30)
    closeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -5, 10)
    closeButton:SetText("Close")
    StyleModernButton(closeButton)
    closeButton:SetScript("OnClick", function() frame:Hide() end)
    
    exportFrame = frame
    return frame
end

--- Show the export dialog with route data
-- @param exportString string The encoded route string to display
function Dialogs:ShowExport(exportString)
    if not exportString then
        RDT:PrintError("No export string provided")
        return
    end
    
    -- Create dialog if it doesn't exist
    if not exportFrame then
        self:CreateExportDialog()
    end
    
    -- Set the export string
    exportFrame.editBox:SetText(exportString)
    exportFrame.editBox:HighlightText()
    exportFrame.editBox:SetFocus()
    
    -- Show the dialog
    exportFrame:Show()
    
    RDT:DebugPrint("Export dialog shown with " .. #exportString .. " character string")
end

--------------------------------------------------------------------------------
-- Import Dialog
--------------------------------------------------------------------------------

--- Create the import dialog window
-- @return Frame The import dialog frame
function Dialogs:CreateImportDialog()
    if importFrame then
        return importFrame
    end
    
    local frame = CreateFrame("Frame", "RDT_ImportDialog", UIParent)
    frame:SetSize(DIALOG_WIDTH, IMPORT_DIALOG_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()
    
    -- Modern backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    frame:SetBackdropColor(0.05, 0.05, 0.05, 0.98)
    frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Import Route")
    
    -- Modern close button (X)
    local closeBtn = CreateModernCloseButton(frame)
    closeBtn:SetScript("OnClick", function() 
        frame:Hide()
        frame.editBox:SetText("") -- Clear on close
    end)
    
    -- Instructions
    local instructions = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    instructions:SetPoint("TOP", 0, -40)
    instructions:SetText("Paste the import string below:")
    
    -- Scroll frame for the import string (with proper insets for scrollbar)
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -70)
    scrollFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -35, -70)  -- Extra space for scrollbar
    scrollFrame:SetHeight(200)
    
    -- Style the scrollbar with modern appearance
    if UIHelpers and UIHelpers.StyleScrollBar then
        UIHelpers:StyleScrollBar(scrollFrame)
    end
    
    -- Edit box (multiline) - width will be set by scrollFrame's width
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetWidth(scrollFrame:GetWidth() or 540)
    editBox:SetHeight(400)
    editBox:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    editBox:SetAutoFocus(true)
    editBox:SetTextColor(1, 1, 1)
    editBox:SetScript("OnEscapePressed", function() 
        frame:Hide()
        editBox:SetText("")
    end)
    -- Dark background for editbox
    editBox:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = nil,
        tile = false,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    editBox:SetBackdropColor(0, 0, 0, 0.8)
    scrollFrame:SetScrollChild(editBox)
    frame.editBox = editBox
    
    -- Warning text - positioned above buttons
    local warning = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    warning:SetPoint("BOTTOM", frame, "BOTTOM", 0, 50)
    warning:SetText("|cFFFFFF00Warning:|r This will create a new route with the imported data")
    warning:SetTextColor(1, 0.8, 0)
    
    -- Buttons horizontally aligned at the bottom
    -- Import button (left side)
    local importButton = CreateFrame("Button", nil, frame)
    importButton:SetSize(120, 30)
    importButton:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 5, 10)
    importButton:SetText("Import")
    StyleModernButton(importButton)
    importButton:SetScript("OnClick", function()
        local importString = editBox:GetText()
        
        if not importString or importString == "" then
            RDT:PrintError("Please paste an import string first")
            return
        end
        
        if not RDT.ImportExport then
            RDT:PrintError("ImportExport module not loaded")
            return
        end
        
        -- Attempt import
        if RDT.ImportExport:Import(importString) then
            frame:Hide()
            editBox:SetText("")
        end
        -- Errors are printed by ImportExport module
    end)
    
    -- Cancel button (right side)
    local cancelButton = CreateFrame("Button", nil, frame)
    cancelButton:SetSize(120, 30)
    cancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -5, 10)
    cancelButton:SetText("Cancel")
    StyleModernButton(cancelButton)
    cancelButton:SetScript("OnClick", function() 
        frame:Hide()
        editBox:SetText("")
    end)
    
    importFrame = frame
    return frame
end

--- Show the import dialog
function Dialogs:ShowImport()
    -- Create dialog if it doesn't exist
    if not importFrame then
        self:CreateImportDialog()
    end
    
    -- Clear any previous text
    importFrame.editBox:SetText("")
    importFrame.editBox:SetFocus()
    
    -- Show the dialog
    importFrame:Show()
    
    RDT:DebugPrint("Import dialog shown")
end

--------------------------------------------------------------------------------
-- Confirmation Dialog (Generic)
--------------------------------------------------------------------------------

--- Show a confirmation dialog
-- @param title string Dialog title
-- @param message string Dialog message
-- @param onConfirm function Callback for confirmation
-- @param onCancel function Optional callback for cancellation
function Dialogs:ShowConfirmation(title, message, onConfirm, onCancel)
    -- Use Blizzard's built-in confirmation dialog
    StaticPopupDialogs["RDT_CONFIRM"] = {
        text = message,
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            if onConfirm then onConfirm() end
        end,
        OnCancel = function()
            if onCancel then onCancel() end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("RDT_CONFIRM")
end

--------------------------------------------------------------------------------
-- Information Dialog (Simple Message)
--------------------------------------------------------------------------------

--- Show an information dialog
-- @param title string Dialog title
-- @param message string Dialog message
function Dialogs:ShowInformation(title, message)
    StaticPopupDialogs["RDT_INFO"] = {
        text = message,
        button1 = "OK",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("RDT_INFO")
end

--------------------------------------------------------------------------------
-- Input Dialog (Future Feature)
--------------------------------------------------------------------------------

--- Show an input dialog (placeholder for future use)
-- @param title string Dialog title
-- @param message string Prompt message
-- @param defaultText string Default input text
-- @param onAccept function Callback(text) when accepted
function Dialogs:ShowInput(title, message, defaultText, onAccept)
    -- Could implement a custom input dialog for:
    -- - Renaming routes
    -- - Adding notes
    -- - Custom profile names
    -- etc.
    
    RDT:DebugPrint("ShowInput not yet implemented")
    
    -- Temporary fallback: use chat
    RDT:Print(message)
end

--------------------------------------------------------------------------------
-- Dialog Management
--------------------------------------------------------------------------------

--- Hide all dialogs
function Dialogs:HideAll()
    if exportFrame then
        exportFrame:Hide()
    end
    if importFrame then
        importFrame:Hide()
        importFrame.editBox:SetText("")
    end
    if newRouteFrame then
        newRouteFrame:Hide()
    end
    if renameRouteFrame then
        renameRouteFrame:Hide()
    end
    if deleteRouteFrame then
        deleteRouteFrame:Hide()
    end

    StaticPopup_Hide("RDT_CONFIRM")
    StaticPopup_Hide("RDT_INFO")
end

--- Check if any dialog is shown
-- @return boolean True if any dialog is visible
function Dialogs:IsAnyShown()
    return (exportFrame and exportFrame:IsShown())
        or (importFrame and importFrame:IsShown())
        or (newRouteFrame and newRouteFrame:IsShown())
        or (renameRouteFrame and renameRouteFrame:IsShown())
        or (deleteRouteFrame and deleteRouteFrame:IsShown())
        or StaticPopup_Visible("RDT_CONFIRM")
        or StaticPopup_Visible("RDT_INFO")
end

--------------------------------------------------------------------------------
-- Route Management Dialogs
--------------------------------------------------------------------------------

function Dialogs:CreateNewRouteDialog()
    if newRouteFrame then
        return newRouteFrame
    end

    newRouteFrame = CreateSimpleDialog({
        name = "RDT_NewRouteDialog",
        title = "New Route",
        width = SIMPLE_DIALOG_WIDTH,
        height = SIMPLE_DIALOG_HEIGHT,
        hasEditBox = true,
        message = "Enter name for new route:",
        button1Text = "Create",
        onButton1Click = function(frame)
            local routeName = frame.editBox:GetText()
            if routeName and routeName ~= "" then
                local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
                if dungeonName then
                    local newRouteName = RDT.RouteManager:CreateRoute(dungeonName, routeName)
                    if newRouteName and RDT.UI then
                        RDT.UI:UpdateRouteDropdown()
                        RDT.UI:RefreshUI()
                        frame:Hide()
                    end
                end
            end
        end
    })

    return newRouteFrame
end

function Dialogs:ShowNewRoute()
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName then
        RDT:PrintError("No dungeon selected")
        return
    end

    if not newRouteFrame then
        self:CreateNewRouteDialog()
    end

    newRouteFrame.editBox:SetText("")
    newRouteFrame.editBox:SetFocus()
    newRouteFrame:Show()
end

function Dialogs:CreateRenameRouteDialog()
    if renameRouteFrame then
        return renameRouteFrame
    end

    renameRouteFrame = CreateSimpleDialog({
        name = "RDT_RenameRouteDialog",
        title = "Rename Route",
        width = SIMPLE_DIALOG_WIDTH,
        height = SIMPLE_DIALOG_HEIGHT,
        hasEditBox = true,
        message = "Enter new route name:",
        button1Text = "Rename",
        onButton1Click = function(frame)
            local newName = frame.editBox:GetText()
            local oldName = frame.oldName
            if newName and newName ~= "" and newName ~= oldName then
                local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
                if dungeonName and oldName then
                    if RDT.RouteManager:RenameRoute(dungeonName, oldName, newName) and RDT.UI then
                        RDT.UI:UpdateRouteDropdown()
                        frame:Hide()
                    end
                end
            end
        end
    })

    return renameRouteFrame
end

function Dialogs:ShowRenameRoute()
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName or not RDT.RouteManager then
        RDT:PrintError("No dungeon selected")
        return
    end

    local oldName = RDT.RouteManager:GetCurrentRouteName(dungeonName)
    if not oldName then
        RDT:PrintError("No route selected")
        return
    end

    if not renameRouteFrame then
        self:CreateRenameRouteDialog()
    end

    renameRouteFrame.oldName = oldName
    renameRouteFrame.messageText:SetText("Rename '" .. oldName .. "' to:")
    renameRouteFrame.editBox:SetText(oldName)
    renameRouteFrame.editBox:HighlightText()
    renameRouteFrame.editBox:SetFocus()
    renameRouteFrame:Show()
end

function Dialogs:CreateDeleteRouteDialog()
    if deleteRouteFrame then
        return deleteRouteFrame
    end

    deleteRouteFrame = CreateSimpleDialog({
        name = "RDT_DeleteRouteDialog",
        title = "Delete Route",
        width = SIMPLE_DIALOG_WIDTH,
        height = 180,
        message = "Delete this route?",
        button1Text = "Delete",
        onButton1Click = function(frame)
            local dungeonName = frame.dungeonName
            local routeName = frame.routeName
            if dungeonName and routeName then
                if RDT.RouteManager:DeleteRoute(dungeonName, routeName) and RDT.UI then
                    RDT.UI:UpdateRouteDropdown()
                    RDT.UI:RefreshUI()
                    frame:Hide()
                end
            end
        end
    })

    local warningText = deleteRouteFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    warningText:SetPoint("TOP", 0, -80)
    warningText:SetText("|cFFFF0000This cannot be undone!|r")
    deleteRouteFrame.warningText = warningText

    return deleteRouteFrame
end

function Dialogs:ShowDeleteRoute()
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName or not RDT.RouteManager then
        RDT:PrintError("No dungeon selected")
        return
    end

    local routeName = RDT.RouteManager:GetCurrentRouteName(dungeonName)
    if not routeName then
        RDT:PrintError("No route selected")
        return
    end

    local routes = RDT.RouteManager:GetRouteNames(dungeonName)
    local routeCount = #routes

    if routeCount <= 1 then
        RDT:PrintError("Cannot delete the last route")
        return
    end

    if not deleteRouteFrame then
        self:CreateDeleteRouteDialog()
    end

    deleteRouteFrame.dungeonName = dungeonName
    deleteRouteFrame.routeName = routeName
    deleteRouteFrame.messageText:SetText("Delete route '" .. routeName .. "'?")
    deleteRouteFrame:Show()
end

--------------------------------------------------------------------------------
-- Cleanup
--------------------------------------------------------------------------------

function Dialogs:Cleanup()
    self:HideAll()

    if exportFrame then
        exportFrame:SetParent(nil)
        exportFrame = nil
    end

    if importFrame then
        importFrame:SetParent(nil)
        importFrame = nil
    end

    if newRouteFrame then
        newRouteFrame:SetParent(nil)
        newRouteFrame = nil
    end

    if renameRouteFrame then
        renameRouteFrame:SetParent(nil)
        renameRouteFrame = nil
    end

    if deleteRouteFrame then
        deleteRouteFrame:SetParent(nil)
        deleteRouteFrame = nil
    end

    RDT:DebugPrint("Dialogs cleaned up")
end

RDT:DebugPrint("Dialogs.lua loaded")
