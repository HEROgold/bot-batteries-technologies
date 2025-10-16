-- This custom roboport has one slot
-- requests all previously requested items
-- acts as a roboport that automatically spits out robots after converting
-- it's goal is to upgrade lower tier robots to higher tier robots
-- on research, it updates its requests to request higher tier robots

require("vars.strings")
require("vars.settings")

-- Base prototypes
local base_linked_chest = data.raw["linked-container"]["linked-chest"]
local base_requester_chest = data.raw["logistic-container"]["logistic-chest-requester"]

-- Create the tier-switcher entity as a requester chest with linked-chest visuals
local tier_switcher_entity = table.deepcopy(base_requester_chest)
tier_switcher_entity.name = TierSwitcherRoboport
tier_switcher_entity.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
tier_switcher_entity.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
tier_switcher_entity.inventory_size = 48  -- Same as regular chest
tier_switcher_entity.logistic_mode = "requester"

-- Use linked-chest visual if available
if base_linked_chest and base_linked_chest.animation then
    tier_switcher_entity.animation = table.deepcopy(base_linked_chest.animation)
end
if base_linked_chest and base_linked_chest.picture then
    tier_switcher_entity.picture = table.deepcopy(base_linked_chest.picture)
end

-- Create item
local tier_switcher_item = {
    type = "item",
    name = TierSwitcherRoboport,
    icon = base_linked_chest and base_linked_chest.icon or base_requester_chest.icon,
    icon_size = base_linked_chest and base_linked_chest.icon_size or base_requester_chest.icon_size,
    subgroup = "logistic-network",
    order = "c[signal]-b[tier-switcher-roboport]",
    place_result = TierSwitcherRoboport,
    stack_size = 50
}

-- Create recipe
local tier_switcher_recipe = {
    type = "recipe",
    name = TierSwitcherRoboport,
    enabled = false,
    ingredients = {
        {type = "item", name = "linked-chest", amount = 1},
        {type = "item", name = "logistic-chest-requester", amount = 1},
        {type = "item", name = "processing-unit", amount = 5}
    },
    results = {{type = "item", name = TierSwitcherRoboport, amount = 1}}
}

-- Add to data
function add_tier_switcher_roboport()
    data:extend({tier_switcher_entity, tier_switcher_item, tier_switcher_recipe})
end
