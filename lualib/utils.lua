utils = {}

function utils.sprite_add_icon(technology_icon, module_icon)
  local icons =
  {
    {
      icon = technology_icon,
      icon_size = 256, icon_mipmaps = 4
    },
    {
      icon = module_icon,
      icon_size = 64,
      icon_mipmaps = 3,
      shift = {80, 100},
      scale = 1.5
    }
  }
  return icons
end


function utils.starts_with(to_check, target)
  return string.sub(to_check, 1, string.len(target)) == target
end

utils.get_internal_suffix = function (effectivity_level, productivity_level, speed_level)
  -- e0p0s0 suffix for effectivity 0, productivity 0, speed 0
  effectivity_level = math.max(effectivity_level, 0)
  productivity_level = math.max(productivity_level, 0)
  speed_level = math.max(speed_level, 0)
  return tostring("e" .. effectivity_level .. "p" .. productivity_level .. "s" .. speed_level)
end
