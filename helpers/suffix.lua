
---@param cargo_level integer
---@param speed_level integer
---@param energy_level integer
---@return string
get_robot_suffix = function(cargo_level, speed_level, energy_level)
    cargo_level = number.within_bounds(cargo_level, 0, energy_efficiency_limit)
    speed_level = number.within_bounds(speed_level, 0, energy_productivity_limit)
    energy_level = number.within_bounds(energy_level, 0, energy_speed_limit)
    return tostring("c" .. cargo_level .. "s" .. speed_level .. "e" .. energy_level)
end