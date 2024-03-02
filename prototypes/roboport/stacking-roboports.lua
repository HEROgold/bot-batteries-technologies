---@diagnostic disable: undefined-field
require("lualib.utils")

local base_roboport_entity = data.raw["roboport"]["roboport"]
local base_roboport_item = data.raw["item"]["roboport"]
local input_flow_limit_modifier = tonumber(settings.startup["battery-roboport-input-flow-limit-modifier"].value)
local buffer_capacity_modifier = tonumber(settings.startup["battery-roboport-buffer-capacity-modifier"].value)
local recharge_minimum_modifier = tonumber(settings.startup["battery-roboport-recharge-minimum-modifier"].value)
local energy_usage_modifier = tonumber(settings.startup["battery-roboport-energy-usage-modifier"].value)
local charging_energy_modifier = tonumber(settings.startup["battery-roboport-charging-energy-modifier"].value)
local f = {}

f.generate_charging_offsets = function (n)
    local offsets = {}
    local min_offset = 1 -- 0.5
    local max_offset = 2 -- 1.5
    local step = 2 * math.pi / n

    for i = 0, n - 1 do
        local theta = step * i
        local r = (i % 2 == 0) and max_offset or min_offset
        local x = r * math.cos(theta)
        local y = r * math.sin(theta)
        table.insert(offsets, {x, y})
    end

    return offsets
end


f.add_all_roboports = function ()
    for i=0, Limits["effectivity"] do
        for j=0, Limits["productivity"] do
            for k=0, Limits["speed"] do
                local roboport_item = table.deepcopy(base_roboport_item)
                local roboport_entity = table.deepcopy(base_roboport_entity)

                local suffix = utils.get_internal_suffix(i, j, k)
                local name = "battery-roboport-mk-" .. suffix
                local localised_name = tostring("Battery Roboport Mk." .. i .. j .. k)

                roboport_item.name = name
                roboport_entity.name = name
                roboport_entity.localised_name = localised_name
                roboport_item.localised_name = localised_name

                roboport_item.place_result = roboport_entity.name

                roboport_entity.fast_replaceable_group = "roboport"
                roboport_entity.minable = base_roboport_entity.minable
                roboport_entity.minable.result = base_roboport_item.name

                -- shorter var names, all changes follow the same logic. linear upgrade
                -- base + base * research_count * modifier.
                -- This makes sure we always get 200%, 300%, 400% etc from base 100%

                -- string.sub(x, 1, -3) to remove mw, kw, etc.
                local bifl = tonumber(string.sub(base_roboport_entity.energy_source["input_flow_limit"], 1, -3))
                local bfc = tonumber(string.sub(base_roboport_entity.energy_source["buffer_capacity"], 1, -3))
                local brm = tonumber(string.sub(base_roboport_entity.recharge_minimum, 1, -3))
                local bru = tonumber(string.sub(base_roboport_entity.energy_usage, 1, -3))
                local bce = tonumber(string.sub(base_roboport_entity.charging_energy, 1, -3))
                local bcsc = #base_roboport_entity.charging_offsets
                local rsc = base_roboport_entity.robot_slots_count
                local msc = base_roboport_entity.material_slots_count

                -- effectivity upgrades
                roboport_entity.energy_source = {
                    type = "electric",
                    usage_priority = "secondary-input",
                    input_flow_limit = tostring(bifl + bifl*i*input_flow_limit_modifier) .. "MW", --5 is default
                    buffer_capacity = tostring(bfc + bfc*i*buffer_capacity_modifier) .. "MJ", --100 is default
                }
                roboport_entity.recharge_minimum = tostring(brm + brm *i*recharge_minimum_modifier) .. "MJ" --50 is default in mj
                roboport_entity.energy_usage = tostring(bru + bru*i*energy_usage_modifier) .. "kW" -- 50 is default in kw, idle draw
                -- speed upgrade
                roboport_entity.charging_energy = tostring(bce + bce*k*charging_energy_modifier) .. "kW" -- 1000 is default in kw, amount of energy given to bots
                -- productivity upgrade -- 4 is default, amount of bots that can charge at once
                roboport_entity.charging_offsets = f.generate_charging_offsets(bcsc + bcsc * j)

                local fdiv = math.floor((i+j+k) / 10)
                if fdiv % 10 then
                    roboport_entity.robot_slots_count = rsc + rsc * fdiv -- Kindly add robot slot's every 10 levels
                    roboport_entity.material_slots_count = msc + msc * fdiv -- Kindly add  material slot's every 10 levels
                end

                data:extend({roboport_item})
                data:extend({roboport_entity})
            end
        end
    end
end


f.add_all_roboports()
