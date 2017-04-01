

local _G = GLOBAL

-- import the strings from that file
modimport "mymodstrings.lua" -- acts like I would write the code of that scripte here

print("QUESTSMOD HuntMod")


---------------- ## QUEST help functions

local function MyCustomMergeMaps(...) -- to merge the killerprefabs that way, that a name does occur only once
    local ret = {}
    local add = true
    for i,map in ipairs({...}) do
        add = true
        for l,name in pairs(map) do
            for l2,name2 in pairs(ret) do
                if name.name == name2.name then
                    add = false
                end
            end
            if add then
                table.insert(ret,name)
            end
         end
    end
    return ret
end

------------------------- ## Quests
if GLOBAL.TUNING.QUESTSMOD==nil then
    GLOBAL.TUNING.QUESTSMOD = {}
end


if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS = {}
end
if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.WINTER]==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.WINTER] = {}
end
if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SUMMER]==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SUMMER] = {}
end
if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.AUTUMN]==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.AUTUMN] = {}
end
if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SPRING]==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SPRING] = {}
end
if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALLSEASON==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALLSEASON = {}
end
if GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALL==nil then
    GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALL = {}
end
-- when adding a new thing here, also add its name to modinfo
local allseason = {{prefabs={"hound","firehound","icehound"}, name="hound", numbers={2,5,8},diff={1,2,3}}, {prefabs={"merm"}, name="merm", numbers={1,3,5},diff={1,2,3}}, {prefabs={"tentacle"}, name="tentacle", numbers={1,3},diff={2,4}}, {prefabs={"leif","leif_sparse"}, name="leif", numbers={1},diff={3}},
                {prefabs={"bee","killerbee","beeguard"}, name="bee", numbers={10,15,20},diff={1,2,3}}, {prefabs={"beefalo","babybeefalo"}, name="beefalo", numbers={1,2},diff={2,3}}, {prefabs={"crow","robin","robin_winter","canary"}, name="birds", numbers={3,6},diff={1,2}},
                {prefabs={"bishop","knight","rook","knight_nightmare","bishop_nightmare","rook_nightmare"}, name="clockworks", numbers={1,2,4},diff={1,2,3}}, {prefabs={"krampus"}, name="krampus", numbers={1},diff={4}},
                {prefabs={"pig","pigguard"}, name="pig", numbers={1},diff={4}}, {prefabs={"rabbit"}, name="rabbit", numbers={2,4},diff={1,2}}, {prefabs={"crawlinghorror","crawlingnightmare","terrorbeak","nightmarebeak"}, name="shadow creatures", numbers={1,2},diff={2,3}}, {prefabs={"shadow_knight","shadow_bishop","shadow_rook"}, name="shadow pieces", numbers={1,2,3},diff={3,4,5}},
                {prefabs={"spider"}, name="spider", numbers={3,6,10},diff={1,2,3}}, {prefabs={"spider_warrior"}, name="spider_warrior", numbers={2,4,6},diff={1,2,3}}, {prefabs={"spiderqueen"}, name="spiderqueen", numbers={1},diff={3}}, {prefabs={"tallbird"}, name="tallbird", numbers={1,2,3},diff={1,2,3}}, 
                {prefabs={"buzzard"}, name="buzzard", numbers={2,4,8},diff={1,2,3}}, {prefabs={"catcoon"}, name="catcoon", numbers={1,2},diff={1,2}}, {prefabs={"dragonfly"}, name="dragonfly", numbers={1},diff={5}}, {prefabs={"glommer"}, name="glommer", numbers={1},diff={2}}, {prefabs={"mole"}, name="mole", numbers={2},diff={1}}, 
                {prefabs={"warg"}, name="warg", numbers={1},diff={3}}, {prefabs={"lightninggoat"}, name="lightninggoat", numbers={1,2},diff={2,3}}, {prefabs={"spat"}, name="spat", numbers={1},diff={2}}, }

local winter = {{prefabs={"penguin"}, name="penguin", numbers={1,3,5},diff={1,2,3}}, {prefabs={"deerclops"}, name="deerclops", numbers={1},diff={4}}, {prefabs={"koalefant_winter"}, name="koalefant_winter", numbers={1,2},diff={2,3}}, {prefabs={"little_walrus","walrus"}, name="walrus", numbers={1,2,3},diff={2,3,4}}, }
local summer = {{prefabs={"antlion"}, name="antlion", numbers={1},diff={4}}, {prefabs={"mosquito"}, name="mosquito", numbers={3,6},diff={1,2}}, {prefabs={"butterfly"}, name="butterfly", numbers={10,20},diff={1,2}}, {prefabs={"frog"}, name="frog", numbers={2,5,10},diff={1,2,3}}, {prefabs={"perf"}, name="perd", numbers={2,4},diff={1,2}}, {prefabs={"koalefant_summer"}, name="koalefant_summer", numbers={1,2},diff={2,3}}, }
local autumn = {{prefabs={"bearger"}, name="bearger", numbers={1},diff={4}}, {prefabs={"mosquito"}, name="mosquito", numbers={3,6},diff={1,2}}, {prefabs={"butterfly"}, name="butterfly", numbers={10,20},diff={1,2}}, {prefabs={"frog"}, name="frog", numbers={2,5,10},diff={1,2,3}}, {prefabs={"perf"}, name="perd", numbers={2,5,10},diff={1,2,3}}, }
local spring = {{prefabs={"mossling"}, name="mossling", numbers={1,1,2},diff={2,2,3}}, {prefabs={"moose"}, name="moose", numbers={1},diff={4}}, {prefabs={"mosquito"}, name="mosquito", numbers={3,6},diff={1,2}}, {prefabs={"butterfly"}, name="butterfly", numbers={10,20},diff={1,2}}, {prefabs={"frog"}, name="frog", numbers={2,5,10},diff={1,2,3}}, {prefabs={"perf"}, name="perd", numbers={2,5,10},diff={1,2,3}}, {prefabs={"lureplant"}, name="lureplant", numbers={1,2},diff={2,3}}, }              
for k,entry in pairs(allseason) do
    if GetModConfigData(string.gsub(" "..entry.name, "%W%l", string.upper):sub(2)) then
        table.insert(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALLSEASON,entry)
    end
end
for k,entry in pairs(winter) do
    if GetModConfigData(string.gsub(" "..entry.name, "%W%l", string.upper):sub(2)) then
        table.insert(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.WINTER],entry)
    end
end
for k,entry in pairs(spring) do
    if GetModConfigData(string.gsub(" "..entry.name, "%W%l", string.upper):sub(2)) then
        table.insert(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SPRING],entry)
    end
end
for k,entry in pairs(summer) do
    if GetModConfigData(string.gsub(" "..entry.name, "%W%l", string.upper):sub(2)) then
        table.insert(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SUMMER],entry)
    end
end
for k,entry in pairs(autumn) do
    if GetModConfigData(string.gsub(" "..entry.name, "%W%l", string.upper):sub(2)) then
        table.insert(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.AUTUMN],entry)
    end
end

for k,entry in pairs(MyCustomMergeMaps(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALLSEASON,GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.WINTER],GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SUMMER],GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.AUTUMN],GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.SEASONS.SPRING])) do
    table.insert(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALL,entry)
end
print(GLOBAL.fastdump(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALL))

local function OnDeath(inst,data)
    if data and data.afflicter and (data.afflicter:HasTag("player") or (not data.afflicter:HasTag("player") and not data.afflicter:HasTag("hostile") and data.afflicter.components.follower~=nil and data.afflicter.components.follower.leader~=nil and data.afflicter.components.follower.leader:HasTag("player") and not data.afflicter.components.follower.leader:HasTag("hostile"))) then -- if a player or any follower of a player killed it
        local x, y, z = inst.Transform:GetWorldPosition()
        local givers = GLOBAL.TUNING.QUESTSMOD.GIVERS--GLOBAL.TheSim:FindEntities(x, y, z, 1000, nil, nil, {"questgiver"}) -- too big numbers will cause freeze ... so we need something where we store all questgivers
        for k,giver in pairs(givers) do
            if giver.components.questgiver.questname=="KillQuest" and GLOBAL.table.contains(giver.components.questgiver.customstore.prefabs , inst.prefab) then
                giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                -- update strings
                if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                    giver.components.questgiver.talking.near = {}
                    for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].NEAR) do
                        table.insert(giver.components.questgiver.talking.near,string.format(entry,giver.components.questgiver.questnumberreached,giver.components.questgiver.questnumber,GLOBAL.STRINGS.NAMES[string.upper(giver.components.questgiver.customstore.name)] or giver.components.questgiver.customstore.name)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                    end
                    giver.components.questgiver.talking.far = {}
                    for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].FAR) do
                        table.insert(giver.components.questgiver.talking.far,string.format(entry,giver.components.questgiver.questnumberreached,giver.components.questgiver.questnumber,GLOBAL.STRINGS.NAMES[string.upper(giver.components.questgiver.customstore.name)] or giver.components.questgiver.customstore.name)) -- if there is no %i in the string, string.format wont change the string
                    end
                end
            end
        end
    end
end

for k,entry in pairs(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALL) do
    for k,prefab in pairs(entry.prefabs) do
        AddPrefabPostInit(prefab,function(inst)
            if GLOBAL.TheWorld.ismastershard then -- only surface
                inst:ListenForEvent("death",OnDeath)
            end
        end)
    end
end

local function GetAveragePlayerAgeInDays()
	local sum = 0
	for i,v in ipairs(GLOBAL.AllPlayers) do -- does only count players in one world surface or cave, not both
		if v.components.age then
            sum = sum + v.components.age:GetAgeInDays()
        end
	end
	local average = sum / #GLOBAL.AllPlayers
	return average
end


local function InitKillQuest(giver)
    local list = GLOBAL.deepcopy(MyCustomMergeMaps(GLOBAL.TUNING.QUESTSMOD.KILLPREFABS.ALLSEASON,GLOBAL.TUNING.QUESTSMOD.KILLPREFABS[GLOBAL.TheWorld.state.season])) -- merge currecnt season list with allseason. no error is thrown if one table is nil
    local age = GetAveragePlayerAgeInDays()
    if age < 25 then -- 0-25 remove all quests with diff >= 3
        local i=1
        while i <= #list do
            for i2,v in ipairs(list[i].diff) do
                while v and v>=3 do
                    table.remove(list[i].diff,i2)
                    table.remove(list[i].numbers,i2)
                    v = list[i].diff[i2]
                end
            end
            if not GLOBAL.next(list[i].diff) then -- if diff is empty now, remove the whole entry from list
                table.remove(list,i)
            else
                i = i + 1
            end
        end
    elseif age < 50 then -- 25-50 make < 3 quest more likely, by adding more numbers/diffs to the list, so instead numbers={2,5,8},diff={1,2,3}, make it to numbers={2,2,5,5,8},diff={1,1,2,2,3}
        for i,entry in ipairs(list) do
            for i2=1,#entry.diff do
                if entry.diff[i2]<3 then
                   table.insert(entry.diff,entry.diff[i2])
                   table.insert(entry.numbers,entry.numbers[i2])
                end
            end
        end
    elseif age < 100 then -- 50-100 unchanged
        age = age -- just do something...
    elseif age <175 then -- 100 - 175  >=3 more likely, so numbers={2,5,8},diff={1,2,3} to numbers={2,5,8,8},diff={1,2,3,3}
        for i,entry in ipairs(list) do
            for i2=1,#entry.diff do
                if entry.diff[i2]>=3 then
                   table.insert(entry.diff,entry.diff[i2])
                   table.insert(entry.numbers,entry.numbers[i2])
                end
            end
        end
    elseif age >=175 then -- 175 - ... remove diff < 3 
        local i=1
        while i <= #list do
            for i2,v in ipairs(list[i].diff) do
                while v and v<3 do
                    table.remove(list[i].diff,i2)
                    table.remove(list[i].numbers,i2)
                    v = list[i].diff[i2]
                end
            end
            if not GLOBAL.next(list[i].diff) then -- if diff is empty now, remove the whole entry from list
                table.remove(list,i)
            else
                i = i + 1
            end
        end
    end
    
    local chosen = GLOBAL.GetRandomItem(list) -- choose random
    
    local rand = math.random(1,#chosen.numbers)
    giver.components.questgiver.questnumber = chosen.numbers[rand]
    giver.components.questgiver.questdiff = chosen.diff[rand]
    giver.components.questgiver.customstore = chosen
    local reached = giver.components.questgiver.questnumberreached 
    local questname = giver.components.questgiver.questname
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].NEAR) do
            table.insert(giver.components.questgiver.talking.near,string.format(entry,reached,giver.components.questgiver.questnumber,GLOBAL.STRINGS.NAMES[string.upper(giver.components.questgiver.customstore.name)] or giver.components.questgiver.customstore.name)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].FAR) do
            table.insert(giver.components.questgiver.talking.far,string.format(entry,reached,giver.components.questgiver.questnumber,GLOBAL.STRINGS.NAMES[string.upper(giver.components.questgiver.customstore.name)] or giver.components.questgiver.customstore.name)) -- if there is no %i in the string, string.format wont change the string
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
    print("KillQuest init with "..GLOBAL.tostring(giver.components.questgiver.customstore.name))
end

if GLOBAL.TUNING.QUESTSMOD.QUESTS==nil then
    GLOBAL.TUNING.QUESTSMOD.QUESTS = {}
end
-- questname:             (string)   An unique quest name
-- questdiff:             (integer)  Difficulty of your quest between 1 and 5 (1=veryeasy, 5=veryhard). The harder the quest, the more reward the players will get by default
-- questnumber:           (integer)  A number that can be used in the checkfunction, to check if the goal of the quest was reached. Eg. used in checkfn="reachnumber". You can increase questnumberreached and as soon as it is higher or equal to questnumber, the quest is fnished.
-- questtimer :           (float)    Can be used to resett questnumberreached after a certain amount of time. Keep in mind that if the game is closed and started again, DoTaskInTime stopps. Is eg. used to force more than one player to emote at same time, by restting the number after 1 second
-- talknear/talkfar:      (integer)  The distance to questgiver when he starts saying something, like "hello", "goodbye".
-- questobject:           (instance) This is an instance you want to save. You can use "self" if you want it to be the questgiver. Or it could be an object that the players should destroy/guard or whatever. In last case you should define it in the quest initfn.
-- questgiver:            (prefab)   Prefab of the questgiver. It is better if the questgiver only exists once in the world, otherwise everyone of them has the same quests.
-- customrewarditems      (table)    Table of prefabs of the items you want to spawn. Every item in this list is spawned once, so if you want 2 cutgrass, it should contain cutgrass two times (you can also fill it in your initfn). Leave it empty, if you want default ones.
-- customrewardblueprints (table)    Table of prefabs of the blueprints you want to spawn as reward. Leave it empty, if you want default ones.
-- checkfn                (function) This function is called in QueckQuest, which you can call yourself or it is called when a player is in talknear/talkfar range of the questgiver, return a true value, if the quest is finished. If you set it to "reachnumber" (string), it is checked if questnumberreached is enough to solve the quest.
-- rewardfn               (function) This function is called when the quest is finished. You can also set it to the following strings: 1) "default"->Depending on the modsettings, it will give blueprints,coins or items (If you set them up, it will be your custom ones). 2) "items"->Items from the REWARDITEMS or if set from customrewarditems list are distributed. 3) "blueprints" blueprints as reward, you should define which ones in customrewardblueprints. If not the modsetting has to be blueprintmode to spawn predefined blueprints, otherwise the reward will be nothing.
-- initfn                 (function) A function that is called once directly after starting the quest. Here you can spawn something or set some values for the quest.
-- animationfn            (function) Is called shortly before releasing the reward. You can make it nil for no animation of "default" for the default animation. For default currently supported are pigking and pigman.
-- customstore            (any)      Can be anything, EXCEPT an object/instance. You can use it to store your custom information. Eg. for the emote quest, I store the ranomly chosen emotion in this.
-- talking                (strings)  talking={near={},far={},solved={},wantskip={}}. In the tables near, far, solved, wantskip, you can add strings the questgiver should say when a player goes near him, leaves him, when the quest is solved or to ask if the player really wants to skip the quest. A random string form the list is chosen each time. Of course you can also fill it during your initfn.
-- skippable              (boolean)  true or false (true by default). If according to modsettings quests are skippable and this skippable entry is not false, the quest will be skippable by perfomring three times within 30 seconds the Annoyed emotion. If not "false", the skippable entry will be set to numbers, to count the times you made the Annoyed animation. So to check if a quest is skippable do a ~=false check.
-- onetime                (boolean)  true or false (nil-> false). If true, this quest at this questgiver can only be solved one time, even it loopquests is active. Eg. if quest is destroy a statue. You can only destroy it once.  
-- HINT about functions: The functions you store here are only saved in this Tuning table. Functions can not be saved in the questgiver component. So if you want to access a function, do it with help of the tuning table.

local killquest = {questname="KillQuest",skippable=true,questdiff=1,questnumber=1,questtimer=nil,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn="reachnumber",rewardfn="default",initfn=InitKillQuest,animationfn="default",talking={near={},far={},solved={},wantskip={},skipped={}},customstore={}}
for i=1,GetModConfigData("number") do -- add the quest 10 times IMPORTANT: if adding entries with the same questname, keep also all other values the same! You can variate them in the initfn instead!
    table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, killquest)
end



-- for k,quest in pairs(GLOBAL.TUNING.QUESTSMOD.QUESTS) do --## you can change quests from other mods 
    -- if quest.questname=="Emote" then
        -- quest.initfn = InitEmoteQuest -- my new initfn. Changes here do only affect new games. To affect running games, you have to change also the questlist of all questgivers. functions are only stored in this GLOBAL table, not in questgiver, so chaging them here should be enough
        -- quest.skippable = false
    -- end
-- end






----------------------------



local function OnPlayerSpawn(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end
AddPlayerPostInit(OnPlayerSpawn)




AddPrefabPostInit("world", function(world)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)




AddPrefabPostInit("pigking",function(inst)
    -- if inst.components.talker==nil then -- only add it if it was not added by another questmod before
        -- inst:AddComponent("talker")
        -- inst.components.talker.offset = GLOBAL.Vector3(0, -500, 0) -- default is Vector3(0, -400, 0)
        -- inst.components.talker.fontsize = 40 -- 35 ist default
    -- end
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)

