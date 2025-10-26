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

-- Dialog constants
local DIALOG_WIDTH = 500
local DIALOG_HEIGHT = 200
local IMPORT_DIALOG_HEIGHT = 250

--------------------------------------------------------------------------------
-- Styling Helper Functions (Use UIHelpers)
--------------------------------------------------------------------------------

-- Local convenience wrappers
local function StyleModernButton(button)
    UIHelpers:StyleSquareButton(button)
end

local function CreateModernCloseButton(parent)
    return UIHelpers:CreateModernCloseButton(parent)
end

local function StyleStaticPopup(dialog)
    UIHelpers:StyleStaticPopup(dialog)
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
    
    -- Scroll frame for the export string
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOP", instructions, "BOTTOM", 0, -10)
    scrollFrame:SetSize(460, 80)
    
    -- Edit box (multiline)
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetSize(460, 200)
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
    
    -- Select All button
    local selectAllButton = CreateFrame("Button", nil, frame)
    selectAllButton:SetSize(100, 25)
    selectAllButton:SetPoint("BOTTOM", 50, 40)
    selectAllButton:SetText("Select All")
    StyleModernButton(selectAllButton)
    selectAllButton:SetScript("OnClick", function()
        editBox:HighlightText()
        editBox:SetFocus()
    end)
    
    -- Copy hint text (Ctrl+C)
    local copyHint = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    copyHint:SetPoint("TOP", selectAllButton, "BOTTOM", 0, -2)
    copyHint:SetText("Press Ctrl+C to copy")
    copyHint:SetTextColor(0.7, 0.7, 0.7)
    
    -- Close button (bottom)
    local closeButton = CreateFrame("Button", nil, frame)
    closeButton:SetSize(100, 25)
    closeButton:SetPoint("BOTTOM", -50, 10)
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
    
    -- Scroll frame for the import string
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOP", instructions, "BOTTOM", 0, -10)
    scrollFrame:SetSize(460, 100)
    
    -- Edit box (multiline)
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetSize(460, 200)
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
    
    -- Warning text
    local warning = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    warning:SetPoint("TOP", scrollFrame, "BOTTOM", 0, -10)
    warning:SetText("|cFFFFFF00Warning:|r This will overwrite your current route!")
    warning:SetTextColor(1, 0.8, 0)
    
    -- Import button
    local importButton = CreateFrame("Button", nil, frame)
    importButton:SetSize(100, 25)
    importButton:SetPoint("BOTTOM", 50, 10)
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
    
    -- Cancel button
    local cancelButton = CreateFrame("Button", nil, frame)
    cancelButton:SetSize(100, 25)
    cancelButton:SetPoint("BOTTOM", -50, 10)
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
    
    StaticPopup_Hide("RDT_CONFIRM")
    StaticPopup_Hide("RDT_INFO")
end

--- Check if any dialog is shown
-- @return boolean True if any dialog is visible
function Dialogs:IsAnyShown()
    return (exportFrame and exportFrame:IsShown()) 
        or (importFrame and importFrame:IsShown())
        or StaticPopup_Visible("RDT_CONFIRM")
        or StaticPopup_Visible("RDT_INFO")
end

--------------------------------------------------------------------------------
-- Cleanup
--------------------------------------------------------------------------------

--- Cleanup dialog resources
--------------------------------------------------------------------------------
-- Route Management Dialogs
--------------------------------------------------------------------------------

--- Show dialog to create a new route
function Dialogs:ShowNewRoute()
    local dungeonName = RDT.db and RDT.db.profile and RDT.db.profile.currentDungeon
    if not dungeonName then
        RDT:PrintError("No dungeon selected")
        return
    end
    
    StaticPopupDialogs["RDT_NEW_ROUTE"] = {
        text = "Enter name for new route:",
        button1 = "Create",
        button2 = "Cancel",
        hasEditBox = true,
        OnShow = function(self)
            self.editBox:SetFocus()
            self.editBox:SetText("")
            StyleStaticPopup(self)
        end,
        OnAccept = function(self)
            local routeName = self.editBox:GetText()
            if routeName and routeName ~= "" then
                local newRouteName = RDT.RouteManager:CreateRoute(dungeonName, routeName)
                if newRouteName and RDT.UI then
                    RDT.UI:UpdateRouteDropdown()
                    RDT.UI:RefreshUI()
                end
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("RDT_NEW_ROUTE")
end

--- Show dialog to rename current route
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
    
    StaticPopupDialogs["RDT_RENAME_ROUTE"] = {
        text = "Rename '" .. oldName .. "' to:",
        button1 = "Rename",
        button2 = "Cancel",
        hasEditBox = true,
        OnShow = function(self)
            self.editBox:SetFocus()
            self.editBox:SetText(oldName)
            self.editBox:HighlightText()
            StyleStaticPopup(self)
        end,
        OnAccept = function(self)
            local newName = self.editBox:GetText()
            if newName and newName ~= "" and newName ~= oldName then
                if RDT.RouteManager:RenameRoute(dungeonName, oldName, newName) and RDT.UI then
                    RDT.UI:UpdateRouteDropdown()
                end
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("RDT_RENAME_ROUTE")
end

--- Show dialog to delete current route
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
    
    -- Count total routes
    local routes = RDT.RouteManager:GetRouteNames(dungeonName)
    local routeCount = #routes
    
    -- Prevent deleting the last route
    if routeCount <= 1 then
        RDT:PrintError("Cannot delete the last route")
        return
    end
    
    StaticPopupDialogs["RDT_DELETE_ROUTE"] = {
        text = "Delete route '" .. routeName .. "'?\n\n|cFFFF0000This cannot be undone!|r",
        button1 = "Delete",
        button2 = "Cancel",
        OnShow = function(self)
            StyleStaticPopup(self)
        end,
        OnAccept = function()
            if RDT.RouteManager:DeleteRoute(dungeonName, routeName) and RDT.UI then
                RDT.UI:UpdateRouteDropdown()
                RDT.UI:RefreshUI()
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("RDT_DELETE_ROUTE")
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
    
    RDT:DebugPrint("Dialogs cleaned up")
end

RDT:DebugPrint("Dialogs.lua loaded")
