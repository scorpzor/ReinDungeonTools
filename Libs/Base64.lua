-- Libs/Base64.lua
-- Base64 encoding/decoding utility library

local RDT = _G.RDT
if not RDT then
    error("RDT not found!")
end

RDT.Base64 = {}
local Base64 = RDT.Base64

--------------------------------------------------------------------------------
-- Base64 Character Table
--------------------------------------------------------------------------------

local base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

--------------------------------------------------------------------------------
-- Encoding
--------------------------------------------------------------------------------

--- Encode data to Base64 string
-- @param data string Binary data to encode
-- @return string Base64 encoded string
function Base64:Encode(data)
    local b64 = ""

    -- Process groups of 3 bytes
    for i = 1, #data, 3 do
        local b1, b2, b3 = string.byte(data, i, i+2)

        local n = b1 * 65536
        if b2 then n = n + b2 * 256 end
        if b3 then n = n + b3 end

        local c1 = math.floor(n / 262144) % 64
        local c2 = math.floor(n / 4096) % 64
        local c3 = math.floor(n / 64) % 64
        local c4 = n % 64

        b64 = b64 .. string.sub(base64_chars, c1+1, c1+1)
        b64 = b64 .. string.sub(base64_chars, c2+1, c2+1)

        if b2 then
            b64 = b64 .. string.sub(base64_chars, c3+1, c3+1)
        else
            b64 = b64 .. "="
        end

        if b3 then
            b64 = b64 .. string.sub(base64_chars, c4+1, c4+1)
        else
            b64 = b64 .. "="
        end
    end

    return b64
end

--------------------------------------------------------------------------------
-- Decoding
--------------------------------------------------------------------------------

--- Decode Base64 string to data
-- @param b64 string Base64 encoded string
-- @return string Decoded binary data
function Base64:Decode(b64)
    -- Create reverse lookup table
    local decode_table = {}
    for i = 1, #base64_chars do
        decode_table[string.sub(base64_chars, i, i)] = i - 1
    end

    local data = ""
    b64 = string.gsub(b64, "[^" .. base64_chars .. "=]", "")

    for i = 1, #b64, 4 do
        local c1, c2, c3, c4 = string.byte(b64, i, i+3)

        local n1 = decode_table[string.char(c1)] or 0
        local n2 = decode_table[string.char(c2)] or 0
        local n3 = decode_table[string.char(c3)] or 0
        local n4 = decode_table[string.char(c4)] or 0

        local n = n1 * 262144 + n2 * 4096 + n3 * 64 + n4

        local b1 = math.floor(n / 65536) % 256
        local b2 = math.floor(n / 256) % 256
        local b3 = n % 256

        data = data .. string.char(b1)

        if c3 ~= 61 then  -- 61 is '='
            data = data .. string.char(b2)
        end

        if c4 ~= 61 then
            data = data .. string.char(b3)
        end
    end

    return data
end

RDT:DebugPrint("Base64 module loaded")
