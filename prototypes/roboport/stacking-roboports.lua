require("lualib.utils")

local base_roboport_entity = data.raw["roboport"]["roboport"]
local base_roboport_item = data.raw["item"]["roboport"]
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_mimimum = settings.startup["energy-research-minimum"].value
local input_flow_limit_modifier = tonumber(settings.startup["input-flow-limit-modifier"].value)
local buffer_capacity_modifier = tonumber(settings.startup["buffer-capacity-modifier"].value)
local recharge_minimum_modifier = tonumber(settings.startup["recharge-minimum-modifier"].value)
local energy_usage_modifier = tonumber(settings.startup["energy-usage-modifier"].value)
local charging_energy_modifier = tonumber(settings.startup["charging-energy-modifier"].value)

function generate_charging_offsets(n)
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


local efficiency_limit = math.max(Limits["efficiency"], research_mimimum)
local productivity_limit = math.max(Limits["productivity"], research_mimimum)
local speed_limit = math.max(Limits["speed"], research_mimimum)

local energy_roboport_entity = table.deepcopy(base_roboport_entity)
local energy_roboport_item = table.deepcopy(base_roboport_item)

local localised_name = "Energy Roboport"

energy_name = "energy-roboport"
energy_roboport_item.name = energy_name
energy_roboport_entity.name = energy_name

energy_roboport_item.place_result = energy_roboport_entity.name
energy_roboport_item.localised_name = localised_name
energy_roboport_item.hidden = false

energy_roboport_entity.localised_name = localised_name
energy_roboport_entity.minable.result = energy_roboport_item.name
energy_roboport_entity.robot_slots_count = 10
energy_roboport_entity.material_slots_count = 10

---@type data.RecipePrototype
local energy_roboport_recipe = {
    type = "recipe",
    name = energy_name,
    -- enabled = true,
    ---@type data.IngredientPrototype[]
    ingredients = {
        {type = "item", name ="roboport", amount = 1},
        {type = "item", name ="steel-plate", amount = 100},
    },
    ---@type data.ItemProductPrototype[]
    results = {{type = "item", name = energy_roboport_item.name, amount = 1},},
    category = "crafting",
    unlock_results = true,
}
local function add_energy_roboport()
    data:extend({energy_roboport_item})
    data:extend({energy_roboport_recipe})
    data:extend({energy_roboport_entity})
end

local function add_all_roboports()
    for i=0, efficiency_limit do
        for j=0, productivity_limit do
            for k=0, speed_limit do
                local roboport_item = table.deepcopy(energy_roboport_item)
                local roboport_entity = table.deepcopy(energy_roboport_entity)

                local suffix = utils.get_energy_suffix(i, j, k)
                local name = energy_name .. "-mk-" .. suffix
                local localised_name = tostring("Energy Roboport Mk." .. i .. j .. k)

                roboport_item.name = name
                roboport_entity.name = name
                roboport_entity.localised_name = localised_name
                roboport_item.localised_name = localised_name
                roboport_item.hidden = true

                roboport_item.place_result = roboport_entity.name

                roboport_entity.fast_replaceable_group = "roboport"
                roboport_entity.minable = energy_roboport_entity.minable
                roboport_entity.minable.result = energy_roboport_item.name

                -- shorter var names, all changes follow the same logic. linear upgrade
                -- base + base * research_count * modifier.
                -- This makes sure we always get 200%, 300%, 400% etc from base 100%

                -- string.sub(x, 1, -3) to remove mw, kw, etc.
                local bifl = tonumber(string.sub(energy_roboport_entity.energy_source["input_flow_limit"], 1, -3))
                local bfc = tonumber(string.sub(energy_roboport_entity.energy_source["buffer_capacity"], 1, -3))
                local brm = tonumber(string.sub(energy_roboport_entity.recharge_minimum, 1, -3))
                local bru = tonumber(string.sub(energy_roboport_entity.energy_usage, 1, -3))
                local bce = tonumber(string.sub(energy_roboport_entity.charging_energy, 1, -3))
                local bcsc = #energy_roboport_entity.charging_offsets

                -- efficiency upgrades
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
                roboport_entity.charging_offsets = generate_charging_offsets(bcsc + bcsc * j)

                if settings.startup["show-items"].value == true then
                    roboport_item.subgroup = "br-roboports"
                    data:extend({roboport_item})
                end
                data:extend({roboport_entity})
            end
        end
    end
end

add_energy_roboport()
add_all_roboports()