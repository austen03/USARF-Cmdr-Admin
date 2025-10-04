-- Hooks.server.lua
return function (Cmdr, Env)
	local Permissions = Env.Permissions
	local Id = Env.Id
	local Logger = Env.Logger

	Cmdr:RegisterHook("BeforeRun", function(context)
		local obj = context and context.Command and context.Command.Object
		if not obj then return end

		local ok, why = Permissions.IsAuthorized(context.Executor, obj.Alias or obj.Name, obj)
		if not ok then
			return false, why or "Not authorized to run this command."
		end

		context._auditId = Id.New()
	end)

	Cmdr:RegisterHook("AfterRun", function(context, result)
		local obj = context and context.Command and context.Command.Object
		if not obj then return end

		local id = context._auditId or Id.New()
		local raw = context.RawText or (obj.Alias or obj.Name)
		local resultText = (typeof(result) == "string" and result)
			or (result and tostring(result) or "")

		local audit = Logger.BuildAudit(id, context, obj, raw, resultText)
		Logger.Log(audit, obj)
	end)
end
