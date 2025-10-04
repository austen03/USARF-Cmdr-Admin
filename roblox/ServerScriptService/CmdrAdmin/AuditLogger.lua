-- AuditLogger.lua
local Config = require(script.Parent.Config)
local Http = require(script.Parent.HttpQueue)

local AuditLogger = {}

local function shouldSend(targetCfg, category)
	if not targetCfg.Enabled then return false end
	if Config.Categories.All then return true end
	return targetCfg.Categories[category] == true
end

local function resolveCategory(commandName, commandDef)
	if commandDef and commandDef.Category then return commandDef.Category end
	return Config.CommandCategory[string.lower(commandName)] or "Utility"
end

local function redactArgs(commandName, args)
	local redacts = Config.RedactArgsFor[commandName]
	if not redacts then return args end
	local out = {}
	for k, v in pairs(args) do
		if table.find(redacts, k) then
			out[k] = "<redacted>"
		else
			out[k] = v
		end
	end
	return out
end

function AuditLogger.Log(audit, commandDef) -- audit table from BuildAudit
	local category = resolveCategory(audit.command, commandDef)

	-- Discord
	if shouldSend(Config.LogTargets.Discord, category) then
		local embed = {
			title = string.format("%s • %s", audit.command, audit.id),
			color = 0xF9D938,
			fields = {
				{ name = "Executor", value = audit.executor, inline = true },
				{ name = "Permission", value = tostring(audit.permissionLevel), inline = true },
				{ name = "Category", value = category, inline = true },
				{ name = "Args", value = audit.argsText or "`(none)`" },
				{ name = "Result", value = audit.resultText or "`(ok)`" },
			},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
		}
		local payload = { username = "CmdrAdmin", embeds = { embed } }
		Http:PostJson(Config.LogTargets.Discord.WebhookUrl, payload, {})
	end

	-- Website
	if shouldSend(Config.LogTargets.Website, category) then
		local headers = {}
		if Config.LogTargets.Website.AuthHeader and #Config.LogTargets.Website.AuthHeader > 0 then
			headers["Authorization"] = Config.LogTargets.Website.AuthHeader
		end
		Http:PostJson(Config.LogTargets.Website.Url, audit, headers)
	end

	-- Google Sheets
	if shouldSend(Config.LogTargets.GoogleSheets, category) then
		Http:PostJson(Config.LogTargets.GoogleSheets.WebAppUrl, audit, {})
	end
end

function AuditLogger.BuildAudit(id, context, commandObj, rawText, resultText)
	local argsMap = {}
	for _, arg in ipairs(commandObj.Arguments or {}) do
		argsMap[arg.Name] = arg.RawText
	end

	if not Config.LogArguments then argsMap = {} end
	argsMap = redactArgs(string.lower(commandObj.Alias or commandObj.Name), argsMap)

	local argsText = nil
	if next(argsMap) ~= nil then
		local kv = {}
		for k, v in pairs(argsMap) do table.insert(kv, string.format("%s=%q", k, tostring(v))) end
		argsText = table.concat(kv, ", ")
		argsText = "```\n" .. argsText .. "\n```"
	end

	return {
		id = id,
		command = string.lower(commandObj.Alias or commandObj.Name),
		raw = rawText,
		executor = context.Executor and context.Executor.Name or "(server)",
		executorUserId = context.Executor and context.Executor.UserId or 0,
		permissionLevel = _G.CMDR_ADMIN.Permissions.GetLevel(context.Executor),
		args = argsMap,
		argsText = argsText,
		resultText = resultText,
		placeId = game.PlaceId,
		jobId = game.JobId,
		serverTime = os.time(),
	}
end

return AuditLogger
