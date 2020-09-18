# Changelog

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
