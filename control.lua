require("lualib.utils")

local max_effectivity_level = tonumber(settings.startup["battery-roboport-energy-research-limit"].value)
local max_productivity_level = tonumber(settings.startup["battery-roboport-energy-research-limit"].value)
local max_speed_level = tonumber(settings.startup["battery-roboport-energy-research-limit"].value)

script.on_init(
    function ()
        Setup_Vars()
    end
)


function Setup_Vars()
    if global.EffectivityResearchLevel == nil then
        global.EffectivityResearchLevel = 0
    end
    if global.ProductivityResearchLevel == nil then
        global.ProductivityResearchLevel = 0
    end
    if global.SpeedResearchLevel == nil then
        global.SpeedResearchLevel = 0
    end
end

function Get_level_from_name(to_check)
    local eff = string.sub(to_check, -5, -5)
    local prod = string.sub(to_check, -3, -3)
    local speed = string.sub(to_check, -1, -1)
    return {tonumber(eff), tonumber(prod), tonumber(speed)}
end

function Is_valid_roboport(roboport)
    local r_name = roboport.name

    if r_name == "roboport" then
        -- The entity is from vanilla Factorio
        return true
    elseif utils.starts_with(r_name, "battery-roboport-mk-") then
        local level = Get_level_from_name(r_name)
        -- Check for correct levels, to avoid replacing already correct roboports.
        if level[1] < global.EffectivityResearchLevel or level[2] < global.ProductivityResearchLevel or level[3] < global.SpeedResearchLevel then
            return true
        end
    else
        -- Entity is from another mod
        return false
    end
end

function Is_research_valid()
    Setup_Vars() -- Shouldn't need to be used here, but is here as a bandaid fix
    eff = global.EffectivityResearchLevel > 0 and global.EffectivityResearchLevel <= max_effectivity_level
    prod = global.ProductivityResearchLevel > 0 and global.ProductivityResearchLevel <= max_productivity_level
    speed = global.SpeedResearchLevel > 0 and global.SpeedResearchLevel <= max_speed_level
    return eff and prod and speed
end

-- End of helper functions
-- Start of main functions

function Update_roboports()
    for _, surface in pairs(game.surfaces) do
        for chunk in surface.get_chunks() do
            local area = {
                left_top = {chunk.x * 32, chunk.y * 32},
                right_bottom = {(chunk.x + 1) * 32, (chunk.y + 1) * 32}
            }
            local roboports = surface.find_entities_filtered{
                type = "roboport",
                area = area
            }
            for _, roboport in pairs(roboports) do
                if Is_valid_roboport(roboport) then
                    local old_energy = roboport.energy
                    local suffix = utils.get_internal_suffix(global.EffectivityResearchLevel, global.ProductivityResearchLevel, global.SpeedResearchLevel)

                    local to_create = {
                        name = "battery-roboport-mk-" .. suffix,
                        position = roboport.position,
                        force = roboport.force,
                        fast_replace = true,
                        create_build_effect_smoke = false
                    }
                    local created_rport = surface.create_entity(to_create)
                    created_rport.energy = old_energy
                    roboport.destroy()
                end
            end
        end
    end
end


script.on_event(defines.events.on_research_finished,
    function (event)
        if utils.starts_with(event.research.name, "roboport-effectivity") then
            global.EffectivityResearchLevel = global.EffectivityResearchLevel + 1
            Update_roboports()
        elseif utils.starts_with(event.research.name, "roboport-productivity") then
            global.ProductivityResearchLevel = global.ProductivityResearchLevel + 1
            Update_roboports()
        elseif utils.starts_with(event.research.name, "roboport-speed") then
            global.SpeedResearchLevel = global.SpeedResearchLevel + 1
            Update_roboports()
        end
    end
)

script.on_event(defines.events.on_research_reversed,
    function (event)
        if utils.starts_with(event.research.name, "roboport-effectivity") then
            global.EffectivityResearchLevel = global.EffectivityResearchLevel - 1
        elseif utils.starts_with(event.research.name, "roboport-productivity") then
            global.ProductivityResearchLevel = global.ProductivityResearchLevel - 1
        elseif utils.starts_with(event.research.name, "roboport-speed") then
            global.SpeedResearchLevel = global.SpeedResearchLevel - 1
        end
    end
)

script.on_nth_tick(3600,
function (event)
    if Is_research_valid() then
        Update_roboports()
    end
end)
