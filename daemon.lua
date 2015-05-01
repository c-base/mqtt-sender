-- vim: ts=2 sw=2 ai

local p = require 'posix'
local is_daemon = false

function log (level, message)
	if is_daemon == true then
		if level == "ERR" then
			p.syslog(p.LOG_ERR, message)
		elseif level == "WARN" then
			p.syslog(p.LOG_WARNING, message)
		elseif level == "NOTICE" then
			p.syslog(p.LOG_NOTICE, message)
		elseif level == "INFO" then
			p.syslog(p.LOG_INFO, message)
		elseif level == "DEBUG" then
			p.syslog(p.LOG_DEBUG, message)
		end
	else
		message = message .. "\n"
		if level == "ERR" then
			io.stderr:write(message)
		elseif level == "WARN" then
			io.stdout:write(message)
		elseif level == "NOTICE" then
			io.stdout:write(message)
		elseif level == "INFO" then
			io.stdout:write(message)
		elseif level == "DEBUG" then
			io.stdout:write(message)
		end
	end
end

function topic_add (topics, name, time, args)
	local module = "mod_" .. name
	topics[#topics+1] = {}
	topics[#topics]["func"] = require(module)
	topics[#topics]["name"] = name
	topics[#topics]["time"] = time
	topics[#topics]["args"] = args
end

function subscription_add(subscriptions, module, topic, args)
    subscriptions[#subscriptions+1] = {}
    subscriptions[#subscriptions+1]["topic"] = topic
    subscriptions[#subscriptions+1]["callback"] = require(module)
    subscriptions[#subscriptions+1]["args"] = args
end

function tprint(level, index, value)
	local i, v
	print(level, index, value)
	if ( type(value) == "table" ) then
		for i,v in pairs(value) do
			tprint(level .. "	", i, v)
		end
	end
end

function process(mqtt,prefix,topics) 
	local i, v, r, e
	for i, v in pairs(topics) do
		assert(type(v) == "table", "a topic must be a table")
		assert(type(v["func"]) == "function", "topic element \"func\" must contain a reference to a function")
		assert(type(v["time"]) == "number",   "topic element \"time\" must contain a number in seconds")
		assert(type(v["name"]) == "string",   "topic element \"name\" must contain a name as string")
		assert(type(v["args"]) == "table",    "topic element \"args\" must contain a table")
		r = v["func"](v["time"],v["args"])
		if ( mqtt == nil ) then
			print(v["name"], r)
		elseif ( r and mqtt.connected ) then
			e = mqtt:publish(prefix .. v["name"], r)
			if ( e ) then
				log("ERR",error_message)
				return
			end
			e = mqtt:handler()
			if ( e ) then
				log("ERR",error_message)
				return
			end
		end
		r = nil
	end
end

function exit(val)
	p._exit(val)
end

function daemon(pidfile)
	local ppid = p.getpid("ppid")
	if p.getpid("ppid") == 1 then
		log("ERR", "We are already a daemon")
		return
	end
	if pidfile then
		local f = io.open(pidfile,"r")
		if f then
			log("ERR", "pidfile " .. pidfile .. " already exists")
			p._exit(1)
		end
	end
	local pid = p.fork();
	if pid < 0 then
		log("ERR", "fork() failed")
		p._exit(1)
	elseif pid ~= 0 then
		local f = io.open(pidfile,"w")
		if f then
			f:write(string.format("%d\n",pid))
			f:close()
		else
			log("ERR", "Unable to open pidfile " .. pidfile .. " for writing")
			p.kill(pid)
			p.wait(pid)
			p._exit(1)
		end
		p._exit(0)
	end
	p.signal(p.SIGTERM, function() os.remove(pidfile); log("NOTICE", "exiting"); p._exit(0) end)
	p.openlog('mqtt-netstat',p.LOG_PID,p.LOG_DAEMON)
	is_daemon = true
	if p.version == "posix library for Lua 5.1 / 31" or p.version == "posix library for Lua 5.1 / 32" then
		p.close(0); p.open("/dev/null", p.O_RDONLY);
		p.close(1); p.open("/dev/null", p.O_WRONLY);
		p.close(2); p.open("/dev/null", p.O_WRONLY);
	else
		p.close(0); p.open("/dev/null", {p.O_RDONLY});
		p.close(1); p.open("/dev/null", {p.O_WRONLY});
		p.close(2); p.open("/dev/null", {p.O_WRONLY});
	end
	return
end

function ignored( topic, message )
	-- we don't want anything
end
