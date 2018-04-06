
Msg("DiscordRPC loading: start\n")

local function load(path)
	local action = CLIENT and include or AddCSLuaFile -- this is completely clientside, soo...
	action(path)
	print("\tLoaded: " .. path)
end

load("discordrpc/init.lua")
if SERVER then -- if server then just add the files to download
	for _, fn in next, (file.Find("discordrpc/states/*.lua", "LUA")) do
		load("discordrpc/states/" .. fn)
	end
else -- otherwise create the function to load states later in main.lua
	function discordrpc.LoadStates()
		discordrpc.Print("Loading states:")
		for _, fn in next, (file.Find("discordrpc/states/*.lua", "LUA")) do
			load("discordrpc/states/" .. fn)
		end
	end
end
load("discordrpc/main.lua")

Msg("DiscordRPC loading: done!\n")

if SERVER then
	CreateConVar("discordrpc", "1", 0, "This ConVar does nothing, don't bother! It just allows people to filter servers using it.") -- server ConVar to allow filtering
end

