# Changelog

## Changed in v4.0.5
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
* [b]For the cache-scanning to work, you have to import data. It relies on NPC ids that can't be gained from within the game.[/b]

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
