-- vim: sw=2 ts=2 ai
json = require "cjson"
inspect = require('inspect')

local state = {}

function tformat(value)
	local post = "B/s "
	value = value * 1
	if (value >= (1024 * 1024 * 1024)) then
		value = value / (1024 * 1024 * 1024)
		post = "GB/s"
	elseif (value >= (1024 * 1024)) then
		value = value / (1024 * 1024)
		post = "MB/s"
	elseif (value >= 1024) then
		value = value / 1024
		post = "KB/s"
	end
	return(string.format("%7.2f %s",value,post))
end

function stats(message, args)
	local decoded = json.decode(message)
  --print(inspect(decoded))
	out = ""
	for i=1,#decoded["interfaces"] do
		name = decoded["interfaces"][i]["name"]
		rx =   decoded["interfaces"][i]["rx"]
		tx =   decoded["interfaces"][i]["tx"]
		if ( string.len(out) > 0 ) then
			out = out .. "  "
		end
		out = out .. string.format("%s rx: %s  tx: %s",name,tformat(rx),tformat(tx))
	end
	print(os.date("%Y-%m-%d %H:%M:%S") .. " " .. out)
end

return(stats)

-- vim: ts=2 sw=2 ai
