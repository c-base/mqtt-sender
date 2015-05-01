-- vim: sw=2 ts=2 ai
require "luci.json"

local state = {}

function ampel(message, args)
	local decoded = luci.json.decode(message)
  local pins = args['pins']
  for color,pin in pairs(pins) do
    if (decoded[color] ~= nil) then 
      value = tonumber(decoded[color])
    	os.execute("echo " .. value .. " > /sys/class/gpio/gpio" .. pin .. "/value")
      
    end
  end
end

return(ampel)

-- vim: ts=2 sw=2 ai
