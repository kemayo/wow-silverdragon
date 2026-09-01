local myname, ns = ...

-- Treasures of Drustvar
ns.RegisterPoints(896, { -- Drustvar
    [33713008] = {quest=53356, criteria=41697,}, -- Web-Covered Chest
    [63306585] = {quest=53385, loot={163743}, criteria=41699, note="Left Down Up Right",}, -- Runebound Cache
    [33687173] = {quest=53387, loot={163740}, criteria=41701, note="Right Up Left Down",}, -- Runebound Coffer
    [55605181] = {quest=53472, loot={163790}, minimap=true, criteria=41703, note="Click on Witch Torch",}, -- Bespelled Chest
    [25472416] = {quest=53474, loot={163796}, minimap=true, criteria=41705, note="Click on Witch Torch",}, -- Enchanted Chest
    [25751995] = {quest=53357, criteria=41698, note="Get keys from Gorging Raven",}, -- Merchant's Chest
    [44222770] = {quest=53386, loot={163742}, criteria=41700, note="Left Right Down Up",}, -- Runebound Chest
    [18515133] = {quest=53471, loot={163789}, minimap=true, criteria=41702, note="Click on Witch Torch",}, -- Hexed Chest
    [67767367] = {quest=53473, loot={163791}, minimap=true, criteria=41704, note="Click on Witch Torch",}, -- Ensorcelled Chest
    [24304840] = {quest=53475, minimap=true, criteria=41752,}, -- Stolen Thornspeaker Cache
}, {
    achievement=12995,
})

-- Drust the Facts, Ma'am
ns.RegisterPoints(896, { -- Drustvar
    [37126380] = {criteria=41436,}, -- Drust Stele: The Circle
    [27354833] = {criteria=41438,}, -- Drust Stele: The Tree
    [27605760] = {criteria=41441,}, -- Drust Stele: Sacrifice
    [19065787] = {criteria=41443,}, -- Drust Stele: The Cycle
    [56558583] = {criteria=41446,}, -- Drust Stele: The Flayed Man
    [50777371] = {criteria=41437,}, -- Drust Stele: The Ritual
    [59396668] = {criteria=41439,}, -- Drust Stele: Breath Into Stone
    [50144232] = {criteria=41442,}, -- Drust Stele: Constructs
    [46453723] = {criteria=41445,}, -- Drust Stele: Conflict
    [44584566] = {criteria=41449,}, -- Drust Stele: Protectors of the Forest
}, {
    achievement=13064,
    atlas="reagents",
})

-- Junk
ns.RegisterPoints(896, { -- Drustvar
    [65312905] = {quest=51871,},
    [57862187] = {quest=51875,},
    [58642825] = {quest=51875,},
    [50332252] = {quest=51878,},
    [62094463] = {quest=51882,},
    [60306860] = {quest=51896,},
    [26222993] = {quest=51907,},
    -- [23181263] = {quest=5191,},
    [24223681] = {quest=51911,},
    [39326173] = {quest=51914,},
}, {
    group="junk",
    label='Small Treasure Chest',
})

-- Rares

-- Adventurer of Drustvar
ns.RegisterPoints(896, { -- Drustvar
    [59933466] = {quest=47884, npc=124548, criteria=41706,}, -- Betsy
    [58901790] = {quest=48842, npc=127333, criteria=41708,}, -- Barbthorn Queen
    [66585068] = {quest=48978, loot={154376}, npc=126621, criteria=41711,}, -- Bonesquall
    [59245526] = {quest=48981, npc=127877, criteria=41713, note="Pick one to fight; Dagger from Longfang, mail gloves from Henry",}, -- Longfang & Henry Breakwater
    [52074697] = {quest=49216, loot={163036}, npc=129904, criteria=41715,}, -- Cottontail Matron
    [65002266] = {quest=49311, npc=128973, criteria=41718,}, -- Whargarble the Ill-Tempered
    [50842040] = {quest=49388, npc=127129, criteria=41720,}, -- Grozgore
    [51352957] = {quest=49481, npc=129805, criteria=41722,}, -- Beshol
    [63414020] = {quest=49530, npc=129995, criteria=41724,}, -- Emily Mayville
    [56572924] = {quest=49602, loot={160475}, npc=130143, criteria=41726,}, -- Balethorn
    [31011831] = {quest=50546, npc=134213, criteria=41728,}, -- Executioner Blackwell
    [22934796] = {quest=50688, npc=134754, criteria=41729,}, -- Hyo'gi
    [34966921] = {quest=51383, npc=137529, criteria=41732,}, -- Arvon the Betrayed
    [43808828] = {quest=51471, npc=137825, criteria=41736,}, -- Avalanche
    [29202488] = {quest=51700, npc=138675, criteria=41742,}, -- Gorged Boar
    [24242193] = {quest=51749, npc=138866, loot={154217}, criteria=41748,}, -- Fungi Trio (quest 51887 also?)
    [30476344] = {quest=51923, npc=139322, loot={154315}, criteria=41751,}, -- Whitney "Steelclaw" Ramsay
    [66574259] = {quest=48178, npc=125453, loot={158583}, criteria=41707,}, -- Quillrat Matriarch
    [72786036] = {quest=48928, loot={160474}, npc=127651, criteria=41709,}, -- Vicemaul
    [62956938] = {quest=48979, npc=127844, criteria=41712,}, -- Gluttonous Yeti
    [43463611] = {quest=49137, criteria=41714,}, -- Ancient Sarcophagus
    [59557181] = {quest=49269, npc=128707, criteria=41717,}, -- Rimestone
    [67936683] = {quest=49341, loot={158598}, criteria=41719,}, -- Seething Cache
    [57424380] = {quest=49480, npc=129835, criteria=41721,}, -- Gorehorn
    [32204036] = {quest=49528, npc=129950, criteria=41723,}, -- Talon
    [59874478] = {quest=49601, npc=130138, criteria=41725,}, -- Nevermore
    [35483290] = {quest=50163, npc=132319, criteria=41727,}, -- Bilefang Mother
    [18746057] = {quest=50669, npc=134706, criteria=42342,}, -- Deathcap
    [28051425] = {quest=50939, npc=135796, criteria=41730,}, -- Captain Leadfist
    [29056863] = {quest=51470, npc=137824, criteria=41733,}, -- Arclight
    [23422975] = {quest=51698, npc=138618, criteria=41739,}, -- Haywire Golem
    [33245765] = {quest=51748, npc=138863, criteria=41745,}, -- Sister Martha
    [26935962] = {quest=51922, npc=139321, criteria=41750,}, -- Braedan Whitewall
}, {achievement=12941,})

-- world quest rares?
-- [20295731] = {quest=nil, npc=137665,}, -- Soul Goliath
-- [35711177] = {quest=nil, npc=138667,}, -- Blighted Monstrosity
-- [25151616] = {quest=nil, npc=139358,}, -- The Caterer
-- [34722062] = {quest=nil, npc=137704,}, -- Matron Morana
