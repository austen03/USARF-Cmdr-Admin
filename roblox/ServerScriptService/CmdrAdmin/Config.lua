-- Config.lua
local Config = {}

-- Toggle categories globally (acts as a root "allow" per category)
Config.Categories = {
	Moderation = true,
	Admin      = true,
	Utility    = false,
	All        = false,
}

-- Optional fallback: map command name -> category for logging
Config.CommandCategory = {
	ban = "Moderation",
	kick = "Moderation",
	warn = "Moderation",
	mute = "Moderation",
	unmute = "Moderation",
	announce = "Moderation",
	shout = "Moderation",
	setcurrency = "Admin",
	removecurrency = "Admin",
	getcurrency = "Utility",
}

-- Destinations
Config.LogTargets = {
	Discord = {
		Enabled = false,
		WebhookUrl = "https://discord.com/api/webhooks/XXXX/XXXX",
		Categories = { Moderation = true, Admin = true, Utility = false }
	},
	Website = {
		Enabled = false,
		Url = "https://your-site.example.com/cmdr/audit",
		AuthHeader = "Bearer YOUR_SECRET_TOKEN",
		Categories = { Moderation = true, Admin = true, Utility = true }
	},
	GoogleSheets = {
		Enabled = false,
		WebAppUrl = "https://script.google.com/macros/s/XXXX/exec",
		Categories = { Moderation = true, Admin = true, Utility = true }
	}
}

-- Redact args by name for certain commands
Config.RedactArgsFor = {
	setcurrency = { "amount" },
	removecurrency = { "amount" },
	warn = { "reason" },
}

Config.LogArguments = true

Config.Id = {
	UseGuid = true,
	Prefix = "CMDR-",
}

return Config
