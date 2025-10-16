require("vars.strings")

---@diagnostic disable: assign-type-mismatch
---@type number
robot_cargo_research_limit = settings.startup[RobotLimitCargo].value
---@type number
robot_speed_research_limit = settings.startup[RobotLimitSpeed].value
---@type number
robot_energy_research_limit = settings.startup[RobotLimitEnergy].value
---@type number
robot_research_minimum = settings.startup[RobotResearchMinimum].value
---@type number
research_modifier_cargo = settings.startup[ResearchModifierCargo].value
---@type number
research_modifier_speed = settings.startup[ResearchModifierSpeed].value
---@type number
research_modifier_energy = settings.startup[ResearchModifierEnergy].value
---@type number
modifier_max_payload_size = settings.startup[ModifierMaxPayloadSize].value
---@type number
modifier_speed = settings.startup[ModifierSpeed].value
---@type number
modifier_max_energy = settings.startup[ModifierMaxEnergy].value
