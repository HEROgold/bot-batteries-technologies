
local base_roboport_item = data.raw["item"]["roboport"]

---@type data.ItemGroup
local item_group = {
    icon = base_roboport_item.icon,
    icon_size = base_roboport_item.icon_size,
    icon_mipmaps = base_roboport_item.icon_mipmaps,
    type = "item-group",
    name = "br-roboports",
    order = "z",
}
---@type data.ItemSubGroup
local item_subgroup = {
    type = "item-subgroup",
    name = "br-roboports",
    group = "br-roboports",
    order = "a",
}

data:extend({item_group, item_subgroup})
