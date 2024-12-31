require("vars.strings")

---@diagnostic disable: assign-type-mismatch
---@type number
robot_cargo_research_limit = settings.startup[RobotCargoLimit].value
---@type number
robot_speed_research_limit = settings.startup[RobotSpeedLimit].value
---@type number
robot_energy_research_limit = settings.startup[RobotEnergyLimit].value
---@type number
robot_research_minimum = settings.startup[RobotResearchMinimum].value
