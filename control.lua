
script.on_init(
    function ()
        Init_Vars()
    end
)

function Init_Vars()
    if global.RoboportChargeSpeedLevel == nil then
		global.RoboportChargeSpeedLevel = 1
	end
    if global.BotBatteryTechnologiesResearchCount == nil then
        global.BotBatteryTechnologiesResearchCount = 0
    end
end


function Update_roboport_charge_speed(entities)
    if (global.RoboportChargeSpeedLevel < 1) then
        return
    end
    for _, entity in pairs(entities) do
        player = game.get_player("HEROgoldmw")
        player.print(tostring("before:" .. entity.charging_energy) .. " ".. tostring(entity.input_flow_limit))
        entity.charging_energy = (settings.startup["BotBatteriesTechnologies-battery-modifier"].value * global.BotBatteryTechnologiesResearchCount)
        entity.input_flow_limit = (settings.startup["BotBatteriesTechnologies-battery-modifier"].value * global.BotBatteryTechnologiesResearchCount)
        player.print(tostring("after:" .. entity.charging_energy) .. " ".. tostring(entity.input_flow_limit))
        -- entity.charging_distance
        -- charging_station_count
    end
end


script.on_event(defines.events.on_research_finished,
function(event)
    player = game.get_player("HEROgoldmw")
    global.BotBatteryTechnologiesResearchCount = global.BotBatteryTechnologiesResearchCount + 1
    for _, surface in pairs(game.surfaces) do
        -- for chunk in surface.get_chunks() do
            -- player.print("x: " .. chunk.x .. ", y: " .. chunk.y)
            -- player.print("area: " .. serpent.line(chunk.area))
        -- end
        for chunk in surface.get_chunks() do
            local roboports = surface.find_entities_filtered{
                area = chunk.area,
                position = {
                    x=chunk.x,
                    y=chunk.y
                },
                force = event.research.force,
                type = "roboport"
            }
            player.print("BotBatteryTechnologiesResearchCount: " .. global.BotBatteryTechnologiesResearchCount)
            local status, error = pcall(Update_roboport_charge_speed, roboports) 
            if status then
                player.print("No error")
            else
                player.print("ERROR! DURING ROBOPORT UPDATE")
            player.print("" .. tostring(status) .. " " .. tostring(error))
            end
        end
    end
end)
