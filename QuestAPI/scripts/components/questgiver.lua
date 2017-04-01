-- playerprox stuff
local function AnyPlayer(inst, self)
    local x, y, z = inst.Transform:GetWorldPosition()
    if not self.isclose then
        local player = FindClosestPlayerInRange(x, y, z, self.talknear, self.alivemode)
        if player ~= nil then
            self.isclose = true
            if self.onnear ~= nil then
                self.onnear(inst, player)
            end
        end
    elseif not IsAnyPlayerInRange(x, y, z, self.talkfar, self.alivemode) then
        self.isclose = false
        if self.onfar ~= nil then
            self.onfar(inst)
        end
    end
end
local function SpecificPlayer(inst, self)
    if not self.isclose then
        if self.target:IsNear(inst, self.talknear) then
            self.isclose = true
            if self.onnear ~= nil then
                self.onnear(inst, self.target)
            end
        end
    elseif not self.target:IsNear(inst, self.talkfar) then
        self.isclose = false
        if self.onfar ~= nil then
            self.onfar(inst)
        end
    end
end
local function LockOnPlayer(inst, self)
    if not self.isclose then
        local x, y, z = inst.Transform:GetWorldPosition()
        local player = FindClosestPlayerInRange(x, y, z, self.talknear, self.alivemode)
        if player ~= nil then
            self.isclose = true
            self:SetTarget(player)
            if self.onnear ~= nil then
                self.onnear(inst, player)
            end
        end
    elseif not self.target:IsNear(inst, self.talkfar) then
        self.isclose = false
        self:SetTarget(nil)
        if self.onfar ~= nil then
            self.onfar(inst)
        end
    end
end
local function LockAndKeepPlayer(inst, self)
    if not self.isclose then
        local x, y, z = inst.Transform:GetWorldPosition()
        local player = FindClosestPlayerInRange(x, y, z, self.talknear, self.alivemode)
        if player ~= nil then
            self.isclose = true
            self:SetTargetMode(SpecificPlayer, player, true)
            if self.onnear ~= nil then
                self.onnear(inst, player)
            end
        end
    else
        -- we should never get here
        assert(false)
    end
end
local function OnTargetLeft(self)
    self:Stop()
    self.target = nil
    if self.initialtargetmode == LockAndKeepPlayer or
        self.initialtargetmode == LockOnPlayer then
        self:SetTargetMode(self.initialtargetmode)
    end 
    if self.losttargetfn ~= nil then
        self.losttargetfn()
    end
end


questfunctions = require("scenarios/questfunctions")

-- quest stuff

local function PlaySpecialAnimation(inst) -- plays animation depending on what inst we have
    if inst.prefab=="pigking" then
        inst.AnimState:PlayAnimation("cointoss")
        inst.AnimState:PushAnimation("happy")
        inst.AnimState:PushAnimation("idle", true)
        inst:DoTaskInTime(20/30, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold") end)
        inst:DoTaskInTime(1.5, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy") end)
    elseif inst.prefab=="pigman" then
        inst.AnimState:PlayAnimation("idle_happy")
        inst.SoundEmitter:PlaySound("dontstarve/pig/oink")
        inst.AnimState:PushAnimation("idle", true)
    end
end



local function GiveQuestLoot(questkeeper,questname,player) -- player is only needed for spawning the reward in direction of the player. so not mandatory
    local defaultstrings = STRINGS.QUESTSMOD.DEFAULTSOLVED -- standard solved strings
    local str = GetRandomItem(type(questkeeper.components.questgiver.talking)=="table" and type(questkeeper.components.questgiver.talking.solved)=="table" and next(questkeeper.components.questgiver.talking.solved) and questkeeper.components.questgiver.talking.solved or defaultstrings)
    if str~="" then
        questkeeper.components.talker:Say(string.upper(str))--,nil,nil,nil,nil,questkeeper.components.questgiver.textcolour)
    end
    if questkeeper.components.questgiver.animationfn=="default" then
        PlaySpecialAnimation(questkeeper)
    else 
        -- self.animationfn will be nil after loading if it was a function, cause a function cannot be saved. But a string can of course.
        -- TheWorld:PushEvent("QuestmodEventFn",{func="animationfn",giver=questkeeper,questname=questname}) -- call the check function in questmod, if it does exist.
        for k,quest in pairs(TUNING.QUESTSMOD.QUESTS) do 
            if quest.questname == questkeeper.components.questgiver.questname then
                if type(quest.animationfn)=="function" then
                    quest.animationfn(questkeeper)
                    break -- even if there are more entries with this questname, make the fn of course only once -> quests with same name should always also have same functions!
                end
            end
        end
    end
    local loot = {}
    local num = questkeeper.components and questkeeper.components.questgiver and questkeeper.components.questgiver.questdiff or 2 -- 1 to 3
    print("Quest: Give questloot num "..tostring(num))
    if questkeeper.components.questgiver.rewardfn=="default" then
        -- check if there are important blueprints left, if not then just random reward
        if TUNING.QUEST_BLUEPRINTMODE then -- mostly blueprints and coins
            loot = questfunctions.GetNewBlueprints(questname,questkeeper.components.questgiver.customrewardblueprints,num)
            if not next(loot) then -- if no blueprints are left, give more coins
                if TUNING.QUEST_SHOPMODE then
                    for i=1,math.ceil(math.random()*5+5*num) do
                        table.insert(loot,"coin") 
                    end
                else -- if no blueprints left and no shop active, we dont need more coins, so give a items
                    loot = questfunctions.GetRewardItems(questname,questkeeper.components.questgiver.customrewarditems,num)
                end
            end
            if TUNING.QUEST_SHOPMODE then
                for i=1,math.ceil(math.random()*3+3*num) do -- in addition few more coins
                    table.insert(loot,"coin") 
                end
            else
                for i=1,math.ceil(math.random()*1+1*num) do -- in addition few coins
                    table.insert(loot,"coin") 
                end
                num = num - 2
                if num <=0 then num = 1 end -- also add a small amount of items
                loot = JoinArrays(loot,questfunctions.GetRewardItems(questname,questkeeper.components.questgiver.customrewarditems,num))
            end
        elseif not TUNING.QUEST_BLUEPRINTMODE and TUNING.QUEST_SHOPMODE then -- mostly coins
            for i=1,math.ceil(math.random()*10+10*num) do -- num is 1 to 5
                table.insert(loot,"coin") 
            end
        elseif not TUNING.QUEST_BLUEPRINTMODE and not TUNING.QUEST_SHOPMODE then -- only items
            loot = questfunctions.GetRewardItems(questname,questkeeper.components.questgiver.customrewarditems,num)
        end
    elseif questkeeper.components.questgiver.rewardfn=="items" then
        loot = questfunctions.GetRewardItems(questname,questkeeper.components.questgiver.customrewarditems,num)
    elseif questkeeper.components.questgiver.rewardfn=="blueprints" then
        loot = questfunctions.GetNewBlueprints(questname,questkeeper.components.questgiver.customrewardblueprints,num)
    else
        -- self.rewardfn will be nil after loading if it was a function, cause a function cannot be saved. But a string can of course.
        -- TheWorld:PushEvent("QuestmodEventFn",{func="rewardfn",giver=questkeeper,questname=questname,player=player,num=num}) -- call the check function in questmod, if it does exist.  -- player can be nil. But if it is not, it will be the player that went near the questgiver
        for k,quest in pairs(TUNING.QUESTSMOD.QUESTS) do 
            if quest.questname == questkeeper.components.questgiver.questname then
                if type(quest.rewardfn)=="function" then
                    quest.rewardfn(questkeeper,player,num)
                    break -- even if there are more entries with this questname, make the fn of course only once -> quests with same name should always also have same functions!
                end
            end
        end
    end
    if questkeeper.components and questkeeper.components.lootdropper then 
        local timer = nil
        for key,lootprefab in ipairs(loot) do
            timer = type(key)=="number" and key/15 or 0.1 -- not spawn them all at same time, but with very small delay each
            questkeeper:DoTaskInTime(timer,function(questkeeper) questkeeper.components.lootdropper:SpawnLootPrefab(lootprefab, questkeeper:GetPosition()) end)
        end
    else
        if next(loot) then
            questfunctions.SpawnPuff(questkeeper)
        end
        questkeeper:DoTaskInTime(20/30, function(questkeeper) -- smal delay, compatible to pigking animation
            for key,lootprefab in pairs(loot) do
                questfunctions.SpawnDrop(questkeeper, lootprefab,player)
            end
        end)
    end
    
    
    if questkeeper.components and questkeeper.components.questgiver then 
        questkeeper.components.questgiver.questname = nil
        questkeeper.components.questgiver:QuestResett()
    end -- make it a normal shopkeeper without a quest
end



local function TriggerReward(inst,player,questname)
    if inst.components.questgiver.queststatus=="finished" then
        inst.components.questgiver.queststatus = "done" -- prevent triggering twice
        if inst.components.questgiver.onetime then
            table.insert(inst.components.questgiver.solvedonetimequests,questname) -- make sure this quest comes not again.
        end
        inst:DoTaskInTime(2,GiveQuestLoot,questname,player)
        inst.components.questgiver.nextquesttask = inst:DoTaskInTime(TUNING.QUEST_NEWONE * TUNING.TOTAL_DAY_TIME + 5,function(inst) inst.components.questgiver:StartNextQuest() end) -- next day there will be the next quest 
    end
end

local function CheckIfQuestFinished(inst) -- inst is questgiver
    if not ((inst.prefab=="pigking" and inst.components.trader:GetDebugString()=="true") or inst.prefab~="pigking") then -- do nothing if pigking is sleeping
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.components.questgiver.questname~=nil and inst.components.questgiver.queststatus~="finished" and inst.components.questgiver.queststatus~="done" then
        
        if inst.components.questgiver.checkfn == "reachnumber" then
            if inst.components.questgiver.questnumberreached >= inst.components.questgiver.questnumber then
                inst.components.questgiver.queststatus="finished"
            end    
        else
            -- self.checkfn will be nil after loading if it was a function, cause a function cannot be saved. But a string can of course.
            -- TheWorld:PushEvent("QuestmodEventFn",{func="checkfn",giver=inst,questname=inst.components.questgiver.questname}) -- call the check function in questmod, if it does exist. This should also set it to finished.
            for k,quest in pairs(TUNING.QUESTSMOD.QUESTS) do 
                if quest.questname == inst.components.questgiver.questname then
                    if type(quest.checkfn)=="function" then
                        quest.checkfn(inst)
                        break -- even if there are more entries with this questname, make the fn of course only once -> quests with same name should always also have same functions!
                    end
                end
            end
        end
    end
    if inst.components.questgiver.queststatus=="finished" then -- if quest is finished and at least one player is in range of questgiver, trigger the reward (otherwise the reward is triggered when a player goes near)
        local questname = inst.components.questgiver.questname
        local playerss = TheSim:FindEntities(x, y, z, 20, nil, {"playerghost"}, {"player"})
        if next(playerss) then
            local k,player = next(playerss)
            TriggerReward(inst,player,questname)
        end
    end
end   



local function TalkNear(questkeeper,player) -- give hints about "quests" or give reward
    print("questgiver: TalkNear "..tostring(questkeeper.components.questgiver and questkeeper.components.questgiver.questname or "nichts"))
    local questname = questkeeper.components.questgiver.questname
    local defaultstrings = {questname} -- if not strings are defined, use questname
    if questname~=nil and questkeeper.components.questgiver.queststatus~="finished" then 
        CheckIfQuestFinished(questkeeper) -- calls also triggerreward , but only if a player is in range! .. which should be the case when talknear... nevermind, it does not hurt this way 
    elseif questname~=nil and questkeeper.components.questgiver.queststatus=="finished" then -- 
        TriggerReward(questkeeper,player,questname)
    end
    if ((questkeeper.prefab=="pigking" and questkeeper.components.trader:GetDebugString()=="true") or questkeeper.prefab~="pigking") then -- say nothing, if pigking is sleeping
        local str = ""
        if questname~=nil and questkeeper.components.questgiver.queststatus~="finished" then
            str = GetRandomItem(type(questkeeper.components.questgiver.talking)=="table" and type(questkeeper.components.questgiver.talking.near)=="table" and next(questkeeper.components.questgiver.talking.near) and questkeeper.components.questgiver.talking.near or defaultstrings)
        elseif questname==nil and not next(questkeeper.components.questgiver.questlist) then -- if no quest left (if questloop is active, the questlist won't be empty)
            str = GetRandomItem(STRINGS.QUESTSMOD.NOMOREQUEST)
            if questkeeper["mynetvarQuestsR"] and questkeeper["mynetvarQuestsG"] and questkeeper["mynetvarQuestsB"] then -- do not change colour if this is not there, eg for shopkeeper
                questkeeper.components.talker.colour = Vector3(1, 1, 1) 
                questkeeper["mynetvarQuestsR"]:set(255) 
                questkeeper["mynetvarQuestsG"]:set(255)
                questkeeper["mynetvarQuestsB"]:set(255)
            end
        elseif questname==nil and next(questkeeper.components.questgiver.questlist) then -- next quest will start in x days
            local days = 0.001 -- 0 will result in a netagive 0 ...
            if questkeeper.components.questgiver.nextquesttask~=nil then
                days = GetTaskRemaining(questkeeper.components.questgiver.nextquesttask)
            end
            str = string.format(GetRandomItem(STRINGS.QUESTSMOD.NEXTQUESTIN),days/TUNING.TOTAL_DAY_TIME,1)
            if questkeeper["mynetvarQuestsR"] and questkeeper["mynetvarQuestsG"] and questkeeper["mynetvarQuestsB"] then -- do not change colour if this is not there, eg for shopkeeper
                questkeeper.components.talker.colour = Vector3(1, 1, 1) 
                questkeeper["mynetvarQuestsR"]:set(255) 
                questkeeper["mynetvarQuestsG"]:set(255)
                questkeeper["mynetvarQuestsB"]:set(255)
            end
        end
        if str~="" then
            questkeeper.components.talker:Say(string.upper(str))--,nil,nil,nil,nil,questkeeper.components.questgiver.textcolour)
            if questkeeper.prefab=="pigking" then-- and math.random()>0.3 then 
                questkeeper.SoundEmitter:PlaySound("dontstarve/pig/grunt")
            end
        end
    end
end

local function TalkFar(questkeeper) -- player is unknown
    print("questgiver: TalkFar")
    local questname = questkeeper.components.questgiver.questname
    local defaultstrings = {questname} -- if not strings are defined, use questname
    if questname~=nil and questkeeper.components.questgiver.queststatus~="finished" then 
        CheckIfQuestFinished(questkeeper) -- calls also triggerreward  , but only if a player is in range!
    elseif questname~=nil and questkeeper.components.questgiver.queststatus=="finished" then
        TriggerReward(questkeeper,nil,questname)
    end
    if questname~=nil and questkeeper.components.questgiver.queststatus~="finished" and ((questkeeper.prefab=="pigking" and questkeeper.components.trader:GetDebugString()=="true") or questkeeper.prefab~="pigking") then
        local str = GetRandomItem(type(questkeeper.components.questgiver.talking)=="table" and type(questkeeper.components.questgiver.talking.far)=="table" and next(questkeeper.components.questgiver.talking.far) and questkeeper.components.questgiver.talking.far or defaultstrings)
        if str~="" then
            questkeeper.components.talker:Say(string.upper(str))--,nil,nil,nil,nil,questkeeper.components.questgiver.textcolour)
        end
    end
end



local QuestGiver = Class(function(self, inst, targetmode, target)
	
    self.inst = inst
	self.questname = nil
    self.queststatus = "open"
    self.questdiff = nil -- difficulty -> higher reward, can be 1 2 or 3. 3 is the highest reward
    self.questobject = nil
    self.questnumber = nil -- a number, can be used differently, eg the number of houses to build or things to destroy
    self.questtimer = nil
    self.questnumberreached = 0 -- a number, can be used differently, eg the number of houses already built
    self.checkfn = nil
    self.customrewarditems = {}
    self.customrewardblueprints = {}
    self.initfn = nil
    self.rewardfn = nil
    self.animationfn = nil
    self.customstore = nil
    self.talking = {near={},far={},solved={},wantskip={},skipped={}}
    self.skippable = true
    self.nextquesttask = nil
    self.nextquesttasktimeleft = nil
    self.onetime = nil
    self.solvedonetimequests = {}

    
    self.questlist = {} -- all the quests the questgiver can give, but only one quest active at the time. {{"questname",questobject},...} . this list will get empty
    self.questlistSave = {} -- this is a deepcopy of questlist, but won't get empty. Can be used to restore questlist
    
    -- playerprox copy
    self.talknear = 5
    self.talkfar = 6
    self.isclose = false
    self.period = 10 * FRAMES
    self.onnear = TalkNear
    self.onfar = TalkFar
    self.task = nil
    self.target = nil
    self.losttargetfn = nil
    self.alivemode = nil
    self._ontargetleft = function() OnTargetLeft(self) end

    self:SetTargetMode(targetmode or AnyPlayer, target)
    -- print("INIT questname "..tostring(self.questname).." timeleft "..tostring(self.nextquesttasktimeleft))
    -- init wird offenbar immer aufgerufen, teilweise auch bis zu 3 mal -.-
end)

function QuestGiver:CheckQuests()
    CheckIfQuestFinished(self.inst)
end

function QuestGiver:QuestResett()
    self.questname = nil
    self.queststatus = "open"
    self.questdiff = nil -- difficulty -> higher reward, can be 1 2 or 3. 3 is the highest reward
    self.questobject = nil
    self.questnumber = nil -- a number, can be used differently, eg the number of houses to build or things to destroy
    self.questtimer = nil
    self.questnumberreached = 0 -- a number, can be used differently, eg the number of houses already built
    self.checkfn = nil
    self.customrewarditems = {}
    self.customrewardblueprints = {}
    self.initfn = nil
    self.rewardfn = nil
    self.animationfn = nil
    self.customstore = nil
    self.talking = {near={},far={},solved={},wantskip={},skipped={}}
    self.skippable = true
    self.onetime = nil
end 

function QuestGiver:SkipQuest() -- skip the quest
    self.inst.components.questgiver:QuestResett() -- start next quest in half of the normal waiting time
    self.inst.components.questgiver.nextquesttask = self.inst:DoTaskInTime(((TUNING.QUEST_NEWONE * TUNING.TOTAL_DAY_TIME)/2) + 5 ,function(inst) inst.components.questgiver:StartNextQuest() end) -- next day there will be the next quest (or when world is loaded)  
end

function QuestGiver:WantSkipQuest() -- quest if quest skipping is allowed and count
    local questkeeper = self.inst
    if self.inst.components.questgiver.questname~=nil and self.inst.components.questgiver.skippable~=false then
        self.inst.components.questgiver.skippable = type(self.inst.components.questgiver.skippable)~="number" and 1 or self.inst.components.questgiver.skippable + 1
        if self.inst.components.questgiver.skippable == 2 then
            local defaultstrings = STRINGS.QUESTSMOD.DEFAULTWANTSKIP
            local str = GetRandomItem(type(questkeeper.components.questgiver.talking)=="table" and type(questkeeper.components.questgiver.talking.wantskip)=="table" and next(questkeeper.components.questgiver.talking.wantskip) and questkeeper.components.questgiver.talking.wantskip or defaultstrings)
            if str~="" then
                questkeeper.components.talker:Say(string.upper(str))--,nil,nil,nil,nil,self.textcolour)
            end
            if self.inst.unskipptask~=nil then
                self.inst.unskipptask:Cancel() -- cancel all previous tasks
                self.inst.unskipptask = nil
            end
            self.inst.unskipptask = self.inst:DoTaskInTime(15,function(inst) inst.components.questgiver.skippable = 0 end) -- make it 0 after 15 seconds, so you should do the annyoed emotion 3 times within ~ 30 seconds
        elseif self.inst.components.questgiver.skippable >= 3 then
            local defaultstrings = STRINGS.QUESTSMOD.DEFAULTSKIPPED
            local str = GetRandomItem(type(questkeeper.components.questgiver.talking)=="table" and type(questkeeper.components.questgiver.talking.skipped)=="table" and next(questkeeper.components.questgiver.talking.skipped) and questkeeper.components.questgiver.talking.skipped or defaultstrings)
            if str~="" then
                questkeeper.components.talker:Say(string.upper(str))--,nil,nil,nil,nil,self.textcolour)
            end
            self.inst.components.questgiver:SkipQuest()
        else
            if self.inst.unskipptask~=nil then
                self.inst.unskipptask:Cancel() -- cancel all previous tasks
                self.inst.unskipptask = nil
            end
            self.inst.unskipptask = self.inst:DoTaskInTime(10,function(inst) inst.components.questgiver.skippable = 0 end) -- make it 0 after 10 seconds, so you should do the annyoed emotion 3 times within ~ 30 seconds
        end
    end
end

function QuestGiver:OnSave()
	local data = {}
	local references = {}
    -- we need to pass the GUID references to the game
    if type(self.questobject)=="table" then
        table.insert(references, self.questobject.GUID)
        -- save a table with flag and GUID where entity should be
        data.questobject = { is_GUID = true, GUID = self.questobject.GUID }
    else
        data.questobject = self.questobject
    end
    data.questlist = {}
    local tab = nil
    for i,l in ipairs(self.questlist) do
        tab = {}
        for key, thing in pairs(l) do
			if type(thing) == "table" and thing.GUID then
				-- we need to pass the GUID references to the game
				table.insert(references, thing.GUID)
				-- save a table with flag and GUID where entity should be
                tab[key] = { is_GUID = true, GUID = thing.GUID }
			else
                tab[key] = thing
			end
		end
        table.insert(data.questlist,tab)
    end
    data.questlistSave = {}
    local tab = nil
    for i,l in ipairs(self.questlistSave) do
        tab = {}
        for key, thing in pairs(l) do
			if type(thing) == "table" and thing.GUID then
				-- we need to pass the GUID references to the game
				table.insert(references, thing.GUID)
				-- save a table with flag and GUID where entity should be
                tab[key] = { is_GUID = true, GUID = thing.GUID }
			else
                tab[key] = thing
			end
		end
        table.insert(data.questlistSave,tab)
    end
    data.questname = self.questname
    data.queststatus = self.queststatus
    data.questdiff = self.questdiff
    data.questnumber = self.questnumber
    data.questtimer = self.questtimer
    data.questnumberreached = self.questnumberreached
    data.customrewarditems = self.customrewarditems
    data.customrewardblueprints = self.customrewardblueprints
    data.checkfn = self.checkfn
    data.initfn = self.initfn
    data.rewardfn = self.rewardfn
    data.animationfn = self.animationfn
    data.customstore = self.customstore
    data.talking = self.talking
    data.skippable = self.skippable
    data.onetime = self.onetime
    data.solvedonetimequests = self.solvedonetimequests
    if self.nextquesttask~=nil then 
        data.nextquesttasktimeleft = GetTaskRemaining(self.nextquesttask) -- save the remaining time instead of the task itself
    elseif self.nextquesttasktimeleft~=nil then
        data.nextquesttasktimeleft = self.nextquesttasktimeleft
    end
    
    
    data.talknear = self.talknear
    data.talkfar = self.talkfar
    
    if next(references) == nil then
		-- if references is empty, make it nil
		references = nil
	end
    return data,references 
end

function QuestGiver:OnLoad(data)
	
    self.questname = data and data.questname or nil
    self.queststatus = data and data.queststatus or nil
    self.questdiff = data and data.questdiff or nil
    self.questnumber = data and data.questnumber or nil
    self.questtimer = data and data.questtimer or nil
    self.questnumberreached = data and data.questnumberreached or 0
    self.talknear = data and data.talknear or nil
    self.talkfar = data and data.talkfar or nil
    self.questlist = data and data.questlist or {}
    self.questlistSave = data and data.questlistSave or {}
    self.customrewarditems = data and data.customrewarditems or {}
    self.customrewardblueprints = data and data.customrewardblueprints or {}
    self.checkfn =data and data.checkfn or nil
    self.initfn = data and data.initfn or nil
    self.rewardfn = data and data.rewardfn or nil
    self.animationfn = data and data.animationfn or nil
    self.customstore = data and data.customstore or nil
    self.talking = data and data.talking or {near={},far={},solved={},wantskip={},skipped={}}
    self.skippable = data and data.skippable or true
    self.nextquesttasktimeleft = data and data.nextquesttasktimeleft or nil
    self.onetime = data and data.onetime or nil
    self.solvedonetimequests = data and data.solvedonetimequests or {}
    
    if self.inst["mynetvarQuestsR"] and self.inst["mynetvarQuestsG"] and self.inst["mynetvarQuestsB"] then -- do not change colour if this is not there, eg for shopkeeper
        if self.questdiff == 1 then
            self.inst.components.talker.colour = Vector3(.25, .65, .15) 
            self.inst["mynetvarQuestsR"]:set(64) -- *255
            self.inst["mynetvarQuestsG"]:set(166)
            self.inst["mynetvarQuestsB"]:set(38)
        elseif self.questdiff == 2 then
            self.inst.components.talker.colour = Vector3(0, 1, 0) 
            self.inst["mynetvarQuestsR"]:set(0)
            self.inst["mynetvarQuestsG"]:set(255)
            self.inst["mynetvarQuestsB"]:set(0)
        elseif self.questdiff == 3 then
            self.inst.components.talker.colour = Vector3(1, 0.5, 0) 
            self.inst["mynetvarQuestsR"]:set(255)
            self.inst["mynetvarQuestsG"]:set(128)
            self.inst["mynetvarQuestsB"]:set(0)
        elseif self.questdiff == 4 then
            self.inst.components.talker.colour = Vector3(1, 0, 0) 
            self.inst["mynetvarQuestsR"]:set(255)
            self.inst["mynetvarQuestsG"]:set(0)
            self.inst["mynetvarQuestsB"]:set(0)
        elseif self.questdiff == 5 then
            self.inst.components.talker.colour = Vector3(0.6, 0, 0) 
            self.inst["mynetvarQuestsR"]:set(153)
            self.inst["mynetvarQuestsG"]:set(0)
            self.inst["mynetvarQuestsB"]:set(0)
        end
    end
end

function QuestGiver:LoadPostPass(newents,data)
	self.questobject = data and data.questobject or nil
    if self.questobject and type(self.questobject)=="table" and self.questobject.is_GUID then
        local thingy = newents[self.questobject.GUID]
        if thingy then
            -- swap temp table for entity
            self.questobject = thingy.entity
        else
            self.questobject = nil
        end
    end
    if next(self.questlist) then
        for i,l in ipairs(self.questlist) do
            for key, thing in pairs(l) do
                if type(thing) == "table" then
                    if thing.is_GUID then
                        local thingy = newents[thing.GUID]
                        if thingy then
                            -- swap temp table for entity
                            l[key] = thingy.entity
                        end
                    end
                end
            end
        end
    end
    if next(self.questlistSave) then
        for i,l in ipairs(self.questlistSave) do
            for key, thing in pairs(l) do
                if type(thing) == "table" then
                    if thing.is_GUID then
                        local thingy = newents[thing.GUID]
                        if thingy then
                            -- swap temp table for entity
                            l[key] = thingy.entity
                        end
                    end
                end
            end
        end
    end
end

function QuestGiver:InitializeQuest(quest)
    local keeper = self.inst
    self.questname = quest.questname
    -- resett values first
    self.queststatus = "open"
    self.questdiff = nil -- difficulty -> higher reward, can be 1 2 or 3. 3 is the highest reward
    self.questobject = nil
    self.questnumber = nil -- a number, can be used differently, eg the number of houses to build or things to destroy
    self.questnumberreached = 0
    self.talknear = 5
    self.talkfar = 6
    self.nextquesttask = nil
    self.nextquesttasktimeleft = nil
    
    self.questname = quest.questname
    self.queststatus = "open"
    self.questdiff = quest.questdiff
    self.questobject = quest.questobject=="self" and self.inst or quest.questobject
    self.questnumber = quest.questnumber
    self.questtimer = quest.questtimer
    self.customrewarditems = deepcopy(quest.customrewarditems)
    self.customrewardblueprints = deepcopy(quest.customrewardblueprints)
    self.checkfn = quest.checkfn
    self.talknear = quest.talknear
    self.talkfar = quest.talkfar
    self.initfn = quest.initfn
    self.rewardfn = quest.rewardfn
    self.animationfn = quest.animationfn
    self.customstore = deepcopy(quest.customstore) -- in case it is a table. Even if it is a string/nil, deepcopy wont throw error
    self.talking = deepcopy(quest.talking) -- without deepcopy, they are set the same object, which is bad...
    self.skippable = quest.skippable
    self.onetime = quest.onetime
    
    -- self.initfn(self.inst) -- the questgiver
    -- TheWorld:PushEvent("QuestmodEventFn",{func="initfn",giver=self.inst,questname=self.questname})
    
    for k,quest in pairs(TUNING.QUESTSMOD.QUESTS) do 
        if quest.questname == self.questname then
            if type(quest.initfn)=="function" then
                quest.initfn(self.inst)
                break -- even if there are more entries with this questname, make the initfn of course only once
            end
        end
    end
    -- after calling the init fct, change colour of text to show diff
    if self.inst["mynetvarQuestsR"] and self.inst["mynetvarQuestsG"] and self.inst["mynetvarQuestsB"] then -- do not change colour if this is not there, eg for shopkeeper
        if self.questdiff == 1 then
            self.inst.components.talker.colour = Vector3(.25, .65, .15)  -- dark green
            self.inst["mynetvarQuestsR"]:set(64) -- *255
            self.inst["mynetvarQuestsG"]:set(166)
            self.inst["mynetvarQuestsB"]:set(38)
        elseif self.questdiff == 2 then
            self.inst.components.talker.colour = Vector3(0, 1, 0) -- light green
            self.inst["mynetvarQuestsR"]:set(0)
            self.inst["mynetvarQuestsG"]:set(255)
            self.inst["mynetvarQuestsB"]:set(0)
        elseif self.questdiff == 3 then
            self.inst.components.talker.colour = Vector3(1, 0.5, 0)  -- orange
            self.inst["mynetvarQuestsR"]:set(255)
            self.inst["mynetvarQuestsG"]:set(128)
            self.inst["mynetvarQuestsB"]:set(0)
        elseif self.questdiff == 4 then
            self.inst.components.talker.colour = Vector3(1, 0, 0)  -- light red
            self.inst["mynetvarQuestsR"]:set(255)
            self.inst["mynetvarQuestsG"]:set(0)
            self.inst["mynetvarQuestsB"]:set(0)
        elseif self.questdiff == 5 then
            self.inst.components.talker.colour = Vector3(0.6, 0, 0)  -- dark red
            self.inst["mynetvarQuestsR"]:set(153)
            self.inst["mynetvarQuestsG"]:set(0)
            self.inst["mynetvarQuestsB"]:set(0)
        end
    end
    
    
    print("Quest: InitializeQuest Succesful "..tostring(self.questname))
end

function QuestGiver:StartNextQuest() 
	print("startnextquest called")
    self.nextquesttasktimeleft = nil
    
    local k = 1
    for i,name in ipairs(self.solvedonetimequests) do -- if there are onetime quests, remove them form all lists. Do not remove name from solvedonetimequests, cause it could be that the quest is added to QUEST at next gamestart again.
        k = 1
        while k~=#TUNING.QUESTSMOD.QUESTS + 1 do
            if TUNING.QUESTSMOD.QUESTS[k].questname == name and TUNING.QUESTSMOD.QUESTS[k].questgiver==self.inst.prefab then -- only remove it from QUESTS, if this is the questgiver
                table.remove(TUNING.QUESTSMOD.QUESTS,k)
            else
                k = k + 1
            end
        end
        k = 1
        while k~=#self.questlist + 1 do
            if self.questlist[k].questname == name then
                table.remove(self.questlist,k)
            else
                k = k + 1
            end
        end
        k = 1
        while k~=#self.questlistSave + 1 do
            if self.questlistSave[k].questname == name then
                table.remove(self.questlistSave,k)
            else
                k = k + 1
            end
        end
    end
        
    
    if self.questname~=nil then -- check if tha actual quest is still in global QUESTS. If not, remove it and get another quest
        local drin = false
        for k,quest in pairs(TUNING.QUESTSMOD.QUESTS) do
            if quest.questname==self.questname then
                drin = true
            end
        end
        if not drin then
            print("QUESTS: The quest "..tostring(self.questname).." is no longer in the global QUESTS. Therefore remove it and start another quest.")
            self.questname = nil -- enough to set it nil (no resett neccesary cause next quest is started directly or no quest at all)
        end
    end
    
    if not next(self.questlist) and next(self.questlistSave) then -- if questlist got emtpy due to settings/deactivation of mods
        if TUNING.QUEST_LOOP then -- if mod setting is true
            self.questlist = deepcopy(self.questlistSave) -- restore the original questlist, so every quest can be done again.
            print("QUESTS: Questloop active, refill empty questlist of "..tostring(self.inst.prefab))
        end
    end
    
    if self.questname==nil and next(self.questlist) then -- if there is no current quest and there is another quest in list
        local quest = questfunctions.MyPickSome(1, self.questlist)[1] -- pick and remove one quest.
        print("hier startnextquest "..tostring(quest.questname).." "..tostring(quest.questobject))
        self:InitializeQuest(quest)
    end
    
    if not next(self.questlist) and next(self.questlistSave) then -- if questlist is empty due to all quests were chosen
        if TUNING.QUEST_LOOP then -- if mod setting is true
            self.questlist = deepcopy(self.questlistSave) -- restore the original questlist, so every quest can be done again.
            print("QUESTS: Questloop active, refill empty questlist of "..tostring(self.inst.prefab))
        end
    end
end






-- copy of playerprox component:
--[[
    PlayerProx component can run in four possible ways
    - Any player within distance, all players outside distance (PlayerProx.AnyPlayer)
    - a specific player within and outside distance (PlayerProx.SpecificPlayer)
    - as soon as a player comes within range, start tracking that one for going out of distance and then relinquish tracking (PlayerProx.LockOnPlayer)
    - as soon as a player comes within range, start tracking that player and keep tracking that player (PlayerProx.LockAndKeepPlayer)
--]]


-- local PlayerProx = Class(function(self, inst, targetmode, target)
    -- self.inst = inst
    -- self.talknear = 2
    -- self.talkfar = 3
    -- self.isclose = false
    -- self.period = 10 * FRAMES
    -- self.onnear = nil
    -- self.onfar = nil
    -- self.task = nil
    -- self.target = nil
    -- self.losttargetfn = nil
    -- self.alivemode = nil
    -- self._ontargetleft = function() OnTargetLeft(self) end

    -- self:SetTargetMode(targetmode or AnyPlayer, target)
-- end)

QuestGiver.AliveModes =
{
    AliveOnly =         true,
    DeadOnly =          false,
    DeadOrAlive =       nil,
}

QuestGiver.TargetModes =
{
    AnyPlayer =         AnyPlayer,
    SpecificPlayer =    SpecificPlayer,
    LockOnPlayer =      LockOnPlayer,
    LockAndKeepPlayer = LockAndKeepPlayer,
}

function QuestGiver:GetDebugString()
    return self.isclose and "NEAR" or "FAR"
end

function QuestGiver:SetOnPlayerNear(fn)
    self.onnear = fn
end

function QuestGiver:SetOnPlayerFar(fn)
    self.onfar = fn
end

function QuestGiver:IsPlayerClose()
    return self.isclose
end

function QuestGiver:SetDist(near, far)
    self.talknear = near
    self.talkfar = far
end

function QuestGiver:SetLostTargetFn(func)
    self.losttargetfn = func
end

function QuestGiver:SetPlayerAliveMode(alivemode)
    self.alivemode = alivemode
end

function QuestGiver:Schedule()
    self:Stop()
    self.task = self.inst:DoPeriodicTask(self.period, self.targetmode, nil, self)
end

function QuestGiver:ForceUpdate()
    if self.task ~= nil and self.targetmode ~= nil then
        self.targetmode(self.inst, self)
    end
end

function QuestGiver:Stop()
    if self.task ~= nil then
        self.task:Cancel()
        self.task = nil
    end
end

QuestGiver.OnEntityWake = QuestGiver.Schedule
QuestGiver.OnEntitySleep = QuestGiver.Stop
QuestGiver.OnRemoveEntity = QuestGiver.Stop
QuestGiver.OnRemoveFromEntity = QuestGiver.Stop

function QuestGiver:SetTargetMode(mode, target, override)
    if not override then
        self.originaltargetmode = mode
    end
    self.targetmode = mode
    self:SetTarget(target)
    assert(self.targetmode ~= SpecificPlayer or self.target ~= nil)
    self:Schedule()
end

function QuestGiver:SetTarget(target)
    --listen for playerexited instead of ms_playerleft because
    --this component may be used for client side prefabs
    if self.target ~= nil then
        self.inst:RemoveEventCallback("onremove", self._ontargetleft, self.target)
    end
    self.target = target
    if target ~= nil then
        self.inst:ListenForEvent("onremove", self._ontargetleft, target)
    end
end





return QuestGiver
