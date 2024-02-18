function util.add_technology_icon_constant_battery(technology_icon)
  local icons =
  {
    {
      icon = technology_icon,
      icon_size = 256, icon_mipmaps = 4
    },
    {
      icon = "__core__/graphics/icons/technology/constants/constant-battery.png",
      icon_size = 128,
      icon_mipmaps = 3,
      shift = {100, 100}
    }
  }
  return icons
end
