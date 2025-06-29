--[[
    Celesth's Webhook Lib
    Author: celesth
    Features:
    ✅ G_ cache system
    🌐 IP geolocation (ipinfo.io)
    📁 File upload (Synapse)
    📜 Raw JSON embed support
    🔄 Compatible with most executors
    Discord: korieuko
]]

local HttpService = game:GetService("HttpService")

-- Detect executor-compatible request
local req = syn and syn.request or http_request or request or (fluxus and fluxus.request)
assert(req, "No supported HTTP request method found.")

-- Global state via G_
_G_ = rawget(getgenv(), "G_") or {}
getgenv().G_ = _G_

local Celesth = {}
Celesth.__index = Celesth

-- Webhook constructor
function Celesth.new(url)
    assert(type(url) == "string" and url:find("^https://"), "Invalid Discord webhook URL.")
    return setmetatable({
        Url = url,
        Username = "Celesth",
        Avatar = nil,
    }, Celesth)
end

-- Set webhook username
function Celesth:SetUsername(name)
    self.Username = name
end

-- Set webhook avatar image URL
function Celesth:SetAvatar(url)
    self.Avatar = url
end

-- IP info from ipinfo.io (cached in G_)
function Celesth:GetIP()
    if not G_.ipinfo then
        local success, res = pcall(function()
            return game:HttpGet("https://ipinfo.io/json")
        end)
        if success and res then
            local decoded = HttpService:JSONDecode(res)
            G_.ipinfo = decoded
        else
            warn("[Celesth] Failed to fetch IP info.")
        end
    end
    return G_.ipinfo
end

-- Basic message sender
function Celesth:Send(content)
    assert(type(content) == "string", "Content must be string.")
    req({
        Url = self.Url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            content = content,
            username = self.Username,
            avatar_url = self.Avatar
        })
    })
end

-- Send raw embed (JSON format)
function Celesth:SendEmbedJSON(embedTable)
    assert(type(embedTable) == "table", "Embed must be a JSON table.")
    req({
        Url = self.Url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            embeds = {embedTable},
            username = self.Username,
            avatar_url = self.Avatar
        })
    })
end

-- Upload file with text
function Celesth:SendFile(fileName, fileContent, messageText)
    assert(req == syn.request, "File upload only supported with syn.request")
    local boundary = "celesth-boundary-" .. tostring(math.random(100000,999999))
    local body = ""

    -- Payload JSON part
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. 'Content-Disposition: form-data; name="payload_json"\r\n\r\n'
    body = body .. HttpService:JSONEncode({
        content = messageText or "",
        username = self.Username,
        avatar_url = self.Avatar
    }) .. "\r\n"

    -- File part
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. 'Content-Disposition: form-data; name="file"; filename="'..fileName..'"\r\n'
    body = body .. "Content-Type: application/octet-stream\r\n\r\n"
    body = body .. fileContent .. "\r\n"

    -- End
    body = body .. "--" .. boundary .. "--\r\n"

    req({
        Url = self.Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
        },
        Body = body
    })
end

return Celesth
