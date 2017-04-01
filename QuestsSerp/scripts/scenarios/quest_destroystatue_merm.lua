local function CheckDestroy2(inst) -- must be this way, cause when statue is destroyed no event is fired -.-   if there is an event, we can simply use this and increase questnumberreached until it reaches questnumber
    if (inst.components.questgiver.questobject==nil or not inst.components.questgiver.questobject:IsValid()) then -- then the statue is most likely destroyed
        inst.components.questgiver.queststatus="finished"
    end
end

local function OnLoad(inst, scenariorunner) -- wehn statue is destroyed, onload is not called anymore on gamestart, so this quest is no more added to QUESTS, wich is good  
    -- print("scenario ONLOAD2")
    if not TUNING.QUESTSMOD then
        TUNING.QUESTSMOD = {}
    end
    if not TUNING.QUESTSMOD.QUESTS then
        TUNING.QUESTSMOD.QUESTS = {}
    end
    table.insert(TUNING.QUESTSMOD.QUESTS, {questname="DestroyStatueMerm",skippable=true,onetime=true,questdiff=4,questnumber=0,questtimer=nil,questrange=50,talknear=8,talkfar=9,questobject=inst,questgiver="pigking",customrewarditems={},customrewardblueprints={},checkfn=CheckDestroy2,rewardfn="default",initfn=nil,animationfn="default",talking={near=STRINGS.QUESTSMOD.DESTROYSTATUEMERM.NEAR,far=STRINGS.QUESTSMOD.DESTROYSTATUEMERM.FAR,solved=STRINGS.QUESTSMOD.DESTROYSTATUEMERM.SOLVED,wantskip=STRINGS.QUESTSMOD.DESTROYSTATUEMERM.WANTSKIP,skipped=STRINGS.QUESTSMOD.DESTROYSTATUEMERM.SKIPPED},customstore=nil})
end


return
{
    OnLoad = OnLoad,
}