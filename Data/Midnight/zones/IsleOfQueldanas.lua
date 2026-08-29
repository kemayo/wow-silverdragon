local myname, ns = ...

local VOIDLIGHT = {ns.rewards.Currency(ns.CURRENCY_VOIDLIGHT, 5)}

ns.RegisterPoints(2432, { -- Intro version
	[38363304] = {quest=92620, vignette=7010}, -- voidlight x5, potent healing potion x3
	[54152363] = {quest=92621, vignette=7505}, -- potent healing potion x3
	[35462932] = {quest=92622, vignette=7506}, -- potent healing potion x3, frayed handwraps
	[58793526] = {quest=92623, vignette=7507}, -- potent healing potion x3, voidlight x4
	[63803463] = {quest=92624, vignette=7508}, -- potent healing potion x3, voidlight x4
	[38522288] = {quest=92625, vignette=7509}, -- potent healing potion x4, frayed wristwraps
	[48902183] = {quest=94830, vignette=7510}, -- potent healing potion x3, threadbare sash
}, {
	label="Artisan's Cache",
})

ns.RegisterPoints(ns.ISLEOFQUELDANAS, {
	[55712913] = { label="Tarhu the Ransacker",
		quest=95011,
		npc=252465,
		loot={
			267271, -- Nethersteel Deflectors
			267267, -- Ransacker's Netherhide Mask
		},
		vignette=7325,
	},
	[37093830] = { label="Dripping Shadow",
		quest=95010,
		npc=239864,
		loot={
			267268, -- Dripping Silk Footwraps
			267270, -- Shadow-Drenched Legguards
		},
		vignette=7155,
	},
})
