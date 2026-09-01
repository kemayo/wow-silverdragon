local myname, ns = ...

-- ["TanaanJungleIntro"] = {},
ns.RegisterPoints(534, { -- TanaanJungle
    -- [42903490] = {quest=nil, loot={128346, ns.rewards.Currency(824)}, label="Suspiciously Glowing Chest", note="Second floor", repeatable=true},
    -- [35604620] = {quest=nil, loot={128346, ns.rewards.Currency(824)}, label="Suspiciously Glowing Chest", note="in the cave", repeatable=true},
    -- [49104660] = {quest=nil, loot={128346, ns.rewards.Currency(824)}, label="Suspiciously Glowing Chest", note="on the pile", repeatable=true},
    -- [22104980] = {quest=nil, loot={128346, ns.rewards.Currency(824)}, label="Suspiciously Glowing Chest", note="on the ridge", repeatable=true},
    -- [27506940] = {quest=nil, loot={128346, ns.rewards.Currency(824)}, repeatable=true}, -- draenic chest
    -- [21403570] = {quest=nil, loot={128346, ns.rewards.Currency(824)}, repeatable=true},
    [14905440] = {quest=38754, loot={127325}, note="In the tower, on an orc hanging from a chain"}, -- weeping wolf axe
    [15904970] = {quest=38208, loot={127324}, note="Back of cave"}, -- weathered axe
    [16005940] = {quest=38757, loot={128220}, note="Second floor of the tower"}, -- grannok's eye
    [17005300] = {quest=38283, npc=91382, loot={128346}, note="Small chest next to the body"}, -- deserter
    [17405700] = {quest=38755, loot={128346, ns.rewards.Currency(824)}, note="In the hut"}, -- spoils
    [19304100] = {quest=38320, loot={127338}, note="Bottom of the lake"}, -- blade of Kra'nak
    [22004780] = {quest=38678, loot={128346, ns.rewards.Currency(824)}, note="In the hut"}, -- warchest
    [25305030] = {quest=38735, loot={128222}, note="Top of tower, use rope to get up"}, -- enchanted spyglass
    [26506290] = {quest=38741, loot={ns.rewards.Currency(823)}, note="Top of tower, use rope to get up"}, -- bleeding hollow chest
    [26804410] = {quest=38683, loot={{127709, toy=true}}}, -- Looted Bleeding Hollow Treasure
    [28702330] = {quest=38334, loot={{127668, toy=true}}}, -- Jewel of Hellfire
    [28803460] = {quest=38863, loot={ns.rewards.Currency(823)}}, -- Partially Mined Apexis Crystal
    [30307190] = {quest=38629, loot={127389}}, -- polished crystal
    [31403110] = {quest=38732, loot={127413}}, -- Jeweled Arakkoa Effigy
    [32407040] = {quest=38426, loot={{127670, toy=true}}}, -- sargerei tome
    [33907810] = {quest=38760, loot={128346}}, -- captain booty 1
    [34407830] = {quest=38762, loot={128346}}, -- captain booty 3
    [34703464] = {quest=38742, loot={{127669, toy=true}}, note="Bottom of the cave. Watch out for fall damage."}, -- Mad Chief
    [34707710] = {quest=38761, loot={128346}}, -- captain booty 2
    [35907860] = {quest=38758, loot={ns.rewards.Currency(824)}}, -- Ironbeard's Treasure
    [36304350] = {quest=37956, loot={127397}}, -- Strange Sapphire
    [37004620] = {quest=38640, loot={ns.rewards.Currency(824)}}, -- Pale Removal Equipment
    [37808070] = {quest=38788, loot={127770}}, -- brazier
    [40607980] = {quest=38638, loot={127333}}, -- snake flute
    [40807550] = {quest=38639, loot={{127766, toy=true}}}, -- perfect blossom
    [41607330] = {quest=38657, loot={127339}}, -- forgotten champion sword
    [42803530] = {quest=38822, loot={{127859, toy=true}}, note="Top floor"},
    [43203830] = {quest=38821, loot={127348}, note="In the building"},
    [46207280] = {quest=38739, loot={128320}}, -- Mysterious Corrupted Obelisk
    [46804220] = {quest=38776, loot={127328}}, -- blade
    [46903660] = {quest=38771, loot={127347}}, -- book
    [46904440] = {quest=38773, loot={128218}}, -- fel satchel
    [47907040] = {quest=38705, loot={127329}}, -- Crystalized Essence of Elements
    [48507520] = {quest=38814, loot={127337}}, -- Looted Mystical Staff
    [49907680] = {quest=38809, loot={{128223, toy=true}}}, -- Bleeding Hollow Mushroom Stash
    [49907960] = {quest=38703, loot={127354}}, -- Scouts Belongings
    [49908120] = {quest=38702, loot={127312}}, -- Discarded Helm
    [50806490] = {quest=38731, loot={127412}}, -- overgrown relic
    [51603270] = {quest=39075, loot={ns.rewards.Currency(823)}}, -- Fel-Tainted Apexis Formation
    [51702430] = {quest=38686, loot={127341}}, -- Rune Etched Femur
    [54806930] = {quest=38593, loot={127334}, note="Climb the vine bridge, spear in the side"}, -- spear
    [54909070] = {quest=39470, loot={ns.rewards.Currency(824)}}, -- Dead Mans Chest
    [56906510] = {quest=38591, loot={127408}}, -- broken selfie sack
    [58502500] = {quest=38679, loot={115804}}, -- Jewel of the Fallen Star
    [61207580] = {quest=38601, loot={ns.rewards.Currency(824)}}, -- Blackfang Isle Cache
    [62107070] = {quest=38602, loot={128217}}, -- Crystalized Fel Spike
    [62602050] = {quest=38682, loot={127401}}, -- Censer of Torment
    [63402810] = {quest=38740, loot={{128309, pet=1690}}}, -- Forgotten Shard of the Cipher
    [64704280] = {quest=38701, loot={127396}}, -- Loose Soil
    [65908500] = {quest=39469, loot={128386}}, -- Bejeweled Egg
    [69705600] = {quest=38704, loot={ns.rewards.Currency(824)}}, -- Forgotten Iron Horde Supplies
    [73604320] = {quest=38779, note="First floor of north-east tower"}, -- Stashed Bleeding Hollow Loot
}, {
    achievement=10262,
    hide_quest=39463,
    minimap=true,
})

-- Rares
ns.RegisterPoints(534, { -- TanaanJungle
    [15006300]={quest=39288, npc=95044, criteria=28221}, -- Terrorfist
    [23004020]={quest=39287, npc=95053, criteria=28220}, -- Deathtalon
    [32407380]={quest=39290, npc=95054, criteria=28219}, -- Vengeance
    [46805260]={quest=39289, npc=95056, criteria=28218}, -- Doomroller
}, {
    achievement=10061,
    atlas="VignetteKillElite", scale=1.2,
    loot={{116658,mount=611},{116669,mount=622},{116780,mount=643},128315,128025},
})

ns.RegisterPoints(534, { -- TanaanJungle
    [37807260]={quest=38632, npc=92636, criteria=28366, note="Find it several times and it'll appear to fight"}, -- The Night Haunter
    [39007300]={quest=38631, npc=92627, criteria=28365}, -- Rendrak
    [44403740]={quest=37990, npc=90519, criteria=28338}, -- Cindral the Wildfire
    [12605660]={quest=38751, npc=92977, criteria=28350}, -- The Iron Houndmaster
    [13405640]={quest=38747, npc=91243, criteria=28347}, -- Tho'gar Gorefist
    [15005420]={quest=38746, npc=91232, criteria=28346}, -- Commander Krag'goth
    [15805700]={quest=38752, npc=93001, criteria=28349}, -- Szirek the Twisted
    [16005900]={quest=38750, npc=93057, criteria=28348}, -- Grannok
    [16804300]={quest=38034, npc=90782, criteria=28341}, -- Rasthe
    [16804820]={quest=38282, npc=91374, criteria=28329}, -- Podlord Wakkawam
    [20005360]={quest=38736, npc=93028, criteria=28369}, -- Driss Vile
    [20404980]={quest=38263, npc=90885, criteria=28352}, -- Rogond the Tracker
    [21005240]={quest=38266, npc=90936, criteria=28355}, -- Bloodhunter Zulk
    [22804880]={quest=38265, npc=90887, criteria=28353}, -- Dorg the Bloody
    [23405220]={quest=38262, npc=90884, criteria=28351}, -- Bilkor the Thrower
    [25207620]={quest=38029, npc=90438, criteria=28334}, -- Lady Oran
    [25404620]={quest=38264, npc=90888, criteria=28354}, -- Drivnul
    [25807960]={quest=38032, npc=90442, criteria=28337}, -- Mistress Thavra
    [26205420]={quest=38496, npc=92197, criteria=28356}, -- Relgor
    [26207540]={quest=38030, npc=90437, criteria=28335}, -- Jax'zor
    [27403260]={quest=37937, npc=92451, criteria=28340}, -- Varyx the Damned
    [28805100]={quest=38775, npc=93168, criteria=28372}, -- Felbore
    [30807140]={quest=38026, npc=90429, loot={{127655, toy=true}}, criteria=28333}, -- Imp-Master Valessa
    [31406740]={quest=38031, npc=90434, criteria=28336}, -- Ceraxas
    [32603540]={quest=38709, npc=92941, criteria=28368}, -- Gorabosh
    [34004420]={quest=38620, npc=92574, criteria=28362}, -- Thromma the Gutslicer
    [34407240]={quest=38654, npc=92694, criteria=28367}, -- The Goreclaw
    [34407780]={quest=38764, npc=93125, criteria=28371}, -- Glub'glok
    [35004700]={quest=38609, npc=92552, criteria=28363}, -- Belgork
    [35808020]={quest=38756, npc=93076, loot={{127659, toy=true}}, criteria=28370}, -- Captain Ironbeard
    [37003300]={quest=39045, npc=90122, criteria=28723}, -- Zoug the Heavy
    [39006840]={quest=38209, npc=91093, loot={{127652, toy=true}}, criteria=28330}, -- Bramblefell
    [39403240]={quest=39046, npc=90094, criteria=28724}, -- Harbormaster Korak
    [39606820]={quest=38825, npc=93279, criteria=28377}, -- Kris'kar the Unredeemed
    [41007860]={quest=38628, npc=92606, criteria=28364}, -- Sylissa
    [41403740]={quest=37953, npc=90024, criteria=28339}, -- Sergeant Mor'grak
    [45804700]={quest=38634, npc=92647, criteria=28726}, -- Felsmith Damorka
    [46404220]={quest=38400, npc=91695, criteria=28343}, -- Grand Warlock Nethekurse
    [48202840]={quest=38207, npc=91087, criteria=28331}, -- Zeter'el
    [48405700]={quest=38820, npc=93264, criteria=28730}, -- Captain Grok'mar
    [49207340]={quest=38597, npc=92465, criteria=28361}, -- The Blackfang
    [49603660]={quest=38411, npc=91727, criteria=28380}, -- Executor Riloth
    [49606100]={quest=38812, npc=93236, criteria=28725}, -- Shadowthrash
    [50004780]={quest=38749, npc=89675, criteria=28731}, -- Commander Org'mok
    [50807440]={quest=38696, npc=92657, criteria=28376}, -- Bleeding Hollow Horror
    [51802740]={quest=38211, npc=91098, criteria=28332}, -- Felspark
    [51808340]={quest=38605, npc=92517, criteria=28360}, -- Krell the Serene
    [52201980]={quest=38580, npc=92411, criteria=28729}, -- Overlord Ma'gruth
    [52206500]={quest=38726, npc=93002, criteria=28345}, -- Magwia
    [52404020]={quest=38430, npc=91871, criteria=28722}, -- Argosh the Destroyer
    [53402140]={quest=38557, npc=92274, criteria=28342}, -- Painmistress Selora
    [55208080]={ label="Rumble in the Jungle: Akrrilo, Rendarr, Eyepiercer",
        label="{quest:39565}",
        quest={39379,39399,39400},
        criteria={28373,28374,28375},
        note="Summon and defeat {npc:92766}, {npc:92817}, {npc:92819}",
        npc=92819,
        atlas="VignetteKillElite", scale=1.1,
    },
    [57002300]={quest=38457, npc=91009, criteria=28727}, -- Putre'thar
    [57606720]={quest=38589, npc=92429, criteria=28357}, -- Broodlord Ixkor
    [60002100]={quest=38579, npc=92408, criteria=28728}, -- Xanzith the Everlasting
    [62407240]={quest=38600, npc=92495, criteria=28358}, -- Soulslicer
    [63408100]={quest=38604, npc=92508, criteria=28359}, -- Gloomtalon
    [64603700]={quest=38700, npc=92887, criteria=28344}, -- Steelsnout
}, {
    achievement=10070,
})

ns.RegisterPoints(534, { -- TanaanJungle
    -- non-achievement:
    [40605640]={quest=40107, npc=98408, loot={129295}}, -- Fel Overseer Mudlump
    [20204120]={quest=38028, npc=90777, loot={{122117, toy=true}}}, -- High Priest Ikzan
    [22205040]={quest=39159, npc=91227, loot={{127666, toy=true}}}, -- Remnant of the Blood Moon
    [38408060]={quest=37407, npc=80398}, -- Keravnos
    [80405660]={quest=40106, npc=98284, loot={{108633, toy=true}}}, -- Gondar
    [83404340]={quest=40105, npc=98283, loot={{108631, toy=true}}}, -- Drakum
    [87605580]={quest=40104, npc=98285, loot={{108634, toy=true}}}, -- Smashum Grabb
})
