questfunctions = require("scenarios/questfunctions")

local function OnCreate(inst, scenariorunner)
    local keeper = questfunctions.SpawnPrefabAtLandPlotNearInst("shopkeeper",inst,17,0,17,1,15,15)
    if keeper then -- is enough to do this at start, cause component will save and load stuff
        if keeper.components.questgiver then -- needs to be added in prefab
            keeper.components.questgiver.questname = "FreePigking"
            keeper.components.questgiver.questdiff = 3
            keeper.components.questgiver.questobject = inst
            local x, y, z = inst.Transform:GetWorldPosition() -- find pigtorches near piging
            local structures = TheSim:FindEntities(x, y, z, 15, nil, nil, {"structure"})
            local torches = {}
            for k,v in pairs(structures) do
                if v.prefab == "pigtorch" then
                    table.insert(torches,v) -- a table that only include the pigtorches near it. we have to count it first, because it is possible that there are more than 4 cause any other thing is near it.
                end
            end
            keeper.components.questgiver.questnumber = #torches -- destroy 4 pigtorches, so after it is done, the pigtorches around pigking will be #torches-4
        end
    end
end



local function OnLoad(inst, scenariorunner) 
end

return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
}