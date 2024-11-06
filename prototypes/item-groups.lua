-- TODO: use String vars
local base_roboport_item = data.raw["item"]["roboport"]
local base_robot_item = data.raw["item"]["construction-robot"]

---@type data.ItemGroup
local roboport_item_group = {
    icon = base_roboport_item.icon,
    icon_size = base_roboport_item.icon_size,
    icon_mipmaps = base_roboport_item.icon_mipmaps,
    type = "item-group",
    name = "br-roboports",
    order = "z",
}
---@type data.ItemSubGroup
local roboport_item_subgroup = {
    type = "item-subgroup",
    name = "br-roboports",
    group = "br-roboports",
    order = "a",
}
---@type data.ItemGroup
local robot_item_group = {
    icon = base_robot_item.icon,
    icon_size = base_robot_item.icon_size,
    icon_mipmaps = base_robot_item.icon_mipmaps,
    type = "item-group",
    name = "br-robots",
    order = "z",
}
---@type data.ItemSubGroup
local robot_item_subgroup = {
    type = "item-subgroup",
    name = "br-robots",
    group = "br-robots",
    order = "a",
}

data:extend({roboport_item_group, roboport_item_subgroup})
data:extend({robot_item_group, robot_item_subgroup})
