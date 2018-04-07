
if not discordrpc then ErrorNoHalt("DiscordRPC: missing???") return end

local default = discordrpc.states.default or {}
default.assets = default.assets or {
	large_image = {},
	small_image = {}
}
local presences = {
	darkrp = {},
	sandbox = {},
	terrortown = {},
	zombiesurvival = {},
	cinema = {},
	murder = {},
	prop_hunt = {},
}

-- default gamemode presence
local gameStart = os.time()
function presences.sandbox:GetActivity()
	local GAMEMODE = GM or GAMEMODE
	local large_image = default.assets.large_image[engine.ActiveGamemode()] and engine.ActiveGamemode() or "default"
	local ip = game.GetIPAddress() == "loopback" and "local server" or game.GetIPAddress()
	return {
		details = GetHostName() .. " (" .. ip .. ")",
		state = "Playing on " .. game.GetMap() .. " (" .. player.GetCount() .. " / " .. game.MaxPlayers() .. " players)",
		timestamps = {
			start = gameStart
		},
		assets = {
			large_image = large_image,
			large_text = GAMEMODE.Name or engine.ActiveGamemode()
		},
		--[[
		party = {
			id = game.GetIPAddress(),
			size = {
				player.GetCount(),
				game.MaxPlayers()
			}
		}
		]]
	}
end
local fallback = presences.sandbox

-- round based gamemodes shit
local roundStart = os.time()
local roundEnd = os.time()
local lastRoundEnd

function presences.terrortown:Init()
	hook.Add("Think", "discordrpc_state_default", function()
		local roundEndTime = GetGlobalFloat("ttt_round_end")
		if not lastRoundEnd or lastRoundEnd ~= roundEndTime then
			roundStart = os.time()
			roundEnd = roundStart + math.max(0, roundEndTime - CurTime())
		end
	end)
end
function presences.terrortown:GetActivity()
	local activity = fallback:GetActivity()

	activity.timestamps = {
		start = roundStart,
		["end"] = roundEnd
	}

	return activity
end

function presences.prop_hunt:Init()
	hook.Add("Think", "discordrpc_state_default", function()
		local roundEndTime = GetGlobalFloat("RoundEndTime")
		if not lastRoundEnd or lastRoundEnd ~= roundEndTime then
			roundStart = os.time()
			roundEnd = roundStart + math.max(0, roundEndTime - CurTime())
		end
	end)
end
presences.prop_hunt.GetActivity = presences.terrortown.GetActivity

for _, presence in next, presences do -- let's do that currently, until I'm less lazy to actually add other game info to the presence
	if not presence.GetActivity then
		presence.GetActivity = function()
			return fallback:GetActivity()
		end
	end
end

-- actual state
function default:Init()
	local activeGamemode = presences[engine.ActiveGamemode()] or fallback

	discordrpc.clientID = "431766142181441536"

	http.Fetch(("https://discordapp.com/api/v6/oauth2/applications/%s/assets"):format(discordrpc.clientID), function(body, size, headers, code)
		local data = util.JSONToTable(body)
		if data then
			for _, asset in next, data do
				if asset.type then
					if asset.type == 2 then
						self.assets.large_image[asset.name] = true
					elseif asset.type == 1 then
						self.assets.small_image[asset.name] = true
					end
				end
			end
		end

		if activeGamemode.Init then
			activeGamemode:Init()
		end

		timer.Create("discordrpc_state_default", 15, 0, function()
			discordrpc.SetActivity(self:GetActivity(), discordrpc.Print)
		end)
	end, function(err)
		discordrpc.Print("Error: Asset retrieval failure: ", err)
	end)
end
function default:GetActivity()
	local activeGamemode = presences[engine.ActiveGamemode()] or fallback

	local activity = activeGamemode:GetActivity()
	if not activity.assets then
		activity.assets = {}
	end
	if not activity.assets.small_image and activeGamemode ~= fallback then
		activity.assets.small_image = "default_small"
	end

	return activity
end

discordrpc.states.default = default

