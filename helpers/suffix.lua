require("__heroic-library__.number")
require("vars.settings")
require("stubs.levels")

--- @param levels RobotUpgradeLevels
---@return string
get_robot_suffix = function(levels)
    return tostring(
        "c" .. number.within_bounds(levels.cargo, 0, robot_cargo_research_limit) ..
        "s" .. number.within_bounds(levels.speed, 0, robot_speed_research_limit) ..
        "e" .. number.within_bounds(levels.energy, 0, robot_energy_research_limit)
    )
end
