local myname, ns = ...

-- Zone, faction and currency ids, plus the conditions built from them. Kept
-- in their own file so SilverDragon can pull it in verbatim alongside the zone
-- data; plugin setup (profile defaults, groups) stays in the main file.

ns.VALDRAKKEN = 2112
ns.WAKINGSHORES = 2022
ns.OHNAHRANPLAINS = 2023
ns.AZURESPAN = 2024
ns.THALDRASZUS = 2025
ns.FORBIDDENREACH = 2151 -- was 2026 before 10.0.7 (but was also unreachable)
ns.FORBIDDENREACHINTRO = 2118 -- Dracthyr
ns.PRIMALISTFUTURE = 2085
ns.ZARALEKCAVERN = 2133
ns.EMERALDDREAM = 2200
ns.AMIRDRASSIL = 2239

ns.FACTION_MARUUK = 2503
ns.FACTION_DRAGONSCALE = 2507
ns.FACTION_VALDRAKKEN = 2510
ns.FACTION_ISKAARA = 2511
ns.FACTION_LOAMM = 2564
ns.FACTION_DREAMWARDENS = 2574

ns.CURRENCY_MARUUK = 2108 -- renown: 2002
ns.CURRENCY_DRAGONSCALE = 2031 -- renown: 2021
ns.CURRENCY_VALDRAKKEN = 2106 -- renown: 2088
ns.CURRENCY_ISKAARA = 2109 -- renown: 2087
ns.CURRENCY_LOAMM = 2420 -- renown: 2402
ns.CURRENCY_DREAMWARDENS = 2652 -- renown: 2653

-- 67030 completes alongside 66221 (moving on) and 72366; it's then also completed on any alts, unlike the others
-- (It's what's in the vignettes as a condition for visibility)
ns.MAXLEVEL = {ns.conditions.QuestComplete(67030), ns.conditions.Level(70)}
ns.DRAGONRIDING = ns.conditions.SpellKnown(376777)

ns.PROF_DF_ALCHEMY = 2823 -- spell: 366261
ns.PROF_DF_BLACKSMITHING = 2822 -- spell: 365677
ns.PROF_DF_COOKING = 2824
ns.PROF_DF_ENCHANTING = 2825 -- spell: 366255
ns.PROF_DF_ENGINEERING = 2827 -- spell: 366254
ns.PROF_DF_FISHING = 2826
ns.PROF_DF_HERBALISM = 2832
ns.PROF_DF_INSCRIPTION = 2828 -- spell: 366251
ns.PROF_DF_JEWELCRAFTING = 2829 -- spell: 366250
ns.PROF_DF_LEATHERWORKING = 2830 -- spell: 366249
ns.PROF_DF_MINING = 2833
ns.PROF_DF_SKINNING = 2834
ns.PROF_DF_TAILORING = 2831 -- spell: 366258
