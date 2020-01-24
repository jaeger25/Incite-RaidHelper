local GuildHandlers = {}
_G["GuildHandlers"] = GuildHandlers

LibStub("AceEvent-3.0"):Embed(GuildHandlers)

function GuildHandlers:GUILD_ROSTER_UPDATE(canRequestRosterUpdate)
    if C_GuildInfo.CanViewOfficerNote
    then
        self:SaveRoster()
    end
end

function GuildHandlers:SaveRoster()
    local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player");
    local numTotal, numOnline, numOnlineAndMobile = GetNumGuildMembers();
    local unixTimestamp = GetServerTime()

    if Incite.db.factionrealm[guildName] == nil
    then
        Incite.db.factionrealm[guildName] = {}
        Incite.db.factionrealm[guildName].Roster = {}
    end

    Incite.db.factionrealm[guildName].Roster.LastModifiedAt = unixTimestamp
    Incite.db.factionrealm[guildName].Roster.Characters = {}

    for i = 1, numTotal
    do
        local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status,
        class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(i)

        Incite.db.factionrealm[guildName].Roster.Characters[name] = {}
        Incite.db.factionrealm[guildName].Roster.Characters[name].OfficerNote = officerNote
    end

end

GuildHandlers:RegisterEvent("GUILD_ROSTER_UPDATE")
