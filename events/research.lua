require("__heroic_library__.technology")
require("vars.strings")
require("vars.settings")
require("helpers.suffix")

---@param force ForceID
---@return table<number, number, number>
local function get_research_levels(force)
    local force = game.forces[force.name]
    local levels = {0, 0, 0}
    levels[1] = get_highest_researched_level(force, RobotCargoUpgrade) * research_modifier_cargo
    levels[2] = get_highest_researched_level(force, RobotSpeedUpgrade) * research_modifier_speed
    levels[3] = get_highest_researched_level(force, RobotEnergyUpgrade) * research_modifier_energy
    return levels
end

---@param name string
---@param levels table<number, number, number>
local function get_upgraded_robot_name_from_levels(name, levels)
    if string.starts_with(name, ArchitectRobot) then
        return ArchitectRobot.. get_robot_suffix(levels[1], levels[2], levels[3])
    elseif string.starts_with(name, HaulerRobot) then
        return HaulerRobot .. get_robot_suffix(levels[1], levels[2], levels[3])
    end
end

---@param inventory LuaInventory
---@param item ItemWithQualityCounts
---@param force ForceID
local function upgrade_robot_in_inventory(inventory, item, force)
    local levels = get_research_levels(force)
    local upgraded_robot_name = get_upgraded_robot_name_from_levels(item.name, levels)
    if upgraded_robot_name == nil then return end

    inventory.remove({
        name = item.name,
        count = item.count,
        quality = item.quality
    })
    inventory.insert({
        name = upgraded_robot_name,
        count = item.count,
        quality = item.quality
    })
end

---@param roboport LuaEntity
local function upgrade_robots_in_roboport(roboport)
    local inventory = roboport.get_inventory(defines.inventory.roboport_robot)
    if inventory == nil then return end
    local force = roboport.force

    ---@type ItemWithQualityCounts[]
    local contents = inventory.get_contents()
    for i, item in ipairs(contents) do
        upgrade_robot_in_inventory(inventory, item, roboport.force)
    end
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_roboports(event, surface)
    local roboports = surface.find_entities_filtered{
        type = Roboport,
        force = event.research.force
    }
    for _, roboport in pairs(roboports) do
        upgrade_robots_in_roboport(roboport)
    end
end

---@param robot LuaEntity
---@param surface LuaSurface
local function upgrade_robot_in_air(robot, surface)
    local force = robot.force
    local levels = get_research_levels(force)
    local upgraded_robot_name = get_upgraded_robot_name_from_levels(robot.name, levels)
    if upgraded_robot_name == nil then return end

    local to_create = table.deepcopy(robot)
    to_create.name = upgraded_robot_name
    surface.create_entity(table.unpack(to_create))
    robot.destroy()
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_air(event, surface)
    local robots = surface.find_entities_filtered{
        type = Robot,
        force = event.research.force
    }

    for _, robot in pairs(robots) do
        upgrade_robot_in_air(robot, surface)
    end
end

script.on_event(
    defines.events.on_research_finished,
    ---@param event EventData.on_research_finished
    function (event)
        local surfaces = game.surfaces
        for _, surface in pairs(surfaces) do
            upgrade_robots_in_roboports(event, surface)
            -- TODO: when upgrade is applied, upgrade all bots found in 
            -- inventory, chest, on the floor, logistic settings, filters
            -- TODO: Adjust the available recipe to only make new upgraded variant.
            -- TODO: Upgrade all current recipes to the new upgraded variant.
        end
    end
)
script.on_event(
    defines.events.on_research_reversed,
    ---@param event EventData.on_research_reversed
    function (event) 
        local surfaces = game.surfaces
        for _, surface in pairs(surfaces) do
            upgrade_robots_in_roboports(event, surface)
            upgrade_robots_in_air(event, surface)
            -- TODO: when upgrade is applied, upgrade all bots found in 
            -- TODO: inventory, chest, on the floor, logistic settings, filters
            -- TODO: Adjust the available recipe to only make new upgraded variant.
            -- TODO: Upgrade all current recipes to the new upgraded variant.
        end
    end
)