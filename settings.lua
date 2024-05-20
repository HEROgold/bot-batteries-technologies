data:extend({
    {
        type = "int-setting",
        name = "energy-research-limit",
        setting_type = "startup",
        default_value = 9,
        maximum_value = 9
        --Maximum amount of research and roboport levels. > MASSIVELY impacts the game loading, as it becomes a*b*c amount. (a, b and c are all this setting)
    },
    {
        type = "int-setting",
        name = "energy-research-minimum",
        setting_type = "startup",
        default_value = 3,
        maximum_value = 9
        -- Minimum amount of researches required
    },
    {
        type = "double-setting",
        name = "input-flow-limit-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "buffer-capacity-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "recharge-minimum-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "energy-usage-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = "charging-energy-modifier",
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },{
        type = "int-setting",
        name = "upgrade-timer",
        setting_type = "startup",
        minimum_value = 1,
        default_value = 8
    },
    {
        type = "bool-setting",
        name = "show-items",
        setting_type = "startup",
        default_value = true
    },
    {
        type = "double-setting",
        name = "construction-area-limit",
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "double-setting",
        name = "logistic-area-limit",
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "double-setting",
        name = "robot-storage-limit",
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "double-setting",
        name = "material-storage-limit",
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    }
})