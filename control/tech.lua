---@param force LuaForce
---@param name string
---@param level number
function get_tech_level(force, name, level)
    --- TODO: move to library
    local suffix = utils.get_level_suffix(level)
    local tech_name = name .. suffix
    if force.technologies[tech_name].researched then
        return level
    end
    return 0
end

---@param force LuaForce
---@return table<number, number, number, number>
function get_logistical_levels(force)
    levels = {0, 0, 0, 0}
    for i, name in ipairs{
        RoboportConstructionArea,
        RoboportLogisticsArea,
        RoboportRobotStorage,
        RoboportMaterialStorage
    } do
        for level = 1, research_minimum, 1 do
            levels[i] = get_tech_level(force, name, level)
        end
    end
    return levels
end

---@param force LuaForce
---@return table<number, number, number>
function get_energy_levels(force)
    local levels = {0, 0, 0}
    for i, name in ipairs{
        RoboportEfficiency,
        RoboportProductivity,
        RoboportSpeed
    } do
        for level = 1, research_minimum, 1 do
            local tech_level = get_tech_level(force, name, level)
            if levels[i] < tech_level then
                levels[i] = tech_level
            end
        end
    end
    return levels
end
