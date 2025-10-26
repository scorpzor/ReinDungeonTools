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

--- Get next available pull number (max + 1)
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

--- Get the highest pull number in use
-- @param pullsTable table The pulls table from a route
-- @return number Highest pull number (0 if none)
function RM:GetMaxPull(pullsTable)
    if not pullsTable or type(pullsTable) ~= "table" then
        return 0
    end
    
    local maxP = 0
    for _, p in pairs(pullsTable) do
        if type(p) == "number" and p > maxP then
            maxP = p
        end
    end
    return maxP
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

--- Add a pack to the current pull
-- @param packId number Pack ID to add
function RM:AddPackToPull(packId)
    if not RDT.State.currentRoute or not packId then return end
    
    RDT:DebugPrint("Adding pack " .. packId .. " to pull " .. RDT.State.currentPull)
    
    -- Assign pack to current pull
    RDT.State.currentRoute.pulls[packId] = RDT.State.currentPull
    
    -- Update UI
    if RDT.UI then
        if RDT.UI.UpdateLabels then
            RDT.UI:UpdateLabels()
        end
        if RDT.UI.UpdatePullList then
            RDT.UI:UpdatePullList()
        end
    end
end

function RM:NewPull()
    local maxPull = self:GetMaxPull(RDT.State.currentRoute.pulls)
    local nextPull = maxPull + 1
    RDT.State.currentPull = nextPull
    
    RDT:Print(string.format("Started new pull #%d", nextPull))
    
    -- Update UI
    if RDT.UI then
        if RDT.UI.UpdatePullIndicator then
            RDT.UI:UpdatePullIndicator()
        end
        if RDT.UI.UpdatePullList then
            RDT.UI:UpdatePullList()
        end
    end
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

function RM:ResetPulls()
    if not RDT.State.currentRoute then return end
    
    RDT:DebugPrint("Resetting all pulls")
    
    wipe(RDT.State.currentRoute.pulls)
    RDT.State.currentPull = 1
    
    -- Update UI
    if RDT.UI then
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
    
    local validPacks = {}
    for _, pack in ipairs(dungeonData.packData or {}) do
        validPacks[pack.id] = true
    end
    
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
    
    for packId, pullNum in pairs(RDT.State.currentRoute.pulls) do
        if pullNum > 0 then
            packCount = packCount + 1
        end
    end
    
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

--------------------------------------------------------------------------------
-- Route Storage Management (Multiple Routes per Dungeon)
--------------------------------------------------------------------------------

-- @param dungeonName string Name of the dungeon
function RM:EnsureRouteExists(dungeonName)
    if not RDT.db or not RDT.db.profile then return end
    
    if not RDT.db.profile.routes[dungeonName] then
        RDT.db.profile.routes[dungeonName] = {
            currentRoute = "Route 1",
            routeList = {
                ["Route 1"] = { pulls = {} }
            }
        }
        RDT:DebugPrint("Created default route for: " .. dungeonName)
    end
    
    if not RDT.db.profile.routes[dungeonName].routeList then
        RDT.db.profile.routes[dungeonName].routeList = {}
    end
    
    local hasRoutes = false
    for _ in pairs(RDT.db.profile.routes[dungeonName].routeList) do
        hasRoutes = true
        break
    end
    
    if not hasRoutes then
        RDT.db.profile.routes[dungeonName].routeList["Route 1"] = { pulls = {} }
        RDT.db.profile.routes[dungeonName].currentRoute = "Route 1"
    end
    
    if not RDT.db.profile.routes[dungeonName].currentRoute then
        for routeName in pairs(RDT.db.profile.routes[dungeonName].routeList) do
            RDT.db.profile.routes[dungeonName].currentRoute = routeName
            break
        end
    end
end

--- Get the current route data for a dungeon
-- @param dungeonName string Name of the dungeon
-- @return table Route data {pulls = {...}} or nil
function RM:GetCurrentRoute(dungeonName)
    if not RDT.db or not RDT.db.profile then return nil end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    if not dungeonData then return nil end
    
    local routeName = dungeonData.currentRoute
    if not routeName then return nil end
    
    return dungeonData.routeList[routeName]
end

--- Get list of all route names for a dungeon
-- @param dungeonName string Name of the dungeon
-- @return table Array of route names
function RM:GetRouteNames(dungeonName)
    if not RDT.db or not RDT.db.profile then return {} end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    if not dungeonData or not dungeonData.routeList then return {} end
    
    local names = {}
    for name in pairs(dungeonData.routeList) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

--- Get the currently selected route name
-- @param dungeonName string Name of the dungeon
-- @return string Current route name or nil
function RM:GetCurrentRouteName(dungeonName)
    if not RDT.db or not RDT.db.profile then return nil end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    return dungeonData and dungeonData.currentRoute or nil
end

--- Switch to a different route
-- @param dungeonName string Name of the dungeon
-- @param routeName string Name of the route to switch to
-- @return boolean Success status
function RM:SwitchRoute(dungeonName, routeName)
    if not RDT.db or not RDT.db.profile then return false end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    if not dungeonData or not dungeonData.routeList[routeName] then
        RDT:PrintError("Route '" .. routeName .. "' not found")
        return false
    end
    
    dungeonData.currentRoute = routeName
    RDT.State.currentRoute = dungeonData.routeList[routeName]
    
    RDT:Print("Switched to: " .. routeName)
    return true
end

--- Create a new route
-- @param dungeonName string Name of the dungeon
-- @param routeName string Name for the new route (optional, will auto-generate if nil)
-- @return string|nil New route name or nil if failed
function RM:CreateRoute(dungeonName, routeName)
    if not RDT.db or not RDT.db.profile then return nil end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    
    if not routeName or routeName == "" then
        local counter = 1
        repeat
            routeName = "Route " .. counter
            counter = counter + 1
        until not dungeonData.routeList[routeName]
    else
        -- Check if route name already exists and find an available variant
        if dungeonData.routeList[routeName] then
            local baseName = routeName
            local counter = 1
            repeat
                routeName = baseName .. " " .. counter
                counter = counter + 1
            until not dungeonData.routeList[routeName]
            
            RDT:Print("Route name already exists, using: " .. routeName)
        end
    end
    
    dungeonData.routeList[routeName] = { pulls = {} }
    dungeonData.currentRoute = routeName
    RDT.State.currentRoute = dungeonData.routeList[routeName]
    
    RDT:Print("Created new route: " .. routeName)
    return routeName
end

--- Rename a route
-- @param dungeonName string Name of the dungeon
-- @param oldName string Current route name
-- @param newName string New route name
-- @return boolean Success status
function RM:RenameRoute(dungeonName, oldName, newName)
    if not RDT.db or not RDT.db.profile then return false end
    if not newName or newName == "" then
        RDT:PrintError("Route name cannot be empty")
        return false
    end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    if not dungeonData.routeList[oldName] then
        RDT:PrintError("Route '" .. oldName .. "' not found")
        return false
    end
    
    if dungeonData.routeList[newName] then
        RDT:PrintError("Route '" .. newName .. "' already exists")
        return false
    end
    
    -- Copy route to new name and delete old
    dungeonData.routeList[newName] = dungeonData.routeList[oldName]
    dungeonData.routeList[oldName] = nil
    
    -- Update currentRoute if it was the renamed one
    if dungeonData.currentRoute == oldName then
        dungeonData.currentRoute = newName
    end
    
    RDT:Print("Renamed route: " .. oldName .. " → " .. newName)
    return true
end

--- Delete a route
-- @param dungeonName string Name of the dungeon
-- @param routeName string Name of the route to delete
-- @return boolean Success status
function RM:DeleteRoute(dungeonName, routeName)
    if not RDT.db or not RDT.db.profile then return false end
    
    self:EnsureRouteExists(dungeonName)
    
    local dungeonData = RDT.db.profile.routes[dungeonName]
    
    local routeCount = 0
    for _ in pairs(dungeonData.routeList) do
        routeCount = routeCount + 1
    end
    
    if routeCount <= 1 then
        RDT:PrintError("Cannot delete the last route")
        return false
    end
    
    if not dungeonData.routeList[routeName] then
        RDT:PrintError("Route '" .. routeName .. "' not found")
        return false
    end
    
    dungeonData.routeList[routeName] = nil
    
    if dungeonData.currentRoute == routeName then
        for name in pairs(dungeonData.routeList) do
            self:SwitchRoute(dungeonName, name)
            break
        end
    end
    
    RDT:Print("Deleted route: " .. routeName)
    return true
end

RDT:DebugPrint("RouteManager.lua loaded")
