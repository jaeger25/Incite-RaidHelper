local DebuffTracker = {}
_G["DebuffTracker"] = DebuffTracker

LibStub("AceEvent-3.0"):Embed(DebuffTracker)

DebuffTracker.DebuffExpirationTimes = {}

function DebuffTracker:ENCOUNTER_START(event)
    self:RegisterEvent("UNIT_AURA")
end

function DebuffTracker:ENCOUNTER_END(event)
    self:UnregisterEvent("UNIT_AURA")
end

function DebuffTracker:UNIT_AURA(event, unitTarget)
    self:DetectBadDebuff(unitTarget)
end

function DebuffTracker:GetIsDebuffDisallowed(info, name)
    return Incite.db.factionrealm[GuildName].DisallowedDebuffs[name]
end

function DebuffTracker:SetIsDebuffDisallowed(info, name, isDisallowed)
    Incite.db.factionrealm[GuildName].DisallowedDebuffs[name] = isDisallowed
end

function DebuffTracker:DetectBadDebuff(unitTarget)
    if unitTarget ~= "target" and not unitTarget:startswith("boss")
    then
        return
    end

    for i=1, 40
    do
        local name, icon, count, debuffType, duration,
            expirationTime, sourceUnitId = UnitDebuff(unitTarget, i)

        if name == nil
        then
            break
        elseif self:GetIsDebuffDisallowed(nil, name) and self.DebuffExpirationTimes[name] ~= expirationTime
        then
            self.DebuffExpirationTimes[name] = expirationTime

            if UnitIsGroupLeader("player")
            then
                SendChatMessage("SHAME!!! "..Incite.PlayerName.." used "..name, "RAID_WARNING")                
            end
            if sourceUnitId == "player"
            then
                SendChatMessage("[Incite] The following debuff is disallowed: "..name, "WHISPER", nil, Incite.PlayerName)   
            end
        end
    end

end

DebuffTracker:RegisterEvent("ENCOUNTER_START")
DebuffTracker:RegisterEvent("ENCOUNTER_END")

DebuffTracker.WarriorDebuffs =
{
    ["Rend"] = "Rend",
    ["Mortal Strike"] = "Mortal Strike",
    ["Sunder Armor"] = "Sunder Armor",
    ["Thunder Clap"] = "Thunder Clap",
    ["Demoralizing Shout"] = "Demoralizing Shout",
    ["Deep Wounds"] = "Deep Wounds",
}

DebuffTracker.WarlockDebuffs =
{
    ["Improved Shadow Bolt"] = "Improved Shadow Bolt",
    ["Curse of Shadow"] = "Curse of Shadow",
    ["Curse of the Elements"] = "Curse of the Elements",
    ["Curse of Recklessness"] = "Curse of Recklessness",
    ["Curse of Weakness"] = "Curse of Weakness",
    ["Curse of Tongues"] = "Curse of Tongues",
    ["Curse of Agony"] = "Curse of Agony",
    ["Curse of Doom"] = "Curse of Doom",
    ["Corruption"] = "Corruption",
    ["Immolate"] = "Immolate",
    ["Siphon Life"] = "Siphon Life",
}

DebuffTracker.PriestDebuffs =
{
    ["Shadow Weaving"] = "Shadow Weaving",
    ["Shadow Word: Pain"] = "Shadow Word: Pain",
    ["Mind Flay"] = "Mind Flay",
    ["Vampiric Embrace"] = "Vampiric Embrace",
}

DebuffTracker.MageDebuffs =
{
    ["Winter's Chill"] = "Winter's Chill",
    ["Ignite"] = "Ignite",
    ["Improved Scorch"] = "Improved Scorch",
}

DebuffTracker.DruidDebuffs =
{
    ["Faerie Fire"] = "Faerie Fire",
    ["Faerie Fire (Feral)"] = "Faerie Fire (Feral)",
    ["Rake"] = "Rake",
    ["Rip"] = "Rip",
    ["Insect Swarm"] = "Insect Swarm",
    ["Moonfire"] = "Moonfire",
    ["Demoralizing Roar"] = "Demoralizing Roar",
}

DebuffTracker.HunterDebuffs =
{
    ["Serpent Sting"] = "Serpent Sting",
    ["Viper Sting"] = "Viper Sting",
    ["Hunter's Mark"] = "Hunter's Mark",
    ["Scorpid Sting"] = "Scorpid Sting",
}

DebuffTracker.RogueDebuffs =
{
    ["Hemorrhage"] = "Hemorrhage",
    ["Expose Armor"] = "Expose Armor",
    ["Garrote"] = "Garrote",
    ["Deadly Poison V"] = "Deadly Poison V",
    ["Rupture"] = "Rupture"
}

DebuffTracker.ShamanDebuffs =
{
    ["Flame Shock"] = "Flame Shock",
}