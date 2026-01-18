require("__heroic-library__.technology")
require("__heroic-library__.string")
require("__heroic-library__.table")
require("helpers.robot-upgrade")
require("helpers.inventory-upgrade")
require("helpers.filter-upgrade")

local robot_upgrade = require("helpers.robot-upgrade")
local inventory_upgrade = require("helpers.inventory-upgrade")
local filter_upgrade = require("helpers.filter-upgrade")

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_roboports(event, surface)
    local roboports = surface.find_entities_filtered{
        type = Roboport,
        force = event.research.force
    }
    for _, roboport in pairs(roboports) do
        inventory_upgrade.upgrade_robots(roboport, defines.inventory.roboport_robot)
    end
end

---@param robot LuaEntity
---@param surface LuaSurface
local function upgrade_robot_in_air(robot, surface)
    local upgraded_robot_name = robot_upgrade.get_upgraded_name(robot.name, robot.force)
    if not upgraded_robot_name then return end

    local to_create = table.deepcopy(robot)
    to_create.name = upgraded_robot_name
    surface.create_entity(table.unpack(to_create))
    robot.destroy()
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_containers(event, surface)
    local containers = surface.find_entities_filtered{
        type = Container,
        force = event.research.force
    }
    for _, chest in pairs(containers) do
        inventory_upgrade.upgrade_robots(chest, defines.inventory.chest)
    end
end


---@param entity LuaEntity
local function upgrade_robots_in_requests(entity)
    filter_upgrade.upgrade_logistic_filters(entity)
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_logistic_containers(event, surface)
    local containers = surface.find_entities_filtered{
        type = LogisticContainer,
        force = event.research.force
    }
    for _, chest in pairs(containers) do
        inventory_upgrade.upgrade_robots(chest, defines.inventory.chest)
        inventory_upgrade.upgrade_robots(chest, defines.inventory.logistic_container_trash)
        upgrade_robots_in_requests(chest)
    end
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_air(event, surface)
    local robots = {}
    for _, surf in pairs(game.surfaces) do
        table.extend(robots, surf.find_entities_filtered {
            type = "construction-robot",
            force = event.research.force
        })
        table.extend(robots, surf.find_entities_filtered {
            type = LogisticRobot,
            force = event.research.force
        })
    end

    for _, robot in pairs(robots) do
        if robot_upgrade.is_upgradeable(robot.name) then
            upgrade_robot_in_air(robot, surface)
        end
    end
end


---@param event EventData.on_research_finished | EventData.on_research_reversed
local function update_robots(event)
    local surfaces = game.surfaces
    for _, surface in pairs(surfaces) do
        upgrade_robots_in_roboports(event, surface)
        upgrade_robots_in_air(event, surface)
        upgrade_robots_in_containers(event, surface)
        upgrade_robots_in_logistic_containers(event, surface)
        -- TODO: when upgrade is applied, upgrade all bots found in 
        -- player inventory, ~~chest~~, on the floor, logistic settings, filters
        -- TODO: Adjust the available recipe to only make new upgraded variant.
        -- TODO: Upgrade all current recipes to the new upgraded variant.
    end
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
local function on_research_changed(event)
    if not string.starts_with(event.research.name, RobotUpgrade) then return end
    update_robots(event)
end

script.on_event(
    defines.events.on_research_finished,
    on_research_changed
)
script.on_event(
    defines.events.on_research_reversed,
    on_research_changed
)
