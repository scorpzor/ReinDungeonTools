-- Core/RouteManager.lua
-- Route management: grouping pulls, calculating forces, route state

local RDT = _G.RDT
local L = LibStub("AceLocale-3.0"):GetLocale("ReinDungeonTools")

-- Module namespace
RDT.RouteManager = {}
local RM = RDT.RouteManager

--------------------------------------------------------------------------------
-- Pull Number Management
--------------------------------------------------------------------------------

--- Get next available pull number
-- @param pullsTable table The pulls table from a route
-- @return number Next available pull number (minimum 1)
function RM:GetNextPull(pullsTable)
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

--- Get all unique pull numbers in use
-- @param pullsTable table The pulls table from a route
-- @return table Sorted array of pull numbers
function RM:GetUsedPulls(pullsTable)
    if not pullsTable or type(pullsTable) ~= "table" then
        return {}
    end
    
    local pulls = {}
    local pullSet = {}
    
    for _, pullNum in pairs(pullsTable) do
        if type(pullNum) == "number" and pullNum > 0 and not pullSet[pullNum] then
            pullSet[pullNum] = true
            tinsert(pulls, pullNum)
        end
    end
    
    table.sort(pulls)
    return pulls
end

--------------------------------------------------------------------------------
-- Force Calculations
--------------------------------------------------------------------------------

--- Calculate total enemy forces percentage for current route
-- @return number Total percentage (0-100+)
function RM:CalculateTotalForces()
    if not RDT.State.currentRoute then return 0 end
    
    local total = 0
    for packId, pullNum in pairs(RDT.State.currentRoute.pulls) do
        if pullNum and pullNum > 0 then
            local button = RDT.State.packButtons["pack" .. packId]
            if button and button.count then
                total = total + button.count
            end
        end
    end
    
    return total
end

--- Calculate forces for a specific pull
-- @param pullNum number Pull number to calculate
-- @return number Total percentage for that pull
function RM:CalculatePullForces(pullNum)
    if not RDT.State.currentRoute or not pullNum then return 0 end
    
    local total = 0
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            local button = RDT.State.packButtons["pack" .. packId]
            if button and button.count then
                total = total + button.count
            end
        end
    end
    
    return total
end

--- Get pack IDs assigned to a specific pull
-- @param pullNum number Pull number
-- @return table Array of pack IDs
function RM:GetPacksInPull(pullNum)
    if not RDT.State.currentRoute or not pullNum then return {} end
    
    local packs = {}
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            tinsert(packs, packId)
        end
    end
    
    table.sort(packs)
    return packs
end

--------------------------------------------------------------------------------
-- Route Modification
--------------------------------------------------------------------------------

--- Group selected packs into current pull
function RM:GroupPull()
    if #RDT.State.selectedPacks == 0 then 
        RDT:Print("No packs selected")
        return 
    end
    
    RDT:DebugPrint("Grouping " .. #RDT.State.selectedPacks .. " packs into pull " .. RDT.State.currentPull)
    
    -- Assign all selected packs to current pull
    for _, id in ipairs(RDT.State.selectedPacks) do
        RDT.State.currentRoute.pulls[id] = RDT.State.currentPull
    end
    
    -- Update UI
    if RDT.UI then
        if RDT.UI.ClearSelection then
            RDT.UI:ClearSelection()
        end
        if RDT.UI.UpdateLabels then
            RDT.UI:UpdateLabels()
        end
    end
    
    -- Advance to next pull
    RDT.State.currentPull = self:GetNextPull(RDT.State.currentRoute.pulls)
    
    -- Update pull list
    if RDT.UI and RDT.UI.UpdatePullList then
        RDT.UI:UpdatePullList()
    end
    
    RDT:Print(string.format("Grouped %d packs into pull", #RDT.State.selectedPacks))
end

--- Unassign a pack from its pull
-- @param packId number Pack ID to unassign
function RM:UnassignPack(packId)
    if not RDT.State.currentRoute then return end
    
    if RDT.State.currentRoute.pulls[packId] then
        local oldPull = RDT.State.currentRoute.pulls[packId]
        RDT.State.currentRoute.pulls[packId] = nil
        
        -- Update UI
        if RDT.UI then
            if RDT.UI.UpdateLabels then
                RDT.UI:UpdateLabels()
            end
            if RDT.UI.UpdatePullList then
                RDT.UI:UpdatePullList()
            end
        end
        
        RDT:Print(string.format("Pack %d removed from pull %d", packId, oldPull))
    end
end

--- Unassign all packs from a specific pull
-- @param pullNum number Pull number to clear
function RM:UnassignPull(pullNum)
    if not RDT.State.currentRoute or not pullNum then return end
    
    local count = 0
    for packId, pNum in pairs(RDT.State.currentRoute.pulls) do
        if pNum == pullNum then
            RDT.State.currentRoute.pulls[packId] = nil
            count = count + 1
        end
    end
    
    if count > 0 then
        -- Update UI
        if RDT.UI then
            if RDT.UI.UpdateLabels then
                RDT.UI:UpdateLabels()
            end
            if RDT.UI.UpdatePullList then
                RDT.UI:UpdatePullList()
            end
        end
        
        RDT:Print(string.format("Removed %d packs from pull %d", count, pullNum))
    end
end

--- Reset all pulls for current dungeon
function RM:ResetPulls()
    if not RDT.State.currentRoute then return end
    
    RDT:DebugPrint("Resetting all pulls")
    
    wipe(RDT.State.currentRoute.pulls)
    RDT.State.currentPull = 1
    
    -- Update UI
    if RDT.UI then
        if RDT.UI.ClearSelection then
            RDT.UI:ClearSelection()
        end
        if RDT.UI.UpdateLabels then
            RDT.UI:UpdateLabels()
        end
        if RDT.UI.UpdatePullList then
            RDT.UI:UpdatePullList()
        end
    end
    
    RDT:Print("All pulls reset")
end

--------------------------------------------------------------------------------
-- Route Validation
--------------------------------------------------------------------------------

--- Validate that a route is valid for a dungeon
-- @param route table Route data with pulls table
-- @param dungeonName string Dungeon name to validate against
-- @return boolean isValid, string errorMessage
function RM:ValidateRoute(route, dungeonName)
    if type(route) ~= "table" then
        return false, "Route is not a table"
    end
    
    if not route.pulls or type(route.pulls) ~= "table" then
        return false, "Route missing pulls table"
    end
    
    -- Get dungeon data
    local dungeonData = RDT.Data:GetDungeon(dungeonName)
    if not dungeonData then
        return false, "Unknown dungeon: " .. tostring(dungeonName)
    end
    
    -- Build valid pack ID set
    local validPacks = {}
    for _, pack in ipairs(dungeonData.packData or {}) do
        validPacks[pack.id] = true
    end
    
    -- Validate all pack IDs in route
    for packId, pullNum in pairs(route.pulls) do
        if type(packId) ~= "number" then
            return false, "Invalid pack ID type: " .. type(packId)
        end
        
        if not validPacks[packId] then
            return false, "Invalid pack ID for dungeon: " .. packId
        end
        
        if type(pullNum) ~= "number" or pullNum < 0 then
            return false, "Invalid pull number: " .. tostring(pullNum)
        end
    end
    
    return true, nil
end

--------------------------------------------------------------------------------
-- Route Statistics
--------------------------------------------------------------------------------

--- Get statistics for current route
-- @return table Statistics including totalForces, pullCount, avgForces, etc.
function RM:GetRouteStats()
    if not RDT.State.currentRoute then
        return {
            totalForces = 0,
            pullCount = 0,
            packCount = 0,
            avgForcesPerPull = 0,
            maxPullForces = 0,
            minPullForces = 0,
        }
    end
    
    local totalForces = self:CalculateTotalForces()
    local pulls = self:GetUsedPulls(RDT.State.currentRoute.pulls)
    local pullCount = #pulls
    local packCount = 0
    
    -- Count assigned packs
    for packId, pullNum in pairs(RDT.State.currentRoute.pulls) do
        if pullNum > 0 then
            packCount = packCount + 1
        end
    end
    
    -- Calculate min/max/avg per pull
    local maxPullForces = 0
    local minPullForces = 999999
    
    for _, pullNum in ipairs(pulls) do
        local forces = self:CalculatePullForces(pullNum)
        maxPullForces = math.max(maxPullForces, forces)
        minPullForces = math.min(minPullForces, forces)
    end
    
    if pullCount == 0 then
        minPullForces = 0
    end
    
    return {
        totalForces = totalForces,
        pullCount = pullCount,
        packCount = packCount,
        avgForcesPerPull = pullCount > 0 and (totalForces / pullCount) or 0,
        maxPullForces = maxPullForces,
        minPullForces = minPullForces,
    }
end

RDT:DebugPrint("RouteManager.lua loaded")
