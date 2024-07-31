local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Scan_CHAT", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-2.0")

local globaldb

function module:OnInitialize()
    self.db = core.db:RegisterNamespace("Scan_Chat", {
        profile = {
            enabled = true,
        },
    })
    globaldb = core.db.global

    local config = core:GetModule("Config", true)
    if config then
        config.options.args.scanning.plugins.chat = {
            chat = {
                type = "group",
                name = "Chat",
                get = function(info) return self.db.profile[info[#info]] end,
                set = function(info, v) self.db.profile[info[#info]] = v end,
                args = {
                    enabled = config.toggle("Enabled", "Listen for mobs that announce themselves in chat", 10),
                },
            },
        }
    end
end

function module:OnEnable()
    self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_MONSTER_SAY", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_MONSTER_WHISPER", "OnChatMessage")
end

local redirects = {
    [62352] = 62346, -- Chief Salyis => Galleon
    [154342] = 151934, -- Arachnoid Harvester (time displaced) => Arachnoid Harvester
    [157726] = 160857, -- Scorched Scavenger => Sire Ladinas
    [157727] = 160857, -- Scorched Outcast => Sire Ladinas
    [157733] = 160857, -- Crazed Ash Ghoul => Sire Ladinas
    [166726] = 160857, -- Blistering Ash Ghoul => Sire Ladinas
    [179974] = 179985, -- Drippy => Stygian Stonecrusher
}
local type_restriction = {
    [157726] = "CHAT_MSG_MONSTER_YELL", -- Scorched Scavenger
    [157727] = "CHAT_MSG_MONSTER_YELL", -- Scorched Outcast
    [157733] = "CHAT_MSG_MONSTER_YELL", -- Crazed Ash Ghoul
    [166726] = "CHAT_MSG_MONSTER_YELL", -- Blistering Ash Ghoul
    [179974] = "CHAT_MSG_MONSTER_YELL", -- Stygian Stonecrusher
}

function module:OnChatMessage(event, text, name, ...)
    if not self.db.profile.enabled then return end
    if not core.db.profile.instances and IsInInstance() then return end
    local zone = HBD:GetPlayerZone()
    local guid = select(10, ...)
    local id, x, y
    if guid then
        id = ns.IdFromGuid(guid)
    elseif name then
        id = core:IdForMob(name, zone)
    end
    Debug("OnChatMessage", event, text, name, id, guid)
    if id then
        if type_restriction[id] and type_restriction[id] ~= event then
            -- Added for Sire Ladinas, whose spawn is announced by a different
            -- type of mob yelling. That mob can normally say things in
            -- combat, so restricting the announcement to yells seems to make
            -- sense...
            return
        end
        if redirects[id] then
            id = redirects[id]
        end
    end
    if not id or not (ns.mobdb[id] or globaldb.always[id]) then return end
    if not globaldb.always[id] and not (ns.mobsByZone[zone] and ns.mobsByZone[zone][id]) then
        -- Only announce from chat message in zones that a rare is known to
        -- exist in (or if they're manually-added rares). Avoids issues like
        -- the Shadowlands pre-event where a lot of boss names got reused and
        -- started getting rare-alerts in their older versions in instances.
        return
    end
    -- Guess from the event whether we're anywhere near the mob
    -- Used to trust CHAT_MSG_MONSTER_EMOTE here as well, but there's a lot of
    -- zone-wide emotes these days
    if event == "CHAT_MSG_MONSTER_SAY" then
        x, y = HBD:GetPlayerZonePosition()
    else
        x, y = 0, 0
    end
    -- id, zone, x, y, dead, source, unit, silent, force, GUID
    core:NotifyForMob(id, zone, x, y, false, "chat", false, false, false, guid)
end
