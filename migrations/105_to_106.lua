if global.EffectivityResearchLevel == nil then
    global.EffectivityResearchLevel = 0
end
if global.ProductivityResearchLevel == nil then
    global.ProductivityResearchLevel = 0
end
if global.SpeedResearchLevel == nil then
    global.SpeedResearchLevel = 0
end
if global.roboports_to_update == nil then
    ---@type table<LuaEntity, boolean>
    global.roboports_to_update = {}
end
if global.ghosts_to_update == nil then
    ---@type table<LuaEntity, boolean>
    global.ghosts_to_update = {}
end
