
## Discord Rich Presence support for Garry's Mod!

<p align="center">
    <img src="https://raw.githubusercontent.com/Tenrys/csgo_richpresence/master/img/gmod_icon.png" height=150/>
    <img src="https://raw.githubusercontent.com/Tenrys/csgo_richpresence/master/img/discord_icon.png" height=150/>
</p>

### Notice: This script is completely safe and won't get you banned from Discord.

# How does it work?

This script makes Garry's Mod send HTTP requests to your Discord client's RPC server in order to change your Rich Presence status according to what you make it feed it.

# Installation, usage

## Recommended:

1. Download the [latest version](https://github.com/Tenrys/gmod_discordrpc/archive/master.zip) of the script.
2. Extract the contents of the zip file you downloaded in the `addons` folder located in your game's installation directory. *(Default, on Windows: `C:\Program Files (x86\Steam\steamapps\common\Garry's Mod\garrysmod`)*.
3. [Setup your own Discord application](https://discordapp.com/developers/applications/me), and grab its client ID.
4. Put the client ID you got for the `discordrpc.clientID` value.

By default, the add-on won't do much on itself, it's mainly targetting developers for them to expand on. Take a look at the example file in the `lua/discordrpc/states` folder to get a quick start.

# Support

I've tested this on the Canary branch of Discord, and on the Chromium branch of Garry's Mod.
If this doesn't work on normal Discord, please wait patiently for the update that makes this work to roll out.

If it still doesn't work even on Discord Canary, or the script ends up creating Lua errors internally *(e.g: not caused by your custom states logic)*, please create an issue with the error and the output from your console around `[DiscordRPC]` stuff.

# Known bugs

- None!

# Planned

- Default gamemodes states to server as examples, or simply just for lazy people (DarkRP, TTT, Sandbox)

# Credits

- [Tenrys](https://github.com/Tenrys), came up with the idea after working on the original [CS:GO Discord Rich Presence](https://github.com/Tenrys/csgo_richpresence) program and started research
- [SpiralP](https://github.com/SpiralP), helped a **GOOD** bit with research on the subject and supplied starting code to build upon
