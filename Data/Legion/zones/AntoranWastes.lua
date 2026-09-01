local myname, ns = ...

ns.RegisterPoints(885, { -- Antoran Wastes
    [49135934] = {quest=49020, criteria=37698, note="Behind the waterfall"}, -- Legion Treasure Hoard
    [52102720] = {quest=49019, criteria=37697, note="Requires Light's Judgement"}, -- Fel-Bound Chest
    [57426367] = {quest=49159, criteria=37960, vignette=2327, note="Requires Shroud of Arcane Echoes"}, -- Missing Augari Chest
    [58775895] = {quest=49017, criteria=37695, note="Requires Lightforged Warframe", path=58906140, minimap=true}, -- Forgotten Legion Supplies (49022 for opening)
    [65903980] = {quest=49018, criteria=37696, note="Requires Light's Judgement"}, -- Ancient Legion War Cache
    [75705260] = {quest=49021, criteria=37699}, -- Timeworn Fel Chest
}, {
    achievement=12074,
    atlas="VignetteLootElite", scale=1.2,
})

-- Junk:
ns.RegisterPoints(885, { -- Antoran Wastes
    [57806496] = {quest=48382, vignette=2137},
    [60897052] = {quest=48382},
    [62106933] = {quest=48382},
    [64475836] = {quest=48382},
    [67516988] = {quest=48382},
    [69406320] = {quest=48382},

    [51693779] = {quest=48383},
    [53763556] = {quest=48383, vignette=2138},
    [55103930] = {quest=48383},
    [56393555] = {quest=48383},
    [58403090] = {quest=48383},
    [59883581] = {quest=48383},

    [59101940] = {quest=48384},
    [63702569] = {quest=48384, vignette=2139},
    [66581711] = {quest=48384},
    [64062748] = {quest=48384},

    [55544742] = {quest=48385, vignette=2140},
    [55925384] = {quest=48385},
    [57735890] = {quest=48385},
    [48225455] = {quest=48385},

    [72404210] = {quest=48387},
    [65522830] = {quest=48387, vignette=2143},
    [66603641] = {quest=48387},
    [68993348] = {quest=48387, vignette=2143},
    [69503966] = {quest=48387},

    [55991401] = {quest=48388},
    [59581389] = {quest=48388},
    [55402040] = {quest=48388},
    [54202800] = {quest=48388},

    [60344695] = {quest=48389},
    [60684104] = {quest=48389},
    [62965008] = {quest=48389, vignette=2152},
    [64315036] = {quest=48389, note="In the cave"},
    [65225180] = {quest=48389, note="In the cave"},
    [65484091] = {quest=48389},

    [73306850] = {quest=48390},
    [76465651] = {quest=48390}, -- Verify me...
    [76565823] = {quest=48390},
    [77955619] = {quest=48390, vignette=2144},

    [63075799] = {quest=48391, note="In the cave"},
    [65215506] = {quest=48391, vignette=2150},
    [65224956] = {quest=48391},
    [68005070] = {quest=48391},
    [69785509] = {quest=48391},
    [71205442] = {quest=48391},

    [52102721] = {quest=49019},
    [65204060] = {quest=49018, note="Requires Light's Judgement to be equipped in the Vindicaar Matrix. Blow the pile of ruble with the ability"},
}, {
    label="Legion War Supplies",
    group="junk",
    scale=0.9,
})

-- Rares

ns.RegisterPoints(885, { -- Antoran Wastes
    [50905530] = {quest=48820, npc=127118, criteria=37605, loot={153312}, worldquest=48834, vignette=2276}, -- Worldsplitter Skuul
    [52702950] = {quest=48822, npc=127291, criteria=37613}, -- Watcher Aival
    [53103580] = {quest=48810, npc=126199, criteria=37649, loot={{152903, mount=981}}, worldquest=48465}, -- Vrax'thul
    [54003800] = {quest=48966, npc=127581, criteria=37660, loot={{153195, pet=2136}}, note="Gather bones in Scavenger's Boneyard"}, -- The Many-Faced Devourer
    [55702190] = {quest=48824, npc=127300, criteria=37614, loot={153319}, worldquest=48866}, -- Void Warden Valsuran
    [56204550] = {quest=49241, npc=122999, criteria=37656, worldquest=47566}, -- Gar'zoth
    [57353355] = {quest=49240, npc=122947, criteria=37658, loot={153327}, worldquest=47552, vignette=2345}, -- Mistress Il'thendra
    [58001200] = {quest=48968, npc=127703, criteria=37663, loot={{153194, toy=true}}, note="3 people on the runes to summon; don't interrupt Doom Star"}, -- Doomcaster Suprax
    [60644840] = {quest=48815, npc=126946, criteria=37608, loot={151543}, vignette=2271}, -- Inquisitor Vethroz
    [60902290] = {quest=48865, npc=127376, criteria=37606, worldquest=48867}, -- Chief Alchemist Munculus
    [61703720] = {quest=49183, npc=122958, criteria=37657, loot={{152905, mount=979}}}, -- Blistermaw
    [61906430] = {quest=48814, npc=126338, criteria=37616, loot={{153126,toy=true}}}, -- Wrath-Lord Yarez
    [62405380] = {quest=48813, npc=126254, criteria=37612, worldquest=48828}, -- Lieutenant Xakaar
    [63102520] = {quest=48821, npc=127288, criteria=37615, loot={{152790, mount=955}}, worldquest=48835}, -- Houndmaster Kerrax
    [63035735] = {quest=48811, npc=126115, criteria=37648, worldquest=48466, vignette=2266, note="The entrance to the cave is north east from her in the spider area at 66, 54.1"}, -- Ven'orn
    [63902090] = {quest=48809, npc=126040, criteria=37647, loot={{152903, mount=981}}, note="Entrance to the cave is south east - use the eastern bridge to get there."}, -- Puscilla
    [64304820] = {quest=48812, npc=126208, criteria=37607, loot={153190}, worldquest=48827}, -- Varga
    [66981777] = {quest=48970, npc=127705, criteria=37665, loot={{153252, pet=2135}}, note="Summon with imp meat"}, -- Mother Rosula
    [73207080] = {quest=48817, npc=127090, criteria=37611, loot={153324}, worldquest=48832}, -- Admiral Rel'var
    [75605650] = {quest=48818, npc=127096, criteria=37609}, -- All-Seer Xanarian
    [82656580] = {quest=48816, npc=127084, criteria=37610, note="Use the portal slightly west from him at 80, 62.4"}, -- Commander Texlaz
    [84408100] = { label="Squadron Commander Vishax",
        quest=48967,
        npc=127700,
        criteria=37662,
        loot={
            {153253,toy=true,}, -- S.F.E. Interceptor
        },
        note="Get {item:152890:Smashed Portal Generator} from {npc:127598:Immortal Netherwalker}. Once you have it you can get {item:152941:Conductive Sheath}, {item:152940:Arc Circuit}, and {item:152891:Power Cell} from {npc:127597:Eredar War-Mind} and {npc:127596:Felsworn Myrmidon} on the docks. Combine them, then use the portal.",
        active={
            ns.conditions.QuestComplete(48984), -- hidden quest for completing the portal generator, 49007 is for actually activating it
            ns.conditions.Item(152965),
            any=true
        },
        path={
            77407490,
            label="Portal to {npc:127700:Squadron Commander Vishax}",
            atlas="mageportalalliance",
        }
    },
}, {
    achievement=12078,
})

ns.RegisterPoints(885, { -- Antoran Wastes
    [65408140] = { label="Rezira the Seer",
        quest=nil,
        npc=127706,
        loot={
            {153293,toy=true,}, -- Sightless Eye
        },
        active=ns.conditions.Item(153226),
        note="Use {item:153226:Observer's Locus Resonator} bought from {npc:128134:Orix the All-Seer} to reach here",
    },
    [60204540] = {
        label="{npc:128134:Orix the All-Seer}",
        loot={
            {153204, toy=true, note="1000x"}, -- All-Seer's Eye
            {153026, pet=2115, note="1000x"}, -- Cross Gazer
            {153226, note="500x"}, -- Observer's Locus Resonator
        },
        note="Become an agent of Orix to loot {item:153021:Intact Demon Eye}, which can be used to buy things from Orix",
        atlas="vehicle-templeofkotmogu-cyanball",
    },
})
