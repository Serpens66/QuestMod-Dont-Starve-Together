

local _G = GLOBAL
   
-- import the strings from that file
modimport "mymodstrings.lua" -- acts like I would write the code of that scripte here


print("QUESTSMOD QuestMod")

PrefabFiles = { 
    "skin_collector",
    "maxy",
    "diviningrod",
}
Assets = {
    Asset( "ANIM", "anim/skin_collector.zip"),
    Asset( "IMAGE", "images/map_icons/skin_collector.tex" ),
    Asset( "ATLAS", "images/map_icons/skin_collector.xml" ),
    Asset( "SOUNDPACKAGE", "sound/skin_collector.fev"),    
    Asset( "SOUND", "sound/skin_collector.fsb"),

    Asset( "ANIM", "anim/maxy.zip"),
    Asset( "IMAGE", "images/map_icons/maxy.tex" ),
    Asset( "ATLAS", "images/map_icons/maxy.xml" ),

    Asset( "ANIM", "anim/diviningrod.zip"),
    Asset( "IMAGE", "images/map_icons/rod.tex" ),
    Asset( "ATLAS", "images/map_icons/rod.xml" ),
}


RemapSoundEvent( "dontstarve/characters/skincollector/talk_LP", "skin_collector/sound/talk_LP" )

-- store all questgivers in GLOBAL.TUNING.QUESTSMOD.GIVERS to loop through them and find the one with the quest you are searching for. 
-- when only searching for a questgiver in a specifc range, you can also use instead: TheSim:FindEntities(x, y, z, 100, nil, nil, {"questgiver"})

---------------- ## QUEST help functions
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

local function HarvestSomething()
    print("done cooking")
end

local function OnDeployItem(player,data)
    local treeseeds = {"pinecone","twiggy_nut","acorn"}
    local butterfly = {"butterfly"}
    if player~=nil and data~=nil and type(data)=="table" and type(player)=="table" then
        print("Quest Debug: player ".._G.tostring(player.prefab).." deployed: ".._G.tostring(data.prefab))
    end
    if data and data then 
        local x, y, z = player.Transform:GetWorldPosition()
        local questgivers = TheSim:FindEntities(x, y, z, 100, nil, nil, {"questgiver"}) 
        if GLOBAL.table.contains(treeseeds,data.prefab) then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="Reforester_Rod" or giver.components.questgiver.questname=="Reforester_Maxy" or giver.components.questgiver.questname=="Reforester_Skin" or giver.components.questgiver.questname=="Reforester_Glommer"  then
                    giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    -- update strings
                    if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                        giver.components.questgiver.talking.examine = {}
                        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].EXAMINE) do
                            table.insert(giver.components.questgiver.talking.examine,string.format(entry,giver.components.questgiver.questnumber-giver.components.questgiver.questnumberreached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                        end
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end
            end
        elseif GLOBAL.table.contains(butterfly,data.prefab) then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="Flourist_Glommer" or giver.components.questgiver.questname=="Flourist_Stagehand"  then
                    giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    -- update strings
                    if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                        giver.components.questgiver.talking.examine = {}
                        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].EXAMINE) do
                            table.insert(giver.components.questgiver.talking.examine,string.format(entry,giver.components.questgiver.questnumber-giver.components.questgiver.questnumberreached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                        end
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end            
            end
        end
    end
end

local function OnFinishedWork(player,data)
    local tree = {"evergreen","deciduoustree","marsh_tree","evergreen_sparse","livingtree","twiggytree"}
    if player~=nil and data~=nil and type(data)=="table" and type(player)=="table" then
        print("Quest Debug: player ".._G.tostring(player.prefab).." worked: ".._G.tostring(data.target.prefab))
    end
    if data and data then 
        local x, y, z = player.Transform:GetWorldPosition()
        local questgivers = TheSim:FindEntities(x, y, z, 150, nil, nil, {"questgiver"}) 
        if GLOBAL.table.contains(tree,data.target.prefab) then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="Lumberjack_Rod" or giver.components.questgiver.questname=="Lumberjack_Maxy" or giver.components.questgiver.questname=="Lumberjack_Skin" or giver.components.questgiver.questname=="Lumberjack_Glommer"  then
                    giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    -- update strings
                    if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                        giver.components.questgiver.talking.examine = {}
                        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].EXAMINE) do
                            table.insert(giver.components.questgiver.talking.examine,string.format(entry,giver.components.questgiver.questnumber-giver.components.questgiver.questnumberreached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                        end
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end
            end
        end
    end
end

local function OnPickSomething(player,data)
    local flowers = {"flower","planted_flower","flowers"}
    if player~=nil and data~=nil and type(data)=="table" and type(player)=="table" then
        print("Quest Debug: player ".._G.tostring(player.prefab).." picked: ".._G.tostring(data.prefab))
    end
    if data and data then
        local x, y, z = player.Transform:GetWorldPosition()
        local questgivers = TheSim:FindEntities(x, y, z, 100, nil, nil, {"questgiver"}) 
        if GLOBAL.table.contains(flowers,data.object.prefab) then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname== "FlowerPick_Glommer" or giver.components.questgiver.questname== "FlowerPick_Stagehand" then
                    giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    -- update strings
                    if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                        giver.components.questgiver.talking.examine = {}
                        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].EXAMINE) do
                            table.insert(giver.components.questgiver.talking.examine,string.format(entry,giver.components.questgiver.questnumber-giver.components.questgiver.questnumberreached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                        end
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end
            end
        end
    end
end

--[[
local function InitSleepOver(giver)
end
-- check function is automatically called when walking in range of questgiver. While sleeping you can't walk, so you need an event that is fired when sleeping and then call giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end) this will also call your specifc checkfn
-- problem here is, that there seems to be no event for sleeping (only "sleep" in sense of "pause"=offscreen)
-- so we need another solution. The only one I can imagine is a PeriodicTask which calles CheckQuests every few seconds. So I added periodicfn to api mod
local function PeriodicSleepOver(giver)
    giver.components.questgiver:CheckQuests()
end
local function CheckSleepOver(giver) 
    local x, y, z = giver.components.questgiver.questobject.Transform:GetWorldPosition()
    local sleepers = GLOBAL.TheSim:FindEntities(x, y, z, 10, {"player","sleeping"})
    if #sleepers >= giver.components.questgiver.questnumber then
        giver.components.questgiver.queststatus="finished"
    end
end
]]

local function InitReforester(giver)
    -- generate random number
    local l = {10,20,30}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {10}
    elseif age <60 then
        l = {10,20}
    elseif age < 100 then
        l = {20,30,30,40}
    elseif age >= 100 then
        l = {30,50}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l)
    giver.components.questgiver.questnumber = num
    giver.components.questgiver.questdiff = num / 10
    local reached = giver.components.questgiver.questnumberreached 
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,num-reached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function InitLumberjack(giver)
    -- generate random number
    local l = {10,20,30}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {10}
    elseif age <60 then
        l = {10,20}
    elseif age < 100 then
        l = {20,30,30,40}
    elseif age >= 100 then
        l = {30,50}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l)
    giver.components.questgiver.questnumber = num
    giver.components.questgiver.questdiff = num / 10
    local reached = giver.components.questgiver.questnumberreached 
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,num-reached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end


local function InitEmotey(giver) -- #GLOBAL.AllPlayers is only players in one world, GLOBAL.TheNet:GetPlayerCount() is the number of players on forest and cave together
    local num = 1 --  the number of emotions that should be done within 0.5 seconds [questtimer] (that way several players should make it at once)
    giver.components.questgiver.questnumber = num
    local timer = giver.components.questgiver.questtimer
    local questname = giver.components.questgiver.questname
    local Emotions = giver.components.questgiver.customstore -- load the customstore with emotions (that way they can also be edited by other mods loading after this one)
    giver.components.questgiver.customstore = GLOBAL.GetRandomItem(Emotions)
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,GLOBAL.tostring(giver.components.questgiver.customstore.str),num,timer)) -- add information about what emotion is wanted to the strings, which contain "%s"
        end
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP) do
            table.insert(giver.components.questgiver.talking.wantskip,string.format(entry,GLOBAL.tostring(giver.components.questgiver.customstore.str)))
        end
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED --{"That was nice!"}
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end    

    print("Emotey initialized with "..GLOBAL.tostring(giver.components.questgiver.customstore.str))
end

local function OnEmote(player,data) -- eg customstore=={str="Dance",anims{"emoteXL_loop_dance0","emoteXL_pre_dance0"}}
    -- print("OnEmote "..tostring(player))
    -- print(_G.fastdump(data)) 
    -- {mounted=true,loop=true,tags={["dancing"]},state="idle",beaver=true,anim={["emoteXL_pre_dance0"],["emoteXL_loop_dance0"]},fx=false}
    -- {anim="emoteXL_kiss",mounted=true} , {anim="emoteXL_bonesaw",mounted=true} , {anim="emoteXL_angry",mounted=true} , {anim="emoteXL_happycheer",mounted=true} , {mounted=true,randomanim=true,anim={["emoteXL_waving1"],["emoteXL_waving2"]}}
    -- {anim="emoteXL_facepalm",mounted=true}, {anim="research",fx=false}joy, {mounted=true,fx="tears",anim="emoteXL_sad",fxdelay=0.56666666666667}, {anim="emoteXL_annoyed",mounted=true}, {mounted=true,randomanim=true,anim={["emoteXL_waving4"],["emoteXL_waving3"]}}
    -- {fx=false,randomanim=true,anim={{["emote_pre_sit2"],["emote_loop_sit2"]},{["emote_pre_sit4"],["emote_loop_sit4"]}},loop=true}    
    -- {fx=false,randomanim=true,anim={{["emote_pre_sit1"],["emote_loop_sit1"]},{["emote_pre_sit3"],["emote_loop_sit3"]}},loop=true}    
    if data then
        local okay = false
        local x, y, z = player.Transform:GetWorldPosition() 
        local questgivers = TheSim:FindEntities(x, y, z, 6, nil, nil, {"questgiver"})
        for i,giver in ipairs(questgivers) do
            if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="Emotey_Maxy" or giver.components.questgiver.questname=="Emotey_Skin" or giver.components.questgiver.questname=="Emotey_Rod" and type(giver.components.questgiver.customstore)=="table" then
                if type(data.anim)=="string" and giver.components.questgiver.customstore.anims[1] == data.anim then -- if data.anim is a string, we only need to check first.
                    okay = true
                elseif type(data.anim)=="table" then -- chack also if anim is a table
                    for k,animstringdata in pairs(data.anim) do
                        if type(animstringdata)=="table" then -- in cae of sit and aquat it is again a table...
                            for q,stringdata in pairs(animstringdata) do
                                for k2,animstring in pairs(giver.components.questgiver.customstore.anims) do
                                    if animstring == stringdata then
                                        okay = true
                                    end
                                end 
                            end
                        elseif type(animstringdata)=="string" then
                            for k2,animstring in pairs(giver.components.questgiver.customstore.anims) do
                                if animstring == animstringdata then
                                    okay = true
                                end
                            end
                        end
                    end
                end
                if okay then
                    giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    if giver.components.questgiver.questtimer and giver.components.questgiver.questnumberreached < giver.components.questgiver.questnumber then -- do not restt, if the number is already reached
                        giver:DoTaskInTime(giver.components.questgiver.questtimer,function(giver) giver.components.questgiver.questnumberreached = 0 end) -- number is resett to 0 after few seconds () -> you have to emote with several players at same time to reach the questnumber
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end
            end
        end
    end
end

local function InitFlourist(giver)
    -- generate random number
    local l = {10,20,30}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {5}
    elseif age <60 then
        l = {5,10}
    elseif age < 100 then
        l = {10,20,20,30}
    elseif age >= 100 then
        l = {20,30,40}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l)
    giver.components.questgiver.questnumber = num
    --giver.components.questgiver.questdiff = num / 10
    local reached = giver.components.questgiver.questnumberreached 
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,num-reached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end
local function InitFlowerPick(giver)
    -- generate random number
    local l = {10,20,30}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {5}
    elseif age <60 then
        l = {5,10}
    elseif age < 100 then
        l = {10,20,20,30}
    elseif age >= 100 then
        l = {20,30,40}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l)
    giver.components.questgiver.questnumber = num
    --giver.components.questgiver.questdiff = num / 10
    local reached = giver.components.questgiver.questnumberreached 
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,num-reached)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function SkinRewardAnim(inst)
    inst.AnimState:PlayAnimation("snap", false)
    inst.AnimState:PushAnimation("dialog_pre")
    inst.AnimState:PushAnimation("dial_loop")
    inst.AnimState:PushAnimation("dialog_pst", false)
    inst.AnimState:PushAnimation("idle", true)

    inst:DoTaskInTime(0.2,function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/skincollector/snap", "skincollector") end)
end
local function MaxyRewardAnim(inst)
    inst.AnimState:PlayAnimation("smoke")
    inst.AnimState:PushAnimation("dialog_pre")
    inst.AnimState:PushAnimation("dial_loop")
    inst.AnimState:PushAnimation("dialog_pst", false)
    inst.AnimState:PushAnimation("idle", true)
end
local function GlommerRewardAnim(inst)
    inst.AnimState:PlayAnimation("bored")
    inst.AnimState:PushAnimation("idle", true)
end
local function StageHandRewardAnim(inst)
    inst.AnimState:PlayAnimation("extinguish")
    --inst.AnimState:PushAnimation("idle")

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_girl_howl")
end
------------------------- ## Quests
if GLOBAL.TUNING.QUESTSMOD==nil then
    GLOBAL.TUNING.QUESTSMOD = {}
end
if GLOBAL.TUNING.QUESTSMOD.QUESTS==nil then
    GLOBAL.TUNING.QUESTSMOD.QUESTS = {}
end
-- questname:             (string)   An unique! quest name
-- questdiff:             (integer)  Difficulty of your quest between 1 and 5 (1=veryeasy, 5=veryhard). The harder the quest, the more reward the players will get by default
-- questnumber:           (integer)  A number that can be used in the checkfunction, to check if the goal of the quest was reached. Eg. used in checkfn="reachnumber". You can increase questnumberreached and as soon as it is higher or equal to questnumber, the quest is fnished.
-- questtimer :           (float)    Can be used to resett questnumberreached after a certain amount of time. Keep in mind that if the game is closed and started again, DoTaskInTime stopps. Is eg. used to force more than one player to emote at same time, by restting the number after 1 second
-- talknear/talkfar:      (integer)  The distance to questgiver when he starts saying something, like "hello", "goodbye".
-- questobject:           (instance) This is an instance you want to save. You can use "self" if you want it to be the questgiver. Or it could be an object that the players should destroy/guard or whatever. In last case you should define it in the quest initfn.
-- questgiver:            (prefab)   Prefab of the questgiver. It is better if the questgiver only exists once in the world, otherwise everyone of them has the same quests.
-- customrewarditems      (table)    Table of prefabs of the items you want to spawn. Every item in this list is spawned once, so if you want 2 cutgrass, it should contain cutgrass two times (you can also fill it in your initfn). Leave it empty, if you want default ones. They are only distributed, if shopmode is inactive, or rewardfn is "items".
-- customrewardblueprints (table)    Table of prefabs of the blueprints you want to spawn as reward. Leave it empty, if you want default ones.
-- checkfn                (function) This function is called in QueckQuest, which you can call yourself or it is called when a player is in talknear/talkfar range of the questgiver, return a true value, if the quest is finished. If you set it to "reachnumber" (string), it is checked if questnumberreached is enough to solve the quest.
-- rewardfn               (function) This function is called when the quest is finished. You can also set it to the following strings: 1) "default"->Depending on the modsettings, it will give blueprints,coins or items (If you set them up, it will be your custom ones). 2) "items"->Items from the REWARDITEMS or if set from customrewarditems list are distributed. 3) "blueprints" blueprints as reward, you should define which ones in customrewardblueprints. If not, the modsetting has to be blueprintmode to spawn predefined blueprints, otherwise the reward will be nothing.
-- initfn                 (function) A function that is called once directly after starting the quest. Here you can spawn something or set some values for the quest.
-- animationfn            (function) Is called shortly before releasing the reward. You can make it nil for no animation of "default" for the default animation. For default currently supported are pigking and pigman.
-- customstore            (any)      Can be anything, EXCEPT an object/instance. You can use it to store your custom information. Eg. for the emote quest, I store the ranomly chosen emotion in this. You can also save this to store a character prefab, so only this character can solve your quest or whatever.
-- talking                (strings)  talking={near={},far={},solved={},wantskip={}}. In the tables near, far, solved, wantskip, you can add strings the questgiver should say when a player goes near him, leaves him, when the quest is solved or to ask if the player really wants to skip the quest. A random string form the list is chosen each time. Of course you can also fill it during your initfn. If you fill them in initfn, better let them empty in global QUESTS.
-- skippable              (boolean)  true or false (true by default). If according to modsettings quests are skippable and this skippable entry is not false, the quest will be skippable by perfomring three times within 30 seconds the Annoyed emotion. If not "false", the skippable entry will be set to numbers, to count the times you made the Annoyed animation. So to check if a quest is skippable do a ~=false check.
-- onetime                (boolean)  true or false (nil-> false). If true, this quest at this questgiver can only be solved one time, even it loopquests is active. Eg. if quest is destroy a statue. You can only destroy it once.         
-- periodicfn             (function) This function will be called periodically with periodictimes, starting after the initfn. You can eg. use it to call CheckQuest. If possible better use an event to check quests or the automatic check when a player goes near the questgiver! But if both is not possible, use this. The api mod will save and load the task automatically and also cancel it, if the quest is solved/skipped.
-- periodictimes          (float)    1 -> call it every 1 second.
-- whensayfn              (function) this function is called everytime shorlty before the questgiver is saying something. params: giver,kind,str. kind can be "near","far","solved","wantskip" and "skipped". str is the string he will say. Here you could add your custom talking sound/animation. Make sure it is compatible to your animationfn, which is played when solved!
-- HINT about functions: The functions you store here are only saved in this Tuning table. Functions can not be saved in the questgiver component. So if you want to access a function, do it with help of the tuning table.

--  table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {
--     questname="Critter",
--     skippable=true,
--     questdiff=3,
--     questnumber=1,
--     questtimer=nil,
--     talknear=8,
--     talkfar=9,
--     questobject="self",
--     questgiver="pigking",
--     customrewarditems={},
--     customrewardblueprints={},
--     checkfn=CheckCritterQuest,
--     rewardfn="default",
--     initfn=InitCritterQuest,
--     animationfn="default",
--     talking={
--         examine={},
--         solved={},
--         wantskip={},
--         skipped={}
--         },
--     customstore=nil
--     }
-- )
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Emotey_Maxy",
    onetime=true,
    skippable=false, 
    questdiff=1,
    questnumber=1,
    questtimer=0.5,
    talknear=8
    ,talkfar=9,
    questobject="self",
    questgiver="maxy",
    customrewarditems={""},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="items",
    initfn=InitEmotey,
    animationfn=MaxyRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        },
    customstore={{str="Wave",anims={"emoteXL_waving1","emoteXL_waving1"}},},
    }
)
--[[
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Sleepover_Maxy",
    conditions={"Emotey_Maxy"},
    onetime=false,
    skippable=true, 
    periodicfn=PeriodicSleepOver, 
    periodictimes=2,
    questdiff=1,
    questnumber=1,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="maxy",
    customrewarditems={},
    customrewardblueprints={},
    checkfn=CheckSleepOver,
    rewardfn="default",
    initfn=InitSleepOver,
    animationfn=MaxyRewardAnim,
    talking= {
        examine= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_MAXY.EXAMINE,
        solved= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_MAXY.SOLVED,
        wantskip= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_MAXY.WANTSKIP,
        skipped= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_MAXY.SKIPPED
        }
    }
)
]]
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Reforester_Maxy",
    conditions={"Emotey_Maxy"},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="maxy",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitReforester,
    animationfn=MaxyRewardAnim,
     talking={
         examine={},
         solved={},
         wantskip={},
         skipped={}
         }
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Lumberjack_Maxy",
    conditions={"Emotey_Maxy"},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="maxy",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitLumberjack,
    animationfn=MaxyRewardAnim,
     talking={
         examine={},
         solved={},
         wantskip={},
         skipped={}
         }
    }
)

table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Emotey_Skin",
    onetime=true,
    skippable=false, 
    questdiff=1,
    questnumber=1,
    questtimer=0.5,
    talknear=8
    ,talkfar=9,
    questobject="self",
    questgiver="skin_collector",
    customrewarditems={""},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="items",
    initfn=InitEmotey,
    animationfn=SkinRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        },
    customstore={{str="Wave",anims={"emoteXL_waving1","emoteXL_waving1"}},},
    }
)
--[[
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Sleepover_Skin",
    conditions={"Emotey_Skin"},
    onetime=false,
    skippable=true, 
    periodicfn=PeriodicSleepOver, 
    periodictimes=2,
    questdiff=1,
    questnumber=1,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="skin_collector",
    customrewarditems={},
    customrewardblueprints={},
    checkfn=CheckSleepOver,
    rewardfn="default",
    initfn=InitSleepOver,
    animationfn=SkinRewardAnim,
    talking= {
        examine= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_SKIN.EXAMINE,
        solved= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_SKIN.SOLVED,
        wantskip= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_SKIN.WANTSKIP,
        skipped= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER_SKIN.SKIPPED
        }
    }
)
]]
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Reforester_Skin",
    conditions={"Emotey_Skin"},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="skin_collector",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitReforester,
    animationfn=SkinRewardAnim,
     talking={
         examine={},
         solved={},
         wantskip={},
         skipped={}
         }
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Lumberjack_Skin",
    conditions={"Emotey_Skin"},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="skin_collector",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitLumberjack,
    animationfn=SkinRewardAnim,
     talking={
         examine={},
         solved={},
         wantskip={},
         skipped={}
         }
    }
)

table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Reforester_Glommer",
    conditions={},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="glommer",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitReforester,
    animationfn=GlommerRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        }
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Flourist_Glommer",
    conditions={},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="glommer",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitFlourist,
    animationfn=GlommerRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        }
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="FlowerPick_Glommer",
    conditions={},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="glommer",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitFlowerPick,
    animationfn=GlommerRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        }
    }
)

table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Flourist_Stagehand",
    conditions={},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="stagehand",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitFlourist,
    animationfn=StageHandRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        }
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="FlowerPick_Stagehand",
    conditions={},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="stagehand",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitFlowerPick,
    animationfn=StageHandRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        }
    }
)


table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Emotey_Rod",
    onetime=true,
    skippable=false, 
    questdiff=1,
    questnumber=1,
    questtimer=0.5,
    talknear=8
    ,talkfar=9,
    questobject="self",
    questgiver="diviningrod",
    customrewarditems={""},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="items",
    initfn=InitEmotey,
    --animationfn=SkinRewardAnim,
    talking={
        examine={},
        solved={},
        wantskip={},
        skipped={}
        },
    customstore={{str="Wave",anims={"emoteXL_waving1","emoteXL_waving1"}},},
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Reforester_Rod",
    conditions={"Emotey_Rod"},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="diviningrod",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitReforester,
     talking={
         examine={},
         solved={},
         wantskip={},
         skipped={}
         }
    }
)
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Lumberjack_Rod",
    conditions={"Emotey_Rod"},
    onetime=false,
    skippable=true,
    questdiff=2,
    questnumber=100,
    questtimer=nil,
    talknear=4,
    talkfar=5,
    questobject="self",
    questgiver="diviningrod",
    customrewarditems={},
    customrewardblueprints={},
    checkfn="reachnumber",
    rewardfn="default",
    initfn=InitLumberjack,
    --animationfn=SkinRewardAnim,
     talking={
         examine={},
         solved={},
         wantskip={},
         skipped={}
         }
    }
)




-- you can also add quests with new world objects. see example in scripts/scenarios/quest_destroystatue_pig.lua. This scenario is added to the maxwell statue of the maxwell_pig_shrine.lua, which must be replaced in map folder.
-- it must be done this way, cause otherwise you would not know which maxwell statue to destroy. 

----------------- # SHOP
--- you can add your items or even overwrite the costs of a recipe from the api mod. The first mod adding a shopitem will define which one is to use, if there are more than one with the same name
if GLOBAL.TUNING.QUESTSMOD.SHOPITEMS==nil then
    GLOBAL.TUNING.QUESTSMOD.SHOPITEMS = {}
end
-- prefab -> the prefab from the item you want
-- costs  -> the amount of coins to buy it
-- image -> the name of the .tex (leave out the ".tex") file of the image of the item. Usually it the same like prefab, in this case you can leave it nil.
-- table.insert(GLOBAL.TUNING.QUESTSMOD.SHOPITEMS,{prefab = "cutgrass", costs = 5, image = nil}) -- eg. increase costs for grass
----------------------------






local function OnPlayerSpawn(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    inst:ListenForEvent("deployitem", OnDeployItem)
    inst:ListenForEvent("finishedwork", OnFinishedWork)
    inst:ListenForEvent("emote", OnEmote)
    inst:ListenForEvent("picksomething", OnPickSomething)
    
    inst:ListenForEvent("harvestsomething", HarvestSomething)

end
AddPlayerPostInit(OnPlayerSpawn)

local function SpawnSkin(world)
    local collector = TheSim:FindFirstEntityWithTag("skin_collector")
    local beefalo = TheSim:FindFirstEntityWithTag("beefalo")
    if not collector and beefalo then -- if there is no skinner, but there should be one, create one.
        GLOBAL.TUNING.questfunctions.SpawnPrefabAtLandPlotNearInst("skin_collector",beefalo,15,0,15,1,3,3)
    end
end

local function SpawnMaxy(world)
    local x,y,z = world.components.playerspawner.GetAnySpawnPoint()
    local spawnpointpos = GLOBAL.Vector3(x ,y ,z )       -- look for the portal
    local maxs = TheSim:FindFirstEntityWithTag("maxy")
    if not maxs then
        GLOBAL.TUNING.questfunctions.SpawnPrefabAtLandPlotNearInst("maxy",spawnpointpos,15,0,15,1,3,3) -- spawn him near the portal
    end
end


local function SpawnRod(world)
    local rod = TheSim:FindFirstEntityWithTag("diviningrod")
    local sculpture = TheSim:FindFirstEntityWithTag("sculpture")
    if not rod and sculpture then -- if there is no skinner, but there should be one, create one.
        GLOBAL.TUNING.questfunctions.SpawnPrefabAtLandPlotNearInst("diviningrod",sculpture,5,0,5,1,3,3)
    end
end



AddPrefabPostInit("skin_collector", function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)

AddPrefabPostInit("maxy", function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)

AddPrefabPostInit("diviningrod", function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)


AddPrefabPostInit("world", function(world)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if world.ismastersim and world.ismastershard then
        world:DoTaskInTime(0,function(world) SpawnSkin(world) end)
        world:DoTaskInTime(0,function(world) SpawnMaxy(world) end)
        world:DoTaskInTime(0,function(world) SpawnRod(world) end)
    end
end)

AddPrefabPostInit("glommer", function(inst)
    if inst.components.talker==nil then -- if not added already, add it with some default settings
        inst:AddComponent("talker")
        inst.components.talker.offset = GLOBAL.Vector3(0, -550, 0) -- default is Vector3(0, -400, 0)
        inst.components.talker.fontsize = 30 -- 35 ist default
        inst.components.talker.colour = GLOBAL.Vector3(1, 1, 1) -- talking colour when no quest -- here it must be a vector ={x=0.25,y=.5,z=0.4}, but in the Say() function is must look like this {0.25,0.5,0.4,1}
    end
end)
AddPrefabPostInit("stagehand", function(inst)
    if inst.components.talker==nil then -- if not added already, add it with some default settings
        inst:AddComponent("talker")
        inst.components.talker.offset = GLOBAL.Vector3(0, -550, 0) -- default is Vector3(0, -400, 0)
        inst.components.talker.fontsize = 30 -- 35 ist default
        inst.components.talker.colour = GLOBAL.Vector3(1, 1, 1) -- talking colour when no quest -- here it must be a vector ={x=0.25,y=.5,z=0.4}, but in the Say() function is must look like this {0.25,0.5,0.4,1}
        inst.components.talker.ontalk = function(inst) inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_girl_howl") end
    end
end)


AddMinimapAtlas("images/map_icons/maxy.xml")
AddMinimapAtlas("images/map_icons/skin_collector.xml")
AddMinimapAtlas("images/map_icons/rod.xml")