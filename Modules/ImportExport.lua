-- Modules/ImportExport.lua
-- Route import/export with Base64 serialization and validation

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

RDT.ImportExport = {}
local IE = RDT.ImportExport

-- Local references to dependencies
local RouteSerializer = RDT.RouteSerializer

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

--- Print human-readable debug output for export/import data
-- @param exportData table The export data structure
-- @param label string Debug section label (e.g., "EXPORT" or "IMPORT")
local function DebugPrintRouteData(exportData, label)
    RDT:DebugPrint("=== " .. label .. " DEBUG ===")
    RDT:DebugPrint("Dungeon: " .. tostring(exportData.dungeon))
    RDT:DebugPrint("Route Name: " .. tostring(exportData.routeName))
    RDT:DebugPrint("Author: " .. tostring(exportData.author))
    RDT:DebugPrint("Version: " .. tostring(exportData.version))
    RDT:DebugPrint("Addon Version: " .. tostring(exportData.addonVersion))

    local pullCount = 0
    local packsByPull = {}
    for packId, pullNum in pairs(exportData.pulls) do
        pullCount = pullCount + 1
        packsByPull[pullNum] = packsByPull[pullNum] or {}
        table.insert(packsByPull[pullNum], packId)
    end

    RDT:DebugPrint("Total Packs: " .. pullCount)
    RDT:DebugPrint("Pulls:")

    local sortedPulls = {}
    for pullNum in pairs(packsByPull) do
        table.insert(sortedPulls, pullNum)
    end
    table.sort(sortedPulls)

    for _, pullNum in ipairs(sortedPulls) do
        local packs = packsByPull[pullNum]
        table.sort(packs)
        local packList = table.concat(packs, ", ")
        RDT:DebugPrint(string.format("  Pull %d: [%s]", pullNum, packList))
    end

    RDT:DebugPrint("==================")
end

--------------------------------------------------------------------------------
-- Export Functions
--------------------------------------------------------------------------------

--- Export current route as Base64-encoded string
-- @return string Encoded route string or nil on failure
function IE:Export()
    local exportData = RouteSerializer:CreateExportData()
    if not exportData then
        return nil
    end

    local importString = RouteSerializer:EncodeRouteData(exportData)
    if not importString then
        return nil
    end

    RDT:Print(string.format("Route exported! Length: %d characters", string.len(importString)))
    DebugPrintRouteData(exportData, "EXPORT")

    return importString
end

--------------------------------------------------------------------------------
-- Import Functions
--------------------------------------------------------------------------------

--- Import route from encoded string
-- @param importString string The encoded route string
-- @return boolean Success status
function IE:Import(importString)
    local data = RouteSerializer:DecodeRouteData(importString)
    if not data then
        return false
    end

    DebugPrintRouteData(data, "IMPORT")

    if not RouteSerializer:ValidateRouteData(data) then
        RDT:PrintError("Import data validation failed (corrupted or malicious data)")
        return false
    end

    if not RDT.Data:DungeonExists(data.dungeon) then
        RDT:PrintError("Dungeon '" .. data.dungeon .. "' not found in your addon")
        RDT:Print("This route is for: " .. data.dungeon)
        return false
    end

    RDT:Print("|cFFFFFF00Importing route:|r")
    RDT:Print("  Dungeon: |cFFFFAA00" .. data.dungeon .. "|r")
    if data.routeName then
        RDT:Print("  Route Name: " .. data.routeName)
    end
    if data.author then
        RDT:Print("  Author: " .. data.author)
    end
    if data.addonVersion and data.addonVersion ~= RDT.Version then
        RDT:Print("  |cFFFFFF00Created with v" .. data.addonVersion .. " (you have v" .. RDT.Version .. ")|r")
    end

    local packCount = 0
    for _ in pairs(data.pulls) do packCount = packCount + 1 end
    RDT:Print("  Packs: " .. packCount .. " assigned")
    
    if not RDT:LoadDungeon(data.dungeon) then
        RDT:PrintError("Failed to load dungeon")
        return false
    end
    
    if not RDT.RouteManager then
        RDT:PrintError("RouteManager not available")
        return false
    end
    
    local importedRouteName = data.routeName or "Imported Route"
    local newRouteName = RDT.RouteManager:CreateRoute(data.dungeon, importedRouteName)
    
    if not newRouteName then
        RDT:PrintError("Failed to create new route")
        return false
    end
    
    if not RDT.State.currentRoute then
        RDT:PrintError("Failed to get current route")
        return false
    end
    
    wipe(RDT.State.currentRoute.pulls)
    for packId, pullNum in pairs(data.pulls) do
        RDT.State.currentRoute.pulls[packId] = pullNum
    end
    
    RDT.State.currentPull = RDT.RouteManager:GetNextPull(RDT.State.currentRoute.pulls)
    
    if RDT.UI then
        if RDT.UI.UpdateLabels then
            RDT.UI:UpdateLabels()
        end
        if RDT.UI.UpdatePullList then
            RDT.UI:UpdatePullList()
        end
        if RDT.UI.UpdateRouteDropdown then
            RDT.UI:UpdateRouteDropdown()
        end
        if RDT.UI.UpdateTotalForces then
            RDT.UI:UpdateTotalForces()
        end
    end
    
    RDT:Print("|cFF00FF00Route imported successfully to: " .. newRouteName .. "|r")
    return true
end

RDT:DebugPrint("ImportExport.lua loaded")