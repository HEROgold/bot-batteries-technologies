---@diagnostic disable: undefined-field


local base_roboport_entity = data.raw["roboport"]["roboport"]
local base_roboport_item = data.raw["item"]["roboport"]
local maximum_level = tonumber(settings.startup["battery-roboport-research-limit"].value)
local input_flow_limit_modifier = tonumber(settings.startup["battery-roboport-input-flow-limit-modifier"].value)
local buffer_capacity_modifier = tonumber(settings.startup["battery-roboport-buffer-capacity-modifier"].value)
local recharge_minimum_modifier = tonumber(settings.startup["battery-roboport-recharge-minimum-modifier"].value)
local energy_usage_modifier = tonumber(settings.startup["battery-roboport-energy-usage-modifier"].value)
local charging_energy_modifier = tonumber(settings.startup["battery-roboport-charging-energy-modifier"].value)


for i=1, maximum_level
do
    RoboportIncrItem = table.deepcopy(base_roboport_item)
    local name = tostring("battery-roboport-mk-" .. i)
    RoboportIncrItem.name = name
    RoboportIncrItem.localised_name = "Battery Roboport Mk. " .. i
    RoboportIncrItem.place_result = name
    data:extend({RoboportIncrItem})
end


for i=1, maximum_level
do
    RoboportIncrEntity = table.deepcopy(base_roboport_entity)

    if i < maximum_level then
        RoboportIncrEntity.next_upgrade = tostring("battery-roboport-mk-" .. i+1)
    end

    -- RoboportIncrEntity.type = "roboport"
    RoboportIncrEntity.name = tostring("battery-roboport-mk-" .. i)
    RoboportIncrEntity.localised_name = "Battery Roboport Mk. " .. i
    RoboportIncrEntity.fast_replaceable_group = "battery-roboports"
    RoboportIncrEntity.energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        input_flow_limit = tostring(5+ 5*i*input_flow_limit_modifier) .. "MW", --5 is default, add same amount for each level
        buffer_capacity = tostring(100+ 100*i*buffer_capacity_modifier) .. "MJ" --100 is default, add same amount for each level
    }
    RoboportIncrEntity.recharge_minimum = tostring(50+ 50*i*recharge_minimum_modifier) .. "MJ" --50 is defualt in mj, add same amount for each level
    RoboportIncrEntity.energy_usage = tostring(200+ 200*i*energy_usage_modifier) .. "kW" -- 200 is default in kw, add same amount for each level
    RoboportIncrEntity.charging_energy = tostring(500+ 500*i*charging_energy_modifier) .. "kW" -- 500 is default in kw, add same amount for each level

    -- RoboportIncrEntity.robot_slots_count = 5 + math.floor(i/10) -- 7 is default amount of slots for robots inside roboport, increment every 10 upgrades
    -- RoboportIncrEntity.material_slots_count = 5 + math.floor(i/10) -- 7 is default slots for repair packs, increment every 10 upgrades
    -- RoboportIncrEntity.charge_approach_distance = 5 .. math.floor(i/5) -- 5 is default approach distance, increase by 1 for every 5 upgrades
    -- RoboportIncrEntity.logistics_radius = 25 -- default radius for roboports logistics
    -- RoboportIncrEntity.construction_radius = 55 -- default radius for roboports construction
    data:extend({RoboportIncrEntity})
end
