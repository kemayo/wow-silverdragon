# SilverDragon

SilverDragon tracks rares in World of Warcraft. It will try everything possible to notice them and tell you about them.

## How does it search?

### Vignettes

Those little skull icons you see on the minimap. If one of them is a rare SilverDragon knows about, it'll yell at you.

### Targets

If you mouse over or target a rare mob, SilverDragon will notice it.

### Nameplates

If you have enemy nameplates turned on, SilverDragon will keep an eye on them to look for the names of known rares.

### Macro

SilverDragon can also create a macro to target any rares that are known in the current zone. You can stick this on your actionbars as a button to spam while chasing after a rare, or bind it to a key. This is sort of a last resort.

### Chat

Some rares yell in zone chat. If SilverDragon notices those yells, it'll alert you.

## How will I know when a rare is seen?

### Frame

When a rare appears, SilverDragon will pop up a frame that you can click on to target it.

Warning: If you're in combat, secure action restrictions mean that it won't show up until combat finishes.

### Sounds

You can choose from assorted sounds to play when a rare is seen. The sound can loop for a while, to make sure you don't miss it.

There's special settings for rares that drop mounts and world boss rares which you might want to call up a group for. If you're sitting mostly-AFK on a Time-Lost Proto Drake spawn, you probably want the sound that plays to be utterly ridiculous and go on for a good long while, to make *sure* you don't miss that sucker.

### Messages

A notice can be sent to a number of places:

 * your scrolling combat text
 * your chat frame
 * a channel in your chat frame (announcing it to your party, for instance)
 * a popup window
 * etc

## Other useful things?

### Custom mobs

In SilverDragon's options you'll find a "Mobs" section. In the "Always" section, you can add any mob you want to be scanned for. All you need to know is the mob id.

So, let's say you wanted to keep an eye out for Lil Timmy in Stormwind, to buy the kitten he sells. You would...

 1. Go to his [wowhead page](http://www.wowhead.com/npc=8666/lil-timmy).
 1. Grab his id from the URL. It's `8666`.
 1. Enter `8666` into the "add" field, and click "okay".
 1. Play with your new kitten.

Yes, this example dates me.

### Ignoring mobs

If there's some mob you don't want to hear about for whatever reason, just go to the "Ignore" section of the options. Again, enter the mob's id into the "add" box, then click okay. Bam! You will never again be told that Vern is up.

(Actually, Vern is ignored by default. But you get the idea.)

### Syncs

SilverDragon will talk to itself. It can communicate with other copies of itself run by people in your party / guild, and tell you when they see a rare mob. (If there's a group of you camping all the Time-Lost Proto Drake spawns, say...)

You can turn this off completely, if you want to be private about it.

### Tooltips

Some rares are part of an achievement. When you mouse over a rare mob, SilverDragon will add to the tooltip whether you've already killed it, so you know whether you need to rush for it.

### Broker

SilverDragon includes a Broker plugin. It'll attach itself to your minimap, or a Broker container you have installed, and show you a list of the mobs it knows about in the current zone.

## Other addons you may find useful

 * [AppearanceTooltip](https://www.curseforge.com/wow/addons/appearancetooltip/): integrates with the SilverDragon loot popups and shows transmog-known status.
 * [ServerRestartSound](https://www.curseforge.com/wow/addons/serverrestartsound): plays a sound when the server's about to restart. If you're AFK-camping for a rare spawn, you probably want to know about this.
 * [ObjectScanner](https://www.wowace.com/projects/objectscanner): A few rares are hidden away behind interacting with world-objects like the Edge of Reality. These have to be localized individually, so you need to work out what they're called in your language and set up a watch for tooltips mentioning them. This addon does that bit.
 * [ButtonBin](https://www.curseforge.com/wow/addons/button-bin): a broker display. SilverDragon's minimap icon will show up on it (or any other addon like it) instead of cluttering up your minimap, if you have it installed.
