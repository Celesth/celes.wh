--[[
    Celesth's Wh Library
    Author: korieuko
    Discord: korieuko
    Status: 🟢
]]

local HttpService = game:GetService("HttpService")

-- Determine request function
local requestFunc = http_request or request or (syn and syn.request)
assert(requestFunc, "No HTTP request function available.")

-- Webhook Class
local Webhook = {}
Webhook.__index = Webhook

function Webhook.new(url)
    assert(type(url) == "string" and url:match("^https://"), "Invalid webhook URL.")
    return setmetatable({
        Url = url,
        Username = nil,
        Avatar = nil,
        DefaultEmbed = nil,
    }, Webhook)
end

function Webhook:SetUsername(name)
    self.Username = name
end

function Webhook:SetAvatar(url)
    self.Avatar = url
end

function Webhook:SetDefaultEmbed(embed)
    self.DefaultEmbed = embed
end

function Webhook:Send(content)
    assert(type(content) == "string", "Webhook content must be a string.")
    local payload = {
        content = content,
        username = self.Username,
        avatar_url = self.Avatar,
    }
    self:_Post(payload)
end

function Webhook:Embed(embed)
    assert(type(embed) == "table", "Embed must be a table.")
    local payload = {
        embeds = {embed},
        username = self.Username,
        avatar_url = self.Avatar,
    }
    self:_Post(payload)
end

function Webhook:SendRaw(payload)
    self:_Post(payload)
end

function Webhook:_Post(payload)
    local data = HttpService:JSONEncode(payload)
    requestFunc({
        Url = self.Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = data
    })
end

-- Embed Builder
Webhook.Embed = function()
    local embed = {}
    function embed:SetTitle(t) embed.title = t return embed end
    function embed:SetDescription(d) embed.description = d return embed end
    function embed:SetColor(c) embed.color = c return embed end
    function embed:AddField(name, value, inline)
        embed.fields = embed.fields or {}
        table.insert(embed.fields, {name = name, value = value, inline = inline or false})
        return embed
    end
    function embed:SetFooter(text, icon) embed.footer = {text = text, icon_url = icon} return embed end
    function embed:SetImage(url) embed.image = {url = url} return embed end
    function embed:SetThumbnail(url) embed.thumbnail = {url = url} return embed end
    return embed
end

return Webhook
