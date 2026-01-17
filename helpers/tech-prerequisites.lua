require("__heroic-library__.utilities")
require("__heroic-library__.table")
require("vars.strings")

--- Helper module for technology prerequisite management
local tech_prerequisites = {}

---@param upgrade_name string
---@param level number
---@return table<TechnologyID>
function tech_prerequisites.get_space_age_prerequisites(upgrade_name, level)
    ---@type table<TechnologyID>
    local prerequisites = {}

    if level >= 1 then
        if upgrade_name == RobotUpgradeSpeed then
            table.insert(prerequisites, MetallurgicSciencePack)
        elseif upgrade_name == RobotUpgradeEnergy then
            table.insert(prerequisites, ElectromagneticSciencePack)
        elseif upgrade_name == RobotUpgradeCargo then
            table.insert(prerequisites, AgriculturalSciencePack)
        end
    end

    if level >= 2 then
        table.insert(prerequisites, CryogenicSciencePack)
    end

    if level >= 3 then
        table.insert(prerequisites, PromethiumSciencePack)
    end
    
    return prerequisites
end

---@param upgrade_name string
---@param level number
---@return string
function tech_prerequisites.get_module_prerequisite(upgrade_name, level)
    if upgrade_name == RobotUpgradeSpeed then
        return "speed-module-3"
    elseif upgrade_name == RobotUpgradeEnergy then
        return "efficiency-module-3"
    elseif upgrade_name == RobotUpgradeCargo then
        return "productivity-module-3"
    end
    return ""
end

---@param upgrade_name string
---@param level number
---@return table<TechnologyID>
function tech_prerequisites.get_all(upgrade_name, level)
    ---@type table<TechnologyID>
    local prerequisites = {}

    -- Add previous level as prerequisite
    if level > 1 then
        local prev_name = upgrade_name .. utilities.get_level_suffix(level - 1)
        table.insert(prerequisites, prev_name)
    end

    -- Add module prerequisite (limited to level 3)
    local module_level = math.min(level, 3)
    local module_prereq = tech_prerequisites.get_module_prerequisite(upgrade_name, module_level)
    if module_prereq ~= "" then
        table.insert(prerequisites, module_prereq)
    end

    -- Add Space Age prerequisites if mod is loaded
    if mods["space-age"] then
        table.extend(prerequisites, tech_prerequisites.get_space_age_prerequisites(upgrade_name, level))
    end

    return prerequisites
end

return tech_prerequisites
