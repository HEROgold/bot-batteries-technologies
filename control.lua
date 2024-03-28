require("lualib.utils")
require("__heroic_library__.utilities")

local max_effectivity_level = tonumber(settings.startup["battery-roboport-energy-research-limit"].value)
local max_productivity_level = tonumber(settings.startup["battery-roboport-energy-research-limit"].value)
local max_speed_level = tonumber(settings.startup["battery-roboport-energy-research-limit"].value)
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


function Get_level_from_name(to_check)
    local eff = string.sub(to_check, -5, -5)
    local prod = string.sub(to_check, -3, -3)
    local speed = string.sub(to_check, -1, -1)
    return {tonumber(eff), tonumber(prod), tonumber(speed)}
end

function Is_valid_roboport(roboport)
    local roboport_name = roboport.name

    if roboport_name == "roboport" then
        -- The entity is from vanilla Factorio
        return true
    elseif utilities.string_starts_with(roboport_name, mod_roboport_name) then
        local level = Get_level_from_name(roboport_name)
        -- Check for correct levels, to avoid replacing already correct roboports.
        if level[1] ~= global.EffectivityResearchLevel or level[2] ~= global.ProductivityResearchLevel or level[3] ~= global.SpeedResearchLevel then
            return true
        end
    else
        -- Entity is from another mod
        return false
    end
end

function Is_research_valid()
    Setup_Vars() -- Shouldn't need to be used here, but is here as a bandaid fix
    local eff = global.EffectivityResearchLevel > 0 and global.EffectivityResearchLevel <= max_effectivity_level
    local prod = global.ProductivityResearchLevel > 0 and global.ProductivityResearchLevel <= max_productivity_level
    local speed = global.SpeedResearchLevel > 0 and global.SpeedResearchLevel <= max_speed_level
    return eff and prod and speed
end


local function update_roboport_level()
    local roboport, needs_upgrade = next(global.roboports_to_update)

    if roboport == nil then
        return
    end

    if roboport.valid and needs_upgrade == true then
        local surface = roboport.surface
        if Is_valid_roboport(roboport) then
            local old_energy = roboport.energy
            local suffix = utils.get_internal_suffix(global.EffectivityResearchLevel, global.ProductivityResearchLevel, global.SpeedResearchLevel)

            local created_rport = surface.create_entity{
                name = mod_roboport_name .. suffix,
                position = roboport.position,
                force = roboport.force,
                fast_replace = true,
                spill = false,
                create_build_effect_smoke = false,
                raise_built = true
            }

            created_rport.energy = old_energy
            global.roboports_to_update[roboport] = nil

            roboport.destroy()
            end
    else
        global.roboports_to_update[roboport] = nil
    end
end


local function update_ghost_level()
    local roboport, needs_downgrade = next(global.ghosts_to_update)

    if roboport == nil then
        return
    end

    if roboport.valid and needs_downgrade == true then
        local surface = roboport.surface
        if roboport.name == "entity-ghost" and utilities.string_starts_with(roboport.ghost_name, mod_roboport_name) then
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
            }
            local created_rport = surface.create_entity(to_create)
            global.ghosts_to_update[roboport] = nil

            roboport.destroy()
            end
    else
        global.ghosts_to_update[roboport] = nil
    end
end


local function mark_all_roboports_for_update()
    for _, surface in pairs(game.surfaces) do
        for _, roboport in pairs(surface.find_entities_filtered{
            type = "roboport"
        }) do
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


---@param roboport LuaEntity
local function mark_roboport_for_update(roboport)
    global.roboports_to_update[roboport] = true
end


---@param roboport LuaEntity
local function mark_ghost_for_update(roboport)
    global.ghosts_to_update[roboport] = true
end


---@param to_update table<LuaEntity, boolean>
local function filter_to_update(to_update)
    for roboport, needs_update in pairs(to_update) do
        if roboport == nil then
            goto continue
        elseif roboport.valid == false then
            to_update[roboport] = nil
        end
    ::continue::
    end
end


---@param entity LuaEntity
local function on_built(entity)
    if entity.name == "entity-ghost" or entity.type == "entity-ghost" then
        mark_ghost_for_update(entity)
    end
    if entity.type == "roboport" then
        mark_roboport_for_update(entity)
    end
end

---@param entity LuaEntity
local function on_remove(entity)
    global.roboports_to_update[entity] = nil
end

script.on_event(defines.events.on_built_entity,
function (event)
    on_built(event.created_entity)
end
)
script.on_event(defines.events.on_robot_built_entity,
function (event)
    on_built(event.created_entity)
end
)
script.on_event(defines.events.on_post_entity_died,
function (event)
    if event.ghost == nil then
        return
    end
    on_built(event.ghost)
end)

script.on_event(defines.events.script_raised_built,
function (event)
    on_built(event.entity)
end)

script.on_nth_tick(
    upgrade_timer,
    function ()
        filter_to_update(global.roboports_to_update)
        filter_to_update(global.ghosts_to_update)
        update_roboport_level()
        update_ghost_level()
    end
)

script.on_event(defines.events.on_player_mined_entity,
    function (event)
        on_remove(event.entity)
    end
)
script.on_event(defines.events.on_robot_mined_entity,
function (event)
    on_remove(event.entity)
end
)
script.on_event(defines.events.on_entity_died,
function (event)
    on_remove(event.entity)
end
)
script.on_event(defines.events.script_raised_destroy,
function (event)
    on_remove(event.entity)
end
)

local function clear_marked()
    global.roboports_to_update = {}
    global.ghosts_to_update = {}
end

commands.add_command(
    "battery-roboport-upgrade-all",
    "Forces all roboports to be checked for upgrades",
    function ()
        mark_all_roboports_for_update()
        game.print(#global.roboports_to_update .. " roboports marked for upgrade")
        game.print(#global.ghosts_to_update .. " ghosts marked for update")
    end
)

commands.add_command(
    "battery-roboport-clear-marked",
    "Forces all marked roboports and ghosts to be unmarked",
    function ()
        clear_marked()
        total = #global.roboports_to_update + #global.ghosts_to_update
        game.print("Cleared all marked roboports, left with " .. total .. " roboports after clear")
    end
)

commands.add_command(
    "battery-roboport-force-upgrade-all",
    "Forces all roboports to be checked for upgrades (shortcut for  clear-marked and upgrade-all)",
    function ()
        clear_marked()
        total = #global.roboports_to_update + #global.ghosts_to_update
        game.print("Cleared all marked roboports, left with " .. total .. " roboports after clear")
        mark_all_roboports_for_update()
        game.print(#global.roboports_to_update .. " roboports marked for upgrade")
        game.print(#global.ghosts_to_update .. " ghosts marked for update")
    end
)
