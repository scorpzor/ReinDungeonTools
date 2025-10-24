-- Core functionality with Ace3 framework
local RDT = LibStub("AceAddon-3.0"):NewAddon("ReinDungeonTools", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- Addon version
RDT.Version = "1.0.0"

-- Default settings structure for AceDB
local defaults = {
    profile = {
        currentDungeon = "Test Dungeon",
        routes = {},  -- Per-dungeon routes (pulls)
        debug = false,
        showMinimapButton = true,
        windowPosition = {
            point = "CENTER",
            relativePoint = "CENTER",
            xOfs = 0,
            yOfs = 0,
        },
    },
}

-- Pull colors - 4 distinct colors that repeat in a cycle
local basePullColors = {
    {0.0, 0.8, 1.0},  -- Cyan/Aqua - Pull 1, 5, 9, ...
    {1.0, 0.5, 0.0},  -- Orange - Pull 2, 6, 10, ...
    {0.6, 0.2, 1.0},  -- Purple - Pull 3, 7, 11, ...
    {0.0, 1.0, 0.4},  -- Green - Pull 4, 8, 12, ...
}

local unassignedColor = {0.5, 0.5, 0.5}  -- Gray for unassigned packs

-- Get color for a pull number (calculated on-demand with caching)
local colorCache = {}
function RDT:GetPullColor(pullNum)
    -- Handle unassigned packs
    if not pullNum or pullNum == 0 then
        return unassignedColor
    end
    
    -- Check cache first
    if colorCache[pullNum] then
        return colorCache[pullNum]
    end
    
    -- Calculate color based on repeating pattern
    local colorIndex = ((pullNum - 1) % #basePullColors) + 1
    local color = basePullColors[colorIndex]
    
    -- Cache for future use
    colorCache[pullNum] = color
    
    return color
end

-- Backward compatibility: Keep PullColors table but use metatable for dynamic lookup
RDT.PullColors = setmetatable({
    [0] = unassignedColor,  -- Explicit for pull 0
}, {
    __index = function(t, key)
        return RDT:GetPullColor(key)
    end
})

-- Addon state (not saved)
RDT.State = {
    selectedPacks = {},
    currentPull = 1,
    currentRoute = nil,
    packButtons = {},
    isInitialized = false,
}

-- Ace3 lifecycle: Called when addon is first loaded
function RDT:OnInitialize()
    -- Initialize database with AceDB
    self.db = LibStub("AceDB-3.0"):New("ReinDungeonToolsDB", defaults, true)
    
    -- Register profile callbacks
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    
    -- Register slash commands
    self:RegisterChatCommand("rdt", "SlashCommand")
    self:RegisterChatCommand("reindungeontools", "SlashCommand")
    
    self:Print(string.format(L["VERSION_INFO"], self.Version))
end

-- Ace3 lifecycle: Called when addon is enabled
function RDT:OnEnable()
    -- Validate data
    if RDT.Data then
        RDT.Data:ValidateAll()
    end
    
    -- Create UI
    if RDT_CreateUI then
        RDT_CreateUI()
    end
    
    -- Load saved dungeon
    local currentDungeon = self.db.profile.currentDungeon
    if not RDT.Data or not RDT.Data:DungeonExists(currentDungeon) then
        currentDungeon = RDT.Data and RDT.Data:GetDungeonNames()[1] or "Test Dungeon"
        self.db.profile.currentDungeon = currentDungeon
    end
    
    self:LoadDungeon(currentDungeon)
    self.State.isInitialized = true
    
    self:Print(L["VERSION_LOADED"])
end

-- Ace3 lifecycle: Called when addon is disabled
function RDT:OnDisable()
    -- Cleanup if needed
    if self.UI then
        self.UI:Hide()
    end
end

-- Profile changed callback
function RDT:RefreshConfig()
    self:Print("Profile changed, reloading...")
    if self.State.isInitialized then
        self:LoadDungeon(self.db.profile.currentDungeon)
    end
end

-- Get next available pull number
function RDT:GetNextPull(pullsTable)
    if not pullsTable or type(pullsTable) ~= "table" then
        return 1
    end
    
    local maxP = 0
    for _, p in pairs(pullsTable) do
        if type(p) == "number" and p > maxP then
            maxP = p
        end
    end
    return maxP + 1
end

-- Calculate total enemy forces percentage for current route
function RDT:CalculateTotalForces()
    if not self.State.currentRoute then return 0 end
    
    local total = 0
    for packId, pullNum in pairs(self.State.currentRoute.pulls) do
        if pullNum and pullNum > 0 then
            local button = self.State.packButtons["pack" .. packId]
            if button and button.count then
                total = total + button.count
            end
        end
    end
    
    return total
end

-- Load a dungeon with validation
function RDT:LoadDungeon(dungeonName)
    self:DebugPrint("Loading dungeon: " .. tostring(dungeonName))
    
    -- Validate dungeon exists
    if not RDT.Data or not RDT.Data:DungeonExists(dungeonName) then
        self:PrintError(string.format(L["ERROR_UNKNOWN_DUNGEON"], tostring(dungeonName)))
        return false
    end
    
    -- Ensure routes table structure
    self.db.profile.routes[dungeonName] = self.db.profile.routes[dungeonName] or {pulls = {}}
    self.State.currentRoute = self.db.profile.routes[dungeonName]
    
    -- Clear old state
    if RDT.UI then
        RDT.UI:ClearPacks()
    end
    
    self.State.currentPull = self:GetNextPull(self.State.currentRoute.pulls)
    
    -- Load new dungeon
    local dungeonData = RDT.Data:GetDungeon(dungeonName)
    
    if not dungeonData.packData or #dungeonData.packData == 0 then
        self:PrintError(L["ERROR_NO_PACKS"])
        return false
    end
    
    if RDT.UI then
        RDT.UI:CreatePacks(dungeonData.packData)
        RDT.UI:UpdateMapTexture(dungeonData.texture)
        RDT.UI:UpdateTitle(dungeonName)
        RDT.UI:ClearSelection()
        RDT.UI:UpdateLabels()
        RDT.UI:UpdatePullList()
    end
    
    -- Save current dungeon
    self.db.profile.currentDungeon = dungeonName
    
    self:DebugPrint("Dungeon loaded successfully")
    return true
end

-- Group selected packs into current pull
function RDT:GroupPull()
    if #self.State.selectedPacks == 0 then 
        self:Print("No packs selected")
        return 
    end
    
    self:DebugPrint("Grouping " .. #self.State.selectedPacks .. " packs into pull " .. self.State.currentPull)
    
    for _, id in ipairs(self.State.selectedPacks) do
        self.State.currentRoute.pulls[id] = self.State.currentPull
    end
    
    if RDT.UI then
        RDT.UI:ClearSelection()
        RDT.UI:UpdateLabels()
    end
    
    self.State.currentPull = self:GetNextPull(self.State.currentRoute.pulls)
    
    if RDT.UI then
        RDT.UI:UpdatePullList()
    end
end

-- Reset all pulls for current dungeon
function RDT:ResetPulls()
    if not self.State.currentRoute then return end
    
    self:DebugPrint("Resetting all pulls")
    
    wipe(self.State.currentRoute.pulls)
    self.State.currentPull = 1
    
    if RDT.UI then
        RDT.UI:ClearSelection()
        RDT.UI:UpdateLabels()
        RDT.UI:UpdatePullList()
    end
    
    self:Print("All pulls reset")
end

-- Export current route as string
function RDT:ExportRoute()
    if not self.State.currentRoute then 
        self:Print("No route to export")
        return nil
    end
    
    local dungeonName = self.db.profile.currentDungeon
    
    -- Build export data
    local exportData = {
        version = self.Version,
        dungeon = dungeonName,
        pulls = self.State.currentRoute.pulls,
        timestamp = time(),
        author = UnitName("player"),
    }
    
    -- Check if libraries are available
    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    local LibCompress = LibStub:GetLibrary("LibCompress", true)
    
    if not AceSerializer then
        self:PrintError("AceSerializer-3.0 not found. Import/Export requires additional libraries.")
        self:Print("Download from: https://www.wowace.com/projects/ace3/files")
        return nil
    end
    
    if not LibCompress then
        self:PrintError("LibCompress not found. Import/Export requires additional libraries.")
        self:Print("Download from: https://www.wowace.com/projects/libcompress/files")
        return nil
    end
    
    -- Step 1: Serialize (Lua table → string)
    local serialized = AceSerializer:Serialize(exportData)
    
    self:DebugPrint("Serialized length: " .. string.len(serialized))
    
    -- Step 2: Compress (reduce size)
    local compressed = LibCompress:CompressHuffman(serialized)
    local didCompress = false
    
    if compressed and string.len(compressed) < string.len(serialized) then
        -- Compression was beneficial
        didCompress = true
        self:DebugPrint("Compressed length: " .. string.len(compressed) .. " (saved " .. (string.len(serialized) - string.len(compressed)) .. " bytes)")
    else
        -- Compression didn't help or failed, use original
        compressed = serialized
        didCompress = false
        self:DebugPrint("Compression skipped (data too small or compression ineffective)")
    end
    
    -- Step 3: Encode for safe transmission
    local encoded = LibCompress:GetAddonEncodeTable():Encode(compressed)
    
    -- Add prefix with compression flag
    local importString = (didCompress and "RDT1C:" or "RDT1:") .. encoded
    
    self:Print("Route exported! Length: " .. string.len(importString))
    self:Print("Copy the string below:")
    
    return importString
end

-- Import route from string
function RDT:ImportRoute(importString)
    if not importString or importString == "" then
        self:PrintError("Invalid import string")
        return false
    end
    
    -- Trim whitespace
    importString = strtrim(importString)
    
    -- Check prefix and extract version + compression flag
    local prefix, encoded = importString:match("^(RDT%d+C?):(.+)$")
    if not prefix then
        self:PrintError("Not a valid RDT import string (missing prefix)")
        return false
    end
    
    local isCompressed = prefix:match("C$") ~= nil
    local version = prefix:match("^RDT(%d+)")
    
    if version ~= "1" then
        self:PrintError("Unsupported import format version: " .. version)
        return false
    end
    
    self:DebugPrint("Import string version: " .. version .. ", compressed: " .. tostring(isCompressed))
    
    -- Check if libraries are available
    local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0", true)
    local LibCompress = LibStub:GetLibrary("LibCompress", true)
    
    if not AceSerializer or not LibCompress then
        self:PrintError("Required libraries not found for import")
        return false
    end
    
    -- Step 1: Decode
    local decoded = LibCompress:GetAddonEncodeTable():Decode(encoded)
    if not decoded then
        self:PrintError("Failed to decode import string")
        self:DebugPrint("Encoded length: " .. string.len(encoded))
        return false
    end
    
    self:DebugPrint("Decoded successfully, length: " .. string.len(decoded))
    
    -- Step 2: Decompress (only if it was compressed)
    local decompressed
    if isCompressed then
        self:DebugPrint("Attempting decompression...")
        local success, result = pcall(LibCompress.DecompressHuffman, LibCompress, decoded)
        if success and result then
            decompressed = result
            self:DebugPrint("Decompressed successfully, length: " .. string.len(decompressed))
        else
            self:PrintError("Failed to decompress: " .. tostring(result))
            return false
        end
    else
        -- Not compressed, use directly
        decompressed = decoded
        self:DebugPrint("Skipping decompression (not compressed)")
    end
    
    -- Step 3: Deserialize
    local success, data = AceSerializer:Deserialize(decompressed)
    if not success then
        self:PrintError("Failed to deserialize import string")
        return false
    end
    
    -- Step 4: VALIDATE (critical for security!)
    if not self:ValidateImportData(data) then
        self:PrintError("Import data validation failed - data may be corrupted or malicious")
        return false
    end
    
    -- Step 5: Check dungeon exists
    if not RDT.Data:DungeonExists(data.dungeon) then
        self:PrintError("Dungeon '" .. data.dungeon .. "' not found in your addon")
        self:Print("This route is for: " .. data.dungeon)
        return false
    end
    
    -- Step 6: Confirm with user
    self:Print("Importing route for: |cFFFFAA00" .. data.dungeon .. "|r")
    if data.author then
        self:Print("Created by: " .. data.author)
    end
    if data.version ~= self.Version then
        self:Print("|cFFFFFF00Warning:|r Route from different version (" .. data.version .. ")")
    end
    
    local pullCount = 0
    for _ in pairs(data.pulls) do pullCount = pullCount + 1 end
    self:Print("Contains " .. pullCount .. " pack assignments")
    
    -- Step 7: Load the dungeon first
    self:LoadDungeon(data.dungeon)
    
    -- Step 8: Apply the pulls
    wipe(self.State.currentRoute.pulls)
    for packId, pullNum in pairs(data.pulls) do
        self.State.currentRoute.pulls[packId] = pullNum
    end
    
    -- Recalculate current pull
    self.State.currentPull = self:GetNextPull(self.State.currentRoute.pulls)
    
    -- Step 9: Update UI
    if RDT.UI then
        RDT.UI:UpdateLabels()
        RDT.UI:UpdatePullList()
    end
    
    self:Print("|cFF00FF00Route imported successfully!|r")
    return true
end

-- Validate imported data (SECURITY!)
function RDT:ValidateImportData(data)
    -- Check basic structure
    if type(data) ~= "table" then 
        self:DebugPrint("Validation failed: data is not a table")
        return false 
    end
    
    -- Check required fields
    if not data.version or type(data.version) ~= "string" then
        self:DebugPrint("Validation failed: invalid version")
        return false
    end
    
    if not data.dungeon or type(data.dungeon) ~= "string" then
        self:DebugPrint("Validation failed: invalid dungeon")
        return false
    end
    
    if not data.pulls or type(data.pulls) ~= "table" then
        self:DebugPrint("Validation failed: invalid pulls table")
        return false
    end
    
    -- Validate pulls table entries
    for packId, pullNum in pairs(data.pulls) do
        -- Check pack ID is number and reasonable
        if type(packId) ~= "number" then
            self:DebugPrint("Validation failed: pack ID not a number")
            return false
        end
        if packId < 1 or packId > 1000 then  -- Reasonable limits
            self:DebugPrint("Validation failed: pack ID out of range")
            return false
        end
        
        -- Check pull number is valid
        if type(pullNum) ~= "number" then
            self:DebugPrint("Validation failed: pull number not a number")
            return false
        end
        if pullNum < 0 or pullNum > 100 then  -- Max 100 pulls should be plenty
            self:DebugPrint("Validation failed: pull number out of range")
            return false
        end
    end
    
    return true
end

-- Slash command handler
function RDT:SlashCommand(input)
    local cmd = string.lower(input or "")
    
    if cmd == "debug" then
        self.db.profile.debug = not self.db.profile.debug
        self:Print("Debug mode: " .. (self.db.profile.debug and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"))
        
    elseif cmd == "reset" then
        self:ResetPulls()
        
    elseif cmd == "version" or cmd == "v" then
        self:Print(string.format(L["VERSION_INFO"], self.Version))
        
    elseif cmd:match("^profile") then
        -- Profile management (AceDB built-in)
        local _, profileCmd, profileName = strsplit(" ", cmd, 3)
        if profileCmd == "list" then
            self:Print("Available profiles:")
            for name in pairs(self.db:GetProfiles()) do
                local current = (name == self.db:GetCurrentProfile()) and " |cFF00FF00(current)|r" or ""
                self:Print("  - " .. name .. current)
            end
        elseif profileCmd == "use" and profileName then
            self.db:SetProfile(profileName)
            self:Print(string.format(L["PROFILE_SWITCHED"], profileName))
        else
            self:Print("Profile commands: /rdt profile list, /rdt profile use <name>")
        end
        
    elseif cmd:match("^export") then
        -- Export current route
        local exportString = self:ExportRoute()
        if exportString then
            -- Create a frame to display the export string
            if not RDT.ExportFrame then
                RDT:CreateExportFrame()
            end
            RDT.ExportFrame.editBox:SetText(exportString)
            RDT.ExportFrame.editBox:HighlightText()
            RDT.ExportFrame:Show()
        end
        
    elseif cmd:match("^import%s+(.+)") then
        -- Import from command line
        local importString = cmd:match("^import%s+(.+)")
        self:ImportRoute(importString)
        
    elseif cmd == "import" then
        -- Show import dialog
        if not RDT.ImportFrame then
            RDT:CreateImportFrame()
        end
        RDT.ImportFrame:Show()
        
    elseif cmd == "help" or cmd == "?" then
        self:Print(L["SLASH_HELP"])
        self:Print(L["SLASH_TOGGLE"])
        self:Print(L["SLASH_DEBUG"])
        self:Print(L["SLASH_RESET"])
        self:Print(L["SLASH_VERSION"])
        self:Print("/rdt profile list - List available profiles")
        self:Print("/rdt profile use <name> - Switch to profile")
        
    else
        -- Toggle UI
        local frame = _G["RDT_Frame"]
        if not frame then
            self:PrintError("UI not initialized yet")
            return
        end
        
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
            if RDT.UI then
                RDT.UI:ClearSelection()
                RDT.UI:UpdatePullList()
            end
        end
    end
end

-- Debug print (only when debug enabled)
function RDT:DebugPrint(msg)
    if self.db and self.db.profile.debug then
        self:Print("|cFF888888[DEBUG]|r " .. tostring(msg))
    end
end

-- Error print
function RDT:PrintError(msg)
    self:Print("|cFFFF0000[ERROR]|r " .. tostring(msg))
end

-- Make RDT globally accessible for UI and Data modules
_G.RDT = RDT