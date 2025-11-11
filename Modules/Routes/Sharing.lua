-- Modules/Routes/Sharing.lua
-- Chat link sharing for routes with clickable import

local RDT = _G.RDT
if not RDT then
    error("RDT not found!")
end

RDT.RouteSharing = {}
local RouteSharing = RDT.RouteSharing

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

-- Cache of shared routes (sender -> route data)
local sharedRoutes = {}

-- Local references to dependencies
local RouteSerializer = RDT.RouteSerializer

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

--- Initialize route sharing system
function RouteSharing:Initialize()
    -- Chat message filter to convert plain text into clickable hyperlinks
    local function filterFunc(_, event, msg, player, l, cs, t, flag, channelId, ...)
        -- Skip GM/DEV messages and numbered channels
        if flag == "GM" or flag == "DEV" or (event == "CHAT_MSG_CHANNEL" and type(channelId) == "number" and channelId > 0) then
            return
        end

        local newMsg = ""
        local remaining = msg
        local done
        local anyLinkFound = false

        repeat
            -- Pattern: [ReinDungeonTools: PlayerName - RouteName]
            local start, finish, characterName, routeName = remaining:find("%[ReinDungeonTools: ([^%s]+) %- (.*)%]")
            if characterName and routeName then
                -- Strip any color codes that might be embedded
                characterName = characterName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
                routeName = routeName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")

                -- Build new message with hyperlink
                -- Use BNplayer protocol (like WeakAuras) to avoid tooltip errors
                newMsg = newMsg .. remaining:sub(1, start - 1)
                newMsg = newMsg .. "|HBNplayer::rdt|h|cFF00FF00[" .. characterName .. " |r|cFF00FF00- " .. routeName .. "]|h|r"
                remaining = remaining:sub(finish + 1)
                anyLinkFound = true
            else
                newMsg = newMsg .. remaining
                done = true
            end
        until done

        if anyLinkFound then
            return false, newMsg, player, l, cs, t, flag, channelId, ...
        end
    end

    -- Register the filter for all relevant chat channels
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)

    RDT:DebugPrint("Chat message filters registered for route link conversion")

    -- Hook SetItemRef to detect clicks on RDT links
    hooksecurefunc("SetItemRef", function(link, text, button)
        if link == "BNplayer::rdt" then
            -- Extract player name and route name from the displayed text
            local _, _, characterName, routeName = text:find("|HBNplayer::rdt|h|cFF00FF00%[([^%s]+) |r|cFF00FF00%- (.*)%]|h")

            if not characterName or not routeName then return end

            -- Strip any color codes that might be embedded
            characterName = characterName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
            routeName = routeName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")

            RDT:DebugPrint("RDT link clicked: sender=" .. characterName)

            -- If Shift is held, re-insert the plain text into chat
            if IsShiftKeyDown() then
                local editbox = GetCurrentKeyBoardFocus()
                if editbox then
                    editbox:Insert("[ReinDungeonTools: " .. characterName .. " - " .. routeName .. "]")
                end
                return
            end

            -- Normal click: request or import route
            -- If it's your own link, show the import dialog
            if characterName == UnitName("player") then
                local routeData = sharedRoutes[characterName]
                if routeData then
                    RouteSharing:ShowImportDialog(characterName, routeData)
                else
                    RDT:Print("Route data not found in cache")
                end
            else
                -- Request route from sender
                RouteSharing:RequestRoute(characterName)
            end
        end
    end)

    RDT:RegisterComm("RDT_Route", function(prefix, message, distribution, sender)
        RDT:DebugPrint("CHAT_MSG_ADDON: prefix=" .. prefix .. ", sender=" .. sender .. ", dist=" .. distribution .. ", msgLen=" .. #message)
        RouteSharing:OnAddonMessage(prefix, message, distribution, sender)
    end)

    RDT:DebugPrint("RouteSharing initialized")
end

--------------------------------------------------------------------------------
-- Chat Link Creation
--------------------------------------------------------------------------------

--- Share current route to chat as a clickable link
-- @param channel string Chat channel ("PARTY", "RAID", "GUILD", "SAY", "YELL")
-- @return boolean Success status
function RouteSharing:ShareToChat(channel)
    local exportData = RouteSerializer:CreateExportData()
    if not exportData then
        return false
    end

    -- Sanitize route name for chat (remove pipe characters that could interfere)
    local routeName = exportData.routeName:gsub("|", "")

    -- Cache it locally so we can send it when requested
    local playerName = UnitName("player")
    sharedRoutes[playerName] = exportData

    -- Send plain text message that will be converted to a hyperlink by the chat filter
    -- Format: [ReinDungeonTools: PlayerName - RouteName]
    -- The ChatFrame_AddMessageEventFilter will convert this to a clickable hyperlink
    local msg = "[ReinDungeonTools: " .. playerName .. " - " .. routeName .. "]"

    -- Send plain message to chat
    local success, errorMsg = pcall(function()
        SendChatMessage(msg, channel)
    end)

    if not success then
        RDT:PrintError("Failed to send chat message: " .. tostring(errorMsg))
        return false
    end

    RDT:Print("Route shared to " .. channel .. ": " .. routeName)
    RDT:DebugPrint("Shared route data cached for player: " .. playerName)
    return true
end

--------------------------------------------------------------------------------
-- Route Request/Response
--------------------------------------------------------------------------------

--- Request a route from another player
-- @param sender string Player name who shared the route
function RouteSharing:RequestRoute(sender)
    RDT:Print("Requesting route from " .. sender .. "...")
    RDT:SendCommMessage("RDT_Route", "REQUEST", "WHISPER", sender, "NORMAL")
end

--- Send route to requesting player
-- @param target string Target player name
-- @param routeData table Route export data
function RouteSharing:SendRoute(target, routeData)
    local exportString = RouteSerializer:EncodeRouteData(routeData)
    if not exportString then
        return
    end

    RDT:DebugPrint("Sending route: " .. #exportString .. " chars")

    RDT:SendCommMessage("RDT_Route", exportString, "WHISPER", target, "NORMAL")

    RDT:Print("Sent route to " .. target)
end

--------------------------------------------------------------------------------
-- Addon Communication Handler
--------------------------------------------------------------------------------

--- Handle incoming addon messages
-- @param prefix string Message prefix
-- @param message string Message content
-- @param distribution string Distribution type
-- @param sender string Sender name
function RouteSharing:OnAddonMessage(prefix, message, distribution, sender)
    if prefix ~= "RDT_Route" then return end

    -- Ignore messages from self
    if sender == UnitName("player") then return end
    -- allow self-messages for testing
    --if sender == UnitName("player") and message ~= "REQUEST" and not message:find("^RDT1:") then
    --    return
    --end

    -- Debug: Show full message info
    local msgPreview = message:sub(1, math.min(50, #message))
    RDT:DebugPrint("Addon message from " .. sender .. " (dist: " .. distribution .. "): " .. msgPreview .. " [len=" .. #message .. "]")

    -- Handle route request
    if message == "REQUEST" then
        local routeData = sharedRoutes[UnitName("player")]
        if routeData then
            RDT:Print(sender .. " requested your route")
            RouteSharing:SendRoute(sender, routeData)
        else
            RDT:Print("No route to send to " .. sender)
        end
        return
    end

    if message:find("^RDT1:") then
        RouteSharing:ReceiveRoute(sender, message)
        return
    end
end

--- Receive and process complete route
-- @param sender string Sender name
-- @param exportString string The RDT1: export string
function RouteSharing:ReceiveRoute(sender, exportString)
    RDT:Print("Received route from " .. sender)

    -- Show import dialog
    RouteSharing:ShowImportDialog(sender, exportString)
end

--------------------------------------------------------------------------------
-- Import Dialog
--------------------------------------------------------------------------------

--- Show import confirmation dialog
-- @param sender string Route sender
-- @param data table or string Route data or export string
function RouteSharing:ShowImportDialog(sender, data)
    -- If data is a table, convert to export string
    local exportString
    if type(data) == "table" then
        exportString = RouteSerializer:EncodeRouteData(data)
        if not exportString then
            return
        end
    else
        exportString = data
    end

    -- Parse route info for display
    local routeInfo = RouteSerializer:ParseRouteInfo(exportString)

    if not RDT.Dialogs then
        RDT:PrintError("Dialogs module not loaded - cannot show import dialog")
        return
    end

    RDT.Dialogs:ShowImport({
        sender = sender,
        importString = exportString,
        routeInfo = routeInfo,
        compact = true
    })
end


--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

--- Register slash commands for route sharing
function RouteSharing:RegisterSlashCommands()
    SlashCmdList["RDTSHARE"] = function(msg)
        local channel = msg:upper()
        if channel == "" then channel = "PARTY" end

        -- Validate channel
        if channel == "PARTY" or channel == "RAID" or channel == "GUILD" or
           channel == "SAY" or channel == "YELL" then
            RouteSharing:ShareToChat(channel)
        else
            RDT:Print("Usage: /rdtshare [PARTY|RAID|GUILD|SAY|YELL]")
            RDT:Print("Default: PARTY")
        end
    end
    SLASH_RDTSHARE1 = "/rdtshare"

    SlashCmdList["RDTSHAREDEBUG"] = function(msg)
        local exportData = RouteSerializer:CreateExportData()
        if not exportData then
            RDT:PrintError("No route to send")
            return
        end

        local playerName = UnitName("player")
        RDT:Print("Debug: Forcing route transmission to yourself...")

        RouteSharing:SendRoute(playerName, exportData)
    end
    SLASH_RDTSHAREDEBUG1 = "/rdtsharedebug"

    RDT:DebugPrint("RouteSharing slash commands registered")
end

RDT:DebugPrint("RouteSharing module loaded")
