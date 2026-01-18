require("__heroic-library__.utilities")
require("__heroic-library__.energy")
require("helpers.suffix")

local Energy = require("__heroic-library__.energy")

--- Create Architect Robots
--- @param c number Cargo level
--- @param s number Speed level
--- @param e number Energy level
local function create_architect_robot(c, s, e)
    local robot_item = table.deepcopy(architect_item)
    local robot_entity = table.deepcopy(architect_entity)

    local suffix = get_robot_suffix({cargo = c, speed = s, energy = e})
    local name = "architect-robot-mk-" .. suffix

    robot_entity.localised_name = {"entity-name.architect-robot-mk-", tostring(c), tostring(s), tostring(e)}
    robot_item.localised_name = {"item-name.architect-robot-mk-", tostring(c), tostring(s), tostring(e)}

    robot_item.name = name
    robot_entity.name = name
    robot_item.hidden = true

    robot_item.place_result = robot_entity.name

    robot_entity.fast_replaceable_group = "construction-robot"
    robot_entity.minable = robot_entity.minable
    robot_entity.minable.result = robot_item.name

    robot_entity.max_payload_size = c + (architect_entity.max_payload_size * c * modifier_max_payload_size:get())
    robot_entity.speed = s + (architect_entity.speed * s * modifier_speed:get())

    -- Use Energy class for proper energy manipulation
    local base_energy = Energy.new(architect_entity.max_energy)
    local energy_multiplier = e * modifier_max_energy:get()
    local scaled_energy = Energy.new(architect_entity.max_energy)
    scaled_energy:set_value(base_energy:value() * (1 + energy_multiplier))
    robot_entity.max_energy = tostring(scaled_energy)
    return robot_item, robot_entity
end

function add_architect_robots()
    for c=0, robot_cargo_research_limit:get() do
        for s=0, robot_speed_research_limit:get() do
            for e=0, robot_energy_research_limit:get() do
                robot_item, robot_entity = create_architect_robot(c, s, e)

                if group_items:get() == true then
                    robot_item.subgroup = "item-sub-group-robot"
                end
                data:extend({robot_item})
                data:extend({robot_entity})
            end
        end
    end
end
