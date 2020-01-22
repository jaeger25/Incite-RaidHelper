local RaidHandlers = {}
_G["RaidHandlers"] = RaidHandlers

LibStub("AceComm-3.0"):Embed(RaidHandlers)
LibStub("AceTimer-3.0"):Embed(RaidHandlers)
LibStub("AceEvent-3.0"):Embed(RaidHandlers)

local function ConcatAddonNames(includeVersions)
    local addons = ""
    addons = addons.."Incite Raid Helper"
    if includeVersions
    then
        addons = addons..","..Incite.version.."|"
    end

    addons = addons.."DBM"
    if includeVersions
    then
        addons = addons..","..DbmInterop:GetVersion().."|"
    end

    addons = addons.."Details"
    if includeVersions
    then
        addons = addons..","..DetailsInterop:GetVersion()
    end

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

function RaidHandlers:CheckAddons()
    self.CheckAddonsResponses = {}

    local addons = ConcatAddonNames(false)
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
    raidMemberAddons[playerName] = SplitAddonNames(ConcatAddonNames(true))

    local latestAddons = SplitAddonNames(ConcatAddonNames(true))
    for sender,addonNames in pairs(self.CheckAddonsResponses)
    do
        local addons = SplitAddonNames(addonNames)
        raidMemberAddons[sender] = addons

        for name,version in pairs(addons)
        do
            if version > latestAddons[name]
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

    self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    for member, memberAddons in pairs(raidMemberAddons)
    do
        for name, version in pairs(latestAddons)
        do
            if memberAddons[name] ~= version
            then
                SendChatMessage("Your required raid addons are out-of-date. Please go update them immediately.", "WHISPER", nil, member)
                SendChatMessage("Your versions: "..table.tostring(memberAddons), "WHISPER", nil, member)
                SendChatMessage(member, "RAID")
                break
            end
        end
    end
    self:UnregisterEvent("CHAT_MSG_WHISPER_INFORM")
end

function RaidHandlers:OnCommReceived(prefix, message, distribution, sender)
    local addons = SplitString(message, ":");
    local command = table.remove(addons, 1)

    Incite:Print("Response Recieve: "..command.." | "..message.." | "..distribution)

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
    self:SendCommMessage("incite-raid", "check-addons-response:"..addons, "WHISPER", sender)
end

function RaidHandlers:OnCheckAddonsResponse(addons, sender)
    self.CheckAddonsResponses[sender] = addons
end

function RaidHandlers:CHAT_MSG_WHISPER_INFORM(...)
    -- Discard chat message
    return true
end

RaidHandlers:RegisterComm("incite-raid")
