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
    self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_MONSTER_SAY", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_MONSTER_WHISPER", "OnChatMessage")
    self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "OnChatMessage")
end

function module:OnChatMessage(event, text, name, ...)
    if not self.db.profile.enabled then return end
    local guid = select(10, ...)
    local id
    if guid then
        id = ns.IdFromGuid(guid)
    elseif name then
        id = core:IdForMob(name)
    end
    Debug("OnChatMessage", event, text, name, id, guid)
    if not id or not (ns.mobdb[id] or globaldb.always[id]) then return end
    local x, y, zone = HBD:GetPlayerZonePosition()
    core:NotifyForMob(id, zone, x, y, false, "chat")
end
