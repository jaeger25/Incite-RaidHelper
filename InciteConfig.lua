local InciteConfig =
{
    type = "group",
    name = "Incite Raid Helper",
    args =
    {
        general =
        {
            name = "General",
            type = "group",
            args =
            {
                version =
                {
                    name = Incite.version,
                    type = "description", 
                }
            }
        },
        debuffTracker =
        {
            name = "Debuff Tracker",
            type = "group",
            args =
            {
                warriorDebuffs = 
                {
                    name = "Warrior",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.WarriorDebuffs,
                },
                warlockDebuffs = 
                {
                    name = "Warlock",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.WarlockDebuffs,
                },
                priestDebuffs = 
                {
                    name = "Priest",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.PriestDebuffs,
                },
                mageDebuffs = 
                {
                    name = "Mage",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.MageDebuffs,
                },
                druidDebuffs = 
                {
                    name = "Druid",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.DruidDebuffs,
                },
                hunterDebuffs = 
                {
                    name = "Hunter",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.HunterDebuffs,
                },
                rogueDebuffs = 
                {
                    name = "Rogue",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.RogueDebuffs,
                },
                shamanDebuffs = 
                {
                    name = "Shaman",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    get = function(...) return DebuffTracker:GetIsDebuffDisallowed(...) end,
                    set = function(...) DebuffTracker:SetIsDebuffDisallowed(...) end,
                    values = DebuffTracker.ShamanDebuffs,
                },
            }
        }
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("Incite", InciteConfig)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Incite", "Incite Raid Helper", nil, "general")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Incite", InciteConfig.args.debuffTracker.name, "Incite Raid Helper", "debuffTracker")
_G["InciteConfig"] = InciteConfig
