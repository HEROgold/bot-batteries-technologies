require("__heroic_library__.find")

---@return table<LuaEntity>
function find_in_air()
    local entities = {}
    for _, surface in pairs(game.surfaces) do
        table.extend(entities, surface.find_entities_filtered { type = ArchitectRobotLeveled })
        table.extend(entities, surface.find_entities_filtered { type = HaulerRobotLeveled })
    end
    return entities
end
