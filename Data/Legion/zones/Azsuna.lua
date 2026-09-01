local myname, ns = ...

local TREASURE = {
    achievement=11256,
    requires=ns.conditions.AuraInactive(182958),
}

ns.RegisterPoints(630, { -- Azsuna
    [26254713] = {quest=44105, label=ns.CHEST_SM},
    [34583556] = {quest=44102, label=ns.CHEST_SM},
    [40575767] = {quest=38316, label=ns.CHEST},
    [41393075] = {quest=42292, label=ns.CHEST},
    [42600810] = {quest=38367, label=ns.CHEST_GLIM},
    [43402243] = {quest=42297, label=ns.CHEST_GLIM},
    [44473946] = {quest=37713, label=ns.CHEST_SM},
    [47860773] = {quest=42295, label=ns.CHEST_SM},
    [49384536] = {quest=37828, loot={122681}, label=ns.CHEST},
    [49415800] = {quest=38370, loot={141882}, label=ns.CHEST},
    [49653448] = {quest=37831, label=ns.CHEST_SM},
    [50215029] = {quest=42290, label=ns.CHEST_SM},
    [51502430] = {quest=42289, label=ns.CHEST, note="Leyhollow cave entrance @ 47.8, 23.7", path=47802370},
    [52004210] = {quest=42281, label=ns.CHEST_SM},
    [52842059] = {quest=42339, label=ns.CHEST, note="Cave entrance @ 53.9, 22.4; don't wake up the bears", path=53902240},
    [53033726] = {quest=37596, label=ns.CHEST_SM},
    [53176444] = {quest=37829, label=ns.CHEST},
    [53504545] = {quest=42283, label=ns.CHEST_SM},
    [53611813] = {quest=44104, label=ns.CHEST_SM},
    [53684396] = {quest=42282, label=ns.CHEST_SM},
    [53834053] = {quest=42284, label=ns.CHEST_SM, note="Inside the Academy"},
    [54313633] = {quest=42287, label=ns.CHEST_SM},
    [54403490] = {quest=42285, label=ns.CHEST_SM, note="Inside the Academy"},
    [54875214] = {quest=44405, label=ns.CHEST_SM},
    [55310505] = {quest=38389, label=ns.CHEST_SM},
    [55362774] = {quest=42288, label=ns.CHEST_SM},
    [55621855] = {quest=40711, label=ns.CHEST, note="Ley Portal inside tower"},
    [55855699] = {quest=38365, label="Disputed Treasure", vignette=753},
    [56443481] = {quest=38251, loot={132950}, label=ns.CHEST},
    [56892499] = {quest=42338, label=ns.CHEST_SM, note="Cave entrance @ 55.7, 25.4", path=55702540},
    [57153106] = {quest=38419, label=ns.CHEST},
    [57901220] = {quest=37958, label=ns.CHEST},
    [58364378] = {quest=37830, label=ns.CHEST_GLIM},
    [58381229] = {quest=37980, label=ns.CHEST, note="Ley Portal @ 58.7, 14.1", path={58701410, label="Ley Portal", atlas="MagePortalAlliance"}},
    [58645340] = {quest=40752, label=ns.CHEST_SM},
    [59876316] = {quest=42272, label=ns.CHEST_SM},
    [62405840] = {quest=42273, label=ns.CHEST_SM},
    [62814479] = {quest=42294, label=ns.CHEST_SM},
    [63005420] = {quest=42278, label=ns.CHEST_SM, note="Cave entrance @ 64.0, 52.9", path=64005290},
    [63231521] = {quest=37832, label=ns.CHEST},
    [63653919] = {quest=42293, label=ns.CHEST_SM},
    [65066978] = {quest=38239, loot={129070}, label="Seemingly Unguarded Treasure", note="Seemingly..."},
    [65462961] = {quest=42958, label=ns.CHEST_SM},
    [66064345] = {quest=40751, label=ns.CHEST_SM},
    [68872973] = {quest=44103, label=ns.CHEST_SM, note="Underwater cave, entrance is on east side of cliff"},
}, TREASURE)

ns.RegisterPoints(631, { -- NarthalasAcademy, Azsuna
    [62458451] = {quest=42284, label=ns.CHEST_SM},
    [71212211] = {quest=42285, label=ns.CHEST_SM, note="Door opens after you finish nearby quests"},
}, TREASURE)

ns.RegisterPoints(632, { -- OceanusCove, Azsuna
    [69294839] = {quest=37649, label=ns.CHEST_GLIM},
    [45346686] = {quest=42291, label=ns.CHEST_SM},
}, TREASURE)

-- Rares

-- Adventurer
ns.RegisterPoints(630, { -- Azsuna
    [28205200] = {quest=42376, npc=107269, criteria=33374, loot={141874}}, -- Inquisitor Tivos
    [32362981] = {quest=38238, npc=91187, criteria=33268, loot={129067}, vignette=723, note="Patrols the beach"}, -- Beacher
    [32604880] = {quest=44108, npc=109504, criteria=33271, loot={129075}}, -- Ragemaw
    [34953390] = {quest=42505, npc=107657, criteria=33372, loot={141868}, note="Walks around the pool"}, -- Arcanist Shal'iman
    [35305030] = {quest=38037, npc=90803, criteria=33264, loot={129083}, note="Cache of Infernals"}, -- Infernal Lord
    [37284321] = {quest=42280, npc=107113, criteria=33374, loot={141875}, worldquest=43614, vignette=1337}, -- Vorthax
    [41004181] = {quest=37537, npc=89016, criteria=33377, loot={129080}, vignette=636}, -- Ravyn-Drath
    [43152815] = {quest=38352, npc=91579, criteria=32402, loot={129056}}, -- Doomlord Kazrok
    [43532458] = {quest=42069, npc=105938, criteria=32401, loot={129087}}, -- Felwing
    [45215783] = {quest=37824, npc=89884, criteria=33258, loot={129090}, vignette=682}, -- Flog the Captain-Eater
    [47463445] = {quest=37726, npc=89650, criteria=33248, loot={129082}, vignette=677}, -- Valiyaka the Stormbringer
    [49275532] = {quest=37909, npc=90164, criteria=33260, loot={129069}, vignette=692, note="Patrols the road"}, -- Warbringer Mox'na (seek and destroy squad)
    [49500880] = {quest=37928, npc=90217, criteria=33261, loot={129061}}, -- Normantis the Deposed
    [50003440] = {quest=37823, npc=89865, criteria=33257, loot={129072}}, -- Mrrgrl the Tidereaver
    [50803160] = {quest=37869, npc=90057, criteria=33259, loot={129084}}, -- Daggerbeak
    [53404400] = {quest=37821, npc=89846, criteria=33250, loot={129066}}, -- Captain Volo'ren
    [55104590] = {quest=42450, npc=107127, criteria=33270, loot={129086}}, -- Brawlgoth
    [56102905] = {quest=38061, npc=90901, criteria=33265, loot={138395}}, -- Pridelord Meowl
    [59304630] = {quest=38212, npc=91100, criteria=32403, loot={129068}, note="Top of the mountain"}, -- Brogozog
    [59601230] = {quest=37932, npc=90244, criteria=33262, loot={129085}, note="Unbound rift"}, -- Arcavellus
    [59695516] = {quest=37822, npc=89850, criteria=33251, loot={129065,136833}, vignette=680}, -- The Oracle
    [61306203] = {quest=38217, npc=91113, criteria=33267, loot={129062}, vignette=721}, -- Tide Behemoth
    [65164000] = {quest=37820, npc=89816, criteria=33249, loot={129091}, note="Horn of the Siren"}, -- Golza the Iron Fin
    [65655691] = {quest=42221, npc=106990, criteria=33269, loot={129073}, vignette=1326}, -- Chief Bitterbrine
    [67105140] = {quest=37989, npc=90505, criteria=33263, loot={129064}}, -- Syphonus
    [50515204] = { label="Trecherous Stallions",
        quest=44081, npc=112636, criteria=33272, loot={140685}, vignette=1623,
        note="Ley Portal @ 60.3, 46.3; kill the stallions",
        path={60304630, label="Ley Portal", atlas="MagePortalAlliance"},
    },
}, {
    achievement=11261
})

ns.RegisterPoints(630, { -- Azsuna
    [29255365] = {quest=42417, npc=107327, loot={129079}}, -- Bilebrain
    [30784800] = {quest=42286, npc=107136, loot={141873}}, -- Houndmaster Stroxis
    [33404120] = {quest=44670, npc=107105, loot={141869}}, -- Broodmother Lizax
    [52402305] = {quest=38268, npc=91289, loot={129063}}, -- Cailyn Paledoom
    [55476980] = {quest=42699, npc=108255, loot={141877}}, -- Coura, Mistress of Arcana
    [58517882] = {quest=44671, npc=108136, loot={129081}}, -- The Muscle
    [28204860] = {quest=45495, npc=109630, loot={144244}, worldquest=43079}, -- Immolian
})
ns.RegisterPoints(633, { -- TempleofaThousandLights
    [62303090] = {quest=42699, npc=108255, loot={141877}}, -- Coura, Mistress of Arcana
})

-- The Long Forgotten Hippogriff

local EPHEMERAL = {
    label="Ephemeral Crystal",
    loot={{138258, mount=802}}, -- Reins of the Long-Forgotten Hippogryph
    note="|cFFFFFF00Use five of these before anyone else, without leaving the zone or dying, and you'll get the {item:138258:Reins of the Long-Forgotten Hippogryph}|r",
    texture=ns.atlas_texture("islands-azeritechest", {r=1, g=0, b=0.5}),
    minimap=true,
    group="hippogryph",
}

ns.RegisterPoints(630, {
    -- PurgatoryWolf's comment on wowhead:
    -- https://www.wowhead.com/item=138258/reins-of-the-long-forgotten-hippogryph#comments:id=2453258
    [29902655] = {note="On island"},
    [30302395] = {note="In the cave"},
    [29853587] = {note="Between some dead trees"},
    [34911715] = {note="Behind the ruins"},
    [34803530] = {note="On cliff edge"},
    [34603570] = {note="In cave at the base of the hill"},
    [35002200] = {note="Near the water"},
    [35722507] = {note="Beside the tree with the lantern and fence, to the left of the path"},
    [36601220] = {note="In the open"},
    [36002300] = {note="Between two trees on the road"},
    [35603780] = {note="By a tree"},
    [36003600] = {note="On cliff edge"},
    [37002175] = {note="By a tree"},
    [37503290] = {note="Behind a wall next to a bush and tree"},
    [38690931] = {note="On grass next to bush"},
    [40303280] = {note="Next to tree"},
    [40553760] = {note="In the middle of the road, by a tree"},
    [40723590] = {note="Next to tree"},
    [41403100] = {note="In Llothien Grizzly Cave, to the right"},
    [41503100] = {note="In the cave"},
    [42200850] = {note="On the hillside"},
    [42661806] = {note="Inside Runa’s Hovel Cave, on rock between spine and skull"},
    [42206230] = {note="On the hill near the Cove Skrog"},
    [43002889] = {note="Behind tree, next to Doomlord Kazrok"},
    [44105980] = {note="On the small hill next to the ship"},
    [45501720] = {note="Next to the lake, where the river begins"},
    [45424542] = {note="Next to a tree"},
    [45005360] = {note="On the coast, in the broken half of a ship"},
    [46550536] = {},
    [46560853] = {note="Next to a tree"},
    [46901775] = {note="At the top of the slope"},
    [46904900] = {note="On hill, above the neutral giants, behind a tree"},
    [46585360] = {note="Between some rocks, by the sleeping bears"},
    [47102580] = {note="Next to the blue crystal lake"},
    [47203300] = {note="Next to the river"},
    [47306190] = {note="Between two rocks"},
    [48884561] = {note="On a rock"},
    [48004800] = {note="Next to the two neutral giants at the bottom of the valley"},
    [48055270] = {note="In the cave next to some piles of gold"},
    [48575728] = {note="In Oceanus Cove, inside a shipwreck"},
    [49000800] = {note="On a little rock in Lair of the Deposed"},
    [49402400] = {note="In bushes, behind the shrine"},
    [49392770] = {note="Next to a tree"},
    [49303150] = {note="Behind a bush"},
    [49305055] = {note="Behind the sleeping giant"},
    [49185354] = {note="On a cliff above the bridge"},
    [49675535] = {note="In Oceanus Cove, next to piles of gold"},
    [49285803] = {note="By the broken pillar right next to the bride and groom"},
    [50501640] = {note="Between three trees"},
    [50502030] = {note="Inside Layhallow cave @ 47.9, 24.8"},
    [50003310] = {note="Next to shells and hut"},
    [50734989] = {note="In the cave at Shipwreck Arena"},
    [50485699] = {note="In the cave, close to eternal bride and groom"},
    [51403760] = {note="Underwater, near to Mrrgrl"},
    [51006500] = {note="Next to the rope tied around the poles"},
    [51007500] = {note="In a cave by the roots"},
    [51805760] = {note="In Oceanus Cove, next to broken ship"},
    [52401340] = {note="Next to a tree"},
    [52292510] = {note="Off road, next to a tree"},
    [52153185] = {note="By the shrine"},
    [52963594] = {note="Underwater next to Narthalas Academy"},
    [52705790] = {note="Up on the hill"},
    [52007100] = {note="On a rock by the water"},
    [53362608] = {note="Between the three trees"},
    [53702805] = {note="In a cave by the river"},
    [53083603] = {},
    [53616336] = {note="By the torch in the alcove"},
    [54332603] = {note="Next to tree roots"},
    [54102760] = {note="Behind the hut, in the bushes"},
    [54802800] = {note="Behind the tree"},
    [54503350] = {note="In the lake, next to basilisks"},
    [54855225] = {note="In the cave with Cole"},
    [55551030] = {note="Up the side of the cliff"},
    [55902940] = {note="Inside the three pillars"},
    [55563272] = {note="Bottom of the cliff, by a tree"},
    [55005500] = {note="Bottom of hill"},
    [55984282] = {},
    [56001200] = {note="By the pink flower"},
    [56903884] = {note="At the shore"},
    [56922600] = {note="In the cave, entrance @ 55.74, 25.46"},
    [56004000] = {note="Under the bridge"},
    [57401679] = {},
    [57502660] = {note="By the road"},
    [57003100] = {note="In the middle of a circle"},
    [57694231] = {note="In cave with a big giant"},
    [58222465] = {note="At the top of the cliff"},
    [58814502] = {note="In cave with Commander Eksis, on rock between spine and skull"},
    [59752784] = {note="Behind a tree"},
    [59703770] = {},
    [59063748] = {note="Near the statue"},
    [59303830] = {note="Behind a naga tent"},
    [60001700] = {note="By a tree"},
    [60103500] = {note="Next to a broken pillar"},
    [60205460] = {note="Near shadowfiends under a small tent"},
    [60404670] = {},
    [60004900] = {},
    [60105320] = {},
    [61103040] = {note="In a cave, on the rock to the right"},
    [61903090] = {note="Behind a tree"},
    [61604010] = {},
    [62253590] = {note="By trees"},
    [62304050] = {note="By a naga tent"},
    [62655246] = {note="By a tree"},
    [62205470] = {note="By a tree"},
    [63384614] = {note="Under a tree"},
    [63485400] = {note="In Gloombound Barrow, @ 63.48, 54.00"},
    [64003400] = {note="Near the table in The Empyrean Society Enclave"},
    [64003900] = {},
    [65402950] = {note="Inside big tree stump"},
    [65403840] = {},
    [65504240] = {note="By the shore"},
    [65155082] = {note="Under a tree"},
    [67703280] = {},
    [67003370] = {note="By pillars"},
    [67004600] = {note="By a log"},
    [67105200] = {note="Outside entrance to the Ruined Sanctum"},
    [68202430] = {},
}, EPHEMERAL)

ns.RegisterPoints(632, { -- Oceanus Cove
    [45833076] = {note="Next to piles of gold"},
    [50897734] = {note="Inside the shipwreck"},
    [81138155] = {note="By the shipwreck"},
}, EPHEMERAL)

