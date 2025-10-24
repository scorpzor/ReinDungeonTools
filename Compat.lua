-- Compatibility layer for WotLK 3.3.5a
-- This file provides helper functions and ensures we're running on correct client

local addonName, RDT = ...

-- Version check - MUST be 3.3.5a (build 12340)
local version, build, date, tocversion = GetBuildInfo()
if tocversion ~= 30300 then
    error(string.format("%s requires WoW 3.3.5a (Interface: 30300). Current: %d", addonName, tocversion or 0))
    return
end

-- Initialize namespace
RDT.Compat = {}
RDT.Debug = false  -- Set to true for verbose logging

-- Safe print with addon prefix
function RDT.Print(msg, r, g, b)
    if msg then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00[RDT]|r " .. tostring(msg), r or 1, g or 1, b or 1)
    end
end

-- Debug print (only when debug enabled)
function RDT.DebugPrint(msg)
    if RDT.Debug then
        RDT.Print("|cFF888888[DEBUG]|r " .. tostring(msg), 0.7, 0.7, 0.7)
    end
end

-- Error print
function RDT.ErrorPrint(msg)
    RDT.Print("|cFFFF0000[ERROR]|r " .. tostring(msg), 1, 0.3, 0.3)
end

-- Safe execution wrapper with error handling
function RDT.SafeExecute(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        RDT.ErrorPrint(tostring(err))
        if RDT.Debug then
            RDT.Print(debugstack())
        end
    end
    return success, err
end

-- Safe table wipe (checks if table exists)
function RDT.Compat.SafeWipe(tbl)
    if tbl and type(tbl) == "table" then
        wipe(tbl)
        return true
    end
    return false
end

-- Safe table insert
function RDT.Compat.SafeInsert(tbl, value)
    if tbl and type(tbl) == "table" and value ~= nil then
        tinsert(tbl, value)
        return true
    end
    return false
end

-- Safe table remove
function RDT.Compat.SafeRemove(tbl, pos)
    if tbl and type(tbl) == "table" and pos then
        return tremove(tbl, pos)
    end
    return nil
end

-- Helper: Find index of value in table (ipairs style)
function RDT.Compat.IndexOf(tbl, value)
    if not tbl or type(tbl) ~= "table" then return nil end
    for i, v in ipairs(tbl) do
        if v == value then return i end
    end
    return nil
end

-- Helper: Check if table contains value
function RDT.Compat.Contains(tbl, value)
    return RDT.Compat.IndexOf(tbl, value) ~= nil
end

-- Helper: Copy table (shallow)
function RDT.Compat.CopyTable(src)
    if type(src) ~= "table" then return src end
    local copy = {}
    for k, v in pairs(src) do
        copy[k] = v
    end
    return copy
end

-- Helper: Deep copy table
function RDT.Compat.DeepCopy(src)
    if type(src) ~= "table" then return src end
    local copy = {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            copy[k] = RDT.Compat.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Helper: Count table entries (works with hash tables)
function RDT.Compat.CountTable(tbl)
    if type(tbl) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- Helper: Get keys from table
function RDT.Compat.GetKeys(tbl)
    local keys = {}
    if type(tbl) == "table" then
        for k in pairs(tbl) do
            tinsert(keys, k)
        end
    end
    return keys
end

-- Helper: Validate coordinates (normalized 0-1)
function RDT.Compat.ValidateCoords(x, y)
    return type(x) == "number" and type(y) == "number" 
           and x >= 0 and x <= 1 
           and y >= 0 and y <= 1
end

-- Helper: Clamp value between min and max
function RDT.Compat.Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- Helper: Round number to decimal places
function RDT.Compat.Round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Frame pool for reusable frames (simple implementation for 3.3.5a)
function RDT.Compat.CreateFramePool(frameType, parent, template)
    local pool = {
        frames = {},
        activeFrames = {},
        parent = parent,
        frameType = frameType,
        template = template,
    }
    
    function pool:Acquire()
        local frame = tremove(self.frames)
        if not frame then
            frame = CreateFrame(self.frameType, nil, self.parent, self.template)
            frame.pool = self
        end
        frame:Show()
        tinsert(self.activeFrames, frame)
        return frame
    end
    
    function pool:Release(frame)
        if not frame then return end
        frame:Hide()
        frame:ClearAllPoints()
        frame:SetParent(self.parent)
        
        for i, f in ipairs(self.activeFrames) do
            if f == frame then
                tremove(self.activeFrames, i)
                break
            end
        end
        
        tinsert(self.frames, frame)
    end
    
    function pool:ReleaseAll()
        for i = #self.activeFrames, 1, -1 do
            self:Release(self.activeFrames[i])
        end
    end
    
    return pool
end

-- FontString pool for reusable text
function RDT.Compat.CreateFontStringPool(parent, layer, fontObject)
    local pool = {
        strings = {},
        activeStrings = {},
        parent = parent,
        layer = layer or "OVERLAY",
        fontObject = fontObject or "GameFontHighlight",
    }
    
    function pool:Acquire()
        local fs = tremove(self.strings)
        if not fs then
            fs = self.parent:CreateFontString(nil, self.layer, self.fontObject)
            fs.pool = self
        end
        fs:Show()
        tinsert(self.activeStrings, fs)
        return fs
    end
    
    function pool:Release(fs)
        if not fs then return end
        fs:Hide()
        fs:ClearAllPoints()
        fs:SetText("")
        
        for i, f in ipairs(self.activeStrings) do
            if f == fs then
                tremove(self.activeStrings, i)
                break
            end
        end
        
        tinsert(self.strings, fs)
    end
    
    function pool:ReleaseAll()
        for i = #self.activeStrings, 1, -1 do
            self:Release(self.activeStrings[i])
        end
    end
    
    return pool
end

-- Initialization message
RDT.DebugPrint(string.format("Compat layer loaded - WoW %s (Build %s)", version, build))