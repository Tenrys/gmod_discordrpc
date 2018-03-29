
if not discordrpc then ErrorNoHalt("DiscordRPC: missing???") return end

local metastruct = {}
function metastruct:GetDetails()
	-- I was thinking of adding zones there maybe, we need to get those working clientside
	return nil
end
function metastruct:GetState()
	-- Other possible states: In PAC Editor, In <zone>, Playing DOND?
	-- Possibly reserved for other discordrpc states
	return "In Game"
end
local start = os.time() -- os.time since spawned in the server, do not edit
function metastruct:GetTimestamps()
	return {
		start = start,
		["end"] = nil -- nothing yet
	}
end
metastruct.mapIconAssets = { -- Has to be updated manually for now, retrieving asset list might prove difficult to do, if even possible
	gm_construct_m = true
}
function metastruct:GetAssets()
	local assets = {}

	if game.GetMap():match("^gm_construct_m_") then
		assets.large_image = "gm_construct_m"
	elseif self.mapIconAssets[game.GetMap()] then
		assets.large_image = game.GetMap()
	else
		assets.large_image = "default"
	end

	return assets
end
discordrpc.states.metastruct = metastruct
