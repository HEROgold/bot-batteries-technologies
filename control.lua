require("lualib.utils")
require("__heroic_library__.utilities")

local upgrade_timer = tonumber(settings.startup["battery-roboport-upgrade-timer"].value)
local mod_roboport_name = "battery-roboport-mk-"

script.on_init(
    function ()
        Setup_Vars()
    end
)


function Setup_Vars()
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
end


local function get_level_from_name(to_check)
    local eff = string.sub(to_check, -5, -5)
    local prod = string.sub(to_check, -3, -3)
    local speed = string.sub(to_check, -1, -1)
    return {tonumber(eff), tonumber(prod), tonumber(speed)}
end

local function validate_roboport(roboport)
    if roboport == nil then
        return
    end
    if not roboport.valid then
        global.roboports_to_update[roboport] = nil
        return
    end

    local roboport_name = roboport.name
    if roboport_name == "roboport" then
        -- The entity is from vanilla Factorio
        return true
    elseif utilities.string_starts_with(roboport_name, mod_roboport_name) then
        local level = get_level_from_name(roboport_name)
        -- Check for correct levels, to avoid replacing already correct roboports.
        if level[1] ~= global.EffectivityResearchLevel or level[2] ~= global.ProductivityResearchLevel or level[3] ~= global.SpeedResearchLevel then
            return true
        end
    else
        -- Entity is from another mod
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
        or not utilities.string_starts_with(ghost.ghost_name, mod_roboport_name)
    ) then
        global.ghosts_to_update[ghost] = nil
        return false
    end
    return true
end

---@param entity LuaEntity
local function is_ghost_entity(entity)
    return entity.name == "entity-ghost" or entity.type == "entity-ghost"
end


---@param roboport LuaEntity
local function update_roboport_level(roboport)
    if not validate_roboport(roboport) then
        return
    end

    local surface = roboport.surface
    local old_energy = roboport.energy
    local suffix = utils.get_internal_suffix(global.EffectivityResearchLevel, global.ProductivityResearchLevel, global.SpeedResearchLevel)

    local created_rport = surface.create_entity{
        name = mod_roboport_name .. suffix,
        position = roboport.position,
        force = roboport.force,
        fast_replace = true,
        spill = false,
        create_build_effect_smoke = false,
        raise_built = false
    }

    created_rport.energy = old_energy
    global.roboports_to_update[roboport] = nil

    roboport.destroy()
end

---@param roboport LuaEntity
local function update_ghost_level(roboport)
    if not validate_ghost(roboport) then
        return
    end

    local surface = roboport.surface
    local to_create = {
        name = "entity-ghost",
        type = "entity-ghost",
        ghost_name = "roboport",
        ghost_type = "roboport",
        ghost_prototype = "roboport",
        position = roboport.position,
        force = roboport.force,
        fast_replace = true,
        spill = false,
        create_build_effect_smoke = false,
        raise_built = false
    }
    local created_rport = surface.create_entity(to_create)
    global.ghosts_to_update[roboport] = nil

    roboport.destroy()
end


local function tick_update_roboport_level()
    local roboport, needs_upgrade = next(global.roboports_to_update)
    if needs_upgrade then
        update_roboport_level(roboport)
    end
end


local function tick_update_ghost_level()
    local roboport, needs_downgrade = next(global.ghosts_to_update)
    if needs_downgrade then
        update_ghost_level(roboport)
    end
end


local function mark_all_roboports_for_update()
    for _, surface in pairs(game.surfaces) do
        for _, roboport in pairs(surface.find_entities_filtered{type = "roboport"}) do
            global.roboports_to_update[roboport] = true
        end
    end
end


script.on_event(defines.events.on_research_finished,
    function (event)
        if utilities.string_starts_with(event.research.name, "roboport-effectivity") then
            global.EffectivityResearchLevel = global.EffectivityResearchLevel + 1
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, "roboport-productivity") then
            global.ProductivityResearchLevel = global.ProductivityResearchLevel + 1
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, "roboport-speed") then
            global.SpeedResearchLevel = global.SpeedResearchLevel + 1
            mark_all_roboports_for_update()
        end
    end
)


script.on_event(defines.events.on_research_reversed,
    function (event)
        if utilities.string_starts_with(event.research.name, "roboport-effectivity") then
            global.EffectivityResearchLevel = global.EffectivityResearchLevel - 1
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, "roboport-productivity") then
            global.ProductivityResearchLevel = global.ProductivityResearchLevel - 1
            mark_all_roboports_for_update()
        elseif utilities.string_starts_with(event.research.name, "roboport-speed") then
            global.SpeedResearchLevel = global.SpeedResearchLevel - 1
            mark_all_roboports_for_update()
        end
    end
)


---@param entity LuaEntity
local function on_built(entity)
    if entity.name == "entity-ghost" or entity.type == "entity-ghost" then
        update_ghost_level(entity)
    end
    if entity.type == "roboport" then
        update_roboport_level(entity)
    end
end

---@param entity LuaEntity
local function on_remove(entity)
    global.roboports_to_update[entity] = nil
end

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.on_post_entity_died,
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
    },
function (event)
    if event.created_entity == nil or not event.created_entity.valid or event.entity == nil or not event.entity.valid then
        return
    end
    on_built(event.created_entity)
end
)

script.on_event(
    {
        defines.events.on_player_mined_entity,
        defines.events.on_robot_mined_entity,
        defines.events.on_entity_died,
        defines.events.script_raised_destroy,
    },
    function (event)
        if event.entity == nil or not event.entity.valid then
            return
        end
        on_remove(event.entity)
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
    "br-uninstall",
    "Forces roboports to be vanilla, usefull for uninstalling this mod",
    function ()
        for _, surface in pairs(game.surfaces) do
            for _, roboport in pairs(surface.find_entities_filtered{type = "roboport"}) do
                if not roboport.valid then
                    goto continue
                end
                if not utilities.string_starts_with(roboport.name, mod_roboport_name) or roboport.name == "roboport" then
                    goto continue
                end

                local old_energy = roboport.energy
                local created_rport = surface.create_entity{
                    name = "roboport",
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

script.on_event(defines.events.on_player_selected_area,
function(event)
    if event.item ~= "roboport-updater" then
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
