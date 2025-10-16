
--- @param entity LuaEntity
function update_prototype(entity)
    local data = data.raw[entity.prototype.type][entity.prototype.name]

    if data.module_inventory_size ~= nil then
        -- Entity has a module inventory size defined in its prototype
        local slots = entity.get_module_inventory()
    end
    if data.input_inventory_size ~= nil then
        -- Entity has an input inventory size defined in its prototype
        local slots = entity.get_input_inventory() -- undefined ??
    end
    if data.output_inventory_size ~= nil then
        -- Entity has an output inventory size defined in its prototype
        local slots = entity.get_output_inventory()
    end
    if data.inventory_size ~= nil then
        -- Entity has an inventory size defined in its prototype
        for key, value in pairs(defines.inventory) do
            -- DEBUG
            local name_match = entity.get_inventory_name(value) == key
            log("Inventory name match: " .. tostring(name_match) .. " for " .. key)

            local slots = entity.get_inventory(value)
            if not slots then
                -- If the inventory is not defined, we can skip it
                goto continue
            end
            for key, item in pairs(slots.get_contents()) do
                -- For each robot item, upgrade it.
            end
            ::continue::
        end
    end
end
