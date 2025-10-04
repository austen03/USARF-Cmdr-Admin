-- Permissions.lua
local GROUP_MAIN      = 6033326
local GROUP_SECONDARY = 8647541

local TierMinLevel = {
	["Training"]       = 1,
	["Moderator"]      = 2,
	["Low Command"]    = 3,
	["Medium Command"] = 4,
	["High Command"]   = 5,
	["Developer"]      = 6,
	["Administrator"]  = 7,
}

local function computePermissionLevel(player: Player): number
	local rMain = player:GetRankInGroup(GROUP_MAIN)
	local rAlt  = player:GetRankInGroup(GROUP_SECONDARY)

	local level = 0
	if rMain >= 19 then
		level = 7
	elseif rAlt == 2 then
		level = 6
	elseif rMain == 18 then
		level = 5
	elseif rMain == 16 or rMain == 17 then
		level = 4
	elseif rMain == 15 or rMain == 13 then
		level = 3
	elseif rMain == 11 or rMain == 10 then
		level = 2
	elseif rMain >= 8 then
		level = 1
	end

	if player.Name == "austen181" or player.Name == "ncis1366" then
		level = 7
	end

	return level
end

-- Optional per-command overrides
local perCommandOverride = {
	-- ["ban"] = 5, ["announce"] = 2
}

local Permissions = {}

function Permissions.GetLevel(player) return computePermissionLevel(player) end

function Permissions.IsAuthorized(player, commandName: string, commandDef)
	local have = computePermissionLevel(player)
	local needed = perCommandOverride[string.lower(commandName)]
	if not needed then
		local groupName = (commandDef and commandDef.Group) or "Training"
		needed = TierMinLevel[groupName] or 1
	end

	if have >= needed then return true end
	return false, string.format("Requires %s (level %d); you have level %d.",
		(commandDef and commandDef.Group) or "higher tier", needed, have)
end

return Permissions
