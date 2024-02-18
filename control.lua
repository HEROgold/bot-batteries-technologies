
script.on_init(
    function ()
        Init_Vars()
    end
)

function Init_Vars()
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
        -- Entity is from our mod
        if global.BatteryRoboportResearchLevel > 0 and global.BatteryRoboportResearchLevel < 100 then
            -- Entity is upgradable
            return true
        else
            -- Entity is not upgradable
            return true
        end
    else
        -- Entity is from another mod
        return false
    end
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
                    local to_create = {
                        name = "battery-roboport-mk-" .. global.BatteryRoboportResearchLevel,
                        position = roboport.position,
                        force = roboport.force
                    }
                    roboport.destroy()
                    surface.create_entity(to_create)
                end
            end
        end
    end
end


script.on_event(defines.events.on_research_finished,
    function (event)
        game.print(event.research.name)
        if Starts_with(event.research.name, "roboport-charge-speed-") then
            global.BatteryRoboportResearchLevel = global.BatteryRoboportResearchLevel + 1
            Update_roboports()
        end
    end
)


script.on_nth_tick(3600,
function (event)
    Update_roboports()
end)
