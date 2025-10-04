-- IdGenerator.lua
local HttpService = game:GetService("HttpService")
local Config = require(script.Parent.Config)

local Id = {}

function Id.New()
	local id
	if Config.Id.UseGuid then
		id = HttpService:GenerateGUID(false)
	else
		id = tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))
	end
	if Config.Id.Prefix and #Config.Id.Prefix > 0 then
		id = Config.Id.Prefix .. id
	end
	return id
end

return Id
