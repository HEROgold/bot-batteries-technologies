require("vars.strings")

---@type table<LuaSettings>
local energy_roboport_settings = {
    {
        type = "double-setting",
        name = InputFlowLimitModifier,
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = BufferCapacityModifier,
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = RechargeMinimumModifier,
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = EnergyUsageModifier,
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
    {
        type = "double-setting",
        name = ChargingEnergyModifier,
        setting_type = "startup",
        minimum_value = 0.1,
        default_value = 1,
    },
}
---@type table<LuaSettings>
local logistical_roboport_settings = {
    {
        type = "int-setting",
        name = ConstructionAreaLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = LogisticAreaLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = RobotStorageLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = MaterialStorageLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
}
---@type table<LuaSettings>
local research_settings = {
    {
        type = "int-setting",
        name = EnergyResearchLimit,
        setting_type = "startup",
        default_value = 9,
        maximum_value = 9
        --Maximum amount of research and roboport levels. > MASSIVELY impacts the game loading, as it becomes a*b*c amount. (a, b and c are all this setting)
    },
    {
        type = "int-setting",
        name = ResearchMinimum,
        setting_type = "startup",
        default_value = 3,
        maximum_value = 9
        -- Minimum amount of researches required
    },
    {
        type = "int-setting",
        name = RoboportResearchUpgradeCost,
        setting_type = "startup",
        default_value = 500,
        minimum_value = 1,
    },
    {
        type = "int-setting",
        name = RoboportResearchUpgradeTime,
        setting_type = "startup",
        default_value = 60,
        minimum_value = 1,
    },
}
---@type table<LuaSettings>
local mod_settings = {
    {
        type = "int-setting",
        name = UpgradeTimer,
        setting_type = "startup",
        minimum_value = 1,
        default_value = 8
    },
    {
        type = "bool-setting",
        name = ShowItems,
        setting_type = "startup",
        default_value = true
    },
}
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
        name = RobotCargoLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = RobotSpeedLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
    {
        type = "int-setting",
        name = RobotEnergyLimit,
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 9
    },
}

data:extend(energy_roboport_settings)
data:extend(logistical_roboport_settings)
data:extend(research_settings)
data:extend(mod_settings)
data:extend(robot_settings)
