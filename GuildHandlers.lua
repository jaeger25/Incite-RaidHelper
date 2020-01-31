local GuildHandlers = {}
_G["GuildHandlers"] = GuildHandlers

LibStub("AceEvent-3.0"):Embed(GuildHandlers)

function GuildHandlers:GUILD_ROSTER_UPDATE(canRequestRosterUpdate)

    local guildName = GetGuildInfo("player")
    self.GuildName = guildName

    if guildName and Incite.db.factionrealm[guildName] == nil
    then
        Incite.db.factionrealm[guildName] = {}
        Incite.db.factionrealm[guildName].DisallowedDebuffs = {}
        Incite.db.factionrealm[guildName].Roster = {}
        Incite.db.factionrealm[guildName].Roster.Characters = {}
    end

    if C_GuildInfo.CanViewOfficerNote
    then
        self:SaveRoster()
    end
end

function GuildHandlers:SaveRoster()
    local guildName = GetGuildInfo("player")
    local numTotal, numOnline, numOnlineAndMobile = GetNumGuildMembers()
    local unixTimestamp = GetServerTime()

    Incite.db.factionrealm[guildName].Roster.LastModifiedAt = unixTimestamp

    for i = 1, numTotal
    do
        local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status,
        class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(i)

        Incite.db.factionrealm[guildName].Roster.Characters[name] = {}
        Incite.db.factionrealm[guildName].Roster.Characters[name].OfficerNote = officerNote
    end

end

GuildHandlers:RegisterEvent("GUILD_ROSTER_UPDATE")
