local myname, ns = ...

ns.RegisterPoints(525, { -- FrostfireRidge
    -- garrison
    [16104980]={quest=33942, loot={ns.rewards.Currency(824)}, label="Supply Dump"},
    [21605070]={quest=34931, loot={ns.rewards.Currency(824)}, label="Pale Loot Sack"},
    [24001300]={quest=34647, loot={ns.rewards.Currency(824)}, label="Snow-Covered Strongbox"},
    [34202350]={quest=32803, loot={ns.rewards.Currency(824)}, label="Thunderlord Cache"},
    [37205920]={quest=34967, loot={ns.rewards.Currency(824)}, label="Raided Loot"},
    [43705550]={quest=34841, loot={ns.rewards.Currency(824)}, label="Forgotten Supplies"},
    [51002280]={quest=34521, loot={ns.rewards.Currency(824)}, label="Glowing Obsidian Shard", note="May be missing?"},
    [56707180]={quest=36863, loot={ns.rewards.Currency(824)}, label="Iron Horde Munitions"},
    [64702570]={quest=33946, loot={ns.rewards.Currency(824)}, label="Survivalist's Cache"},
    [66702640]={quest=33948, loot={ns.rewards.Currency(824)}, label="Goren Leftovers"},
    [68204580]={quest=33947, loot={ns.rewards.Currency(824)}, label="Grimfrost Treasure"},
    [69006910]={quest=33017, loot={ns.rewards.Currency(824)}, label="Iron Horde Supplies"},
    [74505620]={quest=34937, loot={ns.rewards.Currency(824)}, faction="Horde", label="Lady Sena's Other Materials Stash"},
    -- treasures
    [09804540]={quest=34641, loot={111407}, label="Sealed Jug"},
    [19201200]={quest=34642, loot={111408}, label="Lucky Coin"},
    [21900960]={quest=33926, loot={{108739, toy=true}}, label="Lagoon Pool"},
    [23102500]={quest=33916, loot={{108735, toy=true}}, label="Arena Master's War Horn"},
    [24202720]={quest=33501, loot={63293}, label="Spectator's Chest", note="booze, jump from the tower, entrance @ 25,30"},
    [24204860]={quest=34507, loot={110689}, label="Frozen Frostwolf Axe", note="cave at 25,51"},
    [25502040]={quest=34648, loot={111415}, label="Gnawed Bone"},
    [27604280]={quest=33500, loot={43696}, label="Slave's Stash", note="booze"},
    [30305120]={quest=33438, loot={107662}, label="Time-Warped Tower", note="loot all the frozen ogres"}, -- note: other ogres are 33497, 33439, and 33440
    [38403780]={quest=33502, loot={112087}, label="Obsidian Petroglyph"},
    [39701710]={quest=33532, loot={120945, ns.rewards.Currency(823)}, note="In the tower, behind some rocks"}, -- Cragmaul Cache
    [40902010]={quest=34473, loot={110536}, label="Envoy's Satchel"},
    [42401970]={quest=34520, loot={120341}, label="Burning Pearl"},
    [42703170]={quest=33940, loot={112187}, label="Crag-Leaper's Cache"},
    [57105210]={quest=34476, loot={111554}, label="Frozen Orc Skeleton"},
    [61804250]={quest=33511, npc=72156, loot={112110}, note="Interrupt the ritual, then feed him ogres"},
    [64406580]={quest=33505, loot={{117564, pet=1471}}, label="Wiggling Egg", note="rylak nests on the roof"},
    -- paired treasure
    [54803540]={quest=33525, npc=75072, loot={107273, 112206}, routes={{54803540, 63401480}}, atlas="VignetteLoot", note="Combine with Frostwolf First-Fang @ 63,14"}, -- Young Orc Traveler
    [63401480]={quest=33525, npc=75081, loot={107272, 112206}, route=54803540, atlas="VignetteLoot", note="Combine with Snow Hare's Foot @ 54,35"}, -- Young Orc Woman
    -- bladespire...
    [26503640]={quest=35367, loot={ns.rewards.Currency(824)}, label="Gorr'thogg's Personal Reserve"},
    [26703940]={quest=35370, loot={113189}, label="Doorog's Secret Stash"},
    [26603520]={quest=35347, loot={ns.rewards.Currency(824)}, label="Ogre Booty"},
    [27173763]={quest=35373, label="Ogre Booty", note="Gold"},
    [27283876]={quest=35570, label="Ogre Booty", note="Gold"},
    [27603382]={quest=35371, label="Ogre Booty", note="Gold"},
    [28093409]={quest=35567, loot={ns.rewards.Currency(824)}, label="Ogre Booty"},
    [28093409]={quest=35568, loot={ns.rewards.Currency(824)}, label="Ogre Booty"},
    [28093409]={quest=35569, loot={ns.rewards.Currency(824)}, label="Ogre Booty"},
    [28293440]={quest=35368, label="Ogre Booty", note="Gold"},
    [28293440]={quest=35369, label="Ogre Booty", note="Gold"},
}, {
    achievement=9728,
    hide_quest=34557,
    minimap=true,
})
-- All these Bladespire ones are available for Alliance, but Horde have to complete Moving In (33657) first
ns.RegisterPoints(526, { -- Turgall's Den: Bladespire Citadel
    [44806480]={quest=35570, label="Ogre Booty", note="Gold"},
    [48506720]={quest=35369, label="Ogre Booty", note="Gold; up some crates"},
    [53702880]={quest=35368, label="Ogre Booty", note="Gold; up some crates"},
}, {
    achievement=9728,
    hide_quest=34557,
    minimap=true,
})
ns.RegisterPoints(527, { -- Turgall's Den: Bladespite Courtyard
    [36502900]={quest=35347, loot={ns.rewards.Currency(824)}, label="Ogre Booty"},
    [37806900]={quest=35370, loot={113189}, label="Doorog's Secret Stash", note="second floor, outside"},
    [46401640]={quest=35371, label="Ogre Booty", note="Gold; up some crates; may hit an invisible ceiling, it's reachable if you work at it"},
    [51101770]={quest=35567, loot={ns.rewards.Currency(824)}, label="Ogre Booty"},
    [52605300]={quest=35373, label="Ogre Booty", note="Gold; up some crates"},
    [70806800]={quest=35569, loot={ns.rewards.Currency(824)}, label="Ogre Booty", note="In the vault"},
    [76606330]={quest=35568, loot={ns.rewards.Currency(824)}, label="Ogre Booty", note="In the vault"},
}, {
    achievement=9728,
    hide_quest=34557,
    minimap=true,
})
ns.RegisterPoints(528, { -- Turgall's Den: Bladespite Throne
    [31706640]={quest=35367, loot={113108}, label="Gorr'thogg's Personal Reserve"},
}, {
    achievement=9728,
    hide_quest=34557,
    minimap=true,
})

ns.RegisterPoints(525, { -- FrostfireRidge
    -- followers
    [39602800]=ns.follower{quest=34733, loot={ns.rewards.GarrisonFollower(32)}, note="Rescue Dagg from the other cage first, then find him outside your garrison"}, -- Dagg
    [68001900]=ns.follower{quest=34464, loot={ns.rewards.GarrisonFollower(190)}, label="Mysterious Boots", note="collect all the Mysterious items across Draenor"}, -- Archmage Vargoth
    [65906080]=ns.follower{quest=34733, loot={ns.rewards.GarrisonFollower(32)}, note="Rescue Dagg from the cage, then go to his other location"}, -- Dagg
})

-- Rares

ns.RegisterPoints(525, { -- FrostfireRidge
    [67407820]={quest=34477, npc=78621, loot={112086}}, -- Cyclonic Fury
    [41206820]={quest=34843, npc=80242, loot={111953}}, -- Chillfang
    [28206620]={quest=34470, npc=78606, loot={111666}}, -- Pale Fishmonger
    [38606300]={quest=34865, npc=80312, loot={112077}}, -- Grutush the Pillager
    [50405240]={quest=34825, npc=80190, loot={111948}}, -- Gruuk
    [76406340]={quest=34132, npc=77526, loot={112094}}, -- Scout Goreseeker
    [25405500]={quest=34129, npc=77513, loot={112066}}, -- Coldstomp the Griever
    [27405000]={quest=34497, npc=78867, loot={{111476, toy=true}}}, -- Breathless
    [40404700]={quest=33014, npc=72294, loot={111490}}, -- Cindermaw
    [66403140]={quest=33843, npc=74613, loot={111533}}, -- Broodmother Reeg'ak
    [36803400]={quest=33938, npc=76918, loot={111576}}, -- Primalist Mur'og
    [26803160]={quest=34133, npc=77527, loot={111475}}, -- The Beater
    [40402780]={quest=34559, npc=79145, loot={111477}}, -- Yaga the Scarred
    [61602640]={quest=34708, npc=79678, loot={112078}}, -- Jehil the Climber
    [34002320]={quest=32941, npc=71721, loot={101436, ns.rewards.Currency(824)}}, -- Canyon Icemother
    [54602220]={quest=32918, npc=71665, loot={111530}}, -- Giant-Slayer Kul
    [58603420]={quest=34130, npc=78151, loot={ns.rewards.Currency(824)}}, -- Huntmaster Kuang
    [54606940]={quest=34131, npc=76914, loot={111484}}, -- Coldtusk
    [71404680]={quest=33504, npc=74971, loot={107661}}, -- Firefury Giant
    [47005520]={quest=34839, npc=80235, loot={111955}}, -- Gurun
    [50201860]={quest=33531, npc=75120, loot={112096}, note="...and a peeled banana"}, -- Clumsy Cragmaul Brute
    [85005220]={quest=37556, npc=87600, loot={ns.rewards.Currency(823)}}, -- Jaluk the Pacifist
    [88605740]={quest=37525, npc=84378, loot={119365}}, -- Ak'ox the Slaughterer
    [86604880]={quest=37401, npc=84392, loot={119359}}, -- Ragore Driftstalker
    [86605180]={quest=37403, npc=84376, loot={119374}}, -- Earthshaker Holar
    [83604720]={quest=37402, npc=87622, loot={119366}}, -- Ogom the Mangler
    [87004640]={quest=37404, npc=84374, loot={119372}}, -- Kaga the Ironbender
    [70002700]={quest=37381, npc=87351, loot={119376}}, -- Mother of Goren
    [72203300]={quest=34361, npc=78265, loot={111534}}, -- The Bone Crawler
    [68801940]={quest=37382, npc=87348, loot={119415}}, -- Hoarfrost
    [72203600]={quest=37380, npc=87352, loot={119349, {119180, toy=true}}, note="Flees"}, -- Gibblette the Cowardly
    [70003600]={quest=33562, npc=72364, loot={111545, ns.rewards.Currency(824)}}, -- Gorg'ak the Lava Guzzler
    [70603900]={quest=37379, npc=87356, loot={119416, ns.rewards.Currency(823)}}, -- Vrok the Ancient
    [72402420]={quest=37378, npc=87357, loot={119416, ns.rewards.Currency(823)}}, -- Valkor
    [43600940]={quest=37384, npc=82618, loot={{119163, toy=true}, 119379}}, -- Tor'goroth
    [38201600]={quest=37383, npc=82620, loot={119399}}, -- Son of Goramal
    [45001500]={quest=37385, npc=82617, loot={119362}}, -- Slogtusk the Corpse-Eater
    [48202340]={quest=37386, npc=82616, loot={119390}}, -- Jabberjaw
    [43002100]={quest=37387, npc=82614, loot={119356}}, -- Moltnoma
    [40601240]={quest=34522, npc=79104, loot={ns.rewards.Currency(823)}}, -- Ug'lok the Frozen
    [62604220]={quest=nil, npc=72156, loot={112110}, note="Don't kill it, feed the ogres to it; it'll spit up an object to loot"}, -- Borrok the Devourer
    [13805140]={npc=81001, loot={{116794, mount=657}}}, -- Nok-Karosh
    -- probably never went live:
    -- [84404880]={ quest=nil, npc=84384, note=UNKNOWN, }, -- Taskmaster Kullah
    -- [72203000]={ quest=nil, npc=87349, note=UNKNOWN }, -- Gomtar the Agile
})
