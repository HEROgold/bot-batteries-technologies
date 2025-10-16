require("stubs.levels")
require("vars.strings")
require("vars.settings")

---@param force ForceID
---@return RobotUpgradeLevels
function get_research_levels(force)
    local force = game.forces[force.name]
    return {
        cargo = get_highest_researched_level(force, RobotUpgradeCargo) * research_modifier_cargo,
        speed = get_highest_researched_level(force, RobotUpgradeSpeed) * research_modifier_speed,
        energy = get_highest_researched_level(force, RobotUpgradeEnergy) * research_modifier_energy
    }
end
