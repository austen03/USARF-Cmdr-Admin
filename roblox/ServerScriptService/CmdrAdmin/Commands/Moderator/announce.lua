return {
	Name = "announce",
	Group = "Moderator",      -- access tier (folder)
	Category = "Moderation",  -- logging category
	Description = "Send a global announcement.",
	Args = {
		{ Type = "string", Name = "message", Description = "What to announce" }
	},
	Run = function(context, message)
		game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
			Text = ("[Announcement] %s"):format(message);
			Color = Color3.fromRGB(249, 217, 56);
		})
		return "Announcement sent."
	end,
}