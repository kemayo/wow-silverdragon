local myname = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:GetModule("Overlay")
local Debug = core.Debug
local ns = core.NAMESPACE

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
                    achieved = {
                        type = "toggle",
                        name = "Show achieved",
                        desc = "Whether to show icons for mobs you have already killed (tested by whether you've got their achievement progress)",
                        order = 10,
                    },
                    questcomplete = {
                        type = "toggle",
                        name = "Show quest-complete",
                        desc = "Whether to show icons for mobs you have the tracking quest complete for (which probably means they won't drop anything)",
                        order = 15,
                    },
                    achievementless = {
                        type = "toggle",
                        name = "Show non-achievement mobs",
                        desc = "Whether to show icons for mobs which aren't part of the criteria for any known achievement",
                        width = "full",
                        order = 20,
                    },
                    unhide = {
                        type = "execute",
                        name = "Reset hidden mobs",
                        desc = "Show all nodes that you manually hid by right-clicking on them and choosing \"hide\".",
                        func = function()
                            wipe(self.db.profile.hidden)
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
                        desc = "How to color the icons",
                        values = {
                            ["distinct"] = "Unique per-mob",
                            ["completion"] = "Completion status",
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
                    tooltip_completion = config.toggle("Completion", "Show achievement/drop completion in the tooltip", 50),
                    tooltip_regularloot = config.toggle("Regular Loot", "Show regular untrackable loot in the tooltip", 51),
                    tooltip_lootwindow = config.toggle("Popout loot window", "Show a popout for the loot so you can see its details", 52),
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
                    tooltip_completion = config.toggle("Completion", "Show achievement/drop completion in the tooltip", 40),
                    tooltip_regularloot = config.toggle("Regular Loot", "Show regular untrackable loot in the tooltip", 41),
                    tooltip_lootwindow = config.toggle("Popout loot window", "Show a popout for the loot so you can see its details", 42),
                    tooltip_help = config.toggle("Help", "Show the click shortcuts in the tooltip", 43),
                },
                order = 30,
            },
        },
    }, }
end