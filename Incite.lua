Incite = LibStub("AceAddon-3.0"):NewAddon("Incite", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
Incite.version = GetAddOnMetadata("Incite-RaidHelper", "Version")

function Incite:OnInitialize()
    local guildName = GetGuildInfo("player")

    self.db = LibStub("AceDB-3.0"):New("Incite_Database")
    self.GuildName = guildName
    self.PlayerGUID = UnitGUID("player")
    self.PlayerName = UnitName("player")

    Incite:RegisterChatCommand("incite", "DispatchCommand")
end

function Incite:OnEnable()
    -- Called when the addon is enabled
end

function Incite:OnDisable()
    -- Called when the addon is disabled
end

function Incite:DispatchCommand(input)
    local args = SplitString(input, " ");
    local command = table.remove(args, 1)

    if command == "backup"
    then
        GuildHandlers:SaveRoster()
    elseif command == "check-addons"
    then
        RaidHandlers:CheckAddons()
    end
end
