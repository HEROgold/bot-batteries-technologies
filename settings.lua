
---@type Settings
local Settings = require("__heroic-library__.settings_manager").new("heroic-robots")
local startup = Settings:startup()

-- Int settings with min/max - store containers for use in control stage
robot_research_minimum = startup:default("robot-research-minimum", 3, {
    minimum = 1,
    maximum = 9
})

robot_cargo_research_limit = startup:default("robot-limit-cargo", 3, {
    minimum = 1,
    maximum = 9
})

robot_speed_research_limit = startup:default("robot-limit-speed", 3, {
    minimum = 1,
    maximum = 9
})

robot_energy_research_limit = startup:default("robot-limit-energy", 3, {
    minimum = 1,
    maximum = 9
})
research_maximum = startup:default("research-maximum", 99, {
    minimum = 1,
    maximum = 99
})
research_minimum = startup:default("research-minimum", 1, {
    minimum = 1,
    maximum = 99
})
research_upgrade_cost = startup:default("research-upgrade-cost", 500, {
    minimum = 1
})
research_upgrade_time = startup:default("research-upgrade-time", 30, {
    minimum = 1
})

research_modifier_cargo = startup:default("research-modifier-cargo", 1.0)
research_modifier_speed = startup:default("research-modifier-speed", 1.0)
research_modifier_energy = startup:default("research-modifier-energy", 1.0)
modifier_max_payload_size = startup:default("modifier-max-payload-size", 1.0)
modifier_speed = startup:default("modifier-speed", 1.0)
modifier_max_energy = startup:default("modifier-max-energy", 1.0)
group_items = startup:default("group-items", false)
