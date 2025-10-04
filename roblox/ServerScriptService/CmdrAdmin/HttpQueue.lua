-- HttpQueue.lua
local HttpService = game:GetService("HttpService")

local HttpQueue = {}
HttpQueue.__index = HttpQueue

function HttpQueue.new()
	return setmetatable({
		_queue = {},
		_sending = false,
		_retryDelay = 5,
	}, HttpQueue)
end

function HttpQueue:PostJson(url: string, payload: table, headers: {[string]: string}?)
	table.insert(self._queue, { url = url, body = HttpService:JSONEncode(payload), headers = headers or {} })
	self:_drain()
end

function HttpQueue:_drain()
	if self._sending then return end
	self._sending = true

	task.spawn(function()
		while #self._queue > 0 do
			local item = table.remove(self._queue, 1)
			local ok, res = pcall(function()
				local params = {
					Url = item.url,
					Method = "POST",
					Headers = table.clone(item.headers),
					Body = item.body,
				}
				if not params.Headers["Content-Type"] then
					params.Headers["Content-Type"] = "application/json"
				}
				return HttpService:RequestAsync(params)
			end)
			if not ok then
				warn("[CmdrAdmin][HttpQueue] POST failed; retrying:", res)
				table.insert(self._queue, 1, item)
				task.wait(self._retryDelay)
			else
				task.wait(0.05)
			end
		end
		self._sending = false
	end)
end

return HttpQueue.new()
