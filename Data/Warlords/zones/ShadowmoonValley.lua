local myname, ns = ...

ns.RegisterPoints(539, { -- ShadowmoonValleyDR
    -- garrison-y
    [27100260]={ quest=35280, loot={ns.rewards.Currency(824)}, label="Stolen Treasure", },
    [26500570]={ quest=34174, loot={ns.rewards.Currency(824)}, label="Fantastic Fish", },
    -- [28800710]={ quest=35279, loot={ns.rewards.Currency(824)}, label="Sunken Treasure", }, -- bugged for years
    [30301990]={ quest=35530, loot={ns.rewards.Currency(824)}, label="Lunarfall Egg", note="Moves to the garrison once built", faction="Alliance", },
    [45802460]={ quest=33570, loot={ns.rewards.Currency(824)}, label="Shadowmoon Exile Treasure", note="cave below Exile Rise", },
    [52902490]={ quest=37254, loot={ns.rewards.Currency(824)}, label="Mushroom-Covered Chest", },
    [57904530]={ quest=33568, loot={ns.rewards.Currency(824)}, label="Kaliri Egg", },
    [28303930]={ quest=33883, loot={ns.rewards.Currency(824)}, label="Shadowmoon Treasure", },
    [42106130]={ quest=33041, loot={ns.rewards.Currency(824)}, label="Iron Horde Cargo Shipment", },
    [84504470]={ quest=33885, loot={ns.rewards.Currency(824)}, label="Cargo of the Raven Queen", },
    -- treasures
    [20303060]={quest=33575, loot={108904}, label="Demonic Cache"},
    [22803390]={quest=33572, loot={113373}, label="Rotting Basket"},
    [29803750]={ quest=36879, label="Dusty Lockbox", note="On top of the standing stones; some random greens", },
    [30004530]={quest=35919, loot={113563}, label="Shadowmoon Sacrificial Dagger"},
    [31303910]={quest=33886, loot={109081}, label="Ronokk's Belongings"},
    [33503970]={quest=33569, loot={113545}, label="Reusable mana potion"},
    [34204350]={quest=33866, loot={109124}, label="Veema's Herb Bag, underground"},
    [34404620]={quest=33891, loot={108901}, label="Giant Moonwillow Cone"},
    [35904090]={quest=33540, loot={113546}, label="Uzko's Knickknacks"},
    [36704450]={quest=33573, loot={113378}, label="{item:113378:Rovo's Dagger}"},
    [36804140]={quest=33046, loot={113547}, label="Beloved's Offering", note="Offhand decoration"},
    [37202310]={quest=33613, loot={108945}, label="Bubbling Cauldron", note="In cave"},
    [37202610]={quest=35677, loot={110506}, label="Sunken Fishing Boat", note="fishy fun items"},
    [37505930]={quest=33567, loot={108903}, label="Iron Horde Tribute"},
    [37704430]={quest=33584, loot={113531}, note="Consumable: Rested XP"},
    [38504300]={quest=33614, loot={113408}, label="Greka's Urn"},
    [39208380]={quest=33566, loot={113372}, label="Waterlogged Chest"},
    [41502790]={quest=33869, loot={108902}, label="Armored Elekk Tusk"},
    [43806060]={quest=33611, loot={107650}, label="Peaceful Offering"},
    [44505920]={quest=33612, loot={107650}, label="Peaceful Offering"},
    [44506350]={quest=33384, loot={107650}, label="Peaceful Offering"},
    [45206050]={quest=33610, loot={107650}, label="Peaceful Offering"},
    [47104610]={quest=33564, loot={108900}, label="Hanging Satchel"},
    [48704750]={quest=35798, loot={109130}, label="Glowing Cave Mushroom"},
    [49303750]={quest=33867, loot={{109739, toy=true}}, label="Astrologer's Box"},
    [51107910]={quest=33574, loot={{113375, toy=true}}, label="Vindicator's Cache"},
    [52804840]={quest=35584, loot={113560}, label="Ancestral Greataxe", note="against the grave"},
    [55004500]={quest=35581, loot={109124}, label="Alchemist's Satchel"},
    [55307480]={quest=35580, loot={{117550, toy=true}}, label="Swamplighter Hive"},
    [55801990]={quest=35600, loot={{118104, pet=1538}}, label="Strange Spore", note="On top of the mushroom, go over the mountain"},
    [58902200]={quest=35603, loot={113215}, label="Mikkal's Chest", note="A sick burn from the NPC"},
    [66903350]={quest=36507, loot={116875}, label="Orc Skeleton"},
    [67108430]={quest=33565, loot={44722}, label="Scaly Rylak Egg", note="ah the memories"},
}, {
    achievement=9728,
    hide_quest=36464,
    minimap=true,
})
ns.RegisterPoints(540, { -- BloodthornCave
    [55544974]={quest=33572, loot={113373}, label="Rotting Basket"},
}, {
    achievement=9728,
    hide_quest=36464,
    minimap=true,
})

ns.RegisterPoints(539, { -- ShadowmoonValleyDR
    [51803550]={ quest=33037, label="False-Bottomed Jar", note="Gold", group="junk", },
    -- followers
    [42804040]=ns.follower{ quest=35614, loot={ns.rewards.GarrisonFollower(179)}, --[[npc=74741,]] faction="Alliance", note="Do the crystal defense event here to get him", }, -- Artificer Romuul
}, {
    minimap=true,
})

-- Rares

ns.RegisterPoints(539, { -- ShadowmoonValleyDR
    -- rares (do these count for the 'treasure hunter' achievement?)
    [21602100]={quest=33640, npc=75482, loot={108906}}, -- Veloss
    [27604360]={quest=36880, npc=86689, loot={118734}}, -- Sneevel
    [29600620]={quest=35281, npc=81406, loot={111666}}, -- Bahameye
    [29603380]={quest=33664, npc=76380, loot={113082}, note="In the cave @ 25,33"}, -- Gorum
    [29605080]={quest=37357, npc=85451, loot={119369}}, -- Malgosh Shadowkeeper
    [31905720]={quest=37359, npc=85078, loot={119392}}, -- Voidreaver Urnae
    [32203500]={quest=33039, npc=72362, loot={109061}}, -- Ku'targ the Voidseer
    [32604140]={quest=35847, npc=83385, loot={109074}}, -- Voidseer Kalurg
    [37203640]={quest=33061, npc=77140, loot={109060}}, -- Amaukwa
    [37404880]={quest=35558, npc=79524, loot={{113631, toy=true}}}, -- Hypnocroak
    [37601460]={quest=33055, npc=72537, loot={108907}}, -- Leaf-Reader Kurri
    [38607020]={quest=35523, npc=82362, loot={113559}}, -- Morva Soultwister
    [40804440]={quest=33043, npc=74206, loot={109078}}, -- Killmaw
    [41008300]={quest=35448, npc=82268, loot={113548}}, -- Darkmaster Go'vid
    [42804100]={quest=33038, npc=75434, loot={113553}}, -- Windfang Matriarch
    [43807740]={quest=33383, npc=81639, loot={117551}}, -- Brambleking Fili
    [44005760]={quest=33642, npc=75071, loot={119449}}, -- Mother Om'ra, hunter quest
    [44802080]={quest=35906, npc=77310, loot={113561}}, -- Mad King Sporeon
    [46007160]={quest=37351, npc=84911, loot={{119431, pet=1601}, ns.rewards.Currency(823)}, achievement=9437}, -- Demidos
    [48007760]={quest=37355, npc=85121, loot={119360}}, -- Lady Temptessa
    [48208100]={quest=37354, npc=85029, loot={119396}}, -- Shadowspeaker Niir
    [48602260]={quest=35553, npc=82374, loot={{113542, toy=true}}}, -- Rai'vosh, reusable slow-fall Item
    [48604360]={quest=33064, npc=77085, loot={109075}}, -- Dark Emanation
    [48806640]={quest=33389, npc=75435, loot={{113570, toy=true}}}, -- Yggdrel
    [49604200]={quest=35555, npc=82411, loot={113541}}, -- Darktalon
    [50207240]={quest=37352, npc=84925, loot={119382}}, -- Quartermaster Hershak
    [50807880]={quest=37356, npc=86213, loot={86213}}, -- Aqualir
    [51807920]={quest=37353, npc=85001, loot={85001}}, -- Master Sergeant Milgra
    [52801680]={quest=35731, npc=82326, loot={{113540, toy=true}}}, -- Ba'ruun, reusable food (no buff)
    [53005060]={quest=34068, npc=72606, loot={109077}}, -- Rockhoof
    [54607060]={quest=33643, npc=75492, loot={108957}}, -- Venomshade
    [57404840]={quest=35909, npc=83553, loot={113571}}, -- Insha'tar
    [58408680]={quest=37409, npc=85555, loot={119364}, note="in a cave @ 59,89"}, -- Nagidna
    [61005520]={quest=35732, npc=82415, loot={{113543, toy=true}}}, -- Shinri
    [61408880]={quest=37411, npc=85837, loot={119411}}, -- Slivermaw
    [61606180]={quest=35725, npc=82207, loot={113557}}, -- Faebright
    [67806380]={quest=35688, npc=82676, loot={113556}}, -- Enavra
    [68208480]={quest=37410, npc=85568, loot={119400}}, -- Avalanche
})
