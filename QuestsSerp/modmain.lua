

local _G = GLOBAL
   
-- import the strings from that file
modimport "mymodstrings.lua" -- acts like I would write the code of that scripte here


print("QUESTSMOD QuestMod")


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

local function OnDeployItem(player,data)
    if player~=nil and data~=nil and type(data)=="table" and type(player)=="table" then
        print("Quest Debug: player ".._G.tostring(player.prefab).." deployed: ".._G.tostring(data.prefab))
    end
    if data and data then 
        local x, y, z = player.Transform:GetWorldPosition()
        local questgivers = TheSim:FindEntities(x, y, z, 100, nil, nil, {"questgiver"}) 
        if string.match(data.prefab,"wall") then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="BuildWall" then
                    if data.prefab=="wall_hay_item" then
                        giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    elseif data.prefab=="wall_wood_item" then
                        giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 2.5
                    elseif data.prefab=="wall_stone_item" then
                        giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 5
                    elseif data.prefab=="wall_ruins_item" then
                        giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 10
                    elseif data.prefab=="wall_moonrock_item" then
                        giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 10
                    end
                    -- update strings
                    if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                        giver.components.questgiver.talking.examine = {}
                        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].EXAMINE) do
                            table.insert(giver.components.questgiver.talking.examine,string.format(entry,giver.components.questgiver.questnumberreached,giver.components.questgiver.questnumber)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                        end
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end
            end
        end
    end
end

local function OnStructureBuild(player,data) -- data.item and data.recipe
    if player~=nil and data~=nil and type(data)=="table" and type(player)=="table" and data.item then
        print("Quest Debug: player ".._G.tostring(player.prefab).." build: ".._G.tostring(data.item.prefab))
    end
    if data and data.item then 
        local x, y, z = player.Transform:GetWorldPosition()
        local questgivers = TheSim:FindEntities(x, y, z, 100, nil, nil, {"questgiver"}) 
        if data.item.prefab=="pighouse" then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="BuildPighouses" then
                    giver.components.questgiver.questnumberreached = giver.components.questgiver.questnumberreached + 1
                    -- update strings
                    if GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)] then
                        giver.components.questgiver.talking.examine = {}
                        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(giver.components.questgiver.questname)].EXAMINE) do
                            table.insert(giver.components.questgiver.talking.examine,string.format(entry,giver.components.questgiver.questnumberreached,giver.components.questgiver.questnumber)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
                        end
                    end
                    giver:DoTaskInTime(0.1,function(giver) giver.components.questgiver:CheckQuests() end)
                end
            end
        end
    end
end

local function InitEmoteQuest(giver) -- #GLOBAL.AllPlayers is only players in one world, GLOBAL.TheNet:GetPlayerCount() is the number of players on forest and cave together
    local num = GLOBAL.TheNet:GetPlayerCount() - 1 --  the number of emotions that should be done within 0.5 seconds [questtimer] (that way several players should make it at once)
    num = num > 0 and num or 1
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
    if giver.components.questgiver.customstore.str=="Annoyed" then
        giver.components.questgiver.skippable = false -- this is the only quest that can't be skipped by doing the annoyed emotion
    end
    
    print("EmoteQuest initialized with "..GLOBAL.tostring(giver.components.questgiver.customstore.str))
end

local function OnEmote(player,data) -- eg customstore=={str="Dance",anims{"emoteXL_loop_dance0","emoteXL_pre_dance0"}}
    -- print("OnEmote "..tostring(player))
    -- print(_G.fastdump(data)) 
    -- {mounted=true,loop=true,tags={["dancing"]},state="idle",beaver=true,anim={["emoteXL_pre_dance0"],["emoteXL_loop_dance0"]},fx=false}
    -- {anim="emoteXL_kiss",mounted=true} , {anim="emoteXL_bonesaw",mounted=true} , {anim="emoteXL_angry",mounted=true}	, {anim="emoteXL_happycheer",mounted=true} , {mounted=true,randomanim=true,anim={["emoteXL_waving1"],["emoteXL_waving2"]}}
    -- {anim="emoteXL_facepalm",mounted=true}, {anim="research",fx=false}joy, {mounted=true,fx="tears",anim="emoteXL_sad",fxdelay=0.56666666666667}, {anim="emoteXL_annoyed",mounted=true}, {mounted=true,randomanim=true,anim={["emoteXL_waving4"],["emoteXL_waving3"]}}
    -- {fx=false,randomanim=true,anim={{["emote_pre_sit2"],["emote_loop_sit2"]},{["emote_pre_sit4"],["emote_loop_sit4"]}},loop=true}	
    -- {fx=false,randomanim=true,anim={{["emote_pre_sit1"],["emote_loop_sit1"]},{["emote_pre_sit3"],["emote_loop_sit3"]}},loop=true}	
    if data then
        local okay = false
        local x, y, z = player.Transform:GetWorldPosition() 
        local questgivers = TheSim:FindEntities(x, y, z, 12, nil, nil, {"questgiver"})
        for i,giver in ipairs(questgivers) do
            if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="Emote" and type(giver.components.questgiver.customstore)=="table" then
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

local function InitHousesQuest(giver)
    -- generate random number
    local questname = giver.components.questgiver.questname
    local l = {1,2,3}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {1}
    elseif age <60 then
        l = {1,2}
    elseif age < 100 then
        l = {1,2,2,3}
    elseif age >= 100 then
        l = {2,3,3}
    end
    local num = GLOBAL.GetRandomItem(l)
    giver.components.questgiver.questnumber = num
    giver.components.questgiver.questdiff = num
    local reached = giver.components.questgiver.questnumberreached 
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,reached,num)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function InitPigHatsQuest(giver)
    -- random amount of hats required
    local l = {2,4,6}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {2}
    elseif age <60 then
        l = {2,4}
    elseif age < 100 then
        l = {2,4,4,6}
    elseif age >= 100 then
        l = {4,6}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l) 
    giver.components.questgiver.questdiff = num / 2
    giver.components.questgiver.questnumber = num
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,num)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP) do
            table.insert(giver.components.questgiver.talking.wantskip,string.format(entry,num))
        end
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED --{"That was nice!"}
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function CheckHats(giver) -- giver is the questgiver
    local x, y, z = giver.components.questgiver.questobject.Transform:GetWorldPosition()
    local pigs = GLOBAL.TheSim:FindEntities(x, y, z, 20, nil, nil, {"pig"})
    local pigswithhat = 0
    for k,v in pairs(pigs) do
        if v.components and v.components.inventory and v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)~=nil then
            pigswithhat = pigswithhat + 1
        end
    end
    if pigswithhat>=giver.components.questgiver.questnumber then 
        giver.components.questgiver.queststatus="finished" -- set it finished, if the quest is filled
    end
end

local function CheckDestroy0(giver) -- must be this way, cause when statue is destroyed no event is fired -.-   if there would be an event for destroying, we can simply use this and increase questnumberreached until it reaches questnumber
    if (giver.components.questgiver.questobject==nil or not giver.components.questgiver.questobject:IsValid()) then -- then the statue is most likely destroyed
        giver.components.questgiver.queststatus="finished"
    end
end

local function InitWallQuest(giver)
    -- generate random number
    local l = {40,80,120}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {40}
    elseif age <60 then
        l = {40,80}
    elseif age < 100 then
        l = {40,80,80,120}
    elseif age >= 100 then
        l = {80,120}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l)
    giver.components.questgiver.questnumber = num
    giver.components.questgiver.questdiff = num / 40
    local reached = giver.components.questgiver.questnumberreached 
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,reached,num)) -- add information about what emotion is wanted to the strings, which contain "%s" for string or %i for number
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function InitTeenbirdQuest(giver)
    local l = {1,1,2}
    local age = GetAveragePlayerAgeInDays()
    if age <=25 then
        l = {1}
    elseif age <60 then
        l = {1,1,2}
    elseif age < 100 then
        l = {1,2}
    elseif age >= 100 then
        l = {1,2,2}
    end
    local questname = giver.components.questgiver.questname
    local num = GLOBAL.GetRandomItem(l) -- 1 or 2 teenbirds
    giver.components.questgiver.questnumber = num
    giver.components.questgiver.questdiff = 2 + num -- 3 or 4 diff
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,num)) 
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function CheckTeenbirdQuest(giver)
    local x, y, z = giver.components.questgiver.questobject.Transform:GetWorldPosition()
    local birds = GLOBAL.TheSim:FindEntities(x, y, z, 20, nil, nil, {"teenbird"})
    if #birds >= giver.components.questgiver.questnumber then
        giver.components.questgiver.queststatus="finished"
    end
end

local function InitCritterQuest(giver)
    local questname = giver.components.questgiver.questname
    local critters = {"critter_kitten", "critter_puppy", "critter_lamb", "critter_dragonling", "critter_glomling", "critter_perdling"}
    giver.components.questgiver.customstore = GLOBAL.GetRandomItem(critters) -- choose a random critter
    -- adjust strings
    if GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)] then
        for k,entry in ipairs(GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].EXAMINE) do
            table.insert(giver.components.questgiver.talking.examine,string.format(entry,GLOBAL.STRINGS.NAMES[string.upper(giver.components.questgiver.customstore)])) 
        end
        giver.components.questgiver.talking.wantskip = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].WANTSKIP 
        giver.components.questgiver.talking.solved = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SOLVED 
        giver.components.questgiver.talking.skipped = GLOBAL.STRINGS.QUESTSMOD[string.upper(questname)].SKIPPED
    end
end

local function CheckCritterQuest(giver)
    local x, y, z = giver.components.questgiver.questobject.Transform:GetWorldPosition()
    local critters = GLOBAL.TheSim:FindEntities(x, y, z, 20, nil, nil, {"critter"})
    for i,crit in ipairs(critters) do
        if crit and crit.prefab==giver.components.questgiver.customstore then
            giver.components.questgiver.queststatus="finished" -- number is always 1
        end
    end
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
-- talknear/talkfar:      (integer)  The distance to questgiver when queststatus is checked automatically.
-- questobject:           (instance) This is an instance you want to save. You can use "self" if you want it to be the questgiver. Or it could be an object that the players should destroy/guard or whatever. In last case you should define it in the quest initfn.
-- questgiver:            (prefab)   Prefab of the questgiver. It is better if the questgiver only exists once in the world, otherwise everyone of them has the same quests.
-- customrewarditems      (table)    Table of prefabs of the items you want to spawn. Every item in this list is spawned once, so if you want 2 cutgrass, it should contain cutgrass two times (you can also fill it in your initfn). Leave it empty, if you want default ones. They are only distributed, if shopmode is inactive, or rewardfn is "items".
-- customrewardblueprints (table)    Table of prefabs of the blueprints you want to spawn as reward. Leave it empty, if you want default ones.
-- checkfn                (function) This function is called in QueckQuest, which you can call yourself or it is called when a player is in talknear/talkfar range of the questgiver, return a true value, if the quest is finished. If you set it to "reachnumber" (string), it is checked if questnumberreached is enough to solve the quest.
-- rewardfn               (function) This function is called when the quest is finished. You can also set it to the following strings: 1) "default"->Depending on the modsettings, it will give blueprints,coins or items (If you set them up, it will be your custom ones). 2) "items"->Items from the REWARDITEMS or if set from customrewarditems list are distributed. 3) "blueprints" blueprints as reward, you should define which ones in customrewardblueprints. If not, the modsetting has to be blueprintmode to spawn predefined blueprints, otherwise the reward will be nothing.
-- initfn                 (function) A function that is called once directly after starting the quest. Here you can spawn something or set some values for the quest.
-- animationfn            (function) Is called shortly before releasing the reward. You can make it nil for no animation of "default" for the default animation. For default currently supported are pigking and pigman.
-- customstore            (any)      Can be anything, EXCEPT an object/instance. You can use it to store your custom information. Eg. for the emote quest, I store the ranomly chosen emotion in this. You can also save this to store a character prefab, so only this character can solve your quest or whatever.
-- talking                (strings)  talking={examine={},solved={},wantskip={},skipped={},orderedstrings=false}. In the tables examine, solved, wantskip, you can add strings the questgiver should say when a player examines him near, when the quest is solved or to ask if the player really wants to skip the quest. A random string form the list is chosen each time. Of course you can also fill it during your initfn, if you want variable strings.-- skippable              (boolean)  true or false (true by default). If according to modsettings quests are skippable and this skippable entry is not false, the quest will be skippable by perfomring three times within 30 seconds the Annoyed emotion. If not "false", the skippable entry will be set to numbers, to count the times you made the Annoyed animation. So to check if a quest is skippable do a ~=false check.  -- orderedstrings         (boolean)  for the examine talking. When true, the questgiver will say the strings in the same order they are in the table, eg. to describe the task. If false/nil, a random string from the list is chosen everytime.
-- onetime                (boolean)  true or false (nil-> false). If true, this quest at this questgiver can only be solved one time, even it loopquests is active. Eg. if quest is destroy a statue. You can only destroy it once. onetime means, that it is checking if already a quest with this name was filled, so be careful with several quests having the same name!    
-- endfn                  (function) this function is alawys called, when a quest was solved or skipped. Here you can remove any questspecifc things, if necessary
-- periodicfn             (function) This function will be called periodically with periodictimes, starting after the initfn. You can eg. use it to call CheckQuest. If possible better use an event to check quests or the automatic check when a player goes near the questgiver! But if both is not possible, use this. The api mod will save and load the task automatically and also cancel it, if the quest is solved/skipped.
-- periodictimes          (float)    1 -> call it every 1 second.
-- whensayfn              (function) this function is called everytime shorlty before the questgiver is saying something. params: giver,kind,str. kind can be "examine","solved","wantskip" and "skipped". str is the string he will say. Here you could add your custom talking sound/animation. Make sure it is compatible to your animationfn, which is played when solved!
-- conditions             {table}    A list of questname strings you have to solve at least one time, to have a chance to get this quest. If list is empty/nil, you can get this quest anytime. If making a questlline this way, you may consider doing them "onetime" quests.
-- requiredsidequests     {integer}  The number of solved sidequests, to have chance to get this quest. Keep in mind if quests are not onetime, you could make several times the same sidequest, to increase the solved sidequests.
-- issidequest            {boolean}  True by default! If true, it is considered a side quest and therefore counted in requiredsidequests
-- customconditionsfn     (function) your custom conditions for the quest to show up. Return false if you dont want the quest to be chosen. Return true, if your conditions are met and the quest can appear. If possible, make your conditions in form of quests, you put into conditions table. Only if this is not possible, make your own conditions function.
-- HINT about functions: The functions you store here are only saved in this Tuning table. Functions can not be saved in the questgiver component. So if you want to access a function, do it with help of the tuning table.


local emotequest = {questname="Emote",skippable=true,questdiff=1,questnumber=1,questtimer=0.5,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn="reachnumber",rewardfn="default",initfn=InitEmoteQuest,animationfn="default",talking={examine={},solved={},wantskip={},skipped={}},customstore={{str="Dance",anims={"emoteXL_pre_dance0","emoteXL_loop_dance0"}},{str="Kiss",anims={"emoteXL_kiss"}},{str="Bonesaw",anims={"emoteXL_bonesaw"}},{str="Angry",anims={"emoteXL_angry"}},{str="Happy",anims={"emoteXL_happycheer"}},{str="Pose",anims={"emote_strikepose"}},{str="Wave",anims={"emoteXL_waving1","emoteXL_waving2","emoteXL_waving3"}},{str="Facepalm",anims={"emoteXL_facepalm"}},{str="Joy",anims={"research"}},{str="Cry",anims={"emoteXL_sad"}},{str="Annoyed",anims={"emoteXL_annoyed"}},{str="Rude",anims={"emoteXL_waving4"}},{str="Sit",anims={"emote_pre_sit2","emote_loop_sit2","emote_pre_sit4","emote_loop_sit4"}},{str="Squat",anims={"emote_pre_sit1","emote_loop_sit1","emote_pre_sit3","emote_loop_sit3"}}},}
for i=1,GetModConfigData("number") do -- add the emote quest x times. IMPORTANT: if adding entries with the same questname, keep also all other values the same! You can variate them in the initfn instead!
    table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, emotequest)
end
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="BuildPighouses",skippable=true,questdiff=3,questnumber=1,questtimer=nil,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn="reachnumber",rewardfn="default",initfn=InitHousesQuest,animationfn="default",talking={examine={},solved={},wantskip={},skipped={}},customstore=nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="BuildWall",skippable=true,questdiff=2,questnumber=100,questtimer=nil,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn="reachnumber",rewardfn="default",initfn=InitWallQuest,animationfn="default",talking={examine={},solved={},wantskip={},skipped={}},customstore=nil}) -- -- depending on kind of wall, questnumberreached will be increased by different values
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="PigHats",skippable=true,questdiff=1,questnumber=1,questtimer=nil,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn=CheckHats,rewardfn="default",initfn=InitPigHatsQuest,animationfn="default",talking={examine={},solved={},wantskip={},skipped={}},customstore=nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Teenbird",skippable=true,questdiff=3,questnumber=1,questtimer=nil,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn=CheckTeenbirdQuest,rewardfn="default",initfn=InitTeenbirdQuest,animationfn="default",talking={examine={},solved={},wantskip={},skipped={}},customstore=nil})
table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {questname="Critter",skippable=true,questdiff=3,questnumber=1,questtimer=nil,talknear=8,talkfar=9,questobject="self",questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn=CheckCritterQuest,rewardfn="default",initfn=InitCritterQuest,animationfn="default",talking={examine={},solved={},wantskip={},skipped={}},customstore=nil})



-- you can also add quests with new world objects. see example in scripts/scenarios/quest_destroystatue_pig.lua. This scenario is added to the maxwell statue of the maxwell_pig_shrine.lua, which must be replaced.
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
    inst:ListenForEvent("buildstructure", OnStructureBuild) -- eg. building pig houses
    inst:ListenForEvent("deployitem", OnDeployItem) -- eg placing walls
    inst:ListenForEvent("emote", OnEmote) -- zb tanzen fuer pigking
end
AddPlayerPostInit(OnPlayerSpawn)




AddPrefabPostInit("world", function(world)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)




AddPrefabPostInit("pigking",function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)

