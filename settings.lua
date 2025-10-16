require("vars.strings")

---@type table<LuaSettings>
local robot_settings = {
    {
        type = "int-setting",
        name = RobotResearchMinimum,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = RobotLimitCargo,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = RobotLimitSpeed,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = RobotLimitEnergy,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },{
        type = "double-setting",
        name = ResearchModifierCargo,
        setting_type = "startup",
        default_value = 1,
    },{
        type = "double-setting",
        name = ResearchModifierSpeed,
        setting_type = "startup",
        default_value = 1,
    },{
        type = "double-setting",
        name = ResearchModifierEnergy,
        setting_type = "startup",
        default_value = 1,
    }, {
        type = "double-setting",
        name = ModifierMaxPayloadSize,
        setting_type = "startup",
        default_value = 1,
    }, {
        type = "double-setting",
        name = ModifierSpeed,
        setting_type = "startup",
        default_value = 1,
    }, {
        type = "double-setting",
        name = ModifierMaxEnergy,
        setting_type = "startup",
        default_value = 1,
    }
}

data:extend(robot_settings)