local function SpawnPrefabAtLandPlotNearInst(prefab,loc,x,y,z,times,xmin,zmin) -- xmin and zmin are the mind distance it should have to the given position
    -- print("Spawn "..tostring(prefab).." near "..tostring(loc).." times: "..tostring(times))
    if prefab==nil or loc==nil or type(prefab)~="string" then
        print("Adventure: Spawnprefab is "..tostring(prefab).." instead of a prefab string... and loc is "..tostring(loc))
        return nil 
    end
    local pos = nil
    if loc.prefab then    
        pos = loc:GetPosition()
    else -- loc can also be a position already
        pos = loc
    end
    x = x or 5
    y = y or 0
    z = z or 5
    xmin = xmin or 3
    zmin = zmin or 3
    local xn = 0
    local zn = 0
    times = times or 1
    times = math.ceil(times)
    local found = false
    local tp_pos
    local attempts = 100
    local spawn = nil
    for i=1,times,1 do 
        found = false
        attempts = 100 --try multiple times to get a spot on ground before giving up so we don't infinite loop
        while attempts > 0 do
            xn = GetRandomWithVariance(0,x)
            zn = GetRandomWithVariance(0,z)
            xn = (xn>=0 and xn<=xmin and xn+xmin) or (xn<0 and xn>=-xmin and xn-xmin) or xn -- dont be in range of xmin zmin, cause this is too near
            zn = (zn>=0 and zn<=zmin and zn+zmin) or (zn<0 and zn>=-zmin and zn-zmin) or zn
            tp_pos = pos + Vector3(xn ,GetRandomWithVariance(0,y) ,zn  )
            if TheWorld.Map:IsAboveGroundAtPoint(tp_pos:Get()) then
                found = true
                break
            end
            attempts = attempts - 1
        end
        spawn = nil
        if found then
            spawn = SpawnPrefab(prefab)
            if spawn then
                spawn.Transform:SetPosition(tp_pos:Get())
                SpawnPrefab("collapse_small").Transform:SetPosition(tp_pos:Get()) -- a small puff effect
            else
                print("Adventure: Spawn of "..tostring(prefab).." failed...")
            end
            -- print("spawned "..tostring(prefab).." at "..tostring(tp_pos).." times: "..tostring(times).." spawn: "..tostring(spawn))
        end
    end
    return spawn -- does only return the last spawn, if times is higher than 1
end

local function SpawnPuff(inst,puffp)
    local puffprefab = puffp or "small_puff"
    local x, y, z = inst.Transform:GetWorldPosition()
    local puff = SpawnPrefab(puffprefab)
    puff.Transform:SetPosition(x, y, z)
end

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function SpawnDrop(inst, lootprefab, player)
    local x, y, z = inst.Transform:GetWorldPosition()
    y = 4.5

    local angle
    if player ~= nil and type(player)=="table" and player:IsValid() then
        angle = 180 - player:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
    end

    local item = SpawnPrefab(lootprefab)
    if item ~= nil then
        item.Transform:SetPosition(x, y, z)
        launchitem(item, angle)
    end
end

-- Made to work with (And return) array-style tables
-- This function does not preserve the original table
function MyPickSome(num, choices) -- better function than in util.lua
	local l_choices = choices
	local ret = {}
	if l_choices then -- nil check
        for i=1,num do
            if #l_choices > 0 then -- bigger 0 check
                local choice = math.random(#l_choices)
                table.insert(ret, l_choices[choice])
                table.remove(l_choices, choice)
            end
        end
    end
	return ret
end

local function GetRewardItems(questname,custom,num) -- num is questdiff
    local items = {}
    if type(custom)=="table" and next(custom) then -- quest specific reward
        items = custom
    elseif type(TUNING.QUESTSMOD)=="table" and type(TUNING.QUESTSMOD.REWARDITEMS)=="table" then
        local amount = 0
        local chance = 1
        local item = nil
        --- chance und amount wird von questdiff beeinflusst
        if type(TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE) then 
            amount = 1
            chance = 0.0075 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.SUPERRARE)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.RARE)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.RARE) then 
            amount = math.random(1, num)
            chance = 0.025 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.RARE)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK) then 
            amount = 1
            chance = 0.025 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.RARENOSTACK)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.MEDIUM)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.MEDIUM) then 
            amount = math.random(1,2 * num)
            chance = 0.15 * num                                    
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.MEDIUM)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK) then 
            amount = 1
            chance = 0.15 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.MEDIUMNOSTACK)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.OFTEN)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.OFTEN) then 
            amount = math.random(1 * num,3 * num)
            chance = 0.25 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.OFTEN)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
            amount = math.random(1 * num,2 * num)
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.OFTEN)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN) then 
            amount = math.random(3 * num,7 * num)
            chance = 0.4 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
            amount = math.random(2 * num,4 * num)
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK) then 
            amount = 1
            chance = 0.25 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.OFTENNOSTACK)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if type(TUNING.QUESTSMOD.REWARDITEMS.FOOD)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.FOOD) then 
            amount = math.random(1,2 * num)
            chance = 0.2 * num
            if math.random() < chance then
                item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.FOOD)
                for i=1,amount do
                    table.insert(items,item)
                end
            end
        end
        if not next(items) or GetTableSize(items)<=3 then -- if it is still empty, fill it 100% with some often stuff
            if type(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN) then 
                amount = math.random(3 * num,8 * num)
                chance = 1
                if math.random() < chance then
                    item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.VERYOFTEN)
                    for i=1,amount do
                        table.insert(items,item)
                    end
                end
            end
            if type(TUNING.QUESTSMOD.REWARDITEMS.OFTEN)=="table" and next(TUNING.QUESTSMOD.REWARDITEMS.OFTEN) then 
                amount = math.random(1 * num,3 * num)
                chance = 1
                if math.random() < chance then
                    item = GetRandomItem(TUNING.QUESTSMOD.REWARDITEMS.OFTEN)
                    for i=1,amount do
                        table.insert(items,item)
                    end
                end
            end
        end
    end
    -- print(fastdump(items))
    return items
end

local function GetNewBlueprints(questname,custom,num)
    local blueprints = {}
    if type(custom)=="table" and next(custom) then -- quest specific reward
        blueprints = custom
        for k, blue in pairs(custom) do -- remove those blueprints from the regular lists, if they are in them, so we dont get it twice
            if table.contains(TheWorld.components.questworldinfo.stuff3.veryimportantblueprints,blue) then
                table.remove(TheWorld.components.questworldinfo.stuff3.veryimportantblueprints,blue)
            end
            if table.contains(TheWorld.components.questworldinfo.stuff3.importantblueprints,blue) then
                table.remove(TheWorld.components.questworldinfo.stuff3.importantblueprints,blue)
            end
            if table.contains(TheWorld.components.questworldinfo.stuff3.otherblueprints,blue) then
                table.remove(TheWorld.components.questworldinfo.stuff3.otherblueprints,blue)
            end
        end
    else -- if quest has no specific reward
        if TheWorld.components and TheWorld.components.questworldinfo and TheWorld.components.questworldinfo.stuff3 and next(TheWorld.components.questworldinfo.stuff3) then
            local pick = MyPickSome(num, TheWorld.components.questworldinfo.stuff3.veryimportantblueprints)
            if next(pick) then -- if it contains at least one item
                for key,thing in pairs(pick) do
                    table.insert(blueprints,thing.."_blueprint")
                end
            else -- if it is empty, add the next blueprint stuff... important and winter/summer/spring/darkness blueprints merged
                pick = MyPickSome(num, TheWorld.components.questworldinfo.stuff3.importantblueprints)
                if next(pick) then -- if it contains at least one item
                    for key,thing in pairs(pick) do
                        table.insert(blueprints,thing.."_blueprint")
                    end
                else -- if it is empty, add the next blueprint stuff
                    pick = MyPickSome(num, TheWorld.components.questworldinfo.stuff3.otherblueprints)
                    if next(pick) then -- if it contains at least one item
                        for key,thing in pairs(pick) do
                            table.insert(blueprints,thing.."_blueprint")
                        end
                    end
                end
            end
        else
            print("AdventureMod: GetNewBlueprints, something went wrong, there are no blueprints in world questworldinfo stuff3 ?!")
        end
    end
    
    for k, blue in pairs(blueprints) do -- add those blueprints also to shop
        if TheWorld then
            if TheWorld.components.questworldinfo and TheWorld.components.questworldinfo.stuff1 then
                TheWorld.components.questworldinfo.stuff1[blue.."_shop"] = true
                -- if TheWorld["mynetvar"..blue.."_shop"] then
                    -- TheWorld["mynetvar"..blue.."_shop"]:set(true) -- store in world does not work
                -- end
                for k,player in pairs(AllPlayers) do -- clients cant access the component, so we have to set a netvar for every blueprint. AllPlayers does only work for the world it is called!  So if a blueprint is picked in caves, this wont work!
                    if player and player["mynetvar"..blue.."_shop"] then
                        player["mynetvar"..blue.."_shop"]:set(true)
                    end
                end
                -- print("set "..blue.."_shop to true")
            end
        end
    end
    
    return blueprints
end

return
{
	SpawnPrefabAtLandPlotNearInst = SpawnPrefabAtLandPlotNearInst,
    SpawnDrop = SpawnDrop,
    GetNewBlueprints = GetNewBlueprints,
    SpawnPuff = SpawnPuff,
    MyPickSome = MyPickSome,
    GetRewardItems = GetRewardItems,
}