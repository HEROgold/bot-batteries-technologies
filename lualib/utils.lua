utils = {}

---comments
---@param effectivity_level integer
---@param productivity_level integer
---@param speed_level integer
---@return string
utils.get_internal_suffix = function(effectivity_level, productivity_level, speed_level)
    -- e0p0s0 suffix for effectivity 0, productivity 0, speed 0
    effectivity_level = math.max(effectivity_level, 0)
    productivity_level = math.max(productivity_level, 0)
    speed_level = math.max(speed_level, 0)
    return tostring("e" .. effectivity_level .. "p" .. productivity_level .. "s" .. speed_level)
end

---comments
---@param construction_area_level integer
---@param logistic_area_level integer
---@param robot_storage_level integer
---@param material_storage_level integer
---@return string
utils.get_storage_suffix = function(construction_area_level, logistic_area_level, robot_storage_level, material_storage_level)
    construction_area_level = math.max(construction_area_level, 0)
    logistic_area_level = math.max(logistic_area_level, 0)
    robot_storage_level = math.max(robot_storage_level, 0)
    material_storage_level = math.max(material_storage_level, 0)
    return tostring("c" .. construction_area_level .. "l" .. logistic_area_level .. "r" .. robot_storage_level .. "m" .. material_storage_level)
end
