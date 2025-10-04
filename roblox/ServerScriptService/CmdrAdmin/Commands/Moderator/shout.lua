return {
	Name = "shout",
	Group = "Moderator",
	Category = "Moderation",
	Description = "Alias of announce.",
	Args = {
		{ Type = "string", Name = "message", Description = "What to shout" }
	},
	Run = function(context, message)
		game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
			Text = ("[Announcement] %s"):format(message);
			Color = Color3.fromRGB(249, 217, 56);
		})
		return "Shout sent."
	end,
}