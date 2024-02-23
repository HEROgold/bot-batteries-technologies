utils = {}

function utils.add_technology_icon_constant_battery(technology_icon)
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


function utils.table_length(table)
  local len = 0
  for _ in pairs(table) do
    len = len + 1
  end
  return len
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
