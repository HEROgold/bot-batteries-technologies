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
