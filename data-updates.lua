-- Add the replaceable_group to vanilla roboport
if data.raw["roboport"]["roboport"] then
    data.raw["roboport"]["roboport"].fast_replaceable_group = "roboport"
    -- if "upgrade modded" then
    --     for a, b in pairs(data.raw["roboport"]) do
    --         data.raw["roboport"][a].fast_replaceable_group = a
    --     end
    -- end
end
