require("helpers.suffix")
require("stubs.levels")

---@param name string
---@param levels RobotUpgradeLevels
---@return string?
function get_upgraded_robot_with_levels(name, levels)
    if string.starts_with(name, ArchitectRobot) then
        return ArchitectRobot.. get_robot_suffix(levels)
    elseif string.starts_with(name, HaulerRobot) then
        return HaulerRobot .. get_robot_suffix(levels)
    end
end