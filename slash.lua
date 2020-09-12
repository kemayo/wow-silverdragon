local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Slash", "AceConsole-3.0")
local config

function module:OnInitialize()
    config = core:GetModule("Config", true)

    self:RegisterChatCommand("silverdragon", "OnChatCommand")
    if not select(4, GetAddOnInfo("NPCScan")) then
        -- NPCScan is either not installed or not loaded
        -- We'd like to borrow the "/npcscan add 12345" and similar command since it's all over sites
        self:RegisterChatCommand("npcscan", "OnChatCommand")
    end
end

local commands = {
    add = function(self, arg)
        local npcid = ns.input_to_mobid(arg)
        if npcid then
            if core.db.global.always[npcid] then
                return self:Printf("%s (%d) was already on the custom watch list", core:NameForMob(npcid) or UNKNOWN, npcid)
            end
            core.db.global.always[npcid] = true
            if config then
                local mobs = core:GetModule("Mobs")
                mobs:BuildCustomList(config.options)
            end
            return self:Printf("Added %s (%d) to the custom watch list", core:NameForMob(npcid) or UNKNOWN, npcid)
        end
        self:Print("Couldn't work out the mob id from your input")
    end,
    remove = function(self, arg)
        local npcid = ns.input_to_mobid(arg)
        if npcid then
            if not core.db.global.always[npcid] then
                return self:Printf("%s (%d) wasn't on the custom watch list", core:NameForMob(npcid) or UNKNOWN, npcid)
            end
            core.db.global.always[npcid] = nil
            if config then
                local mobs = core:GetModule("Mobs")
                mobs:BuildCustomList(config.options)
            end
            return self:Printf("Removed %s (%d) from the custom watch list", core:NameForMob(npcid) or UNKNOWN, npcid)
        end
        self:Print("Couldn't work out the mob id from your input")
    end,
    ignore = function(self, arg)
        local npcid = ns.input_to_mobid(arg)
        if npcid then
            if core.db.global.ignore[npcid] then
                return self:Printf("%s (%d) was already on the ignore list", core:NameForMob(npcid) or UNKNOWN, npcid)
            end
            core.db.global.ignore[npcid] = true
            if config then
                local mobs = core:GetModule("Mobs")
                mobs:BuildIgnoreList(config.options)
            end
            return self:Printf("Added %s (%d) to the ignore list", core:NameForMob(npcid) or UNKNOWN, npcid)
        end
        self:Print("Couldn't work out the mob id from your input")
    end,
    debug = function(self, args)
        core:ShowDebugWindow()
    end,
}

function module:OnChatCommand(input)
    local command, arg = self:GetArgs(input, 2)
    if command and commands[command:lower()] then
        commands[command:lower()](self, arg, input)
    else
        if config then
            config:ShowConfig()
        end
    end
end
