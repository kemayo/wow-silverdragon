local myname, ns = ...

ns.RegisterPoints(619, {}) -- Broken Isles

ns.RegisterPoints(647, { -- Acherus: The Heart of Acherus
    [56563491] = {
        label="{spell:439568:Runeforge}",
        requires=ns.conditions.Class("DEATHKNIGHT"),
        atlas="ClassOverlay-Rune", scale=1.2,
        minimap=true,
    },
})

