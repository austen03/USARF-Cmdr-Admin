return {
	Name = "setcurrency",
	Group = "Administrator",
	Category = "Admin",
	Description = "Set a player's Money amount.",
	Args = {
		{ Type = "player", Name = "player", Description = "Target player" },
		{ Type = "number", Name = "amount", Description = "New amount" },
	},
	Run = function(context, player, amount)
		-- Example: replace with your own economy system
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then return "No leaderstats." end
		local money = leaderstats:FindFirstChild("Money")
		if not money then return "No Money stat." end
		money.Value = amount
		return string.format("Set %s.Money = %d", player.Name, amount)
	end,
}