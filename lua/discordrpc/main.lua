
if not discordrpc then ErrorNoHalt("DiscordRPC: missing???") return end

discordrpc.clientID = "" -- This is your Discord application's client ID: https://discordapp.com/developers/applications/me
discordrpc.state = "example" -- This is the default state when you first load in.

if not game.SinglePlayer() then
	local httpLoaded = false
	local function checkHTTP()
		http.Fetch("http://google.com", function()
			httpLoaded = true
		end, function()
			httpLoaded = true
		end)
	end
	if not http.Loaded then
		timer.Create("httpLoadedCheck", 3, 0, function()
			if not httpLoaded then
				checkHTTP()
			else
				hook.Run("httpLoaded")
				timer.Remove("httpLoadedCheck")
			end
		end)
	end
else
	hook.Add("HUDPaint", "discordrpc_init", function()
		hook.Run("httpLoaded")
		hook.Remove("HUDPaint", "discordrpc_init")
	end)
end

hook.Add("httpLoaded", "discordrpc_init", function()
	discordrpc.Print("HTTP loaded, trying to init")
	discordrpc.Init(function(succ, err)
		if succ then
			discordrpc.LoadStates()
			discordrpc.SetActivity(discordrpc.GetActivity(), discordrpc.Print)
		else
			discordrpc.Print(succ, err)
		end
	end)
end)

