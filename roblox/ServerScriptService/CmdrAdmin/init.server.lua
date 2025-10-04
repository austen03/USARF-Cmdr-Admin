-- init.server.lua
-- Bootstraps Cmdr, registers hooks, and auto-registers commands by folder.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Adjust this require to wherever your Cmdr **server** lives.
-- If using the official distribution placed in ReplicatedStorage named "Cmdr":
local Cmdr = require(ReplicatedStorage:WaitForChild("Cmdr"))

local Config       = require(script.Config)
local Permissions  = require(script.Permissions)
local IdGenerator  = require(script.IdGenerator)
local HttpQueue    = require(script.HttpQueue)
local AuditLogger  = require(script.AuditLogger)

_G.CMDR_ADMIN = {
	Config = Config,
	Permissions = Permissions,
	Id = IdGenerator,
	Http = HttpQueue,
	Logger = AuditLogger,
}

-- Register hooks
require(script.Hooks)(Cmdr, _G.CMDR_ADMIN)

-- Auto-register commands by subfolder, tagging Group from folder name if not set
local commandsRoot = script:FindFirstChild("Commands")
if commandsRoot then
	for _, groupFolder in ipairs(commandsRoot:GetChildren()) do
		if groupFolder:IsA("Folder") then
			for _, cmd in ipairs(groupFolder:GetChildren()) do
				if cmd:IsA("ModuleScript") then
					local ok, def = pcall(require, cmd)
					if ok and type(def) == "table" then
						def.Group = def.Group or groupFolder.Name
						Cmdr:RegisterCommand(def)
					else
						warn("[CmdrAdmin] Failed to load command:", cmd:GetFullName(), def)
					end
				end
			end
		end
	end
end

print(("[CmdrAdmin] Initialized | Discord:%s Website:%s Sheets:%s")
	:format(
		tostring(Config.LogTargets.Discord.Enabled),
		tostring(Config.LogTargets.Website.Enabled),
		tostring(Config.LogTargets.GoogleSheets.Enabled)
	))
