
## Discord Rich Presence support for Garry's Mod!

<p align="center">
    <img src="https://raw.githubusercontent.com/Tenrys/gmod_discordrpc/master/img/gmod_icon.png" height=256/>
    <img src="https://raw.githubusercontent.com/Tenrys/gmod_discordrpc/master/img/discord_icon.png" height=256/>
</p>

### Notice: This script is completely safe and won't get you banned from Discord.

# How does it work?

This script makes your game client send HTTP requests to your Discord client's RPC server in order to change your Rich Presence according to what you feed it.

It is completely clientside and your server won't have anything to do with the add-on except serving the files for your players, so no weird server HTTP requests to be worrying about!

# Installation, usage

## Recommended:

1. Clone the repository or simply download its [latest version](https://github.com/Tenrys/gmod_discordrpc/archive/master.zip).
2. Extract the contents of the zip file you downloaded in the `addons` folder located in your game's installation directory. *(Default, on Windows: `C:\Program Files (x86\Steam\steamapps\common\Garry's Mod\garrysmod`)*. You can remove the `img` directory from the add-on's folder, it's only used for providing images in this file. *(Might cause issues while trying to pull if you cloned this repository though)*
3. [Setup your own Discord application](https://discordapp.com/developers/applications/me), and grab its client ID.
4. Put the client ID you got for the `discordrpc.clientID` value.

You'll probably want to make a custom state for your server / gamemode, I recommend you look at the `default.lua` and `example.lua` states for an idea of how that works.

# Support

This should work flawlessly on any version of Discord and Garry's Mod. If it doesn't, don't hesitate to create an issue.
If the script ends up creating Lua errors internally *(not caused by your custom states logic)*, please create an issue with the error and the output from your console around `[Discord RPC]` stuff. This applies to the default state too, if it breaks, tell me.

# Known bugs

- None!

# Credits

- [Tenrys](https://github.com/Tenrys), came up with the idea after working on the original [CS:GO Discord Rich Presence](https://github.com/Tenrys/csgo_richpresence) program and started research
- [SpiralP](https://github.com/SpiralP), helped a **GOOD** bit with research on the subject and supplied starting code to build upon
