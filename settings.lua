data:extend({
    {
        type = "int-setting",
        name = "battery-roboport-energy-research-limit",
        setting_type = "startup",
        default_value = 9,
        maximum_value = 9
        --Maximum amount of research and roboport levels. > MASSIVELY impacts the game loading, as it becomes a*b*c amount. (a, b and c are all this setting)
    },
    {
        type = "int-setting",
        name = "battery-roboport-energy-research-minimum",
        setting_type = "startup",
        default_value = 3,
        -- Minimum amount of researches required
    },
    {
        type = "double-setting",
        name = "battery-roboport-input-flow-limit-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "battery-roboport-buffer-capacity-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "battery-roboport-recharge-minimum-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "battery-roboport-energy-usage-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "battery-roboport-charging-energy-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
})