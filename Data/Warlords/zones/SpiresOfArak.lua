local myname, ns = ...

ns.RegisterPoints(542, { -- SpiresOfArak
    -- archeology
    [33302730]={quest=36422, loot={ns.rewards.Currency(829)}, label="Sun-Touched Cache", note="Needs archeology"},
    [42701830]={quest=36244, loot={ns.rewards.Currency(829)}, label="Misplaced Scrolls", note="Needs archeology"},
    [43001640]={quest=36245, loot={ns.rewards.Currency(829)}, label="Relics of the Outcasts", note="Needs archeology; on top of the walls"},
    [43202720]={quest=36355, loot={ns.rewards.Currency(829)}, label="Relics of the Outcasts", note="Needs archeology; climb the ropes"},
    [46004410]={quest=36354, loot={ns.rewards.Currency(829)}, label="Relics of the Outcasts", note="Needs archeology; climb the tree, jump to the rope"},
    [51904890]={quest=36360, loot={ns.rewards.Currency(829)}, label="Relics of the Outcasts", note="Needs archeology"},
    [52404280]={quest=36416, loot={ns.rewards.Currency(829)}, label="Misplaced Scroll", note="Needs archeology; start climbing the mountain at 53.6, 47.7"},
    [56304530]={quest=36433, loot={ns.rewards.Currency(829)}, label="Smuggled Apexis Artifacts", note="Needs archeology; climb  the mushrooms up the tree"},
    [60205390]={quest=36359, loot={ns.rewards.Currency(829)}, label="Relics of the Outcasts", note="Needs archeology"},
    [67403980]={quest=36356, loot={ns.rewards.Currency(829)}, label="Relics of the Outcasts", note="Needs archeology"},
    -- shrines
    [43802470]={quest=36397, loot={115463}, note="Take to a Shrine of Terrok", repeatable=true},
    [43901500]={quest=36395, loot={115463}, note="Take to a Shrine of Terrok", repeatable=true},
    [48906250]={quest=36399, loot={115463}, note="Take to a Shrine of Terrok", repeatable=true},
    [53108450]={quest=nil, loot={115463}, note="Take to a Shrine of Terrok", repeatable=true},
    [55602200]={quest=36400, loot={115463}, note="Take to a Shrine of Terrok", repeatable=true},
    [69204330]={quest=36398, loot={115463}, note="Take to a Shrine of Terrok", repeatable=true},
    [42402670]={quest=36388, loot={118242}, label="Gift of Anzu", note="Drink Elixir of Shadow Sight"},
    [46904050]={quest=36389, loot={118238}, label="Gift of Anzu", note="Drink Elixir of Shadow Sight"},
    [48604450]={quest=36386, loot={118237}, label="Gift of Anzu", note="Drink Elixir of Shadow Sight"},
    [52001960]={quest=36392, loot={118239}, label="Gift of Anzu", note="Drink Elixir of Shadow Sight"},
    [57007900]={quest=36390, loot={118241}, label="Gift of Anzu", note="Drink Elixir of Shadow Sight"},
    [61105550]={quest=36381, loot={118240}, label="Gift of Anzu", note="Drink Elixir of Shadow Sight"},
    [48305260]={quest=36405, loot={118267}, label="Offering to the Raven Mother"},
    [48905470]={quest=36406, loot={118267}, label="Offering to the Raven Mother"},
    [51906460]={quest=36407, loot={118267}, label="Offering to the Raven Mother"},
    [53305560]={quest=36403, loot={118267}, label="Offering to the Raven Mother"},
    [61006380]={quest=36410, loot={118267}, label="Offering to the Raven Mother"},
    -- treasures
    [29504170]={quest=35334, loot={{118207, pet=1541}}, label="Egg of Varasha", note="In the cave"},
    [36801720]={quest=36243, label="Outcast's Belongings", note="Random green"},
    [50402580]={quest=36444, loot={118691}, label="Iron Horde Explosives"},
    [50702880]={quest=36247, label="Lost Herb Satchel", note="Assorted herbs"},
    [36303940]={quest=36402, loot={120337}, label="Orcish Signaling Horn"},
    [37204740]={quest=36420, loot={ns.rewards.Currency(824)}, label="Garrison Supplies"},
    [36505790]={quest=36418, loot={116914}, label="Ephial's Dark Grimoire"},
    [47803610]={quest=36411, loot={116911}, label="Lost Ring"},
    [49203730]={quest=36445, loot={116835}, label="Assassin's Spear"},
    [46903400]={quest=36446, label="Outcast's Pouch", note="Random green"},
    [47903070]={quest=36361, loot={116920}, label="Shattered Hand Lockbox"},
    [42102170]={quest=36447, label="Outcast's Belongings", note="Random green"},
    [34102750]={quest=36421, loot={ns.rewards.Currency(824)}, label="Sun-Touched Cache"},
    [68203880]={quest=36375, npc=85190, loot={118692}}, -- Sethekk Idol
    [71604850]={quest=36450, loot={109223}, label="Sethekk Ritual Brew"},
    [41805050]={quest=36451, loot={116918}, label="Garrison Workman's Hammer"},
    [56202880]={quest=36362, loot={ns.rewards.Currency(824)}, label="Shattered Hand Cache"},
    [68408900]={quest=36453, label="Coinbender's Payment", note="Gold"},
    [63606740]={quest=36454, label="Mysterious Mushrooms", note="Herbs"},
    [66505650]={quest=36455, label="Waterlogged Satchel", note="Random green"},
    [54403240]={quest=36364, loot={118695, ns.rewards.Currency(824)}, label="Toxicfang Venom"},
    [59708130]={quest=36365, loot={ns.rewards.Currency(824)}, label="Spray-O-Matic 5000 XT"},
    [60908460]={quest=36456, loot={ns.rewards.Currency(824)}, label="Shredder Parts"},
    [55509080]={quest=36366, label="Campaign Contributions", note="Gold"},
    [50502210]={quest=36246, loot={116919}, label="Hidden in the water"}, -- Fractured Sunstone
    [44401200]={quest=36377, npc=85206, loot={118693}}, -- Rukhmar's Image
    [40605500]={quest=36458, loot={116913}, label="Abandoned Mining Pick"},
    [58706030]={quest=36340, loot={116922}, label="Ogron Plunder", note="Hobbit reference!"},
    [37305070]={quest=36657, loot={116887}, note="Feed the dog 3x[Rooby Reat] from the chef downstairs"},
    [37705640]={quest=36462, loot={116020}, note="Unlocks a chest in Admiral Taylor's Garrison Town Hall @ 36.2,54.4"},
    [59109060]={quest=36366, loot={116917}, note="In the control room"}, -- Sailor Zazzuk's 180-Proof Rum
}, {
    achievement=9728,
    hide_quest=36467,
    minimap=true,
})

ns.RegisterPoints(542, { -- SpiresOfArak
    -- followers
    [55306850]=ns.follower{quest=37168, loot={ns.rewards.GarrisonFollower(219)}, note="Follow the trail up the hill to 54.9,65.4, find him in the cave"}, -- Leorajh
}, {
    minimap=true,
})

-- Rares

ns.RegisterPoints(542, { -- SpiresOfArak
    [25202420]={quest=36943, npc=86978, loot={118696, ns.rewards.Currency(824)}}, -- Gaze, not certain about item-drop
    [29404140]={quest=35334, npc=82050, loot={{118207, pet=1541}}}, -- Varasha
    [33005900]={quest=36305, npc=84951, loot={116836}}, -- Gobblefin
    [33402200]={quest=36265, npc=84805, loot={116858}}, -- Stonespite
    [36003900]={quest=37464, npc=83746, loot={{116771, mount=634}}}, -- Rukhmar
    [36405240]={quest=36129, npc=82247, loot={116837}}, -- Nas Dunberlin
    [38402780]={quest=36470, npc=85504, loot={{118107, pet=1540}}}, -- Rotcap
    [46402860]={quest=36267, npc=84807, loot={118198}}, -- Durkath Steelmaw
    [46802300]={quest=35599, npc=80614, loot={116839}}, -- Blade-Dancer Aeryx
    [51800720]={quest=37394, npc=83990, loot={119407}}, -- Solar Magnifier
    [52003540]={quest=36478, npc=79938, loot={118201}}, -- Shadowbark
    [52805480]={quest=36472, npc=85520, loot={116857}}, -- Swarmleaf
    [53208900]={quest=36396, npc=84417, loot={118206}}, -- Mutafen
    [54606320]={quest=36278, npc=84836, loot={116838}}, -- Talonbreaker
    [54803960]={quest=36297, npc=84890, loot={118200}}, -- Festerbloom
    [56609460]={quest=36306, npc=84955, loot={118202}}, -- Jiasska the Sporegorger
    [57407400]={quest=36254, npc=84775, loot={116852}}, -- Tesska the Broken
    [58208460]={quest=36291, npc=84887, loot={116907}}, -- Betsi Boombasket
    [58604520]={quest=36298, npc=84912, loot={116855}}, -- Sunderthorn
    [59201500]={quest=36887, npc=86724, loot={118279}}, -- Hermit Palefur
    [59403740]={quest=36279, npc=84838, loot={118199}}, -- Poisonmaster Bortusk
    [62603740]={quest=36268, npc=84810, loot={118735}}, -- Kalos the Bloodbathed
    [64006480]={quest=36283, npc=84856, loot={118205}}, -- Blightglow
    [66005500]={quest=36288, npc=84872, loot={118204}}, -- Oskiira the Vengeful
    [69004880]={quest=36276, npc=84833, loot={118203}}, -- Sangrikrass
    [69005400]={quest=37406, npc=80372, note="No loot"}, -- Echidna
    [70402380]={quest=37361, npc=85037, loot={119354}}, -- Kenos the Unraveler
    [71203380]={quest=37392, npc=87027, loot={119363}, achievement=9601}, -- Shadow Hulk
    [71404500]={quest=37393, npc=87029, loot={119401}, achievement=9601}, -- Giga Sentinel
    [72001980]={quest=37360, npc=85036, loot={119373}}, -- Formless Nightmare
    [72401940]={quest=37358, npc=85026, loot={{119178, toy=true}}}, -- Soul-Twister Torek
    [73003180]={quest=37359, npc=85078, loot={119392}}, -- Voidreaver Urnae
    [73404500]={quest=37493, npc=86621, achievement=9601, note="No loot"}, -- Morphed Sentient
    [73803820]={quest=37391, npc=87026, loot={119398}, achievement=9601}, -- Mecha Plunderer
    [74404280]={quest=37390, npc=87019, loot={119404}, achievement=9601}, -- Glutonous Giant
})
