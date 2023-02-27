data:extend(
  {
    {
      type = "technology",
      name = "roboport-charge-speed-1",
      icon_size = 256, icon_mipmaps = 4,
      icons = util.technology_icon_constant_battery("__base__/graphics/technology/worker-robots-speed.png"),
      upgrade = true,
      max_level = "infinite",
      order = "c-k-f-a",
      prerequisites = {"robotics"},
      effects = {
        {
          type = "worker-robot-battery", -- roboport.charging_energy, -- roboport-charging-speed
          -- modifier = settings.startup["BotBatteriesTechnologies-battery-modifier"].value
          modifier = 0.10
        }
      },
      unit = {
        count_formula = "2^(L-6)*10",
        time = 100,
        ingredients = {
          {"logistic-science-pack", 1},
        }
      },
    },
  }
)
