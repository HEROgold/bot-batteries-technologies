require("__heroic-library__.inventories")
require("vars.strings")
require("helpers.research")
require("helpers.upgrades")

--- Get all lower tier robots that should be requested based on current research levels
--- @param force ForceID
--- @return table<string, integer>
local function get_robots_to_request(force)
    local levels = get_research_levels(force)
    local robots_to_request = {}
    
    -- For each robot type (architect and hauler)
    for robot_type, base_name in pairs({architect = ArchitectRobot, hauler = HaulerRobot}) do
        -- Request all tiers below current research level
        for c = 0, levels.cargo do
            for s = 0, levels.speed do
                for e = 0, levels.energy do
                    -- Skip the highest tier (current research level)
                    if not (c == levels.cargo and s == levels.speed and e == levels.energy) then
                        local suffix = get_robot_suffix({cargo = c, speed = s, energy = e})
                        local robot_name = base_name .. suffix
                        -- Request a reasonable amount of each lower tier
                        robots_to_request[robot_name] = 100
                    end
                end
            end
        end
    end
    
    return robots_to_request
end

--- Update logistic requests for a tier-switcher roboport
--- @param entity LuaEntity
local function update_tier_switcher_requests(entity)
    if entity.name ~= TierSwitcherRoboport then return end
    if not entity.valid then return end
    
    local logistics = entity.get_logistic_sections()
    if logistics == nil then return end
    
    -- Clear existing sections and create new one
    logistics.sections_count = 1
    local section = logistics.get_section(1)
    if section == nil then return end
    
    -- Get robots to request based on current research
    local robots = get_robots_to_request(entity.force)
    
    -- Set filters for each robot type
    local filter_index = 1
    for robot_name, count in pairs(robots) do
        if filter_index > 1000 then break end -- Factorio has limits on filter count
        
        --- @type LogisticFilter
        local filter = {
            index = filter_index,
            count = count,
            value = {
                name = robot_name,
                type = "item",
                quality = "normal",
                comparator = "=",
            }
        }
        section.set_slot(filter_index, filter)
        filter_index = filter_index + 1
    end
end

--- Convert robots in the tier-switcher inventory to highest tier
--- @param entity LuaEntity
local function convert_robots_in_tier_switcher(entity)
    if entity.name ~= TierSwitcherRoboport then return end
    if not entity.valid then return end
    
    local inventory = entity.get_inventory(defines.inventory.chest)
    if inventory == nil then return end
    
    -- Find all robots in the inventory
    local contents = inventories.find(inventory, function(item)
        return string.starts_with(item.name, ArchitectRobot) or string.starts_with(item.name, HaulerRobot)
    end)
    
    -- Get current research levels
    local levels = get_research_levels(entity.force)
    
    -- Convert each robot to highest tier
    for _, item in ipairs(contents) do
        local upgraded_robot_name = get_upgraded_robot_with_levels(item.name, levels)
        if upgraded_robot_name == nil then goto continue end
        
        -- Create upgraded robot item
        local new_item = {
            name = upgraded_robot_name,
            quality = item.quality,
            count = item.count
        }
        
        -- Replace old robot with upgraded one
        inventories.replace(inventory, item, new_item)
        ::continue::
    end
end

--- Update all tier-switcher roboports on a surface
--- @param surface LuaSurface
--- @param force ForceID
local function update_all_tier_switchers(surface, force)
    local tier_switchers = surface.find_entities_filtered{
        name = TierSwitcherRoboport,
        force = force
    }
    
    for _, tier_switcher in pairs(tier_switchers) do
        update_tier_switcher_requests(tier_switcher)
    end
end

--- Handle research changes to update tier-switcher requests
--- @param event EventData.on_research_finished | EventData.on_research_reversed
local function on_research_changed(event)
    if not string.starts_with(event.research.name, RobotUpgrade) then return end
    
    -- Update all tier-switchers on all surfaces
    for _, surface in pairs(game.surfaces) do
        update_all_tier_switchers(surface, event.research.force)
    end
end

--- Handle entity placement to set initial requests
--- @param event EventData.on_built_entity | EventData.on_robot_built_entity
local function on_entity_created(event)
    local entity = event.created_entity or event.entity
    if not entity or not entity.valid then return end
    if entity.name ~= TierSwitcherRoboport then return end
    
    -- Set initial requests
    update_tier_switcher_requests(entity)
end

--- Handle inventory changes to convert robots
--- @param event EventData.on_entity_settings_pasted
local function on_inventory_changed(event)
    local entity = event.destination
    if not entity or not entity.valid then return end
    if entity.name ~= TierSwitcherRoboport then return end
    
    -- Convert any robots in the inventory
    convert_robots_in_tier_switcher(entity)
end

-- Register events
script.on_event(
    defines.events.on_research_finished,
    on_research_changed
)
script.on_event(
    defines.events.on_research_reversed,
    on_research_changed
)

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
    },
    on_entity_created
)

-- We need to check inventory periodically since there's no direct event for item insertion
-- We'll use on_tick with a modulo to check periodically
script.on_nth_tick(60, function(event) -- Check every second (60 ticks)
    for _, surface in pairs(game.surfaces) do
        local tier_switchers = surface.find_entities_filtered{
            name = TierSwitcherRoboport
        }
        
        for _, tier_switcher in pairs(tier_switchers) do
            convert_robots_in_tier_switcher(tier_switcher)
        end
    end
end)
