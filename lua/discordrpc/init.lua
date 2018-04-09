
-- Credits to SpiralP and Tenrys
-- Currently Discord Canary only
-- Fail message: Not authenticated or invalid scope

discordrpc = discordrpc or {}
discordrpc.enabled = CreateClientConVar("discordrpc_enabled", "1", true, false)
discordrpc.debug = CreateClientConVar("discordrpc_debug", "0", true, false) -- alternatively, use the "developer" convar?
discordrpc.port = discordrpc.port

discordrpc.states = discordrpc.states or {}

discordrpc.clientID = "431766142181441536" -- don't change this value, change it in your state's Init function
-- discordrpc.state (string) should be set later in main.lua as the starting state

function discordrpc.Print(...)
	local header = "[Discord RPC%s] "
	local args = {...}
	if type(args[1]) ~= "string" then
		if not discordrpc.debug:GetBool() then return end -- we are entering debug message land, don't show them if we don't want them to
		header = header:format(" DEBUG")
	else
		header = header:format("")
	end

	MsgC(Color(114, 137, 218), header)
	for k, v in next, args do
		if istable(v) then
			args[k] = table.ToString(v)
		end
	end
	print(unpack(args))
end
function discordrpc.Init(callback)
	if not discordrpc.port then
		discordrpc.Print("Finding port")
		local validPort
		for port = 6463, 6473 do
			local success = function(body)
				if body:match("Authorization Required") and not validPort then
					discordrpc.Print(("Connection success on port %s! "):format(port))
					validPort = port
					discordrpc.port = validPort

					discordrpc.SetActivity({ state = "Initializing" }, function(body, err)
						if body == false then
							discordrpc.Print("Error: First SetActivity test was unsuccessful: " .. err)
							if err:match("Not authenticated or invalid scope") then
								discordrpc.Print("Make sure you're using Discord Canary!")
							end
						else
							discordrpc.Print("First SetActivity test was successful, ready to work!")
						end
						discordrpc.Print(body, err)

						if callback then -- idk if we should cancel calling the call back if we error
							callback(body, err)
						end
					end)
				end
			end
			local failed = function(...)
				-- discordrpc.Print("port " .. port .. " is probably invalid: ", ...)
			end
			http.Fetch(("http://127.0.0.1:%s"):format(port), success, failed)
		end
	end
end

local pids = {}
function discordrpc.SetActivity(activity, callback, pid)
	if not discordrpc.enabled:GetBool() then return end

	if not discordrpc.port then
		ErrorNoHalt("DiscordRPC: port unset, did you Init?")
		return
	end

	-- This doesn't really matter though it would be nice if we could get GMod's process ID in Lua
	-- we used to use math.random(11, 32768), I think that was really bad
	local pid = pid or 1337 -- prefer a static pid?
	pids[pid] = true

	HTTP{
		method = "POST",
		url = ("http://127.0.0.1:%s/rpc?v=1&client_id=%s"):format(discordrpc.port, discordrpc.clientID),

		type = "application/json",
		body = util.TableToJSON{
			cmd = "SET_ACTIVITY",
			args = {
				pid = pid,
				activity = activity
			},
			nonce = tostring(SysTime())
		},

		success = function(status, body)
			if not callback then return end

			local data = util.JSONToTable(body)
			if not data or data.evt == "ERROR" then
				callback(false, "Discord error: " .. tostring(data.data and data.data.message or "nil"))
			else
				callback(data)
			end
		end,
		failed = function(err)
			if not callback then return end

			callback(false, "HTTP error: " .. err)
		end,
	}
end
local defaultActivity = {
	details = "???",
	state = "Default state"
}
function discordrpc.GetActivity()
	local activity = {}

	if discordrpc.state then
		local state = discordrpc.states[discordrpc.state]
		if state then
			activity = state.GetActivity and state:GetActivity() or {
				details = state:GetDetails(),
				state = state:GetState(),
				timestamps = state:GetTimestamps(),
				assets = state:GetAssets()
				-- Other fields available that we can't use (atleast I don't think so): party, secrets, instance, application_id, flags
			}
		else
			discordrpc.Print(("Error: State %s not found? Getting default activity!"):format(discordrpc.state))
			activity = defaultActivity
		end
	else
		discordrpc.Print("Warning: No state selected, getting default activity!")
		activity = defaultActivity
	end

	return activity
end
function discordrpc.Shutdown()
	for pid, active in next, pids do
		if active then
			discordrpc.SetActivity(nil, function()
				pids[pid] = false
			end, pid) -- reset all of our rich presences
		end
	end
end

cvars.AddChangeCallback("discordrpc_enabled", function(_, old, new)
	if not tobool(new) then
		discordrpc.Shutdown()
	end
end, "discordrpc_enabled")
hook.Add("ShutDown", "discordrpc_clear", discordrpc.Shutdown)

