local myname, ns = ...

local pebble = {
    quest=46952,
    loot={147420},
    inbag=147420,
    note="Show to Dog in your Draenor garrison",
    hide_before=ns.conditions.QuestComplete(30526),
    upcoming=false,
    atlas="islands-azeritechest",scale=1.2,
}
ns.RegisterPoints(627, { -- Dalaran
    [28466450] = {quest=41929, loot={7676}, label="Desmond's Lockbox", note="Locked", requires=ns.conditions.Class("ROGUE")},
    [47404120] = {quest=45365, loot={{143534, toy=true}}, note="On the table on the second floor of the Legerdemain Lounge", level=10},
    -- Dog pebble, questid is for showing Dog the pebble, not looting it
    [38102920] = pebble,
    [42104440] = pebble,
    [41005320] = pebble,
    [46205390] = pebble,
    [49406940] = pebble,
    [51706220] = pebble,
    [54505320] = pebble,
    [54304080] = pebble,
    [47702920] = pebble,
    [44601820] = pebble,
})

-- Pepe
ns.RegisterPoints(627, {
    [32573104] = {note="Cemetery"},
    [33805062] = {note="Violet Citadel"},
    [34443490] = {note="Tailoring"},
    [34734550] = {note="Underbelly"},
    [35123008] = {note="Leatherworking"},
    [36363796] = {note="First Aid"},
    [37555682] = {note="Threads of Fate"},
    [38553357] = {note="JC stairs"},
    [39654280] = {note="Enchanting"},
    [39923543] = {note="JC"},
    [39932764] = {note="Archaeology"},
    [40883326] = {note="Alchemy"},
    [42435786] = {note="Applebough"},
    [42511961] = {note="Antonidas"},
    [45003021] = {note="BS/Mining"},
    [47333765] = {note="Legerdemain"},
    [47473250] = {note="Well"},
    [48095834] = {note="Trinkets"},
    [49725049] = {note="Chamber of the Guardian"},
    [51025351] = {note="Visitor Center"},
    [51221543] = {note="North Bank"},
    [54304529] = {note="Violet Gate"},
    [59014239] = {note="Menagerie"},
    [60205236] = {note="Hunter's Reach"},
    [64895369] = {note="Violet Hold"},
    [72995286] = {note="Krasus' Landing"},
}, {
    achievement=10770,
    loot={{139632, quest=43695}}, -- A Tiny Pair of Goggles
    note="{npc:113461:Pepe} will spawn occasionally in these locations",
    texture=ns.atlas_texture("dragon-rostrum", {r=0.25,g=0.75,b=0}),
    minimap=true,
    requires=ns.conditions.Achievement(9838), -- What A Strange, Interdimensional Trip It's Been
    group="Pepe",
})
