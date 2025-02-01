function update_modules(forceName, entities, entityType)
    for _, entity in pairs(entities) do
        local inventory --what type of inventory does this entity have?

        if entityType == "chest" then
            inventory = entity.get_inventory(defines.inventory.chest) --grab a chest's inventory

            -- upgrade logistc requests
            local logistics_point = entity.get_requester_point()
            if logistics_point ~= nil then
                for i = 1, logistics_point.sections_count do
                    local section = logistics_point.get_section(i)
                    for ii = 1, section.filters_count do
                        local slot = section.get_slot(ii)
                        if slot ~= nil
                            and slot.value ~= nil
                            and slot.value.name == "alien-hyper-module-" .. storage.currentmodulelevel[forceName] - 1 then
                            local current_filter = section.get_slot(ii)
                            section.set_slot(ii,
                                {
                                    value = { name = "alien-hyper-module-" .. storage.currentmodulelevel[forceName], quality = current_filter.value.quality, comparator = current_filter.value.comparator },
                                    min = current_filter.min,
                                    max = current_filter.max
                                })
                        end
                    end
                end
            end
        elseif entityType == "machine" then
            inventory = entity.get_module_inventory()                   --grab a machine's inventory
        elseif entityType == "player" then
            inventory = entity.get_main_inventory(defines.inventory.player_main) --grab a player's inventory

            -- update currently held items
            if entity.cursor_stack ~= nil and entity.cursor_stack.valid_for_read then
                if string.find(entity.cursor_stack.name, "^alien%-hyper%-module") then
                    --if theres a module in this inventory slot
                    if tonumber(string.match(entity.cursor_stack.name, "%d+$")) < storage.currentmodulelevel[forceName] then
                        --and its level is less than the "current" one
                        local old_count = entity.cursor_stack.count
                        local old_quality = entity.cursor_stack.quality
                        entity.cursor_stack.clear()                                                                                                                     --clear the slot
                        entity.cursor_stack.set_stack({ name = "alien-hyper-module-" ..
                        math.min(storage.currentmodulelevel[forceName], 100), count = old_count, quality = old_quality })                                               --add the updated level modules with whatever amount we recorded
                    end
                end

                if string.find(entity.cursor_stack.name, "^alien%-hyper%-magazine") then
                    --if theres a module in this inventory slot
                    if tonumber(string.match(entity.cursor_stack.name, "%d+$")) < storage.currentmodulelevel[forceName] then
                        --and its level is less than the "current" one
                        local old_count = entity.cursor_stack.count
                        local old_quality = entity.cursor_stack.quality

                        entity.cursor_stack.clear()                                                                                                                       --clear the slot
                        entity.cursor_stack.set_stack({ name = "alien-hyper-magazine-" ..
                        math.min(storage.currentmodulelevel[forceName], 100), count = old_count, quality = old_quality })                                                 --add the updated level modules with whatever amount we recorded
                    end
                end
            end

            -- upgrade logistc requests
            local logistics_point = entity.get_requester_point()
            if logistics_point ~= nil then
                for i = 1, logistics_point.sections_count do
                    local section = logistics_point.get_section(i)
                    for ii = 1, section.filters_count do
                        local slot = section.get_slot(ii)
                        if slot ~= nil
                            and slot.value ~= nil
                            and slot.value.name == "alien-hyper-module-" .. storage.currentmodulelevel[forceName] - 1 then
                            local current_filter = slot
                            section.set_slot(ii,
                                {
                                    value = { name = "alien-hyper-module-" .. storage.currentmodulelevel[forceName], quality = current_filter.value.quality, comparator = current_filter.value.comparator },
                                    min = current_filter.min,
                                    max = current_filter.max
                                })
                        end
                    end
                end
            end
        else
            return --error entity type not defined
        end

        if inventory == nil then
            return
        end

        for i = 1, #inventory, 1 do
            --loop through all of the entity's inventory slots
            local status, err = pcall(function()
                if string.find(inventory[i].name, "^alien%-hyper%-module") then
                    --if theres a module in this inventory slot
                    if tonumber(string.match(inventory[i].name, "%d+$")) < storage.currentmodulelevel[forceName] then
                        --and its level is less than the "current" one
                        local old_count = inventory[i].count --record amount
                        local old_quality = inventory[i].quality --record quality

                        inventory[i].clear()   --clear the slot

                        if entityType == "player" and inventory.get_filter(i) ~= nil then
                            -- check if slot is filtered
                            inventory.set_filter(i,
                                { name = "alien-hyper-module-" .. math.min(storage.currentmodulelevel[forceName], 100), quality =
                                old_quality })                                                                                                  --update filter
                        end

                        inventory[i].set_stack({ name = "alien-hyper-module-" ..
                        math.min(storage.currentmodulelevel[forceName], 100), count = old_count, quality = old_quality })                                        --add the updated level modules with whatever amount we recorded
                    end
                end

                if string.find(inventory[i].name, "^alien%-hyper%-magazine") then
                    --if theres a module in this inventory slot
                    if tonumber(string.match(inventory[i].name, "%d+$")) < storage.currentmodulelevel[forceName] then
                        --and its level is less than the "current" one
                        local old_count = inventory[i].count --record amount
                        local old_quality = inventory[i].quality --record quality

                        inventory[i].clear()   --clear the slot

                        if entityType == "player" and inventory.get_filter(i) ~= nil then
                            -- check if slot is filtered
                            inventory.set_filter(i,
                                "alien-hyper-magazine-" .. math.min(storage.currentmodulelevel[forceName], 100)) --update filter
                        end

                        inventory[i].set_stack({ name = "alien-hyper-magazine-" ..
                        math.min(storage.currentmodulelevel[forceName], 100), count = old_count, quality = old_quality })
                        --add the updated level modules with whatever amount we recorded
                    end
                end
            end)
        end
    end
end

function update_ammo(forceName, turrets)
    for _, entity in pairs(turrets) do
        local inventory = entity.get_inventory(defines.inventory.chest) --grab a chest's inventory

        if inventory == nil then
            return
        end

        for i = 1, #inventory, 1 do
            --loop through all of the entity's inventory slots
            local status, err = pcall(function()
                if string.find(inventory[i].name, "^alien%-hyper%-magazine") then
                    --if theres hyper ammo in the inventory slot
                    if tonumber(string.match(inventory[i].name, "%d+$")) < storage.currentmodulelevel[forceName] then
                        --and its level is less than the "current" one
                        local stacksize = inventory[i].count --record amount
                        inventory[i].clear() --clear the slot
                        inventory[i].set_stack({ name = "alien-hyper-magazine-" ..
                        math.min(storage.currentmodulelevel[forceName], 100), count = stacksize })
                    end
                end
            end)
        end
    end
end

function update_recipes(assemblers, force)
    for _, entity in ipairs(assemblers) do
        if entity.get_recipe() ~= nil then
            --if the assembler has a set recipe
            if string.find(entity.get_recipe().name, "^alien%-hyper%-module") then
                --and its one of ours
                local plates_to_refund = 0

                -- Save the number of modules in the output slot, crafting progress and bonus progress
                local finished_module_count = entity.get_inventory(defines.inventory.assembling_machine_output)
                .get_item_count("alien-hyper-module-" .. storage.currentmodulelevel[force.name] - 1)
                local crafting_progress = entity.crafting_progress
                local bonus_progress = entity.bonus_progress

                entity.set_recipe(force.recipes["alien-hyper-module-" .. storage.currentmodulelevel[force.name]]) --set it to the updated recipe

                -- Add the modules back
                if finished_module_count > 0 then
                    entity.get_inventory(defines.inventory.assembling_machine_output).insert { name = "alien-hyper-module-" .. storage.currentmodulelevel[force.name], count = finished_module_count }
                end
                -- Restore previous progress
                entity.crafting_progress = crafting_progress

                if bonus_progress > 0 and bonus_progress < 1 then
                    entity.bonus_progress = bonus_progress
                end
            end

            if settings.startup["alien-module-hyper-ammo-enabled"].value and string.find(entity.get_recipe().name, "^alien%-hyper%-magazine") then
                local finished_module_count = entity.get_inventory(defines.inventory.assembling_machine_output)
                .get_item_count("alien-hyper-module-" .. storage.currentmodulelevel[force.name] - 1)

                entity.set_recipe(force.recipes["alien-hyper-magazine-" .. storage.currentmodulelevel[force.name]]) --set it to the updated recipe

                if finished_module_count > 0 then
                    entity.get_inventory(defines.inventory.assembling_machine_output).insert {
                        name = "alien-hyper-magazine-" .. storage.currentmodulelevel[force.name],
                        count = finished_module_count
                    }
                end
            end
        end
    end
end

function update_quickbar(force)
    for _, player in pairs(force.players) do
        for i = 1, 100 do
            local slot = player.get_quick_bar_slot(i)
            if slot ~= nil and slot.name == "alien-hyper-module-" .. storage.currentmodulelevel[force.name] - 1 then
                player.set_quick_bar_slot(i, "alien-hyper-module-" .. storage.currentmodulelevel[force.name])
            end
        end
    end
end

function update_logistic_slots(force)
    for _, player in pairs(force.players) do
        if player.character ~= nil then
            --for i = 1, player.character.request_slot_count do
            --	local slot = player.get_personal_logistic_slot(i)
            --	if slot ~= nil and slot.name == "alien-hyper-module-" .. storage.currentmodulelevel[force.name] - 1 then
            --		player.set_personal_logistic_slot(i, { name = "alien-hyper-module-" .. storage.currentmodulelevel[force.name], min = slot.min, max = slot.max })
            --	end
            --
            --	if settings.startup["alien-module-hyper-ammo-enabled"].value and slot ~= nil and slot.name == "alien-hyper-magazine-" .. storage.currentmodulelevel[force.name] - 1 then
            --		player.set_personal_logistic_slot(i, { name = "alien-hyper-magazine-" .. storage.currentmodulelevel[force.name], min = slot.min, max = slot.max })
            --	end
            --end
        end
    end
end

--[[function update_trash_slots(players)
	for _, player in pairs(players) do
		local old_trash = player.auto_trash_filters
		local new_trash = {}

		for key, value in ipairs(old_trash) do
			player.print(key)
			player.print(value)
			if key ~= nil and key == "alien-hyper-module-" .. storage.currentmodulelevel - 1 then
				new_trash.insert("alien-hyper-module-" .. storage.currentmodulelevel, value)
			else
				new_trash.insert(key, value)
			end
		end

		player.print(new_trash)

		player.auto_trash_filters = new_trash
	end
end]]

function update_enabled_recipe(force)
    if force.technologies["automation"].researched then
        if storage.currentmodulelevel[force.name] > 1 then
            force.recipes["alien-hyper-module-1"].enabled = false
            force.recipes["alien-hyper-module-" .. storage.currentmodulelevel[force.name] - 1].enabled = false
            force.recipes["alien-hyper-module-" .. storage.currentmodulelevel[force.name]].enabled = true
        end
    end

    if force.technologies["military"].researched and settings.startup["alien-module-hyper-ammo-enabled"].value then
        if storage.currentmodulelevel[force.name] > 1 then
            force.recipes["alien-hyper-magazine-1"].enabled = false
            force.recipes["alien-hyper-magazine-" .. storage.currentmodulelevel[force.name] - 1].enabled = false
            force.recipes["alien-hyper-magazine-" .. storage.currentmodulelevel[force.name]].enabled = true
        else
            force.recipes["alien-hyper-magazine-1"].enabled = true
        end
    end
end

-- not in use yet, prototype for later use
function update_modules_on_surface(surface, force)
    local names = {}
    local modulesOnGround = surface.find_entities_filtered { force = force, name = 'item-on-ground' }
    local current_module_name = 'alien-hyper-module-' .. tostring(math.min(storage.currentmodulelevel[force.name], 100))
    local current_magazine_name = 'alien-hyper-magazine-' ..
    tostring(math.min(storage.currentmodulelevel[force.name], 100))

    for index, module_on_ground in pairs(modulesOnGround) do
        --game.print(module_on_ground.stack.name)
        local real_name = module_on_ground.stack.name
        local module_pos = module_on_ground.position
        local item_count = module_on_ground.stack.count
        if (string.find(real_name, "^alien%-hyper%-module") and real_name ~= current_module_name) then
            module_on_ground.destroy()
            surface.create_entity { name = 'item-on-ground', position = module_pos, stack = { name = current_module_name, count = item_count } }
        end

        if settings.startup["alien-module-hyper-ammo-enabled"].value and (string.find(real_name, "^alien%-hyper%-magazine") and real_name ~= current_magazine_name) then
            module_on_ground.destroy()
            surface.create_entity { name = 'item-on-ground', position = module_pos, stack = { name = current_magazine_name, count = item_count } }
        end
    end
end


-- Every 10 seconds: calculate the module level and upgrade hyper modules if level floor value changed
script.on_nth_tick(600, function(event)
    update_gui()

    -- if the modulelevel is raised by the kill, increase the level of all hyper modules by finding and replacing them
    for _, force in pairs(game.forces) do
        if not storage.ignoredalienmodulefactions[force.name] then
            local forceName = force.name
            -- check for force if not present
            verifyCountersForForce(forceName)

            storage.modulelevel[forceName] = math.max(math.floor(modulelevel(forceName)), 1)
            if (storage.modulelevel[forceName] > storage.currentmodulelevel[forceName]) then
                storage.currentmodulelevel[forceName] = storage.currentmodulelevel[forceName] + 1

                --update what module recipe is enabled
                update_enabled_recipe(force)

                for _, surface in pairs(game.surfaces) do
                    local assemblers = surface.find_entities_filtered { force = forceName, type = "assembling-machine" }
                    local miners = surface.find_entities_filtered { force = forceName, type = "mining-drill" }
                    local labs = surface.find_entities_filtered { force = forceName, type = "lab" }
                    local furnaces = surface.find_entities_filtered { force = forceName, type = "furnace" }
                    local rocketSilos = surface.find_entities_filtered { force = forceName, name = "rocket-silo" }
                    local chests = surface.find_entities_filtered { force = forceName, type = "container" }
                    local logisticChests = surface.find_entities_filtered { force = forceName, type = "logistic-container" }
                    local beacons = surface.find_entities_filtered { force = forceName, type = "beacon" }
                    local turrets = surface.find_entities_filtered { force = forceName, type = "ammo-turret" }

                    update_modules(forceName, assemblers, "machine")
                    update_modules(forceName, miners, "machine")
                    update_modules(forceName, labs, "machine")
                    update_modules(forceName, furnaces, "machine")
                    update_modules(forceName, rocketSilos, "machine")
                    update_modules(forceName, chests, "chest")
                    update_modules(forceName, logisticChests, "chest")
                    update_modules(forceName, beacons, "machine")

                    if settings.startup["alien-module-hyper-ammo-enabled"].value then
                        update_ammo(forceName, turrets)
                    end

                    -- for _, force in pairs(game.forces) do
                    update_recipes(assemblers, force)
                    -- end

                    update_modules_on_surface(surface, force)
                end
                update_modules(force.name, force.players, "player")
                -- play level up sound
                for _, player in pairs(force.players) do
                    player.play_sound { path = 'alien-level-up' }
                end
                update_quickbar(force)
                update_logistic_slots(force)
                -- update_trash_slots(players)
                pp(force, 'gui.module-upgraded', storage.modulelevel[force.name])
            else
                --every 10 seconds update what module recipe is enabled
                if event.tick % 600 == 0 then
                    update_enabled_recipe(force)
                end
            end
        end
    end
end)
