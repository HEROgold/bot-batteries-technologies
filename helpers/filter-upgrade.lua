require("helpers.robot-upgrade")

local robot_upgrade = require("helpers.robot-upgrade")

--- Helper module for upgrading robot filters in logistic requests
local filter_upgrade = {}

---@param entity LuaEntity
function filter_upgrade.upgrade_logistic_filters(entity)
    local logistics = entity.get_logistic_sections()
    if not logistics then return end

    for i = 1, logistics.sections_count do
        local section = logistics.get_section(i)
        if not section then goto continue end
        
        for j = 1, section.filters_count do
            local filter = section.filters[j]
            if not filter or not filter.value then goto skip_filter end
            
            if robot_upgrade.is_upgradeable(filter.value.name) then
                local upgraded_name = robot_upgrade.get_upgraded_name(filter.value.name, entity.force)
                if not upgraded_name then goto skip_filter end

                --- @type LogisticFilter
                local new_filter = {
                    name = filter.name,
                    index = filter.index,
                    count = filter.count,
                    value = {
                        name = upgraded_name,
                        type = filter.value.type,
                        quality = filter.value.quality,
                        comparator = filter.value.comparator,
                    }
                }
                section.set_slot(j, new_filter)
            end
            
            ::skip_filter::
        end
        ::continue::
    end
end

return filter_upgrade
