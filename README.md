# USARF Cmdr Admin (starter)

Terminal-style Cmdr admin client with:
- Folder-based access tiers (Training, Moderator, Low/Medium/High Command, Developer, Administrator)
- Rank/username permission levels
- Unique audit IDs on every command
- Selective logging to Discord, your Website (REST), and Google Sheets Web App
- Easy per-command `Category` for routing (Moderation/Admin/Utility/etc.)

## Quick start

1) **Place files** in your place:
   - Put the `roblox/ServerScriptService/CmdrAdmin/` folder under **ServerScriptService**.
   - Keep your existing terminal client under **ReplicatedStorage/CmdrClient** (a placeholder is included).
   - Ensure the **Cmdr** server module is available (adjust `init.server.lua`'s `require` path if needed).

2) **Configure logging** in `Config.lua` (Discord webhook, Website URL/Auth, Sheets WebApp URL).
   - Deploy `integrations/google-sheets-webapp.gs` as a Web App and paste the URL into `Config.lua`.

3) **Organize commands**:
   - Drop command modules into `Commands/{Training|Moderator|Low Command|Medium Command|High Command|Developer|Administrator}/`.
   - Each command may set `Category` for logging; otherwise it falls back to `Config.CommandCategory` or `Utility`.

4) **Permissions**:
   - Edit `Permissions.lua` to match your rank ladder.
   - Folder name → min level mapping lives in `TierMinLevel`.

5) **Client**:
   - Your terminal UI (F2) remains unchanged. You can set the label with:
     ```lua
     local ReplicatedStorage = game:GetService("ReplicatedStorage")
     local CmdrClient = require(ReplicatedStorage.CmdrClient.CmdrClient)
     CmdrClient:SetPlaceName("Cmdr")
     ```

## Dev notes

- Hooks:
  - `BeforeRun` checks authorization and assigns an audit ID.
  - `AfterRun` builds an audit record and routes it via `AuditLogger` (queued HTTP).

- HTTP:
  - `HttpQueue` is non-blocking and retries on failure.

- IDs:
  - `IdGenerator` uses GUIDs prefixed with `CMDR-` by default.

Happy moderating!
