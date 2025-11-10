-- Modules/RouteSharing.lua
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

-- Chunk assembly for multi-part messages
local receivingChunks = {}  -- [sender] = {chunks = {}, total = 0}

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

    -- Register for addon messages
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("CHAT_MSG_ADDON")
    frame:SetScript("OnEvent", function(self, event, prefix, message, distribution, sender)
        if event == "CHAT_MSG_ADDON" then
            -- Debug: Log ALL addon messages with RDT_Route prefix
            if prefix == "RDT_Route" then
                RDT:DebugPrint("CHAT_MSG_ADDON: prefix=" .. prefix .. ", sender=" .. sender .. ", dist=" .. distribution .. ", msgLen=" .. #message)
            end
            RouteSharing:OnAddonMessage(prefix, message, distribution, sender)
        end
    end)

    -- Register the addon message prefix (if the function exists in 3.3.5a)
    if RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix("RDT_Route")
        RDT:DebugPrint("Addon message prefix registered: RDT_Route")
    else
        RDT:DebugPrint("RegisterAddonMessagePrefix not available (pre-4.0), using CHAT_MSG_ADDON directly")
    end

    RDT:DebugPrint("RouteSharing initialized (SetItemRef hook active)")
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

    -- Send addon message to request the route
    SendAddonMessage("RDT_Route", "REQUEST", "WHISPER", sender)
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

    -- Split into chunks if needed (255 byte limit per addon message)
    local chunkSize = 250
    local numChunks = math.ceil(#exportString / chunkSize)

    if numChunks == 1 then
        -- Single message
        SendAddonMessage("RDT_Route", exportString, "WHISPER", target)
        RDT:DebugPrint("Sent route in 1 message")
        RDT:Print("Sent route to " .. target)
    else
        -- Multiple chunks - send with delay to avoid throttling
        RDT:Print("Sending route to " .. target .. " (" .. numChunks .. " parts)...")

        local currentChunk = 1
        local sendFrame = CreateFrame("Frame")
        sendFrame.target = target
        sendFrame.exportString = exportString
        sendFrame.numChunks = numChunks
        sendFrame.chunkSize = chunkSize
        sendFrame.currentChunk = currentChunk
        sendFrame.lastSendTime = 0

        sendFrame:SetScript("OnUpdate", function(self, elapsed)
            self.lastSendTime = self.lastSendTime + elapsed

            -- Send one chunk every 1.2 seconds
            if self.lastSendTime >= 1.2 and self.currentChunk <= self.numChunks then
                local start = (self.currentChunk - 1) * self.chunkSize + 1
                local chunk = self.exportString:sub(start, start + self.chunkSize - 1)
                local msg = string.format("CHUNK:%d:%d:%s", self.currentChunk, self.numChunks, chunk)
                SendAddonMessage("RDT_Route", msg, "WHISPER", self.target)
                RDT:DebugPrint("Sent chunk " .. self.currentChunk .. "/" .. self.numChunks .. " to " .. self.target)

                self.currentChunk = self.currentChunk + 1
                self.lastSendTime = 0

                -- Clean up when done
                if self.currentChunk > self.numChunks then
                    RDT:Print("Finished sending route to " .. self.target)
                    self:SetScript("OnUpdate", nil)
                end
            end
        end)
    end
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

    -- Handle chunked messages
    if message:find("^CHUNK:") then
        RouteSharing:HandleChunk(sender, message)
        return
    end

    -- Handle complete route data (single message)
    if message:find("^RDT1:") then
        RouteSharing:ReceiveRoute(sender, message)
        return
    end
end

--- Handle chunked message assembly
-- @param sender string Sender name
-- @param message string Chunk message
function RouteSharing:HandleChunk(sender, message)
    local chunkNum, totalChunks, data = message:match("^CHUNK:(%d+):(%d+):(.+)$")

    if not chunkNum then
        RDT:PrintError("Invalid chunk format")
        return
    end

    chunkNum = tonumber(chunkNum)
    totalChunks = tonumber(totalChunks)

    -- Initialize chunk storage for this sender
    if not receivingChunks[sender] then
        receivingChunks[sender] = {chunks = {}, total = totalChunks}
        RDT:Print("Receiving route from " .. sender .. " (" .. totalChunks .. " parts)...")
    end

    -- Store chunk
    receivingChunks[sender].chunks[chunkNum] = data
    RDT:DebugPrint("Received chunk " .. chunkNum .. "/" .. totalChunks .. " from " .. sender)

    -- Check if we have all chunks
    local complete = true
    local missingChunks = {}
    for i = 1, totalChunks do
        if not receivingChunks[sender].chunks[i] then
            complete = false
            table.insert(missingChunks, i)
        end
    end

    if complete then
        -- Reassemble the message
        local fullMessage = ""
        for i = 1, totalChunks do
            fullMessage = fullMessage .. receivingChunks[sender].chunks[i]
        end

        -- Clean up
        receivingChunks[sender] = nil

        RDT:DebugPrint("Reassembled route: " .. #fullMessage .. " chars")

        -- Process the complete route
        RouteSharing:ReceiveRoute(sender, fullMessage)
    else
        -- Show progress with missing chunks
        local received = totalChunks - #missingChunks
        local missingStr = table.concat(missingChunks, ", ")
        RDT:DebugPrint("Progress: " .. received .. "/" .. totalChunks .. " (missing: " .. missingStr .. ")")
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

    -- Create confirmation dialog
    StaticPopupDialogs["RDT_IMPORT_ROUTE"] = {
        text = "Import route from |cFFFFAA00" .. sender .. "|r?\n\n" ..
               "|cFFFFFFFFDungeon:|r " .. (routeInfo.dungeon or "Unknown") .. "\n" ..
               "|cFFFFFFFFRoute:|r " .. (routeInfo.routeName or "Unnamed") .. "\n" ..
               "|cFFFFFFFFPacks:|r " .. (routeInfo.packCount or 0),
        button1 = "Import",
        button2 = "Cancel",
        OnAccept = function()
            if RDT.ImportExport then
                RDT.ImportExport:Import(exportString)
            else
                RDT:PrintError("ImportExport module not found")
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- Avoid UI taint
    }

    StaticPopup_Show("RDT_IMPORT_ROUTE")
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

    RDT:DebugPrint("RouteSharing slash commands registered")
end

RDT:DebugPrint("RouteSharing module loaded")
