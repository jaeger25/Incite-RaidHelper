local RaidHandlers = {}
_G["RaidHandlers"] = RaidHandlers

LibStub("AceComm-3.0"):Embed(RaidHandlers)
LibStub("AceTimer-3.0"):Embed(RaidHandlers)

local function ConcatAddonNames()
    local addons = ""
    addons = addons.."Incite Raid Helper"..","..Incite.version.."|"
    addons = addons.."DBM"..","..DbmInterop:GetVersion().."|"
    addons = addons.."Details"..","..DetailsInterop:GetVersion()

    return addons
end

local function SplitAddonNames(addonNames)
    local addons = {}
    local addonStrings = SplitString(addonNames, "|")
    for i,v in ipairs(addonStrings)
    do
        local addonString = SplitString(v, ",")
        addons[addonString[1]] = addonString[2]
    end

    return addons
end

function GetHigherVersion(version1, version2)
    local version1Parts = SplitString(version1:gsub("v", "0"), "%.")
    local version2Parts = SplitString(version2:gsub("v", "0"), "%.")

    Incite:Print(table.tostring(version1Parts))
    Incite:Print(table.tostring(version2Parts))

    for i = 1, 4
    do
        local v1Part = tonumber(version1Parts[i])
        local v2Part = tonumber(version2Parts[i])

        Incite:Print(v1Part)
        Incite:Print(v2Part)

        if (v1Part == nil and v2Part == nil)
        then
            return version1
        elseif v1Part == nil
        then
            return version2
        elseif v2Part == nil
        then
            return version1
        elseif v1Part > v2Part
        then
            return version1
        elseif v2Part > v1Part
        then
            return version2
        end
    end
end

function RaidHandlers:CheckAddons()
    self.CheckAddonsResponses = {}

    local addons = ConcatAddonNames()
    self:SendCommMessage("incite-raid", "check-addons-request:"..addons, "RAID")

    self:ScheduleTimer("OnCheckAddonsTimerExpired", 10)
end

function RaidHandlers:OnCheckAddonsTimerExpired()
    local raidMembers = {}
    local raidMemberAddons = {}
    local numRaidMembers = GetNumGroupMembers()
    local playerName = UnitName("player")

    for i=1, numRaidMembers
    do
        raidMembers[i] = {GetRaidRosterInfo(i)}
        raidMemberAddons[raidMembers[i][1]] = {}
    end
    raidMemberAddons[playerName] = SplitAddonNames(ConcatAddonNames())

    local latestAddons = SplitAddonNames(ConcatAddonNames())
    for sender,addonNames in pairs(self.CheckAddonsResponses)
    do
        local addons = SplitAddonNames(addonNames)
        raidMemberAddons[sender] = addons

        for name,version in pairs(addons)
        do
            if version == GetHigherVersion(version, latestAddons[name])
            then
                latestAddons[name] = version
            end
        end
    end

    SendChatMessage("===REQUIRED ADDON STATUS===", "RAID_WARNING")
    SendChatMessage("LATEST VERSIONS:", "RAID")
    for name, version in pairs(latestAddons)
    do
        SendChatMessage(name..": "..version, "RAID")
    end

    SendChatMessage("OFFENDING PLAYERS:", "RAID")
    for member, memberAddons in pairs(raidMemberAddons)
    do
        local isOutOfDate = false
        local chatMessage = member.." : "
        for name, version in pairs(latestAddons)
        do
            if memberAddons[name] ~= version
            then
                isOutOfDate = true
                chatMessage = chatMessage..name..","..(memberAddons[name] or "?").."  "
            end
        end

        if isOutOfDate
        then
            SendChatMessage(chatMessage, "RAID")
        end
    end
end

function RaidHandlers:OnCommReceived(prefix, message, distribution, sender)
    message = SplitString(message, ":");
    local command = table.remove(message, 1)
    local addons = message[1]

    if command == "check-addons-request"
    then
        self:OnCheckAddonsRequest(addons, sender)
    elseif command == "check-addons-response"
    then
        self:OnCheckAddonsResponse(addons, sender)
    end
end

function RaidHandlers:OnCheckAddonsRequest(addons, sender)
    local addons = ConcatAddonNames(true)
    self:SendCommMessage("incite-raid", "check-addons-response:"..addons, "RAID", sender)
end

function RaidHandlers:OnCheckAddonsResponse(addons, sender)
    if self.CheckAddonsResponses ~= nil
    then
        self.CheckAddonsResponses[sender] = addons
    end
end

RaidHandlers:RegisterComm("incite-raid")
