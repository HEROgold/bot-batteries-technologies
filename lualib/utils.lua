require("vars.settings")

utils = {}


---@param effectivity_level integer
---@param productivity_level integer
---@param speed_level integer
---@return string
utils.get_energy_suffix = function(effectivity_level, productivity_level, speed_level)
    -- e0p0s0 suffix for effectivity 0, productivity 0, speed 0
    -- todo: set a hard limit, which should be the amount of roboports we generate. (shouldn't be needed.)
    effectivity_level = utils.get_valid_bounds(effectivity_level, 0, energy_research_limit)
    productivity_level = utils.get_valid_bounds(productivity_level, 0, energy_research_limit)
    speed_level = utils.get_valid_bounds(speed_level, 0, energy_research_limit)
    return tostring("e" .. effectivity_level .. "p" .. productivity_level .. "s" .. speed_level)
end

---@param construction_area_level integer
---@param logistic_area_level integer
---@param robot_storage_level integer
---@param material_storage_level integer
---@return string
utils.get_storage_suffix = function(construction_area_level, logistic_area_level, robot_storage_level, material_storage_level)
    -- todo: set a hard limit, which should be the amount of roboports we generate. (shouldn't be needed.)
    construction_area_level = utils.get_valid_bounds(construction_area_level, 0, construction_area_limit)
    logistic_area_level = utils.get_valid_bounds(logistic_area_level, 0, logistic_area_limit)
    robot_storage_level = utils.get_valid_bounds(robot_storage_level, 0, robot_storage_limit)
    material_storage_level = utils.get_valid_bounds(material_storage_level, 0, material_storage_limit)
    return tostring("c" .. construction_area_level .. "l" .. logistic_area_level .. "r" .. robot_storage_level .. "m" .. material_storage_level)
end

---@param check number
---@param minimum number
---@param limit number
---@return number
utils.get_valid_bounds = function(check, minimum, limit)
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
