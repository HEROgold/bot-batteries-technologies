require("__heroic-library__.utilities")
require("helpers.suffix")
require("vars.settings")

--- Create Architect Robots
--- @param c number Cargo level
--- @param s number Speed level
--- @param e number Energy level
local function create_hauler_robot(c, s, e)
    local robot_item = table.deepcopy(hauler_item)
    local robot_entity = table.deepcopy(hauler_entity)

    local suffix = get_robot_suffix({cargo = c, speed = s, energy = e})
    local name = combine{HaulerRobotLeveled, suffix}

    robot_entity.localised_name = {"entity-name." .. HaulerRobotLeveled, tostring(c), tostring(s), tostring(e)}
    robot_item.localised_name = {"item-name." .. HaulerRobotLeveled, tostring(c), tostring(s), tostring(e)}

    robot_item.name = name
    robot_entity.name = name
    robot_item.hidden = true

    robot_item.place_result = robot_entity.name
    robot_entity.fast_replaceable_group = ConstructionRobot
    robot_entity.minable = robot_entity.minable
    robot_entity.minable.result = robot_item.name

    robot_entity.max_payload_size = c + hauler_entity.max_payload_size * c * modifier_max_payload_size
    robot_entity.speed = s + hauler_entity.speed * s * modifier_speed

    local energy = tonumber(string.match(robot_entity.max_energy, "%d+"))
    local suffix = string.match(robot_entity.max_energy, "%a+")
    robot_entity.max_energy = e + energy * e * modifier_max_energy .. suffix
    return robot_item, robot_entity
end

function add_hauler_robots()
    for c=0, robot_cargo_research_limit do
        for s=0, robot_speed_research_limit do
            for e=0, robot_energy_research_limit do
                robot_item, robot_entity = create_hauler_robot(c, s, e)

                if settings.startup[ShowItems].value == true then
                    robot_item.subgroup = ItemSubGroupRobot
                    data:extend({robot_item})
                end
                data:extend({robot_entity})
            end
        end
    end
end
