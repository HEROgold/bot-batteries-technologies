data:extend(
  {
    {
      type = "technology",
      name = "roboport-charge-speed-1",
      icon_size = 256, icon_mipmaps = 4,
      icons = util.add_technology_icon_constant_battery("__base__/graphics/technology/worker-robots-speed.png"),
      upgrade = true,
      max_level = tostring(settings.startup["battery-roboport-research-limit"].value),
      order = "c-k-f-a",
      prerequisites = {"robotics"},
      effects = {
        {
          type = "worker-robot-battery",
          modifier = settings.startup["battery-roboport-robot-battery-modifier"].value
        }
      },
      unit = {
        -- count_formula = "2(L-6)*10",
        count_formula = "250*(L)",
        time = 100,
        ingredients = {
          {"logistic-science-pack", 1},
        }
      },
    },
  }
)
