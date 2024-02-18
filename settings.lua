data:extend({
    {
        type = "double-setting",
        name = "battery-roboport-robot-battery-modifier",
        setting_type = "startup",
        default_value = 0.15,
    },
    {
        type = "int-setting",
        name = "battery-roboport-research-limit",
        setting_type = "startup",
        default_value = 100,
        description = "Maximum amount of research and roboport levels."
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