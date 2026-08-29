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
})
