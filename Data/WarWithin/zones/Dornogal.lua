local myname, ns = ...

ns.RegisterPoints(ns.DORNOGAL, {
    [50086133] = {
        achievement=40606, -- Flat Earthen
        note="Let yourself get crushed. To death.",
        texture=ns.atlas_texture("vehicle-hammergold", {r=0, g=1, b=1, scale=1.3}),
        minimap=true,
    },
    [61230552] = { label="Tome of Polymorph: Mosswool",
        quest=84438, -- Easy Win
        loot={{227710, class="MAGE"}},
        path={61230552, 61910553, 62460535, 62860471, 61540265, 61100293, 58810639},
        note="Talk to {npc:229128:Valeera Sanguinar} for the book",
        atlas="class",
        requires=ns.conditions.Class("MAGE"),
    },
    [57256085] = { label="Osidion",
        label="{npc:224294:Osidion}",
        --loot={}, -- There's so many that it feels like overkill...
        active=ns.conditions.Item(223951), -- Earth-Encrusted Gem
        atlas="banker",
        note="Trade {item:223951:Earth-Encrusted Gem} for Ensembles",
    },
})
