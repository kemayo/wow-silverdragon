local myname, ns = ...

-- skyhold unlock: 41360 60175223

local TREASURE = {
    achievement=11259,
    requires=ns.conditions.AuraInactive(182957),
}

local grapple = ns.nodeMaker{
    label="Grapple start point",
    atlas="MiniMap-DeadArrow", scale=1.2,
}
local REQ_GRAPPLE = 'Requires: Stormforged Grapple Launcher'
ns.RegisterPoints(634, { -- Stormheim
    [27335749] = {quest=38529, label=ns.CHEST, note="Cave entrance @ 31.4, 57.1", path=31405710},
    [31105600] = {quest=38676, loot={ns.rewards.Currency(1220)}, label=ns.CHEST_SM},
    [32054719] = {quest=43196, label=ns.CHEST},
    [32742791] = {quest=38490, label=ns.CHEST, note="Cave entrance @ 33.6, 27.3", path=33602730},
    [33143607] = {quest=38495, label=ns.CHEST},
    [35033660] = {quest=38487, label=ns.CHEST, note="Cave entrance @ 34.8, 34.2", path=34803420},
    [35176898] = {quest=38478, label=ns.CHEST_SM},
    [35735415] = {quest=38677, loot={140310}, label=ns.CHEST, note="On the wrecked ship"},
    [35924792] = {quest=38680, label=ns.CHEST_SM},
    [37183865] = {quest=43208, label=ns.CHEST_SM},
    [39486518] = {quest=38486, label=ns.CHEST},
    [39571934] = {quest=38498, label=ns.CHEST_SM},
    [40656852] = {quest=38475, label=ns.CHEST_SM, note="In tower; grapple to wall, then to top of tower"},
    [41744604] = {quest=38488, label=ns.CHEST_SM},
    [42336112] = {quest=38477, label=ns.CHEST_SM},
    [42473407] = {quest=43189, loot={141896}, label=ns.CHEST_GLIM, note="Entrance @ 42.2, 34.9", path=42203490},
    [42616579] = {quest=38474, label=ns.CHEST},
    [43164049] = {quest=43238, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [43708009] = {quest=43239, label=ns.CHEST_SM, note="Grapple starting by Erilar at 43.8, 80.6", path=grapple{43808060}},
    [44166997] = {quest=38489, label=ns.CHEST_SM, note="On top of the hut, grapple up"},
    [44983823] = {quest=43240, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [46606496] = {quest=38681, label=ns.CHEST_SM, note="Cave entrance @ 48.2, 65.2", path=48206520},
    [46768040] = {quest=38481, label=ns.CHEST, note=REQ_GRAPPLE},
    [47463412] = {quest=43255, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [47986237] = {quest=38738, label=ns.CHEST, note="Underwater, at base of waterfall"},
    [48137421] = {quest=38476, label=ns.CHEST_SM},
    [49085999] = {quest=43207, label=ns.CHEST_SM},
    [49694731] = {quest=38763, loot={132897}, label=ns.CHEST_GLIM, note="Guarded by Vault Keepers"},
    [49777801] = {quest=38485, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [50061816] = {quest=43195, label=ns.CHEST},
    [50314100] = {quest=38483, label=ns.CHEST_SM, note="In cave"},
    [50554125] = {quest=43246, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [52018058] = {quest=38480, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [53229314] = {quest=43190, label=ns.CHEST_SM},
    [55004716] = {quest=40095, label=ns.CHEST},
    [57946321] = {quest=40090, label=ns.CHEST_SM},
    [58044751] = {quest=40082, label=ns.CHEST_SM},
    [59305846] = {quest=40088, label=ns.CHEST},
    [60834273] = {quest=40094, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [61404440] = {quest=40093, label=ns.CHEST_SM},
    [61836289] = {quest=40089, label=ns.CHEST},
    [61933255] = {quest=38744, label=ns.CHEST_SM},
    [62667362] = {quest=40091, label=ns.CHEST_SM},
    [64293956] = {quest=43302, label=ns.CHEST_SM, path=64224161},
    [65364310] = {quest=43205, label=ns.CHEST_SM},
    [65585737] = {quest=43187, label=ns.CHEST_SM},
    [67935774] = {quest=40083, label=ns.CHEST_SM},
    [68462959] = {quest=40108, label=ns.CHEST_GLIM, note=REQ_GRAPPLE, path=grapple{68402000}},
    [68974183] = {quest=40086, label=ns.CHEST_SM, note="Tomb entrance @ 70.0, 42.6", path=69964262},
    [69144478] = {quest=38637, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [69986719] = {quest=43188, label=ns.CHEST_SM},
    [71924425] = {quest=43305, label=ns.CHEST_SM, note=REQ_GRAPPLE, path=grapple{70734281}},
    [72135489] = {quest=42628, label=ns.CHEST_SM},
    [73154570] = {quest=43194, label=ns.CHEST_SM},
    [73334150] = {quest=40085, label=ns.CHEST_SM},
    [73965223] = {quest=42632, label=ns.CHEST_SM},
    [73975858] = {quest=43237, label=ns.CHEST_SM},
    [74414182] = {quest=43306, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [75164949] = {quest=42629, label=ns.CHEST, note="On top of the mast"},
    [75676060] = {quest=43304, label=ns.CHEST_SM, note=REQ_GRAPPLE},
    [78427138] = {quest=43307, label=ns.CHEST, note="*Really* requires the Stormforged Grapple Launcher", path=grapple{75846406, note="Route *requires* taking some falling damage, I think."}},
    [81876750] = {quest=40099, label=ns.CHEST},
    [82405451] = {quest=43191, label=ns.CHEST_SM},
}, TREASURE)

ns.RegisterPoints(649, { -- Helheim in Stormheim
    [79842471] = {quest=38510, label=ns.CHEST_SM},
    [83322456] = {quest=38503, label=ns.CHEST, note="Underwater in a ship"},
    [19634698] = {quest=38516, label=ns.CHEST},
    [60845332] = {quest=38383, label=ns.CHEST_SM},
}, TREASURE)
ns.RegisterPoints(636, { -- Stormscale Cavern, Stormheim
    [20134125] = {quest=38529, label=ns.CHEST},
}, TREASURE)

-- Rares

-- Adventurer
ns.RegisterPoints(634, { -- Stormheim
    [36505250] = {quest=38472, npc=92152, criteria=33299, loot={138418}}, -- Whitewater Typhoon
    [38454305] = {quest=38626, npc=92599, criteria=33300, loot={129101}}, -- Bloodstalker Alpha
    [40657240] = {quest=38424, npc=91892, criteria=33297, loot={{129113, toy=true}}}, -- Thane Irglov the Merciless
    [41456700] = {quest=38333, npc=91529, criteria=33293, loot={129291}}, -- Glimar Ironfist
    [41753410] = {quest=40068, npc=98188, criteria=33311, loot={132898}, note="Cave under the statue's axe"}, -- Egyl the Enduring
    [44202280] = {quest=38627, npc=92604, criteria=9, loot={129264}, faction="Horde"}, -- Worgen Stalkers
    [44202281] = {quest=38630, npc=92631, criteria=9, loot={129266}, faction="Alliance"}, -- Forsaken Death Squad
    [45847741] = {quest=38431, npc=91874, criteria=33296, loot={129048}, vignette=769}, -- Bladesquall
    [46838412] = {quest=38425, npc=91803, criteria=33295, loot={129206}, vignette=765}, -- Fathnyr
    [48925054] = {quest=38774, npc=93166, criteria=33306, loot={129163}, vignette=867}, -- Tiptog the Lost / Lost Ettin
    [49547178] = {quest=38423, npc=91795, criteria=33294, loot={{129208, pet=1721}}, vignette=763}, -- Stormwing Matriarch
    [51607473] = {quest=42591, npc=107926, criteria=33315, loot={138417}, vignette=1400}, -- Hannval the Butcher
    [58004509] = {quest=38642, npc=92685, criteria=33303, loot={129123}, vignette=833}, -- Captain Brvet (Helmouth Raiders)
    [58353390] = {quest=43342, npc=110363, criteria=33316, loot={139387}}, -- Roteye
    [59806805] = {quest=39031, npc=92751, criteria=33304, loot={132895}}, -- Ivory Sentinel
    [61444316] = {quest=40081, npc=98268, criteria=33312, loot={129199}, vignette=1071}, -- Tarben
    [62056050] = {quest=39120, npc=94413, criteria=33309, loot={129133}}, -- Isel the Hammer
    [63707420] = {quest=37908, npc=90139, criteria=32404, loot={140686}}, -- Inquisitor Ernstenbok
    [64875182] = {quest=38847, npc=93401, criteria=33308, loot={129219}, vignette=879}, -- Urgev the Flayer
    [67263994] = {quest=38685, npc=92763, criteria=33305, loot={129041}, vignette=840}, -- The Nameless King
    [72494994] = {quest=38837, npc=93371, criteria=33307, loot={129035}, vignette=877}, -- Mordvigbjorn
    [73474766] = {quest=40109, npc=98421, criteria=33313, loot={138419}, vignette=1093}, -- Kottr Vondyr
    [78656117] = {quest=40113, npc=98503, criteria=33314, loot={138421}, vignette=1095}, -- Grrvrgull the Conqueror
}, {achievement=11263})
ns.RegisterPoints(649, { -- Helheim
    [28156375] = {quest=39870, npc=97630, criteria=33310, loot={{129188, pet=1753}}}, -- Soulthirster
    [85105030] = {quest=38461, npc=92040, criteria=33298, loot={129044}}, -- Fenri
}, {achievement=11263})

ns.RegisterPoints(634, { -- Stormheim
    [54802940] = {quest=42437, npc=107487, loot={130132}}, -- Starbuck
    [73906060] = {quest=43343, npc=94347, loot={130134}, faction="Alliance", vignette=1496}, -- Dread-Rider Cortis
})
ns.RegisterPoints(649, { -- Helheim
    [27204220] = {quest=46949, npc=115732, path=33154312}, -- Jorvild the Trusted
    [70001920] = {quest=42864, npc=109163, worldquest=42864}, -- Captain Dargun
})
