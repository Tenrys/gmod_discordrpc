
if not discordrpc then ErrorNoHalt("DiscordRPC: missing???") return end

local example = {}
function example:Init()
	discordrpc.clientID = "431766142181441536"

	timer.Create("discordrpc_state_example", 15, 0, function()
		discordrpc.SetActivity(self:GetActivity(), discordrpc.Print)
	end)
end
function example:GetDetails()
	return "Some details"
end
function example:GetState()
	return "In Game"
end
local start = os.time() -- os.time since spawned in the server, do not edit
function example:GetTimestamps()
	return {
		start = start,
		["end"] = nil -- nothing?
	}
end
function example:GetAssets()
	local assets = {}

	-- Do whatever with the assets you add.

	return -- assets
end
function example:GetActivity()
	return {
		details = self:GetDetails(),
		state = self:GetState(),
		timestamps = self:GetTimestamps(),
		assets = self:GetAssets()
	}
end
discordrpc.states.example = example

-- Follow these guidelines: https://discordapp.com/developers/docs/topics/gateway#activity-object
-- You cannot use these fields: party, secrets, instance, application_id, flags (I'm not sure actually but you should only try if you know what you're doing)
-- The default state will probably help you more than this

