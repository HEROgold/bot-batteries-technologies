
---@type data.SelectionToolPrototype
local item = {
    type = "selection-tool",
    name = "roboport-updater",
    subgroup = "tool",
    order = "z[roboport-updater]",
    show_in_library = true,
    icons = {
        {
            icon = "__base__/graphics/icons/repair-pack.png",
            icon_size = 32,
        }
    },
    flags = { "only-in-cursor", "spawnable" },
    stack_size = 1,
    stackable = false,
    selection_color = { r = 0.72, g = 0.45, b = 0.2, a = 1 },
    alt_selection_color = { r = 0.72, g = 0.22, b = 0.1, a = 1 },
    selection_mode = { "buildable-type", "same-force", "entity-ghost" },
    alt_selection_mode = { "buildable-type", "same-force", "entity-ghost" },
    selection_cursor_box_type = "entity",
    alt_selection_cursor_box_type = "entity",
}

---@type data.ShortcutPrototype
local shortcut = {
    type = "shortcut",
    name = "shortcut-roboport-updater-item",
    localised_name = "roboport updater",
    action = "spawn-item",
    item_to_spawn = "roboport-updater",
    order = "m[roboport-updater]",
    --style = "yellow",
    icon = {
        filename = "__base__/graphics/icons/repair-pack.png",
        flags = {
            "icon"
        },
        priority = "extra-high-no-scale",
        scale = 1,
        size = 32
    },
}

data:extend { item, shortcut }
