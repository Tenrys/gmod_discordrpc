
if not discordrpc then ErrorNoHalt("DiscordRPC: missing???") return end

local metastruct = {}
function metastruct:GetDetails()
	-- I was thinking of adding zones there maybe, we need to get those working clientside
	local ply = LocalPlayer()
	if ply:GetNWBool("in pac3 editor") then
		return "Using the PAC3 Editor" -- Shorter later if we need to display more but we have space right now
	end
end
local zone_fixup = {
	hll = "hell",
	hevn = "heaven",
	breenoffice = "breen_office",
	cre = "core",
	cinm = "cinema",
	slight = "darkness"
}
function metastruct:GetState()
	-- Possibly reserved for other discordrpc states
	local ply = LocalPlayer()
	local zone = landmark.nearest(ply:GetPos())

	if not zone then return "In Game" end
	zone = zone:gsub("^AutoInstance0", "")
	zone = zone_fixup[zone:lower()] or zone

	if zone:match("dond") or zone:match("minigame") then
		local dond_screen = ents.FindByClass("mitt_dond_screen")[1]
		if IsValid(dond_screen) and dond_screen:GetRunning() then
			if dond_screen:GetPlayer() == ply then
				return "Playing DOND"
			else
				return "Watching someone play DOND"
			end
		end
		return "In Minigame room"
	end

	return "Near " .. (zone and zone:gsub("^[a-z]", string.upper):gsub("_", " ") or "some place")
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

	-- For gm_construct_m, different large images depending on the zone, with last zone as fallback image?
	if game.GetMap():match("^gm_construct_m") then
		assets.large_image = "gm_construct_m"
	elseif self.mapIconAssets[game.GetMap()] then
		assets.large_image = game.GetMap()
	else
		assets.large_image = "default"
	end
	assets.large_text = game.GetMap()

	return assets
end
discordrpc.states.metastruct = metastruct

timer.Create("discordrpc_metastruct", 20, 0, function()
	discordrpc.SetActivity(discordrpc.GetActivity(), discordrpc.Print)
end)

