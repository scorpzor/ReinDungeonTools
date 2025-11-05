-- Core/Database.lua
-- Database initialization and profile management using AceDB-3.0

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

--------------------------------------------------------------------------------
-- Default Settings Structure
--------------------------------------------------------------------------------

local defaults = {
    profile = {
        currentDungeon = nil,
        routes = {},
        debug = false,
        showMinimapButton = true,
        
        -- Main window position
        windowPosition = {
            point = "CENTER",
            relativePoint = "CENTER",
            xOfs = 0,
            yOfs = 0,
        },
    },
}

--------------------------------------------------------------------------------
-- Database Initialization (called from Init.lua OnInitialize)
--------------------------------------------------------------------------------

function RDT:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ReinDungeonToolsDB", defaults, true)

    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    self:RegisterChatCommand("rdt", "SlashCommand")
    self:RegisterChatCommand("reindungeontools", "SlashCommand")
    
    self:Print(string.format(L["VERSION_INFO"], self.Version))
    self:DebugPrint("Database initialized")
end

--------------------------------------------------------------------------------
-- Profile Management
--------------------------------------------------------------------------------

function RDT:RefreshConfig()
    self:Print("Profile changed, reloading...")
    if self.State.isInitialized then
        self:LoadDungeon(self.db.profile.currentDungeon)
    end
end

--- Get list of all available profiles
-- @return table Array of profile names
function RDT:GetProfiles()
    local profiles = {}
    for name in pairs(self.db:GetProfiles({})) do
        tinsert(profiles, name)
    end
    table.sort(profiles)
    return profiles
end

--- Get current profile name
-- @return string Current profile name
function RDT:GetCurrentProfile()
    return self.db:GetCurrentProfile()
end

--- Switch to a different profile
-- @param profileName string Name of profile to switch to
-- @return boolean Success status
function RDT:SetProfile(profileName)
    if type(profileName) ~= "string" or profileName == "" then
        self:PrintError("Invalid profile name")
        return false
    end
    
    self.db:SetProfile(profileName)
    self:Print(string.format(L["PROFILE_SWITCHED"], profileName))
    return true
end

--- Create a new profile
-- @param profileName string Name for the new profile
-- @return boolean Success status
function RDT:CreateProfile(profileName)
    if type(profileName) ~= "string" or profileName == "" then
        self:PrintError("Invalid profile name")
        return false
    end
    
    local profiles = self:GetProfiles()
    for _, name in ipairs(profiles) do
        if name == profileName then
            self:PrintError("Profile '" .. profileName .. "' already exists")
            return false
        end
    end
    
    -- Create by switching to it (AceDB creates on-demand)
    self.db:SetProfile(profileName)
    self:Print(string.format(L["PROFILE_CREATED"], profileName))
    return true
end

--- Delete a profile
-- @param profileName string Name of profile to delete
-- @return boolean Success status
function RDT:DeleteProfile(profileName)
    if type(profileName) ~= "string" or profileName == "" then
        self:PrintError("Invalid profile name")
        return false
    end
    
    if profileName == self:GetCurrentProfile() then
        self:PrintError("Cannot delete the active profile")
        return false
    end
    
    self.db:DeleteProfile(profileName)
    self:Print(string.format(L["PROFILE_DELETED"], profileName))
    return true
end

--- Copy settings from another profile to current
-- @param sourceProfile string Name of profile to copy from
-- @return boolean Success status
function RDT:CopyProfile(sourceProfile)
    if type(sourceProfile) ~= "string" or sourceProfile == "" then
        self:PrintError("Invalid profile name")
        return false
    end
    
    if sourceProfile == self:GetCurrentProfile() then
        self:PrintError("Cannot copy profile to itself")
        return false
    end
    
    self.db:CopyProfile(sourceProfile)
    self:Print(string.format(L["PROFILE_COPIED"], sourceProfile, self:GetCurrentProfile()))

    self:RefreshConfig()
    return true
end

--- Reset current profile to defaults
-- @return boolean Success status
function RDT:ResetProfile()
    self.db:ResetProfile()
    self:Print("Profile reset to defaults")

    self:RefreshConfig()
    return true
end

--- Reset entire database (all profiles)
-- @return boolean Success status
function RDT:ResetDatabase()
    self.db:ResetDB()
    self:Print("Database reset to defaults")

    self:RefreshConfig()
    return true
end

--------------------------------------------------------------------------------
-- Saved Variables Helpers
--------------------------------------------------------------------------------

--- Get a saved setting
-- @param key string Setting key (supports dot notation: "routes.Test Dungeon")
-- @return any Setting value or nil
function RDT:GetSetting(key)
    local parts = {strsplit(".", key)}
    local current = self.db.profile
    
    for _, part in ipairs(parts) do
        if type(current) == "table" then
            current = current[part]
        else
            return nil
        end
    end
    
    return current
end

--- Set a saved setting
-- @param key string Setting key
-- @param value any Value to save
function RDT:SetSetting(key, value)
    local parts = {strsplit(".", key)}
    local current = self.db.profile
    
    for i = 1, #parts - 1 do
        if type(current[parts[i]]) ~= "table" then
            current[parts[i]] = {}
        end
        current = current[parts[i]]
    end
    
    current[parts[#parts]] = value
end

RDT:DebugPrint("Database.lua loaded")
