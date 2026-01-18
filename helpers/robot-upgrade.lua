require("__heroic-library__.string")

require("helpers.research")
require("helpers.upgrades")

--- Helper module for robot upgrade operations
local robot_upgrade = {}

---@param robot_name string
---@param force ForceID
---@return string?
function robot_upgrade.get_upgraded_name(robot_name, force)
    return get_upgraded_robot_with_levels(robot_name, get_research_levels(force))
end

---@param item ItemWithQualityCount
---@param force ForceID
---@return ItemWithQualityCounts?
function robot_upgrade.get_upgraded_item(item, force)
    ---@diagnostic disable-next-line: undefined-field
    local upgraded_name = robot_upgrade.get_upgraded_name(item.name, force)
    if not upgraded_name then return nil end
    
    ---@diagnostic disable-next-line: undefined-field
    return {
        name = upgraded_name,
        quality = item.quality,
        count = item.count
    }
end

---@param robot_name string
---@return boolean
function robot_upgrade.is_upgradeable(robot_name)
    return string.starts_with(robot_name, ArchitectRobot) or string.starts_with(robot_name, HaulerRobot)
end

return robot_upgrade
