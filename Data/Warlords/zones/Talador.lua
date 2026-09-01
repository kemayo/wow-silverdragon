local myname, ns = ...

ns.RegisterPoints(535, { -- Talador
    -- treasures
    [33307670]={quest=34259, loot={ns.rewards.Currency(824)}, label="Bonechewer Remnants"},
    [35509660]={quest=34249, loot={ns.rewards.Currency(824)}, label="Farmer's Bounty"},
    [36509610]={quest=34182, loot={117567}, label="Aarko's Family Treasure"},
    [37607490]={quest=34148, loot={112371}, label="Bonechewer Spear", note="sticking out of Viperlash, cave entrance @ 36,75"},
    [38201250]={quest=34258, loot={ns.rewards.Currency(824)}, label="Light of the Sea"},
    [38408450]={quest=34257, loot={116119}, label="Treasure of Ango'rosh"},
    [39307770]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [39505520]={quest=34254, loot={117570}, label="Soulbinder's Reliquary"},
    [39807670]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [40608950]={quest=34140, loot={ns.rewards.Currency(824)}, faction="Alliance", label="Yuuri's Gift", note="You have to complete Nightmare in the Tomb first"},
    [47009170]={quest=34256, loot={116128}, label="Relic of Telmor"},
    [52502950]={quest=34235, loot={116132}, label="Luminous Shell"},
    [54002760]={quest=34290, loot={{116402, pet=1515}}, label="Ketya's Stash"},
    [54105630]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [55206680]={quest=34253, loot={116118, ns.rewards.Currency(824)}, label="Draenei Weapons"},
    [57402870]={quest=34238, loot={{116120, toy=true}}, label="Foreman's Lunchbox"},
    [58901200]={quest=33933, loot={{108743, toy=true}}, label="Deceptia's Smoldering Boots"},
    [62003240]={quest=34236, loot={116131, ns.rewards.Currency(824)}, label="Amethyl Crystal"},
    [62404800]={quest=34252, loot={110506}, label="Barrel of Fish"},
    [64607920]={quest=34251, loot={117571}, label="Iron Box"},
    [64901330]={quest=34232, loot={116117}, label="Rook's Tacklebox"},
    [65501130]={quest=34233, loot={117568}, label="Jug of Aged Ironwine", note="cave entrance to the north"},
    [65508860]={quest=34255, loot={116129}, label="Webbed Sac"},
    [65908520]={quest=34276, label="Rusted Lockbox", note="Random green"},
    [66608690]={quest=34239, loot={{117569, toy=true}}, label="Curious Deathweb Egg"},
    [68785621]={quest=34101, loot={109192}, label="Lightbearer"},
    [70100700]={quest=36937, loot={ns.rewards.Currency(823)}, label="Burning Blade Cache"},
    [70803200]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [70903550]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [72403700]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [72803560]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [73503070]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [73505140]={quest=34471, loot={116127}, label="Bright Coin"},
    [74303400]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [74602930]={quest=35162, loot={112699}, label="Teroclaw Nest"},
    [75003600]={quest=33649, npc=75644}, -- Iron Scout (not sure what's on this... wowhead is silent...)
    [75704140]={quest=34261, label="Keluu's Belongings", note="Gold"},
    [75804480]={quest=34250, loot={116128}, label="Relic of Aruuna"},
    [77005000]={quest=34248, loot={116116}, label="Charred Sword"},
    [78201480]={quest=34263, loot={117572}, label="Pure Crystal Dust", note="upper level of the mine"},
    [81803500]={quest=34260, loot={109118}, label="Aruuna Mining Cart"},
}, {
    achievement=9728,
    hide_quest=36466,
    minimap=true,
})
ns.RegisterPoints(537, { -- TombofSouls
    [67602320]={quest=34671, npc=79543, loot={112370}}, -- Shirzir
}, {
    achievement=9728,
    hide_quest=36466,
    minimap=true,
})

ns.RegisterPoints(535, { -- Talador
    [57207540]={quest=34134, loot={117563}, faction="Alliance", group="junk", note="Rescue 4 draenei trapped in spider webs, then Isaari's Cache will spawn here"},
    [61107170]={quest=34116, loot={117563}, faction="Horde", group="junk", note="Rescue 4 adventurers trapped in spider webs, then Norana's Cache will spawn here"},
    -- followers
    [45303700]=ns.follower{quest=34465, loot={ns.rewards.GarrisonFollower(190)}, label="Mysterious Hat", note="collect all the Mysterious items across Draenor"}, -- Archmage Vargoth
    [62755038]=ns.follower{quest=nil, loot={ns.rewards.GarrisonFollower(171)}, note="Complete the quests starting with Clear!"}, -- Pleasure-Bot 8000 (actually a different quest for alliance and horde)
    [57405120]=ns.follower{quest=36519, faction="Alliance", loot={ns.rewards.GarrisonFollower(207)}, note="Complete her quest"}, -- Defender Illona
    [58005300]=ns.follower{quest=36518, faction="Horde", loot={ns.rewards.GarrisonFollower(207)}, note="Complete her quest"}, -- Aeda Brightdawn
    [56802600]=ns.follower{quest=36522, loot={ns.rewards.GarrisonFollower(208)}, note="Complete his quest. Find him again outside your garrison."}, -- Ahm
}, {
    minimap=true,
})

-- Rares

ns.RegisterPoints(535, { -- Talador
    [22207400]={quest=36919, npc=85572, loot={120436}, note="In a crate"}, -- Grrbrrgle
    [31806380]={quest=34189, npc=77719, loot={{116113, toy=true}}}, -- Glimmerwing
    [34205700]={quest=34221, npc=77795, loot={{113670, toy=true}}}, -- Echo of Murmur
    [37607040]={quest=34165, npc=77620, loot={116123}}, -- Cro Fleshrender
    [41506020]={quest=34671, npc=79543, loot={112370}}, -- Shirzir
    [46005500]={quest=34145, npc=77614, loot={113288, 113287}}, -- Frenzied Golem
    [49009200]={quest=34208, npc=77784, loot={116070}}, -- Lo'marg Jawcrusher
    [50808380]={quest=35018, npc=80204, loot={112373}}, -- Felbark
    [53802580]={quest=34135, npc=77529, loot={112263}}, -- Yazheera the Incinerator
    [53909100]={quest=34668, npc=79485, loot={116110}}, -- Talonpriest Zorkra
    [56606360]={quest=35219, npc=76876, loot={{116122, toy=true}}, note="Let him summon one of three rares, who drop the toy"}, -- Kharazos the Triumphant, Galzomar, Sikthiss
    -- [56206540]={quest=35220, npc=78710, loot={{116122, toy=true}}}, -- Kharazos the Triumphant
    -- [56206540]={quest=34483, npc=78713, loot={{116122, toy=true}}}, -- Galzomar
    -- [56206540]={quest=35219, npc=78715, loot={{116122, toy=true}}}, -- Sikthiss, Maiden of Slaughter
    [59008800]={quest=34171, npc=77634, loot={116126}, note="Kill the hatchlings to summon"}, -- Taladorantula
    [59505960]={quest=34196, npc=77741, loot={116112}}, -- Ra'kahn
    [62004600]={quest=34185, npc=77715, loot={116124}}, -- Hammertooth
    [63802070]={quest=34945, npc=80524, loot={112475}, note="Enrages if you kill his pet"}, -- Underseer Bloodmane
    [66808540]={quest=34498, npc=78872, loot={{116125, toy=true}}}, -- Klikixx
    [67408060]={quest=34929, npc=80471, loot={116075}}, -- Gennadian
    [67703550]={quest=36858, npc=86549, loot={117562}}, -- Steeltusk
    [68201580]={quest=34142, npc=77561, loot={112499}}, -- Dr. Gloom
    [69603340]={quest=34205, npc=77776, loot={112261}}, -- Wandering Vindicator
    [78005040]={quest=34167, npc=77626, loot={112369}}, -- Hen-Mother Hami
    [86403040]={quest=34859, npc=79334, loot={116077}}, -- No'losh
})
ns.RegisterPoints(535, { -- Talador
    [37802140]={criteria=26579, quest=37342, npc=88494, loot={119385}}, -- Legion Vanguard
    [38001460]={criteria=26580, quest=37343, npc=82922, loot={119435, 119371}}, -- Xothear the Destroyer
    [44003800]={criteria=26465, quest=37339, npc=87597, loot={119413}}, -- Bombardier Gu'gok
    [46002740]={criteria=26470, quest=37337, npc=88071, loot={119350, ns.rewards.Currency(823)}}, -- War Council: Strategist Ankor, Archmagus Tekar, Soulbinder Naylana
    [46603520]={criteria=26469, quest=37338, npc=88043, loot={119378}}, -- Avatar of Socrethar
    [47603900]={criteria=26466, quest=37340, npc=83019, loot={119402}}, -- Gug'tol
    [48002500]={criteria=26467, quest=37312, npc=83008, loot={119403}}, -- Haakun the All-Consuming
    [50203520]={criteria=26468, quest=37341, npc=82992, loot={119386}}, -- Felfire Consort
}, {
    achievement=9633, -- Cut off the Head
})
ns.RegisterPoints(535, { -- Talador
    [31404750]={criteria=26476, quest=37344, npc=87668, loot={119375, {119170, pet=1576}}, note="5 people needed to stand on the symbols. You *can* solo it by repeatedly teleporting off the symbols and running back to activate another"}, -- Orumo the Observer
    [30502640]={criteria=26477, quest=37345, npc=82920, loot={119388}}, -- Lord Korinak
    [33803780]={criteria=26478, quest=37346, npc=82942, loot={119352}}, -- Lady Demlash
    [37203760]={criteria=26480, quest=37348, npc=82988, loot={119394}}, -- Kurlosh Doomfang
    [36804100]={criteria=26582, quest=37350, npc=88436, loot={119383}}, -- Vigilant Paarthos
    [41004200]={criteria=26479, quest=37347, npc=82930, loot={119393}}, -- Shadowflame Terrorwalker
    [39004960]={criteria=26481, quest=37349, npc=82998, loot={119353}}, -- Matron of Sin
}, {
    achievement=9638, -- Heralds of the Legion
})
