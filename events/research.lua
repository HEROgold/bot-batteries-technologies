require("__heroic-library__.technology")
require("__heroic-library__.inventories")
require("vars.strings")
require("vars.settings")
require("helpers.suffix")
require("helpers.research")
require("helpers.upgrades")


---@param robot_name string
---@param force ForceID
---@return string?
local function get_upgraded_robot_name(robot_name, force)
    return get_upgraded_robot_with_levels(robot_name, get_research_levels(force))
end

---@param item ItemWithQualityCounts
---@param force ForceID
---@return ItemWithQualityCounts?
local function get_upgraded_robot_item(item, force)
    return {
        name = get_upgraded_robot_name(item.name, force),
        quality = item.quality,
        count = item.count
    }
end

---@param entity LuaEntity
---@param inventory defines.inventory
local function upgrade_robots_in_inventories(entity, inventory)
    local inventory = entity.get_inventory(inventory)
    if inventory == nil then return end

    ---@type ItemWithQualityCounts[]
    local contents = inventories.find(inventory, function(item)
        return string.starts_with(item.name, ArchitectRobot) or string.starts_with(item.name, HaulerRobot)
    end)
    for i, item in ipairs(contents) do
        local new_item = get_upgraded_robot_item(item, entity.force)
        if new_item == nil then goto continue end
        inventories.replace(inventory, item, new_item)
        ::continue::
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
        upgrade_robots_in_inventories(roboport, defines.inventory.roboport_robot)
    end
end

---@param robot LuaEntity
---@param surface LuaSurface
local function upgrade_robot_in_air(robot, surface)
    local upgraded_robot_name = get_upgraded_robot_name(robot.name, robot.force)
    if upgraded_robot_name == nil then return end

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
        upgrade_robots_in_inventories(chest, defines.inventory.chest)
    end
end


---@param entity LuaEntity
local function upgrade_robots_in_requests(entity)
    local logistics = entity.get_logistic_sections()
    if logistics == nil then return end

    for i = 1, logistics.sections_count do
        local section = logistics.get_section(i)
        if section == nil then goto continue end
        
        for j = 1, section.filters_count do
            local filter = section.filters[j]
            if filter == nil or filter.value == nil then goto continue end

            if (
                string.starts_with(filter.value.name, ArchitectRobot)
                or string.starts_with(filter.value.name, HaulerRobot)
            ) then
                local upgraded_robot_name = get_upgraded_robot_name(filter.value.name, entity.force)
                if upgraded_robot_name == nil then goto continue end

                --- @type LogisticFilter
                local new_filter = {
                    name = filter.name,
                    index = filter.index,
                    count = filter.count,
                    value = {
                        name = upgraded_robot_name,
                        type = filter.value.type,
                        quality = filter.value.quality,
                        comparator = filter.value.comparator,
                    }
                }
                section.set_slot(j, new_filter)
            end
        end
        ::continue::
    end
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_logistic_containers(event, surface)
    local containers = surface.find_entities_filtered{
        type = LogisticContainer,
        force = event.research.force
    }
    for _, chest in pairs(containers) do
        upgrade_robots_in_inventories(chest, defines.inventory.chest)
        upgrade_robots_in_inventories(chest, defines.inventory.logistic_container_trash)
        upgrade_robots_in_requests(chest)
    end
end

---@param event EventData.on_research_finished | EventData.on_research_reversed
---@param surface LuaSurface
local function upgrade_robots_in_air(event, surface)
    local robots = {}
    for _, surface in pairs(game.surfaces) do
        table.extend(robots, surface.find_entities_filtered {
            type = ConstructionRobot,
            force=event.research.force
        })
        table.extend(robots, surface.find_entities_filtered {
            type = LogisticRobot,
            force=event.research.force
        })
    end

    for _, robot in pairs(robots) do
        if string.starts_with(robot.name, ArchitectRobot) or string.starts_with(robot.name, HaulerRobot) then
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
