local RaidHandlers = {}
_G["RaidHandlers"] = RaidHandlers

LibStub("AceComm-3.0"):Embed(RaidHandlers)
LibStub("AceTimer-3.0"):Embed(RaidHandlers)

local function ConcatAddOnNames(includeVersions)
    local addons = ""
    addons = addons.."DBM"
    if includeVersions
    then
        addons = addons..","..DbmInterop:GetVersion()..";"
    end

    addons = addons.."Details"
    if includeVersions
    then
        addons = addons..","..DetailsInterop:GetVersion()
    end

    return addons
end

function RaidHandlers:CheckAddons()
    self.CheckAddonsResponses = {}

    local addons = ConcatAddOnNames(false)
    Incite:SendCommMessage("incite-raid", "check-addons-request:"..addons, "RAID")

    self:ScheduleTimer(self.OnCheckAddonsTimerExpired, 10)
end

function RaidHandlers:OnCheckAddonsTimerExpired()
    local raidMembers = {}
    local numRaidMembers = GetNumGroupMembers()
    for i=1, numRaidMembers
    do
        raidMembers[i] = {GetRaidRosterInfo()}
    end


end

function RaidHandlers:OnCommReceived(prefix, message, distribution, sender)
    local addons = SplitString(message, ":");
    local command = table.remove(addons, 1)

    if command == "check-addons-request"
    then
        self:OnCheckAddonsRequest(addons, sender)
    elseif command == "check-addons-response"
    then
        self:OnCheckAddonsResponse(addons, sender)
    end
end

function RaidHandlers:OnCheckAddonsRequest(addons, sender)
    local addons = ConcatAddOnNames(true)
    Incite:SendCommMessage("incite-raid", "check-addons-response:"..addons, "WHISPER", sender)
end

function RaidHandlers:OnCheckAddonsResponse(addons, sender)
    self.CheckAddonsResponses[sender] = addons
end

Incite:RegisterComm("incite-raid", RaidHandlers.OnCommReceived)
