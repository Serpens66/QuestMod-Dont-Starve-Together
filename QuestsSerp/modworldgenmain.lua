-- add the statue setpieces to world generation
AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then -- only change forest, not cave
        return
    end
    tasksetdata.set_pieces["MaxMermShrine"] = { count = 1, tasks={"Squeltch"}}
    tasksetdata.set_pieces["MaxPigShrine"] = { count = 1, tasks={"Befriend the pigs","Make a pick","Forest hunters"}}
end)


GLOBAL.require("map/tasks")
local LLayouts = GLOBAL.require("map/layouts").Layouts

AddLevelPreInitAny(function(level) -- modify the fill mask, so chances are higher that it is placed on the map
    local function Add_IIBE_Mask(layout)
        if layout then
            -- layout.fill_mask = GLOBAL.PLACE_MASK.NORMAL
            
            layout.start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN -- increase chance of it being placed in the world, by ignoring some other stuff already placed
            layout.fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN
            
            -- layout.start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN
            -- layout.fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED
        end
    end
    local my_layouts = {
        "MaxMermShrine",
        "MaxPigShrine",
    }
    for i, v in ipairs(my_layouts) do
        Add_IIBE_Mask(LLayouts[v])
    end
end)