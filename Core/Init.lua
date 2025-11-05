-- Core/Init.lua
-- Addon initialization with Ace3 framework

local ADDON_NAME = "ReinDungeonTools"
local RDT = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

-- Make globally accessible
_G.RDT = RDT

-- Addon metadata
RDT.Version = GetAddOnMetadata(ADDON_NAME, "Version") or "1.0.0"
RDT.AddonName = ADDON_NAME

-- Debug flag (will be set by Database module from saved vars)
RDT.Debug = false

--------------------------------------------------------------------------------
-- State Management
--------------------------------------------------------------------------------

-- Runtime state (not saved)
RDT.State = {
    currentPull = 1,         -- Current pull number for adding packs
    currentRoute = nil,      -- Reference to current route table from DB
    packButtons = {},        -- Map of packID -> button frame
    identifierButtons = {},  -- Map of identifierID -> button frame
    portalLines = {},        -- Array of portal connection line textures
    isInitialized = false,   -- Whether addon has finished loading
}

--------------------------------------------------------------------------------
-- Pull Colors (6-color repeating cycle)
--------------------------------------------------------------------------------

local basePullColors = {
    {0.2, 0.8, 1.0},  -- Bright Cyan - Pull 1, 5, 9, ...
    {1.0, 0.6, 0.1},  -- Vibrant Orange - Pull 2, 6, 10, ...
    {0.8, 0.3, 1.0},  -- Vivid Purple - Pull 3, 7, 11, ...
    {0.3, 1.0, 0.5},  -- Bright Green - Pull 4, 8, 12, ...
    {1.0, 0.2, 0.5},  -- Hot Pink - Pull 5, 9, 13, ...
    {1.0, 1.0, 0.2},  -- Bright Yellow - Pull 6, 10, 14, ...
}

local unassignedColor = {0.5, 0.5, 0.5}  -- Gray for unassigned packs

-- Color cache for performance
local colorCache = {}

-- Get color for a pull number (cached)
function RDT:GetPullColor(pullNum)
    -- Handle unassigned packs
    if not pullNum or pullNum == 0 then
        return unassignedColor
    end
    
    if colorCache[pullNum] then
        return colorCache[pullNum]
    end
    
    local colorIndex = ((pullNum - 1) % #basePullColors) + 1
    local color = basePullColors[colorIndex]
    
    colorCache[pullNum] = color
    
    return color
end

--------------------------------------------------------------------------------
-- Ace3 Lifecycle Callbacks
--------------------------------------------------------------------------------

function RDT:OnInitialize()
    self:DebugPrint("OnInitialize called")
end

function RDT:OnEnable()
    self:DebugPrint("OnEnable called")

    if not self.Data then
        self:PrintError("Data module not loaded - check TOC file load order")
        return
    end
    
    -- Validate dungeon data
    self.Data:ValidateAll()

    if self.UI and self.UI.CreateMainFrame then
        self.UI:CreateMainFrame()
    end
    
    -- Load saved dungeon or default to first available
    local currentDungeon = self.db.profile.currentDungeon
    local dungeonNames = self.Data:GetDungeonNames()
    
    if not dungeonNames or #dungeonNames == 0 then
        self:PrintError("No dungeons available in Data.lua")
        return
    end
    
    if not self.Data:DungeonExists(currentDungeon) then
        currentDungeon = dungeonNames[1]
        self.db.profile.currentDungeon = currentDungeon
        self:Print("Default dungeon set to: " .. currentDungeon)
    end
    
    self:LoadDungeon(currentDungeon)
    self.State.isInitialized = true

    if self.MinimapButton then
        self.MinimapButton:Initialize()
    end
    
    self:Print("ReinDungeonTools v" .. self.Version .. " loaded! Type /rdt to open")
end

function RDT:OnDisable()
    self:DebugPrint("OnDisable called")

    if self.UI and self.UI.Hide then
        self.UI:Hide()
    end
end

--------------------------------------------------------------------------------
-- Core Functions
--------------------------------------------------------------------------------

--- Load a dungeon and initialize its route
-- @param dungeonName string The name of the dungeon to load
-- @return boolean Success status
function RDT:LoadDungeon(dungeonName)
    self:DebugPrint("Loading dungeon: " .. tostring(dungeonName))
    
    if not self.Data then
        self:PrintError("Data module not loaded yet")
        return false
    end
    
    if not self.Data:DungeonExists(dungeonName) then
        self:PrintError(string.format("Unknown dungeon: %s", tostring(dungeonName)))
        local available = self.Data:GetDungeonNames()
        if available and #available > 0 then
            self:Print("Available dungeons: " .. table.concat(available, ", "))
        end
        return false
    end
    
    self.RouteManager:EnsureRouteExists(dungeonName)

    self.State.currentRoute = self.RouteManager:GetCurrentRoute(dungeonName)

    if not self.State.currentRoute then
        self:PrintError("Failed to get route for dungeon")
        return false
    end
    
    if self.UI and self.UI.ClearPacks then
        self.UI:ClearPacks()
    end

    self.State.currentPull = self.RouteManager:GetNextPull(self.State.currentRoute.pulls)
    
    local dungeonData = self.Data:GetProcessedDungeon(dungeonName)
    
    if not dungeonData then
        self:PrintError("Failed to process dungeon data")
        return false
    end
    
    if not dungeonData.packData or #dungeonData.packData == 0 then
        self:PrintError(L["ERROR_NO_PACKS"])
        return false
    end
    
    self.db.profile.currentDungeon = dungeonName

    if self.UI then
        if self.UI.UpdateMapForDungeon then
            self.UI:UpdateMapForDungeon(dungeonName)
        elseif self.UI.UpdateMapTexture then
            self.UI:UpdateMapTexture(dungeonData.texture)
        end

        if self.UI.mapContainer then
            self.UI.mapContainer:Show()
        end

        if self.UI.CreatePacks then
            self.UI:CreatePacks(dungeonData.packData)
        end

        if self.UI.CreateIdentifierIcons then
            self.UI:CreateIdentifierIcons()
        end

        if self.UI.UpdateTitle then
            self.UI:UpdateTitle(dungeonName)
        end
        if self.UI.UpdateLabels then
            self.UI:UpdateLabels()
        end
        if self.UI.UpdatePullList then
            self.UI:UpdatePullList()
        end
        if self.UI.UpdateTotalForces then
            self.UI:UpdateTotalForces()
        end
        if self.UI.UpdateRouteDropdown then
            self.UI:UpdateRouteDropdown()
        end
        if self.UI.UpdateDungeonDropdown then
            self.UI:UpdateDungeonDropdown()
        end
    end
    
    self:DebugPrint("Dungeon loaded successfully")
    return true
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

--- Print message to chat with addon prefix
-- @param msg string Message to print
-- @param r number Red component (0-1, optional)
-- @param g number Green component (0-1, optional)
-- @param b number Blue component (0-1, optional)
function RDT:Print(msg, r, g, b)
    if msg then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[RDT]|r " .. tostring(msg), r or 1, g or 1, b or 1)
    end
end

-- @param msg string Debug message to print
function RDT:DebugPrint(msg)
    if self.db and self.db.profile.debug then
        self:Print("|cFF888888[DEBUG]|r " .. tostring(msg), 0.7, 0.7, 0.7)
    end
end

-- @param msg string Error message to print
function RDT:PrintError(msg)
    self:Print("|cFFFF0000[ERROR]|r " .. tostring(msg), 1, 0.3, 0.3)
end

-- @param func function Function to execute
-- @param ... any Arguments to pass to function
-- @return boolean success, any result or error
function RDT:SafeExecute(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        self:PrintError(tostring(err))
        if self.Debug then
            self:Print(debugstack())
        end
    end
    return success, err
end

RDT:DebugPrint("Init.lua loaded")
