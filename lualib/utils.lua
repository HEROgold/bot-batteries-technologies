require("vars.settings")

utils = {}


---@param efficiency_level integer
---@param productivity_level integer
---@param speed_level integer
---@return string
utils.get_energy_suffix = function(efficiency_level, productivity_level, speed_level)
    efficiency_level = utils.get_valid_bounds(efficiency_level, 0, energy_efficiency_limit)
    productivity_level = utils.get_valid_bounds(productivity_level, 0, energy_productivity_limit)
    speed_level = utils.get_valid_bounds(speed_level, 0, energy_speed_limit)
    return tostring("e" .. efficiency_level .. "p" .. productivity_level .. "s" .. speed_level)
end

---@param construction_area_level integer
---@param logistic_area_level integer
---@param robot_storage_level integer
---@param material_storage_level integer
---@return string
utils.get_storage_suffix = function(construction_area_level, logistic_area_level, robot_storage_level, material_storage_level)
    construction_area_level = utils.get_valid_bounds(construction_area_level, 0, construction_area_limit)
    logistic_area_level = utils.get_valid_bounds(logistic_area_level, 0, logistic_area_limit)
    robot_storage_level = utils.get_valid_bounds(robot_storage_level, 0, robot_storage_limit)
    material_storage_level = utils.get_valid_bounds(material_storage_level, 0, material_storage_limit)
    return tostring("c" .. construction_area_level .. "l" .. logistic_area_level .. "r" .. robot_storage_level .. "m" .. material_storage_level)
end


---@param cargo_level integer
---@param speed_level integer
---@param energy_level integer
---@return string
utils.get_robot_suffix = function(cargo_level, speed_level, energy_level)
    -- c0s0e0 suffix for cargo 0, speed 0, energy 0
    cargo_level = utils.get_valid_bounds(cargo_level, 0, robot_cargo_research_limit)
    speed_level = utils.get_valid_bounds(speed_level, 0, robot_speed_research_limit)
    energy_level = utils.get_valid_bounds(energy_level, 0, robot_energy_research_limit)
    return tostring("c" .. cargo_level .. "s" .. speed_level .. "e" .. energy_level)
end


---@param check number
---@param minimum number
---@param limit number
---@return number
utils.get_valid_bounds = function(check, minimum, limit)
    -- TODO: move to library
    if check < minimum then
        return minimum
    end
    if check > limit then
        return limit
    end
    return check
end

utils.get_level_suffix = function(level)
    if level == 1 then
        return ""
    end
    return "-" .. level
end
