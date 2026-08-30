local myname, ns = ...

ns.RegisterPoints(ns.SILVERMOONCITY, {
	[41726638] = {
		label="{npc:259722:Andra}",
		loot={
			{265024, set=5569}, -- Ensemble: Augur's Azure Garments
			{265022, set=5570}, -- Ensemble: Augur's Crimson Garments
			{265026, set=5568}, -- Ensemble: Augur's Lucent Garments
			{265025, set=5571}, -- Ensemble: Augur's Umbral Garments
			{265023, set=5567}, -- Ensemble: Augur's Viridian Garments
			{265019, set=5559}, -- Ensemble: Courtier's Azure Vestments
			{264883, set=5557}, -- Ensemble: Courtier's Crimson Vestments
			{265021, set=5561}, -- Ensemble: Courtier's Lucent Vestments
			{265020, set=5560}, -- Ensemble: Courtier's Umbral Vestments
			{265018, set=5558}, -- Ensemble: Courtier's Viridian Vestments
		},
		active=ns.conditions.Item(264882), -- Finery Funds
		atlas="banker", minimap=true,
		note="Trade {item:264882:Finery Funds} for Ensembles",
	},
	[28754669] = {
		label="{npc:273775:J'imothy}",
		loot={{282417, pet=true}}, -- Stubby Whistle
		note="Find {npc:273760:Ensorcelled Cryptid}, {spell:1313803:Drain Barrier} to remove {spell:1313802:Barrier Integrity}, keep moving to dodge interruptions.",
		additional={51445362, 58304190},
		minimap=true,
		texture=ns.atlas_texture("WildBattlePetCapturable", {r=0, g=0.5, b=1}),
		backdrop=ns.atlas_texture("CircleMaskScalable", {r=0.5, g=1, b=1, a=0.75}),
		border=ns.atlas_texture("Adventures-Buff-Heal-Ring")
	},
})
