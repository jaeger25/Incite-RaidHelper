local RaidHandlers = {}
_G["RaidHandlers"] = RaidHandlers

LibStub("AceComm-3.0"):Embed(RaidHandlers)

function RaidHandlers:CheckAddons()
    Incite:Print(DbmInterop:GetVersion())
    Incite:Print(DetailsInterop:GetVersion())
    Incite:SendCommMessage("incite-addons", "the data to send", "RAID")
end

function RaidHandlers:OnCommReceived(prefix, message, distribution, sender)
end

Incite:RegisterComm("incite-addons", RaidHandlers.OnCommReceived)
