local DebuffTracker = {}
_G["DebuffTracker"] = DebuffTracker

local PlayerGUID = UnitGUID("player")
local PlayerName = UnitName("player")

local DebuffBlacklist =
{
    -- Warrior
    "Rend",
    "Mortal Strike",
}

LibStub("AceEvent-3.0"):Embed(DebuffTracker)

function DebuffTracker:COMBAT_LOG_EVENT_UNFILTERED(event)
    self:DetectBadDebuff(CombatLogGetCurrentEventInfo())
end

function DebuffTracker:ENCOUNTER_START(event)
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function DebuffTracker:ENCOUNTER_END(event)
    self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function DebuffTracker:COMBAT_LOG_EVENT_UNFILTERED()
    self:DetectBadDebuff(CombatLogGetCurrentEventInfo())
end

function DebuffTracker:DetectBadDebuff(...)
    local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags,
        sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

	if subevent == "SPELL_CAST_SUCCESS" and sourceGUID == PlayerGUID then
        local spellId, spellName, spellSchool, amount, overkill, school, resisted,
            blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)

            for i,debuff in ipairs(DebuffBlacklist)
            do
                if spellName:startswith(debuff)
                then
                    SendChatMessage("SHAME!!! "..PlayerName.." used "..debuff, "RAID")
                end
            end
	end

end

DebuffTracker:RegisterEvent("ENCOUNTER_START")
DebuffTracker:RegisterEvent("ENCOUNTER_END")