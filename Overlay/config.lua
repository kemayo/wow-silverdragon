local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

local _, myfullname = C_AddOns.GetAddOnInfo("SilverDragon")

-- Both map sections offer this, and quest/achievement completion is shown either
-- way, so it's only ever about the loot.
local function lootSelect(order)
    return {
        type = "select",
        name = "Show loot",
        desc = "Where to list what a mob or treasure drops. Whether that includes plain items is set under Tooltips",
        values = {
            [module.const.LOOT_TOOLTIP] = "In the tooltip",
            [module.const.LOOT_WINDOW] = "In a popout window",
            [module.const.LOOT_BOTH] = "Both",
            [module.const.LOOT_NONE] = "Don't",
        },
        sorting = {
            module.const.LOOT_TOOLTIP,
            module.const.LOOT_WINDOW,
            module.const.LOOT_BOTH,
            module.const.LOOT_NONE,
        },
        order = order,
    }
end

local iconThemes = {
    {value = "skulls", text = "Skulls"},
    {value = "circles", text = "Circles"},
    {value = "stars", text = "Stars"},
}
local iconColors = {
    {value = "distinct", text = "Unique per-mob",
     tip = "A color of its own for every mob and treasure in the zone."},
    {value = "completion", text = "What's left on it",
     tip = "Four colors: a mount, something notable, nothing notable, or nothing at all."},
}
local function selectValues(list)
    local values = {}
    for _, entry in ipairs(list) do
        values[entry.value] = entry.text
    end
    return values
end

local unknownTip = "Nothing to judge by: no tracking quest, no achievement, no known loot"
local nothingTip = "Still lootable, but with nothing notable remaining"
local doneTip = "Nothing left at all: the achievement is done and everything is looted, or the tracking quest is complete"
local achievementlessTip = "Whether to show icons for things which aren't part of the criteria for any known achievement"

function module:RegisterConfig()
    local config = core:GetModule("Config", true)
    if not config then return end
    config.options.plugins.overlay = { overlay = {
        type = "group",
        name = "Map Overlay",
        get = function(info) return self.db.profile[info[#info]] end,
        set = function(info, v)
            self.db.profile[info[#info]] = v
            module:Update()
        end,
        args = {
            display = {
                type = "group",
                name = "What to display",
                inline = true,
                args = {
                    rares = {
                        type = "group",
                        name = "Rares",
                        inline = true,
                        args = {
                            showMobs = {
                                type = "toggle",
                                name = "Show rares",
                                desc = "Whether to put rare mobs on the map at all",
                                width = "full",
                                order = 0,
                            },
                            filter = {
                                type = "select",
                                name = "Which rares",
                                desc = "What counts as \"notable\" is set in the Notability settings; generally it means some collectable loot",
                                values = {
                                    everything = "All of them",
                                    notable = "Notable ones",
                                },
                                sorting = {"notable", "everything"},
                                disabled = function() return not self.db.profile.showMobs end,
                                width = "double",
                                order = 5,
                            },
                            showUnknown = {
                                type = "toggle",
                                name = "...and unknown ones",
                                desc = unknownTip,
                                disabled = function() return not self.db.profile.showMobs or self.db.profile.filter == "everything" end,
                                order = 10,
                            },
                            showNothing = {
                                type = "toggle",
                                name = "...and emptied ones",
                                desc = nothingTip,
                                disabled = function() return not self.db.profile.showMobs or self.db.profile.filter == "everything" end,
                                order = 11,
                            },
                            showDone = {
                                type = "toggle",
                                name = "...and finished ones",
                                desc = doneTip,
                                disabled = function() return not self.db.profile.showMobs or self.db.profile.filter == "everything" end,
                                order = 12,
                            },
                            achievementless = {
                                type = "toggle",
                                name = "Show non-achievement rares",
                                desc = achievementlessTip,
                                disabled = function() return not self.db.profile.showMobs end,
                                width = "full",
                                order = 20,
                            },
                        },
                        order = 10,
                    },
                    treasures = {
                        type = "group",
                        name = "Treasures",
                        inline = true,
                        args = {
                            showTreasures = {
                                type = "toggle",
                                name = "Show treasures",
                                desc = "Whether to put treasures on the map at all",
                                width = "full",
                                order = 0,
                            },
                            filterTreasure = {
                                type = "select",
                                name = "Which treasures",
                                desc = "What counts as \"notable\" is set in the Notability settings; generally it means some collectable loot",
                                values = {
                                    everything = "All of them",
                                    notable = "Notable ones",
                                },
                                sorting = {"notable", "everything"},
                                disabled = function() return not self.db.profile.showTreasures end,
                                width = "double",
                                order = 5,
                            },
                            showUnknownTreasure = {
                                type = "toggle",
                                name = "...and unsure ones",
                                desc = unknownTip,
                                disabled = function() return not self.db.profile.showTreasures or self.db.profile.filterTreasure == "everything" end,
                                order = 10,
                            },
                            showNothingTreasure = {
                                type = "toggle",
                                name = "...and emptied ones",
                                desc = nothingTip,
                                disabled = function() return not self.db.profile.showTreasures or self.db.profile.filterTreasure == "everything" end,
                                order = 11,
                            },
                            showDoneTreasure = {
                                type = "toggle",
                                name = "...and looted ones",
                                desc = doneTip,
                                disabled = function() return not self.db.profile.showTreasures or self.db.profile.filterTreasure == "everything" end,
                                order = 12,
                            },
                            achievementlessTreasure = {
                                type = "toggle",
                                name = "Show non-achievement treasures",
                                desc = achievementlessTip,
                                disabled = function() return not self.db.profile.showTreasures end,
                                width = "full",
                                order = 20,
                            },
                        },
                        order = 20,
                    },
                    emphasize = {
                        type = "toggle",
                        name = "Emphasize notable",
                        desc = "Make the icons bigger for anything that still has something notable. Useful when the map is showing emptied or finished rares.",
                        width = "full",
                        order = 30,
                    },
                    unhide = {
                        type = "execute",
                        name = "Reset hidden nodes",
                        desc = "Show all nodes that you manually hid by right-clicking on them and choosing \"hide\".",
                        func = function()
                            wipe(self.db.profile.hidden)
                            wipe(self.db.profile.hiddenTreasure)
                            module:Update()
                        end,
                        order = 50,
                    },
                },
                order = 0,
            },
            icon = {
                type = "group",
                name = "Icon settings",
                inline = true,
                args = {
                    desc = {
                        name = "These settings control the look and feel of the icon.",
                        type = "description",
                        order = 0,
                    },
                    icon_theme = {
                        type = "select",
                        name = "Theme",
                        desc = "Which icon set to use",
                        values = selectValues(iconThemes),
                        order = 40,
                    },
                    icon_color = {
                        type = "select",
                        name = "Color",
                        desc = "How to color the icons.\n\n\"What's left on it\" has four colors: a mount, something notable, nothing notable, or nothing at all.",
                        values = selectValues(iconColors),
                        order = 50,
                    },
                },
                order = 10,
            },
            worldmap = {
                type = "group",
                name = "World Map",
                inline = true,
                get = function(info) return self.db.profile.worldmap[info[#info]] end,
                set = function(info, v)
                    self.db.profile.worldmap[info[#info]] = v
                    module:Update()
                    if WorldMapFrame.RefreshOverlayFrames then
                        WorldMapFrame:RefreshOverlayFrames()
                    end
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        name = "Enabled",
                        desc = "Show icons on the world map",
                        width = "full",
                        order = 0,
                    },
                    icon_scale = {
                        type = "range",
                        name = "Icon Scale",
                        desc = "The scale of the icons",
                        min = 0.25, max = 2, step = 0.01,
                        order = 20,
                    },
                    icon_alpha = {
                        type = "range",
                        name = "Icon Alpha",
                        desc = "The alpha transparency of the icons",
                        min = 0, max = 1, step = 0.01,
                        order = 30,
                    },
                    routes = config.toggle("Routes", "Show the routes that some mobs take", 40),
                    loot = lootSelect(50),
                    tooltip_help = config.toggle("Help", "Show the click shortcuts in the tooltip", 53),
                },
                order = 20,
            },
            minimap = {
                type = "group",
                name = "Minimap",
                inline = true,
                get = function(info) return self.db.profile.minimap[info[#info]] end,
                set = function(info, v)
                    self.db.profile.minimap[info[#info]] = v
                    module:Update()
                end,
                args = {
                    enabled = {
                        type = "toggle",
                        name = "Enabled",
                        desc = "Show icons on the minimap",
                        width = "full",
                        order = 0,
                    },
                    edge = {
                        type = "select",
                        name = "Show on edge",
                        values = {
                            [module.const.EDGE_NEVER] = "Never",
                            [module.const.EDGE_FOCUS] = "Focused",
                            [module.const.EDGE_ALWAYS] = "Always",
                        },
                        order = 10,
                    },
                    icon_scale = {
                        type = "range",
                        name = "Icon Scale",
                        desc = "The scale of the icons",
                        min = 0.25, max = 2, step = 0.01,
                        order = 20,
                    },
                    icon_alpha = {
                        type = "range",
                        name = "Icon Alpha",
                        desc = "The alpha transparency of the icons",
                        min = 0, max = 1, step = 0.01,
                        order = 30,
                    },
                    routes = config.toggle("Routes", "Show the routes that some mobs take", 40),
                    loot = lootSelect(41),
                    tooltip_help = config.toggle("Help", "Show the click shortcuts in the tooltip", 43),
                },
                order = 30,
            },
        },
    }, }
end

-- The "what to display" options as a right-click menu. The broker module hangs
-- this off its world-map button; keeping it here means it stays in step with the
-- options above. Worldmap/minimap tuning is left out -- fiddly, and rarely
-- touched -- so those wait on the full panel.
local menuKinds = {
    {name = "Rares", show = "showMobs", filter = "filter", showTip = "Put rare mobs on the map",
     also = {
        {key = "showUnknown", text = "...and unsure ones", tip = unknownTip},
        {key = "showNothing", text = "...and emptied ones", tip = nothingTip},
        {key = "showDone", text = "...and finished ones", tip = doneTip},
     },
     achless = {key = "achievementless", text = "Non-achievement rares", tip = achievementlessTip}},
    {name = "Treasures", show = "showTreasures", filter = "filterTreasure", showTip = "Put treasures on the map",
     also = {
        {key = "showUnknownTreasure", text = "...and unsure ones", tip = unknownTip},
        {key = "showNothingTreasure", text = "...and emptied ones", tip = nothingTip},
        {key = "showDoneTreasure", text = "...and looted ones", tip = doneTip},
     },
     achless = {key = "achievementlessTreasure", text = "Non-achievement treasures", tip = achievementlessTip}},
}

local function displayMenu(owner, rootDescription)
    local odb = module.db.profile

    rootDescription:SetTag("MENU_SILVERDRAGON_OVERLAY_DISPLAY")
    rootDescription:CreateTitle(myfullname)

    -- enabled is a predicate, not a value: the menu polls it, so a row greys out
    -- the moment the toggle it depends on changes, without reopening the menu
    local function toggle(parent, text, key, tip, enabled)
        local item = parent:CreateCheckbox(text,
            function() return odb[key] end,
            function() odb[key] = not odb[key]; module:Update() end)
        item:SetTitleAndTextTooltip(nil, tip)
        if enabled then item:SetEnabled(enabled) end
        return item
    end
    local function filterRadios(parent, key, enabled)
        local function on(v) return function() return odb[key] == v end end
        local function pick(v) return function() odb[key] = v; module:Update(); return MenuResponse.Refresh end end
        local a = parent:CreateRadio("Notable ones", on("notable"), pick("notable"))
        local b = parent:CreateRadio("All of them", on("everything"), pick("everything"))
        if enabled then a:SetEnabled(enabled) b:SetEnabled(enabled) end
    end

    for _, k in ipairs(menuKinds) do
        local kindOn = function() return odb[k.show] end
        -- as in the options: the "also show" rows do nothing while everything's
        -- already showing, and nothing at all while the kind is switched off
        local alsoOn = function() return odb[k.show] and odb[k.filter] ~= "everything" end
        local root = toggle(rootDescription, k.name, k.show, k.showTip)
        filterRadios(root, k.filter, kindOn)
        root:CreateDivider()
        for _, row in ipairs(k.also) do
            toggle(root, row.text, row.key, row.tip, alsoOn)
        end
        root:CreateDivider()
        toggle(root, k.achless.text, k.achless.key, k.achless.tip, kindOn)
    end

    toggle(rootDescription, "Emphasize notable", "emphasize", "Bigger icons for anything notable")

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("Icons")
    local function picker(text, key, list, tip)
        local submenu = rootDescription:CreateButton(text)
        submenu:SetTitleAndTextTooltip(nil, tip)
        for _, entry in ipairs(list) do
            local item = submenu:CreateRadio(entry.text,
                function() return odb[key] == entry.value end,
                function() odb[key] = entry.value; module:Update(); return MenuResponse.Refresh end)
            if entry.tip then item:SetTitleAndTextTooltip(nil, entry.tip) end
        end
    end
    picker("Theme", "icon_theme", iconThemes, "Which icon set to use")
    picker("Color", "icon_color", iconColors, "How to color the icons")

    rootDescription:CreateDivider()
    rootDescription:CreateButton("Open settings", function()
        local config = core:GetModule("Config", true)
        if not config then return end
        config:ShowConfig()
        LibStub("AceConfigDialog-3.0"):SelectGroup("SilverDragon", "overlay")
    end)
end

function module:ShowDisplayMenu(owner)
    if not (_G.MenuUtil and MenuUtil.CreateContextMenu) then return false end
    MenuUtil.CreateContextMenu(owner, displayMenu)
    return true
end