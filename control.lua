require("lualib.utils")
require("__heroic_library__.utilities")
require("vars.strings")
require("vars.settings")

script.on_init(
    function ()
        Setup_Vars()
    end
)

local function initialize_storage_var(var_name, default_value)
    if storage[var_name] == nil then
        storage[var_name] = default_value
    end
end

function Setup_Vars()
    initialize_storage_var("EfficiencyResearchLevel", 0)
    initialize_storage_var("ProductivityResearchLevel", 0)
    initialize_storage_var("SpeedResearchLevel", 0)
    initialize_storage_var("ConstructionAreaResearchLevel", 0)
    initialize_storage_var("LogisticAreaResearchLevel", 0)
    initialize_storage_var("RobotStorageResearchLevel", 0)
    initialize_storage_var("MaterialStorageResearchLevel", 0)

    if storage.roboports_to_update == nil then
        ---@type table<LuaEntity, boolean>
        storage.roboports_to_update = {}
    end
    if storage.ghosts_to_update == nil then
        ---@type table<LuaEntity, boolean>
        storage.ghosts_to_update = {}
    end
end


local function energy_levels_from_name(to_check)
    local eff = string.sub(to_check, -5, -5)
    local prod = string.sub(to_check, -3, -3)
    local speed = string.sub(to_check, -1, -1)
    return {tonumber(eff), tonumber(prod), tonumber(speed)}
end

local function storage_levels_from_name(to_check)
    local c = string.sub(to_check, -7, -7)
    local l = string.sub(to_check, -5, -5)
    local r = string.sub(to_check, -3, -3)
    local m = string.sub(to_check, -1, -1)
    return {tonumber(c), tonumber(l), tonumber(r), tonumber(m)}
end


local function validate_roboport(roboport)
    if roboport == nil then
        return
    end
    if not roboport.valid then
        storage.roboports_to_update[roboport] = nil
        return
    end

    local roboport_name = roboport.name
    if roboport_name == Roboport then
        -- The entity is from vanilla Factorio
        return true
    elseif utilities.string_starts_with(roboport_name, RoboportEnergyLeveled) then
        local level = energy_levels_from_name(roboport_name)
        -- Check for correct levels, to avoid replacing already correct roboports.
        if (
            level[1] < storage.EfficiencyResearchLevel
            or level[2] < storage.ProductivityResearchLevel
            or level[3] < storage.SpeedResearchLevel
        ) then
            return true
        end
    elseif utilities.string_starts_with(roboport_name, RoboportLogisticalLeveled) then 
        local levels = storage_levels_from_name(roboport_name)
        if (
            levels[1] < storage.ConstructionAreaResearchLevel
            or levels[2] < storage.LogisticAreaResearchLevel
            or levels[3] < storage.RobotStorageResearchLevel
            or levels[4] < storage.MaterialStorageResearchLevel
        ) then
            return true
        end
    elseif utilities.string_starts_with(roboport_name, RoboportEnergy) then
        return true
    elseif utilities.string_starts_with(roboport_name, RoboportLogistical) then
        return true
    else
        return false
    end
end


---@param ghost LuaEntity
---@return boolean
local function validate_ghost(ghost)
    if ghost == nil then
        return false
    end
    if (
        not ghost.valid
        or not utilities.string_starts_with(ghost.ghost_name, RoboportEnergyLeveled)
        and not utilities.string_starts_with(ghost.ghost_name, RoboportLogisticalLeveled)
    ) then
        storage.ghosts_to_update[ghost] = nil
        return false
    end
    return true
end

---@param entity LuaEntity
local function is_ghost_entity(entity)
    return entity.name == EntityGhost or entity.type == EntityGhost
end


---@param roboport LuaEntity
local function update_energy_roboport_level(roboport)
    local surface = roboport.surface
    local old_energy = roboport.energy
    local suffix = utils.get_energy_suffix(
        storage.EfficiencyResearchLevel,
        storage.ProductivityResearchLevel,
        storage.SpeedResearchLevel
    )

    local created_rport = surface.create_entity{
        name = RoboportEnergyLeveled .. suffix,
        position = roboport.position,
        force = roboport.force,
        fast_replace = true,
        spill = false,
        create_build_effect_smoke = false,
        raise_built = false,
        quality = roboport.quality
    }

    created_rport.energy = old_energy
    storage.roboports_to_update[roboport] = nil

    roboport.destroy()
end

---@param roboport LuaEntity
local function update_storage_roboport_level(roboport)
    local surface = roboport.surface
    local old_energy = roboport.energy
    local storage_suffix = utils.get_storage_suffix(
        storage.ConstructionAreaResearchLevel,
        storage.LogisticAreaResearchLevel,
        storage.RobotStorageResearchLevel,
        storage.MaterialStorageResearchLevel
    )

    local created_rport = surface.create_entity{
        name = RoboportLogisticalLeveled .. storage_suffix,
        position = roboport.position,
        force = roboport.force,
        fast_replace = true,
        spill = false,
        create_build_effect_smoke = false,
        raise_built = false,
        quality = roboport.quality,
    }

    created_rport.energy = old_energy
    storage.roboports_to_update[roboport] = nil

    roboport.destroy()
end


---@param roboport LuaEntity
local function update_ghost_level(roboport)
    if not validate_ghost(roboport) then
        return
    end

    local to_create = {}

    if utilities.string_starts_with(roboport.ghost_name, RoboportLogisticalLeveled) then
        local suffix = utils.get_storage_suffix(
            storage.ConstructionAreaResearchLevel,
            storage.LogisticAreaResearchLevel,
            storage.RobotStorageResearchLevel,
            storage.MaterialStorageResearchLevel
        )
        to_create = {
            name = EntityGhost,
            type = EntityGhost,
            ghost_name = RoboportLogistical,
            ghost_ype = Roboport,
            ghost_prototype = Roboport,
            position = roboport.position,
            force = roboport.force,
            fast_replace = true,
            spill = false,
            create_build_effect_smoke = false,
            raise_built = false,
            quality = roboport.quality
        }
    elseif utilities.string_starts_with(roboport.ghost_name, RoboportEnergy) then
        local suffix = utils.get_energy_suffix(
            storage.EfficiencyResearchLevel,
            storage.ProductivityResearchLevel,
            storage.SpeedResearchLevel
        )
        to_create = {
            name = EntityGhost,
            type = EntityGhost,
            ghost_name = RoboportEnergy,
            ghost_type = Roboport,
            ghost_prototype = Roboport,
            position = roboport.position,
            force = roboport.force,
            fast_replace = true,
            spill = false,
            create_build_effect_smoke = false,
            raise_built = false,
            quality = roboport.quality
        }
    end

    local surface = roboport.surface
    local created_rport = surface.create_entity(to_create)
    storage.ghosts_to_update[roboport] = nil

    roboport.destroy()
end

---@param roboport LuaEntity
local function update_roboport_level(roboport)
    if not validate_roboport(roboport) then
        return
    end

    -- game.print("Updating roboport: " .. roboport.name)
    if utilities.string_starts_with(roboport.name, RoboportLogistical) then
        update_storage_roboport_level(roboport)
    elseif utilities.string_starts_with(roboport.name, RoboportEnergy) then
        update_energy_roboport_level(roboport)
    end
end


local function tick_update_roboport_level()
    local roboport, needs_upgrade = next(storage.roboports_to_update)
    if needs_upgrade then
        update_roboport_level(roboport)
    end
end


local function tick_update_ghost_level()
    local roboport, needs_downgrade = next(storage.ghosts_to_update)
    if needs_downgrade then
        update_ghost_level(roboport)
    end
end


local function mark_all_roboports_for_update()
    for _, surface in pairs(game.surfaces) do
        -- TODO: This should be optimized to only check roboports that are actually affected by the research.
        -- Or seperate out energy and storage roboports, so we can only check the relevant ones.
        for _, roboport in pairs(surface.find_entities_filtered{type = Roboport}) do
            storage.roboports_to_update[roboport] = true
        end
    end
end


script.on_event(defines.events.on_research_finished,
    ---@param event EventData.on_research_finished
    function (event)
        if utilities.string_starts_with(event.research.name, RoboportEfficiency) then
            storage.EfficiencyResearchLevel = utils.get_valid_bounds(storage.EfficiencyResearchLevel + 1, 0, energy_research_limit)
        elseif utilities.string_starts_with(event.research.name, RoboportProductivity) then
            storage.ProductivityResearchLevel = utils.get_valid_bounds(storage.ProductivityResearchLevel + 1, 0, energy_research_limit)
        elseif utilities.string_starts_with(event.research.name, RoboportSpeed) then
            storage.SpeedResearchLevel = utils.get_valid_bounds(storage.SpeedResearchLevel + 1, 0, energy_research_limit)
        elseif utilities.string_starts_with(event.research.name, RoboportConstructionArea) then
            storage.ConstructionAreaResearchLevel = utils.get_valid_bounds(storage.ConstructionAreaResearchLevel + 1, 0, construction_area_limit)
        elseif utilities.string_starts_with(event.research.name, RoboportLogisticsArea) then
            storage.LogisticAreaResearchLevel = utils.get_valid_bounds(storage.LogisticAreaResearchLevel + 1, 0, logistic_area_limit)
        elseif utilities.string_starts_with(event.research.name, RoboportMaterialStorage) then
            storage.MaterialStorageResearchLevel = utils.get_valid_bounds(storage.MaterialStorageResearchLevel + 1, 0, material_storage_limit)
        elseif utilities.string_starts_with(event.research.name, RoboportRobotStorage) then
            storage.RobotStorageResearchLevel = utils.get_valid_bounds(storage.RobotStorageResearchLevel + 1, 0, robot_storage_limit)
        else
            return
        end
        mark_all_roboports_for_update()
    end
)


script.on_event(defines.events.on_research_reversed,
    ---@param event EventData.on_research_reversed
    function (event)
        if utilities.string_starts_with(event.research.name, RoboportEfficiency) then
            storage.EfficiencyResearchLevel = utils.get_valid_bounds(storage.EfficiencyResearchLevel - 1, 0, energy_research_limit)
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, RoboportProductivity) then
            storage.ProductivityResearchLevel = utils.get_valid_bounds(storage.ProductivityResearchLevel - 1, 0, energy_research_limit)
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, RoboportSpeed) then
            storage.SpeedResearchLevel = utils.get_valid_bounds(storage.SpeedResearchLevel - 1, 0, energy_research_limit)
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, RoboportConstructionArea) then
            storage.ConstructionAreaResearchLevel = utils.get_valid_bounds(storage.ConstructionAreaResearchLevel - 1, 0, construction_area_limit)
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, RoboportLogisticsArea) then
            storage.LogisticAreaResearchLevel = utils.get_valid_bounds(storage.LogisticAreaResearchLevel - 1, 0, logistic_area_limit)
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, RoboportMaterialStorage) then
            storage.MaterialStorageResearchLevel = utils.get_valid_bounds(storage.MaterialStorageResearchLevel - 1, 0, material_storage_limit)
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, RoboportRobotStorage) then
            storage.RobotStorageResearchLevel = utils.get_valid_bounds(storage.RobotStorageResearchLevel - 1, 0, robot_storage_limit)
            mark_all_roboports_for_update()
        end
    end
)


---@param entity LuaEntity
local function on_built(entity)
    if entity.name == EntityGhost or entity.type == EntityGhost then
        validate_ghost(entity)
        update_ghost_level(entity)
    elseif entity.type == Roboport then
        validate_roboport(entity)
        update_roboport_level(entity)
    end
end


script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.on_post_entity_died,
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
    },
    ---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.on_post_entity_died | EventData.script_raised_built | EventData.script_raised_revive
function (event)
    if event.ghost then
        on_built(event.ghost)
        return
    end
    if event.entity then
        on_built(event.entity)
        return
    end
    if event.created_entity then
        on_built(event.created_entity)
        return
    end
end
)

script.on_event(
    {
        defines.events.on_player_mined_entity,
        defines.events.on_robot_mined_entity,
        defines.events.on_entity_died,
        defines.events.script_raised_destroy,
    },
    ---@param event EventData.on_player_mined_entity | EventData.on_robot_mined_entity | EventData.on_entity_died | EventData.script_raised_destroy
    function (event)
        if event.entity == nil or not event.entity.valid then
            return
        end
        storage.roboports_to_update[event.entity] = nil
    end
)

script.on_nth_tick(
    upgrade_timer,
    function ()
        tick_update_roboport_level()
        tick_update_ghost_level()
    end
)

commands.add_command(
    "br-show",
    "Shows the current research levels",
    function ()
        game.print("-- Energy --")
        game.print("efficiency: " .. storage.EfficiencyResearchLevel)
        game.print("Productivity: " .. storage.ProductivityResearchLevel)
        game.print("Speed: " .. storage.SpeedResearchLevel)
        game.print("-- Storage --")
        game.print("Construction Area: " .. storage.ConstructionAreaResearchLevel)
        game.print("Logistics Area: " .. storage.LogisticAreaResearchLevel)
        game.print("Robot Storage: " .. storage.RobotStorageResearchLevel)
        game.print("Material Storage: " .. storage.MaterialStorageResearchLevel)
    end
)


commands.add_command(
    "br-uninstall",
    "Forces roboports to be vanilla, usefull for uninstalling this mod",
    function ()
        for _, surface in pairs(game.surfaces) do
            for _, roboport in pairs(surface.find_entities_filtered{type = Roboport}) do
                if not roboport.valid then
                    goto continue
                end

                if (
                    roboport.name == Roboport
                    or not utilities.string_starts_with(roboport.name, RoboportEnergy)
                    or not utilities.string_starts_with(roboport.name, RoboportEnergy)
                ) then
                    goto continue
                end

                local old_energy = roboport.energy
                local created_rport = surface.create_entity{
                    name = Roboport,
                    position = roboport.position,
                    force = roboport.force,
                    fast_replace = true,
                    spill = false,
                    create_build_effect_smoke = false,
                    raise_built = false
                }
                created_rport.energy = old_energy
                roboport.destroy()
                ::continue::
            end
        end
    end
)


commands.add_command(
    "br-uninstall",
    "Forces roboports to be vanilla, usefull for uninstalling this mod",
    function ()
        -- Reset all research levels
        -- Reset related technologies
        -- Reset all related roboports
    end
)

script.on_event(defines.events.on_player_selected_area,
    ---@param event EventData.on_player_selected_area
function(event)
    if event.item ~= RoboportUpdater then
        return
    end

    for _, entity in pairs(event.entities) do
        if is_ghost_entity(entity) then
            update_ghost_level(entity)
        else
            update_roboport_level(entity)
        end
    end
end
)
