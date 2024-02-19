local maximum_level = tonumber(settings.startup["battery-roboport-research-limit"].value)

script.on_init(
    function ()
        Setup_Vars()
    end
)

function Setup_Vars()
    if global.BatteryRoboportResearchLevel == nil then
        global.BatteryRoboportResearchLevel = 0
    end
end


function Starts_with(to_check, target)
    return string.sub(to_check, 1, string.len(target)) == target
end


function Is_valid_roboport(roboport)
    local obj_name = roboport.name

    if obj_name == "roboport" then
        -- The entity is from vanilla Factorio
        return true
    elseif Starts_with(obj_name, "battery-roboport-mk-") then
            return true
    else
        -- Entity is from another mod
        return false
    end
end

function Is_research_valid()
    Setup_Vars() -- Shouldn't need to be used here, but is here as a bandaid fix
    return global.BatteryRoboportResearchLevel > 0 and global.BatteryRoboportResearchLevel <= maximum_level
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
                    local robo_slots = roboport.get_inventory(defines.inventory.roboport_robot)
                    local robo_material = roboport.get_inventory(defines.inventory.roboport_material)

                    local to_create = {
                        name = "battery-roboport-mk-" .. global.BatteryRoboportResearchLevel,
                        position = roboport.position,
                        force = roboport.force,
                        fast_replace = true,
                        create_build_effect_smoke = false
                    }
                    surface.create_entity(to_create)
                end
            end
        end
    end
end


script.on_event(defines.events.on_research_finished,
    function (event)
        if Starts_with(event.research.name, "roboport-charge-speed-") then
            global.BatteryRoboportResearchLevel = global.BatteryRoboportResearchLevel + 1
            Update_roboports()
        end
    end
)


script.on_nth_tick(3600,
function (event)
    if Is_research_valid() then
        Update_roboports()
    end
end)
