local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

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
                            achieved = {
                                type = "toggle",
                                name = "Show achieved",
                                desc = "Whether to show icons for mobs you're done with: ones you've got the achievement progress for, or that have nothing left on them you want (which is set up under Announcements, in \"What's notable?\")",
                                disabled = function() return not self.db.profile.showMobs end,
                                order = 10,
                            },
                            questcomplete = {
                                type = "toggle",
                                name = "Show quest-complete",
                                desc = "Whether to show icons for mobs you have the tracking quest complete for (which probably means they won't drop anything)",
                                disabled = function() return not self.db.profile.showMobs end,
                                order = 15,
                            },
                            achievementless = {
                                type = "toggle",
                                name = "Show non-achievement mobs",
                                desc = "Whether to show icons for mobs which aren't part of the criteria for any known achievement",
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
                            achievedTreasure = {
                                type = "toggle",
                                name = "Show achieved",
                                desc = "Whether to show icons for treasures you're done with: ones you've got the achievement progress for, or that have nothing left in them you want (which is set up under Announcements, in \"What's notable?\")",
                                disabled = function() return not self.db.profile.showTreasures end,
                                order = 10,
                            },
                            questcompleteTreasure = {
                                type = "toggle",
                                name = "Show looted",
                                desc = "Whether to show icons for treasures you've already opened. Unlike a rare, a treasure doesn't come back, so these are off by default",
                                disabled = function() return not self.db.profile.showTreasures end,
                                order = 15,
                            },
                            achievementlessTreasure = {
                                type = "toggle",
                                name = "Show non-achievement treasures",
                                desc = "Whether to show icons for treasures which aren't part of the criteria for any known achievement",
                                disabled = function() return not self.db.profile.showTreasures end,
                                width = "full",
                                order = 20,
                            },
                        },
                        order = 20,
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
                        values = {
                            ["skulls"] = "Skulls",
                            ["circles"] = "Circles",
                            ["stars"] = "Stars",
                        },
                        order = 40,
                    },
                    icon_color = {
                        type = "select",
                        name = "Color",
                        desc = "How to color the icons.\n\n\"What's left on it\" asks what the announcement filter asks, and has four answers: a mount you'd want, something else you'd want, nothing you want, or nothing left at all.",
                        values = {
                            ["distinct"] = "Unique per-mob",
                            ["completion"] = "What's left on it",
                        },
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