# Changelog

## Changed in v90005.0

* Avoid a new issue which caused errors when showing/hiding the popup in 9.0.5 (had to remove some normal API calls here, so there might be subtle issues with the mouse working on a hidden-in-combat popup until this is resolved on Blizzard's end)
* Popups have been rewritten!
    * They're now a stack, rather than a new one immediately replacing the current popup. (If you prefer the old behavior, you can set the stack size to 1 in the options and it'll be about the same.)
    * They should overlap less windows now.
* Don't play multiple sounds at once. This was particularly bad for rares like the Beasts of Bastion, which simultaneously played the announcement four times, making it way too loud.
* Trim the final awwwk off of Ikiss' loot announcement
* Make help tooltips more compact in general
* Add mobs that trigger via the yell for Sire Ladinas
* Ability to toggle the map overlay per-zone by shift-clicking on the broker icon on the world map
* Add various missing questids and improve loot

## Changed in v90002.15.1

* The broker tooltip "regular loot" icon will now show a checkmark if you have all the quests/appearances your character can get from that loot
* Fix some mounts incorrectly showing as collected
* Fix Tomb Burster questid

## Changed in v90002.15

* Transmog appearances can now be counted as part of mob completion. I've disabled this by default for now, but it's in "settings > outputs > ...include transmog appearances" as a modifier to the existing "got the loot" setting.
* More updates to loot data
* Add It's Always Sinny In Revendreth to tracked achievements
* Fix a number of mobs appearing in Durotar that shouldn't have
* Fix restricted items (covenant/class-specific) counting towards loot completion if you couldn't get them
* Fix restriction labels on the popup tooltip going outside the tooltip borders

## Changed in v90002.14

* A huge amount of loot has been added, across all expansions. I've only added unique-to-that-mob loot
* Now support loot that has an associated quest, and count it for completion purposes. I'm looking at you, Mechagon blueprints
* Update tameable-mob information, which was very out of date, and show the icon for the type of tameable mob in the broker tooltip
* Fix item-type headers not showing in the loot summary part of tooltips

## Changed in v90002.13

* Loot can now be flagged as being covenant/class-specific, and some is; Blizzard is quiet about what counts, so we're going by wowhead comments here, expect further updates
* Checkmark on the popup loot icon was missing if you had all the knowable loot
* Stop an error when mousing over the loot icon on the popup for mobs with more than 3 items that'd have to be previewed
* Sharing a link to chat could fail if you were in an area where the general channel couldn't be identified; it'll fall back properly to opening the chatbox now
* Stop the map overlay from pinging multiple mobs at once if a vignette was visible when you first logged in
* Apparently I missed migrating Cataclysm loot data to the new format a few releases back, so it wasn't properly showing mounts and pets

## Changed in v90002.12

* Better vignette scanning options:
    * You can ignore specific vignettes, including loot vignette (see options > scanning > vignettes > ignore)
    * You can ignore entire categories of vignette by their icon (in particular, the white-skull for Maw bonus bosses may be of interest here...)
* Fix Dead Blanchy's position
* Add Fractured Faerie Tales achievement completion to tooltips

## Changed in v90002.11

* Don't try to draw routes if the map isn't visible (this caused some `y2 is nil` errors, if you saw those)
* Add some more vignette ids to the Maw

## Changed in v90002.10

* Changed the way I was picking distinct colors for map icons
* Fixed an issue where some people were having the minimap icons disabled when logging in
* Fixed an issue where two mobs with identical coordinates wouldn't show up on the map
* Add a few mob routes in Bastion

## Changed in v90002.9

* Can now show mob routes on the map. But I've not added much yet. So, if you want to see it, the Time Lost Proto-Drake is it for this release.
* Avoid an error in the vignette scanner during certain zone transitions
* There's now a crack-of-thunder sound included as an announcement option

## Changed in v90002.8.1

* Reverted the no-target-hunter-pet thing because it didn't work

## Changed in v90002.8

* Scanning macro improvements:
    * Will no longer target hunter pets with the same name as a rare
    * Zones with lots of rares will no longer be quietly truncated by the macro length limit, all rares will now be scanned
* Improved chat scanning so we can catch the Sire Ladinas yell which comes from a different mob
* Improved the detection of zones where we should restrict the range at which we scan for vignettes (no more going into caves in Ardenweald and having Ikiss yell at you suddenly)
* Restrict all scanning in the Maw to visible-only, because of the rare-density there
* Automatically shift the points in the map overlay so they try not to overlap each other
* Range-extended vignettes now have smaller icons but easier mouseover tooltip targets
* Broker tooltip anchor is adjusted to avoid overlapping the map
* Include the Wild Hunting achievement
* Various data updates in Shadowlands

## Changed in v90002.7

* In the mobs options, expose achievements so you can easily ignore/unignore every mob for a given achievement. Like, hypothetically, if you want to stop being notified about the Maw bonus bosses, you can quickly hide everything for "It’s About Sending a Message"
* Split up the options for the map overlay: you can now control everything separately about minimap and worldmap pins
* Changed the defaults for minimap pins so that their tooltips are less bulky
* Added a central toggle for scanning for loot vignettes in the scan>vignette options, so you don't have to turn announcements off in several places if you don't want them.
* Forbidding certain vignettes from being announced. I'm looking at you, Garrison Cache
* Fixed the location of the Ascended Council in Bastion (thanks rainfordays!)
* Filled out other mob locations / vignette ids
* Updated some Maw loot

## Changed in v90002.6

* Click-to-ignore on the target popup didn't understand loot

## Changed in v90002.5

* Show alerts and popups when treasure vignettes appear on the map
    * Haven't y'all missed Ikiss screaming about trinkets? Well, if you really haven't, there's sound options for this.
* New option to only have vignettes trigger alerts when they actually become visible
    * This is force-enabled in Ardenweald, because it has all vignettes viewable from the entire map for some reason
* Change the behavior of the sound preferences: you can now separately toggle regular-mob sounds, mount-dropping sounds, boss sounds, and loot sounds without having to use the hack of setting the sound file to "None"
* The overlay map pins were too sensitive, triggering the tooltip sooner than was ideal
* Avoid tooltips for mobs with loot in the map overlay sticking around when they shouldn't
* Avoid the tooltip on the loot window attached to the target popup overlapping the popup poorly
* Avoid an error if you focus a mob that's in a zone with no route to you
* Touch up some Warlords data

## Changed in v90002.4

* New minimal target popup look
* Show unknowable loot attached to tooltips on the world map
* Option to not set waypoints while you're dead (because it interferes with your corpse waypoint...)
* Fix clicking the world map broker button to toggle map icons
* Various loot data updates in Shadowlands

## Changed in v90002.3

* Include unknowable loot in tooltips
    * Some of this is technically "knowable" in the transmog sense, but tracking that is complicated.
    * You can go install [AppearanceTooltip](https://www.curseforge.com/wow/addons/appearancetooltip/) which'll integrate with the SilverDragon loot popups and show transmog-known.
* Prime the loot cache when showing the world map or broker tooltip, so you see less "loading..." for items
* Update a bunch of Shadowlands loot from new information
* Unstable Memory in Bastion had a typo in its loot
* Some fairly large behind the scenes changes to how the target popup is positioned, but what you should notice is:
    * You can now scale the target popup in settings
    * You can show an anchor for the target popup to see where it'll appear
    * The popup position is saved per-profile rather than per character

## Changed in v90002.2

* Add the ability to toggle the map icons on/off by clicking the world map broker icon
* Add a bunch of missing Shadowlands rares
* Add achievements:
    * Better to Be Lucky Than Dead (Maw)
    * It's About Sending A Message (Maw)
    * In The Mix (Maldraxxus)
    * Bloodsport (Maldraxxus)
* Vignette range extension is broken out into a sub-addon; it now has a better explanation of what's going on in the options, and lets you choose which types of vignette to range-extend
* Lots of work on rewriting the loot system
    * Some loot that's not mounts/toys/pets being visible
    * Not much is added yet; I've got most known Shadowlands drops, and I fleshed out Mechagon for blueprints and Timeless Isle drops for now
    * There's a new item in the broker tooltip to show if a rare has other known loot; click it to see a popup of that loot
* When show the text alert for a rare, if we don't know its location (e.g. zone-wide mob yells) say that rather than just showing "0,0" for it
* The chat scanning will now only announce rares that are known to exist in the current zone, and mobs you've added as custom mobs regardless of zone
    * Death Rising caused a lot of false-positives for people running the old Icecrown instances...
* In the broker tooltip, save space by showing tameable mobs with a hunter icon rather than text

## Changed in v90002.1

* Make sure the ping animation is stopped when the pin frames are reused
* Remove the Death Rising rares, since the event is done
* Fix up various Bastion mobs, including making sure they're flagged as being part of the achievement
* A few past-expansion fixes: some missing positions and a toy in Pandaria, overlapping locations in Hyjal

## Changed in v90002.0

* This one is just a TOC bump, y'all

## Changed in v90001.7

* There's a ping highlight on the world map for:
    * the last seen mob when you open the map (within 30 seconds of seeing it)
    * a focused mob right when you focus it
* Mobs on the map overlay can be shift-right-clicked to immediately hide them
* Options for whether to show mobs on the edge of the minimap; by default, only focused ones are shown there
* Mobs on the map which are completed but shown anyway get slightly smaller icons (the "stars" theme did this already, but now it's consistent)
* The "ignore mobs that an alt has completed the achievement for" option was being ignored for mobs that had a vignette
* Some mobs (Basten) couldn't be hidden from the map... but now they can!
* Chat and vignette scanning now respect the "don't scan in instances" setting

## Changed in v90001.6

* Mobs in the broker tooltip now get click actions and informational tooltips
    * Click a line to open the map with that mob focused
    * Control-click a line to set a waypoint for the closest location for that mob
    * Shift-click a line to link the closest location for that mob in chat
    * Mousing over them triggers the highlights on the map, if it's open
* Minimap pins update their focus state immediately
* Fix a spawn location for Krik'thir the Gatewatcher

## Changed in v90001.5

* Refined waypoint options:
    * Blizzard waypoints are now equivalent to TomTom/DBM, not just a fallback, and you can choose all/none of them independently
    * Blizzard waypoints weren't being auto-removed on timeout correctly
    * An error could happen on auto-removal if you had TomTom *and* DBM enabled simultaneously
* Map overlay improvements:
    * Hover over a mob to show a highlight over all locations for that mob on the map
    * Click a pin (or the mob's name in the broker dropdown) to focus it so it always shows a highlight... now you can easily find a mob after seeing its name in the broker dropdown!
    * Shift-click a pin to link to it in chat (using your target popup settings)
    * Alt-click a pin to set a waypoint for it
* Add notes on Death Rising rares about their spawn order
* Fix a spawn location for Prince Keleseth

## Changed in v90001.4

* The Death Rising pre-launch rares in Icecrown are added temporarily; they won't actually spawn before the appropriate point in the event is reached
* Improve shift-clicking the popup to add a chat link:
    * New default: immediately send the link to the /general channel
    * Which channel to send to can be configured
    * Old behavior of just opening the default chatbox is available in options
* Map icons no longer require HandyNotes
* Right-clicking the LDB icon on the world map will immediately show the options for the map icons
* Right-clicking the target popup to close it will now happen immediately in combat
* Performance improvements when editing the mob ignore list
* Galleon's chat announcement wasn't being noticed, because Chief Salyis isn't Galleon

## Changed in v90001.3

* Improve shift-clicking the popup to add a chat link:
    * Don't require you to have an open chatbox before pasting it there; open the default chatbox if you have nothing else open
    * Include the health for the mob if we can work it out (if it's a target or its nameplate is visible)
    * For sources that don't include the location (chat yells), link to the player's current location
* Option to hide the target popup when the mob dies
* Option to hide the waypoint arrow when you manually close the popup
* Mobs that you've added to the "custom" section will now bypass most "should I announce this?" checks (e.g. you can ignore the entire Warlords source, and manually-add Rukhmar)
* Unchecking "Got the loot" in the outputs config will now only affect mobs for which we know any drops
* Some _very timely_ improvements on Argus
* Achievement tooltip in the broker tooltip will now show your criteria-completion
* Rukhmar's questid added
* The highlight on the "store" popup theme was covering up the loot icon
* The X on the target popup wasn't appearing when the mob died
* Fixed `/silverdragon add` with no parameter causing an error
* Some more Shadowlands questids
* Some missing pets / toys
* Sha of Anger has only had one spawn point since 7.2 (thanks frumpymoons)

## Changed in v90001.2

* Special map icons for mobs with toys and pets as well
* Broker dropdown added to the mount journal, will show all known mobs that drop mounts (and whether you've looted them)
* Show mob variants in the dropdown, for things like the Mechagon Data Anomalies, Madexx, and the Zandalari Warbringers
* Chat-scanner: looks for mobs in the current zone with that name before checking globally in case of a name-collision
* Chat-scanner: only announce coordinates if it's from a chat event which implies the mob is anywhere near you (yells are zone-wide...)
* Waypoint integration with DeadlyBossMods
* If data on a toy/mount/pet is still loading, say that in the tooltip rather than not showing anything about it at all
* Mists: Nalak and Oondasta questids
* Fixed broken N'zoth and Azerite loot popup target themes
* Included updated version of LibQTip-1.0 which won't error if you have a broken pre-9.0 addon installed with an older version of LibQTip-1.0

## Changed in v90001.1

* Fixed a backdrop error in the "classic" popup target theme

## Changed in v90001.0

* Shadowlands data: most of the new rares are included, with questids and loot. Some are still missing quests, but we've got time.
* Integration with "TomTom" is now "Waypoints", and can use the new built-in waypointing system or TomTom as you choose.
    * Ctrl-clicking the target popup will set a waypoint for the mob.
    * Shift-clicking the target popup will paste a clickable link to the mob to an open chatbox.
    * These waypoints will only be accurate for mobs detected through minimap vignettes, otherwise it's just going to point at wherever you were when you saw it.
    * The built-in waypointing can only have one waypoint at a time, so things like waypointing every spawn of a mob at once aren't possible.
    * If you already have a waypoint, SilverDragon will replace it and then try to restore it. (Or can be configured to not add waypoints if you already have one.)
* Added missing toys in Warlords, Mists, and Legion
* The macro targeting now better respects mobs that should be ignored
* Fixed target scanning to work in instances again
* Fixed chat scanning not opening the target popup
* Fixed an error from chat scanning in instances
* Fixed the id for Rukhmar

## Changed in v80300.5

* Watch for known rares which announce themselves in chat (e.g. Arachnoid Harvester)
* Add the broker dropdown to the world map frame -- now you can look at the rare list with loot for any zone
* Add right-clicking on the target popup's close button to ignore the mob
* Allow the waypoint auto-clear timer to be set in 5 second increments
* Fix the target popup not showing up after combat ends if you noticed a rare during combat
* Cleaned up some of the warfront map locations
* Stop the achievement completed-by-alt check from behaving differently than whether your current character has completed it

## Changed in v80300.4

* Loot was missing from the Warfront rares
* Warfront rares all had Alliance questids; now they know to check for the Horde ones, too
* New map icon theme: stars
* Option to not show icons on the minimap
* Show a checkmark on the target popup's loot icon if you've got everything
* Broker popup loot details tooltips will behave properly on the tiny number of mobs with multiple loot drops
* Fix an error if your target popup theme was set to LessAwesome before v80300.3

## Changed in v80300.3

* Loot
    * Include some data about drops from rares, so you can know whether you've gotten the mount / toy / pet that something drops. Data's present for everything in BFA, and spottily before that
    * You can add this to tooltips for the rare so you'll know when you see it
    * The target popup has a loot icon you can mouse over for details
    * The broker dropdown includes icons breaking out what's dropped and whether you have it already
    * The HandyNotes icons show this in their tooltips
* Alerts
    * Improved sound options: you can choose the channel the sound plays on (Master, Music, SFX, etc), and you can ask it to play while the game isn't focused / the channel is muted
    * Improved the flash alert: you can choose the color and texture
    * Add an option to not announce for mobs that another character has the achievement for, regardless of whether the current character has also completed it
* Improved map icons in HandyNotes: you can choose between circles and skulls, and you can tell it to color the icons uniquely per-mob or by completion
* You can right-click on a map icon to add a TomTom waypoint for every location that mob has
* Added a bunch of new target popup themes
* Added a slash command so you can do things like `/silverdragon add 123456` or `/silverdragon remove target` or `/silverdragon ignore target`
* Allow right-clicking on the target popup to close it
* Add bulk ignore all / none buttons to the expansion mob lists
* The broker dropdown is now scrollable, and you can mouse over it for more information about some icons
* Cleaned up some of the Assault / Nazjatar mobs which are replacement-spawns for common mobs
* Cleaned up various rares which are only ever present for world quests
* Changed really long-standing behavior: raid member targets are now checked, not just party member targets
* Fixed various quest ids
* Stopped hiding chat-channel output from the config for other addons using LibSink
* Background Shadowlands work

## Changed in v80300.2

* TomTom integration: option to add a TomTom waypoint pointing to a just-seen rare
* Update the database to mark mount-dropping rares from BfA
* Lower the number of sound loops for the "I've seen a mount-dropping rare!" alert defaults
* Fix a weird bug some people were seeing on login
* Fix a few quest ids

## Changed in v80300.1

* Made it so the 8.3 assault rares only appear while their assault is happening
* ...also, the assault rares for the older faction assaults
* Added many questids for new rares
* Remove ability to automatically announce rares to chat, as Blizzard protected this functionality in 8.2.5 and it was just causing errors

## Changed in v80300.0

* Updated for 8.3
* Added new rares for Uldum and Vale of Eternal Blossoms (missing many questids)
* Added Honey Smasher to Stormsong Valley
* Fixed the creation of the macro
* Changed to a new version number scheme that makes more sense now Classic is a thing

## Changed in v4.0.17
* Added questids for most Mechagon and Nazjatar rares
* Added some missing Nazjatar rares
* If we don't know questids, treat a vignette as the source as equivalent to an incomplete quest. This should help with future no-quest-known-yet situations over-alerting
* Properly suppress mobs that were flagged as hidden from mouseover and targeting alerts

## Changed in v4.0.16
* Updated for 8.2
* Added Mechagon and Nazjatar rares (questids to come)
* Added I Thought You Said They'd Be Rare and Rest In Pistons achievements
* Rearrange some mobs that were added in later expansions (Cataclysm and Mists) into the categories for the expansion whose zone they're in, because that makes more sense
* Ignored mobs are no longer shown in the broker plugin
* Other missing questids added

## Changed in v4.0.15
* Config wasn't opening because localization for some zone names was broken

## Changed in v4.0.14
* HandyNotes integration properly ignores rares you can't interact with because of your faction
* Range-extended vignettes: shrink the clickable size a bit so you can click through them more easily
* 8.1.5 compatibility fixes
* Various mob fixups from NLZ
* Other missing questids

## Changed in v4.0.13
* Extend the range of vignettes on your minimap, so we don't keep on alerting for things without giving you any clue as to where they are.
* Questids added for (almost) all the BfA Adventurer mobs

## Changed in v4.0.12
* Adventurer achievements for BfA, to track whether you've killed those mobs already
* Bad mapids: Isle of Thunder, Deepholm

## Changed in v4.0.11
* Bug in a few areas where vignettes exist but don't provide information
* More Timeless Isle questids
* Bad map ids in Frostfire Ridge
* Update embedded version of LibStub-2.0 to fix an error with chat channels

## Changed in v4.0.10
* Broker tooltip sorts mobs alphabetically
* Add questid tracking to (most) Timeless Isle mobs
* Various bad map ids: Vale of Eternal Blossoms, Krasarang Wilds, Ghostlands, Underbelly, Westlands, Blackrock Mountain
* TomTom integration via HandyNotes was broken

## Changed in v4.0.9
* Vignettes with different names from their associated mob should now be detected on non-English locales.
* Elwynn Forest rares were in the wrong zone

## Changed in v4.0.8
* You Won't Believe This One Simple Trick To Increase Vignette Detection Range!
* Also, fix for lua error in combat related to vignette positions

## Changed in v4.0.7
* ...stupid typo in the TOC broke everything.

## Changed in v4.0.6
* Some map function related issues in BfA.

## Changed in v4.0.5
* Updated for Battle for Azeroth
* New option: ignore all mobs in a given module. (E.g. "please shut up about every single Legion rare".)
* Filled in lots of completion data for the Legion Adventurer achievements
* Added the Commander of Argus achievement
* Adjust colors in the dropdown and handynotes: red for not-complete, yellow for partially-complete (quest / achievement), green for fully complete

## Changed in v4.0.3
* Updated for 7.3
* Argus mobs
* Some new backend support for hiding junk rares (i.e. the Treasure Goblins, and some class-specific ones)

## Changed in v4.0.2
* TOC for 7.2
* Questids for various world bosses

## Changed in v4.0.1
* New feature: automatic hiding of the popup after you've not interacted with it for a while (default: 30 seconds)
* Added text input to the ignore options, so you don't have to find the mob in its expansion
* Improved the text input for ignore/custom, so you can enter "target", "mouseover", the mob's id, the mob's name (if we know about it)
* Properly faction-classify all remaining faction-specific rares
* Lots more Legion rare questids
* Cleaned up a lot of tight clusters of the same mob on the map
* Added some fallbacks for mob-names so it's less likely you'll see "Unknown"
* The wrong Gorok had been included for ages, in Warlords. Sorry, Horde garrison havers.
* Fixed some of the database migration code

## Changed in v4.0.0
* Major rewrite to remove the "import data" paradigm
* Known mobs are now in per-expansion datasets, which you can disable entirely
* Various skins for the click-target popup (mostly based on the various loot toasts, admittedly)
* Show on popup whether the mob is dead, and try to pick this up during combat via combat-log events
* Rearranged the options a lot
* Marker will now respect other announcement settings

## Changed in v3.2.9
* TOC for 7.1
* More Legion vignettes and questids

## Changed in v3.2.8
* CreateTitleRegion was removed by Blizzard, requiring some minor rewriting
* More Legion vignettes and questids

## Changed in v3.2.7
* Option to not alert on rare mobs we've already killed, if we know the achievement / questid for them
* Option to not alert for rare mobs which are no longer flagged as rare
* More Legion vignettes and questids
* Flag some faction-only Legion mobs

## Changed in v3.2.6
* Fix irrelevant map icons appearing while inside caves / other subzones
* Be more likely to record some information about distant mobs
* Made the minimap icon options more obvious
* Fill in a lot of Legion rare questids
* Rewrote the dataminer, to be less likely to lose old information

## Changed in v3.2.5
* Remove debugging vignette sound, which was accidentally left in from Legion update

## Changed in v3.2.4
* Screen flashing alert works again

## Changed in v3.2.3
* Update for Legion
* New setting to control how verbose the macro is
* Don't trust a vignette for mob saving purposes unless we already know lots about it
* Click target sometimes said a mob's name was "0"
* Bounce the WoW icon in the dock, if possible, depending on your OS (okay, it's MacOS)

## Changed in v3.2.2
* Add keybinds for running a scan
* Re-add the Mysterious Camel Figurine locations, which had left us for a bit
* Use HereBeDragons-1.0 instead of Astrolabe for map calculations

## Changed in v3.2.1
* Avoid triggering if map treasure POIs have the same name as a rare
* Allow filtering out of Draenor zones
* Don't record the names given for mobs in achievements, since they're sometimes not correct

## Changed in v3.2.0
* Updated for for 6.2
* Ran dataminer
* Scan world map for POIs, too (Tanaan bosses)
* Fix TomTom name display issue
* Add the Hellbane achievement
* Tooltips: show whether quest flag for a mob is known and completed

## Changed in v3.1.5
* Recolored some map icons
* Ran the dataminer again for new coordinates
* Stopped alerting when you find the dead Time Lost Proto Drake in Nagrand
* Marker ignores mobs better
* Update the macro when finding a new rare

## Changed in v3.1.4
* Stop the popup from showing for Haakun the All-Consuming, since it reliably crashes the game. For reals.
* Fix some wowhead data being missing from the defaults
* Fix minimap tooltip not showing
* Separate out the achievements and quest filters for handynotes
* Adjusted the handynotes icons. Special icons for mount-dropping mobs...

## Changed in v3.1.3
* Stop the Outland rares from showing up in the Draenor zones of the same name
* Ignore the Ashran quartermasters if you're their faction
* The mobs with the mounts
* Count having completed the hidden tracking quests as "achieved" for handynotes integration purposes
* Tweak the appearance of the click-target popup a bit

## Changed in v3.1.2
* Include the Draenor rares
* Include the tooltip / LDB completion notes for Draenor achievements
* Some attempt at matching up rares whose vignette-name is different from the actual mob's name
* Fix automatic-localization of rare names via tooltip-scanning
* Fix making waypoints in TomTom

## Changed in v3.1.0
* Update for 6.0
* Remove cache-scanning. 6.0 broke it. Blizzard has never liked it, so I doubt we're getting it back. :P
* Improve vignette scanning to compensate. 6.0 should have made it more reliable.

## Changed in v3.0.10
* Include the handynotes settings in SD's options, since they're all hidden away in the main HN options
* Add a toggle for the frame locking... apparently the ALT-drag thing was non-obvious.
* Finally fix the last-seen-time ceiling
* Handynotes options to show/hide achieved mobs, and non-achievement mobs
* Option to disable rare announcing if dead
* Looking for achievement mobs: a sound default
* Disabling special sounds for mounts: wasn't working
* Add achievement status to broker and handynotes
* Update the zoom when the zone changes, too
* Add a range display ring to the minimap
* Was missing Throne of Thunder
* The max mapid is no longer below 950...
* Include Timeless Champion achievement
* Try to scan vignettes
* Get the Timeless Isle zoneid in there
* Rearrange notes on handynote popup
* Fix Krasarang terrain issue
* Strip out (Jade) from syncs.
* 5.2 zones should be flagged as MoP
* Warbringer should be in mount list
* Use manual camel coords provided by MysticalOS
* Missed a label

## Changed in v3.0.5
* Make to work in 5.2
* New option to only import mobs which are relevant to achievements
* Mark rares when targeted / mouseovered, to make them easier to track down
* Improvements to HandyNotes integration
* Show achievement status in tooltips ("Glorious!: Needed / Already killed")
* Targeting macro now doesn't try to target ignored mobs
* Stop using UIFrameFlash, since it taints the glyph frame
* Don't announce faction-specific mobs if you're not of the appropriate faction

## Changed in v3.0.0
* Rewritten extensively to better handle the new mob/zone information that's been made available since early 2009.

## Changed in v2.6.3
* Update for 5.0
* NPCScan.Overlay integration
* Remove cartographer support, already
* Drop LibTourist
* Mine for datas
* Adjust zone handling so that Darkmoon Faire and Molten Front aren't considered the same zone. (Blizzard calls them both zoneid 0, so...)

## Changed in v2.6.1
* TOC increase for 4.3
* New version of LibTourist-3.0, which was locking up the game when entering the world
* Avoid a race condition that could happen when setting up the macro while changing zones
* Run the dataminer

## Changed in v2.6
* Scan neighboring zones as well as the current
* More customization in what rares to ignore, based on expansion zone
* Show a list of rares seen this session in the broker plugin
* Registers a sending prefix, for those times when Blizzard feels like enforcing that
* New player location code, should account for changing zone terrain better

## Changed in v2.5
* 4.2
* Syncing of rare-seeing between party members and guild members (switchable off for performance / keeping the rares to yourself)
* Dataminer has been rewritten somewhat
* Mysterious Camel Figurine now included (see above)
* Record NPC ids from target/mouseover instead of relying purely on the import

## Changed in v2.4.3
* Astrolabe error for people with an updated version of Handynotes is fixed
* Quite a few new cataclysm rares included in the data; reimport to pick them up
* Disabling the rare popup wasn't working
* Some people reported an error when the screen flashed to alert them of a rare. This should plausibly be fixed... though I could never actually reproduce it myself, so no promises yet.

## Changed in v2.4.1
* Fix problem with cache-scanning not always working
* Reran dataminer to pick up information on tamable mobs, which had gone missing

## Changed in v2.4
* TOC to 40000
* Option to skip scanning while on a taxi
* Config rearranged
* Dataminer run once more

## Changed in v2.3.4
* New "clear all rares" option in config.
* HandyNotes updates in response to import/clear without needing a reloadui.
* Actually includes the non-vern dataminer run.

## Changed in v2.3.3
* Update for 30300
* Run dataminer. Forcibly exclude Vern from the dump. So if you clear your seen-rares and then do a new import, you won't see the popup for Vern in Dalaran any more.

## Changed in v2.3.2
* Better handling of player location in instances
* Add zhTW rares translation submitted by s8095324.
* Fix Nameplate/Cache scanning
* Run dataminer

## Changed in v2.3.1
* Missing AceLocale-3.0 embed.
* Cartographer integration bug.

## Changed in v2.3.0
* Default rare list localized to: deDE, frFR, ruRU, esES. Run an import to pick 'em up.
* Better filtering-out of player pets.
* Bump the TOC for SilverDragon_Data, so you don't need to enable out of date addons to import rares any more.

## Changed in v2.2.3
* Different layouts for portrait and full-body model views. Full-body is big and on top of the frame.
* Bump TOC
* AceConsole-3.0 embed was missing. Oops.

## Changed in v2.2.2
* Adjust said targeting frame a bit.
* Fix a bunch of errors I found when looking at the Scarshield Quartermaster.
* More feedback when creating a macro.

## Changed in v2.2.1
* Show in the tooltip whether a mob is already in the unit cache.
* Option to choose what ways of seeing a rare will make the targeting frame appear.
* Bugfix for the click-to-target options not showing. (Thanks to EthanCentaurai!)

## Changed in v2.2.0
* Add click-to-target frame that pops up when a rare is seen.
* Add macro-generator.
* Configure which sound is played when a rare is found. (Thanks to EthanCentaurai!)
* Options for which scanning methods to use.

## Changed in v2.1.2
* Quick fix for a nil error

## Changed in v2.1.1
* Add cache-scanning, much credit to NPCScan by Saiket.
* More options for notifying you: text, sound, screen-flashing.
* LDB tooltip now says whether the rare is tameable.
* For the cache-scanning to work, you have to import data. It relies on NPC ids that can't be gained from within the game.

## Changed in v2.0 r20090403010638
* Add a minimap icon for those without.
* Assorted bugfixes

## Changed in 2.0 r20090225045942
* Fix a missing LibSink-2.0 embed.

## Changed in 2.0 r20090224102127
* Total rewrite for WotLK. It's Ace3 now, and works with HandyNotes or Cartographer to put notes on your map.

## Changed in v1.0 r49794
* Update for 2.2.
* Add deDE localization.
* Some distance tweaks to rare location saving.

## Changed in v1.0 r36305
* Update for 2.1.
* Add zhTW translation from norova.

## Changed in v1.0 r32928
* Improve TBC rares defaults.
* Fix a few potential bugs.

## Changed in v1.0 r27768
* Add TBC rares to defaults, provided by Astaldo on wowace forums.
* Adjust display of coordinates to "x.x,y.y" instead of "x,y".
* Better Cartographer information -- show rare info in the Cartographer tooltip.
* Tweaked nameplate scanning for efficiency.

## Changed in v1.0 r21954
* Initial release.
