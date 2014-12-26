-- vim: sw=2 ts=2 ai

local state = {}

function cpu(interval,args)
  local stats
	local now = os.time()
	if  state["last"] ~= nil then
		if now - state["last"] < interval then
			return nil
		end
	end
	local c = 0;
  local f = io.open("/proc/loadavg", "r")
  if ( f ) then
    local load5 = f:read("*number")
    local load15 = f:read("*number")
    local load30 = f:read("*number")

		stats = string.format("{\"load5\":\"%.2f\",\"load15\":\"%.2f\",\"load30\":\"%.2f\"}",
			load5, load15, load30)
		f:close()
  end
	state["last"] = now
  return(stats)
end

return(cpu)

-- vim: ts=2 sw=2 ai
