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
                debuffs = 
                {
                    name = "Disallowed Debuffs",
                    desc = "Select the debuffs which are not allowed.",
                    type = "multiselect",
                    values =
                    {
                        -- Warriors
                        "Rend",
                        "Mortal Strike",
                    }
                }
            }
        }
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("Incite", InciteConfig)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Incite", "Incite Raid Helper", nil, "general")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Incite", InciteConfig.args.debuffTracker.name, "Incite Raid Helper", "debuffTracker")
_G["InciteConfig"] = InciteConfig
