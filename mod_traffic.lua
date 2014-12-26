-- vim: sw=2 ts=2 ai

local state = {}

function read_if(f)
  local iface = ""
  local str
  str = f:read(1)
  while ( str ) do
    if ( str ~= " " and str ~= ":" ) then
      iface = iface .. str
    end
    if ( str == ":" ) then
        return(iface)
    end
    str = f:read(1)
  end
  return
end

function traffic(interval,args)
  local str
  local stats
	local i, v
	local now = os.time()
	if  state["last"] ~= nil then
		if now - state["last"] < interval then
			return stats
		end
	end
  local f = io.open("/proc/net/dev", "r")
  if ( f ) then
    f:read("*line") -- skip the first 2 lines
    f:read("*line")
    str = read_if(f)
    while ( str ) do
      rx = f:read("*number")
      for i = 0, 6, 1 do f:read("*number") end 
      tx = f:read("*number")
      f:read("*line")
      for i, v in pairs(args) do
        if ( str == i ) then
					--print(i, v)
					if state[i] == nil then state[i] = {} ; state[i]["rx"] = 0 state[i]["tx"] = 0 end
          if ((state[i]["rx"] ~= 0 or state[i]["tx"] ~= 0) and state["last"] ) then
            str = string.format("{\"name\":\"%s\",\"rx\":\"%d\",\"tx\":\"%d\"}",
              v,(rx-state[i]["rx"])/(now-state["last"]),(tx-state[i]["tx"])/(now-state["last"]))
          else
            str = nil
          end
          state[i]["rx"] = rx
          state[i]["tx"] = tx
          if ( stats ) then 
            stats = stats .. "," .. str
          else
            stats = str
          end
        end
      end
      str = read_if(f)
    end
		f:close()
  end
  if ( stats ) then
    stats = string.format("{\"interfaces\":[%s]}",stats)
  end
	state["last"] = now
  return(stats)
end

return(traffic)

-- vim: ts=2 sw=2 ai
