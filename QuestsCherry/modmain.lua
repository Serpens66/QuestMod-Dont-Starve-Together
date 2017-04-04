

local _G = GLOBAL
   
-- import the strings from that file
modimport "mymodstrings.lua" -- acts like I would write the code of that scripte here


print("QUESTSMOD QuestMod")

PrefabFiles = { 
    "skin_collector",
}
Assets = {
    Asset( "ANIM", "anim/skin_collector.zip"),
    Asset( "IMAGE", "images/map_icons/skin_collector.tex" ),
    Asset( "ATLAS", "images/map_icons/skin_collector.xml" ),
    Asset("SOUNDPACKAGE", "sound/skin_collector.fev"),    
    Asset("SOUND", "sound/skin_collector.fsb"),
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

local treeseeds = {"pinecone","twiggy_nut","acorn"}
local function OnDeployItem(player,data)
    if player~=nil and data~=nil and type(data)=="table" and type(player)=="table" then
        print("Quest Debug: player ".._G.tostring(player.prefab).." deployed: ".._G.tostring(data.prefab))
    end
    if data and data then 
        local x, y, z = player.Transform:GetWorldPosition()
        local questgivers = TheSim:FindEntities(x, y, z, 100, nil, nil, {"questgiver"}) 
        if GLOBAL.table.contains(treeseeds,data.prefab) then
            for i,giver in ipairs(questgivers) do
                if giver.components and giver.components.questgiver and giver.components.questgiver.questname=="Reforester" then
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
    local sleepers = GLOBAL.TheSim:FindEntities(x, y, z, 20, {"player","sleeping"})
    if #sleepers >= giver.components.questgiver.questnumber then
        giver.components.questgiver.queststatus="finished"
    end
end

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

-- local function CheckReforester(giver)

-- end

local function SkinRewardAnim(inst)
    inst.AnimState:PlayAnimation("snap", false)
    inst.AnimState:PushAnimation("dialog_pre")
    inst.AnimState:PushAnimation("dial_loop")
    inst.AnimState:PushAnimation("dialog_pst", false)
    inst.AnimState:PushAnimation("idle", true)


    inst:DoTaskInTime(0.2,function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/skincollector/snap", "skincollector") end)
    inst.SoundEmitter:PlaySound("dontstarve/characters/skincollector/talk_LP", "skincollector")
    --inst:DoTaskInTime(1,function(inst) inst.SoundEmitter:KillSound("skincollector") end)
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

table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {
    questname="Sleepover",
    skippable=true, 
    periodicfn=PeriodicSleepOver, 
    periodictimes=2,
    questdiff=2,
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
        examine= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.EXAMINE,
        solved= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SOLVED,
        wantskip= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.WANTSKIP,
        skipped= GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SKIPPED
        }
    }
)

table.insert(GLOBAL.TUNING.QUESTSMOD.QUESTS, {
    questname="Reforester",
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
    inst:ListenForEvent("deployitem", OnDeployItem) -- eg placing walls
end
AddPlayerPostInit(OnPlayerSpawn)

local function SpawnSkinCollector(world)
    local keeper = TheSim:FindFirstEntityWithTag("skin_collector")
    local beefalo = TheSim:FindFirstEntityWithTag("beefalo")
    if not keeper and beefalo then -- if there is no keeper, but there should be one, create one.
        GLOBAL.TUNING.questfunctions.SpawnPrefabAtLandPlotNearInst("skin_collector",beefalo,15,0,15,1,3,3)
    end
end

AddPrefabPostInit("skin_collector", function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
end)

AddPrefabPostInit("world", function(world)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if world.ismastersim and world.ismastershard then
        world:DoTaskInTime(0,function(world) SpawnSkinCollector(world) end) -- spawn a shopkeeper if needed
    end
end)




AddMinimapAtlas("images/map_icons/skin_collector.xml")