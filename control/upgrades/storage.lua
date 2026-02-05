---comments
---@param entity LuaEntity
function validate_storage(entity)
    for i, inventory in pairs(defines.inventory) do
        if entity.get_inventory(inventory) then
            return true
        end
    end
end

function get_previous_robot_level()
    return storage.previous_map_size
end

function get_current_robot_level()
    return storage.current_robot_level
end

---comments
---@param entity LuaEntity
---@param inventory_type defines.inventory
---@param item LuaItemStack
---@param upgraded_item LuaItemStack
function replace_item(entity, inventory_type, item, upgraded_item)
    local inventory = entity.get_inventory(inventory_type)
    if not inventory then
        return
    end
    local old_items = inventory.find_item_stack(item)
    if not old_items then
        return
    end
    old_count = inventory.remove(old_items)
    new_count = inventory.insert(upgraded_item)
end

---Upgrades robots in a given entity
---@param entity LuaEntity
function upgrade_robot(entity)
    if not validate_storage(entity) then
        return
    end
    for i, inventory in pairs(defines.inventory) do
        replace_item(entity, inventory, get_previous_robot_level(), get_current_robot_level())
    end
end

function upgrade_robots()
    for _, surface in pairs(game.surfaces) do
        for _, entity in pairs(surface.find_entities()) do
            upgrade_robot(entity)
        end
    end
end
