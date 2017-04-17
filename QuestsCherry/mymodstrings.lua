-----------------------------------------------------
-- ## Quest Strings
-- they should have this form: GLOBAL.STRINGS.QUESTSMOD.  and then the unique name of the quest (questname): GLOBAL.STRINGS.QUESTSMOD.MYQUESTSMODNAME
-- you can also include "%s" or %i" in the strings, to add variable info. Eg. "Build %i houses". In your modmain, in the talking key of your quest in the init of quest,
-- you can add string.format(GLOBAL.STRINGS.QUESTSMOD.MYQUESTSMODNAME,number), to add your random number to the string, to variate the quest.
local STRINGS = GLOBAL.STRINGS
local require = GLOBAL.require


if not STRINGS.QUESTSMOD then
    STRINGS.QUESTSMOD = {}
end
if not STRINGS.QUESTSMOD.NOMOREQUEST then
    STRINGS.QUESTSMOD.NOMOREQUEST = {}
end
if not STRINGS.QUESTSMOD.NEXTQUESTIN then
    STRINGS.QUESTSMOD.NEXTQUESTIN = {}
end

STRINGS.QUESTSMOD.EMOTEY_MAXY = {}
STRINGS.QUESTSMOD.EMOTEY_MAXY.EXAMINE = {"Want to work for me, pal?\nWave and you're hired.","Looking for work?\nShow me a wave and you got a job."}
STRINGS.QUESTSMOD.EMOTEY_MAXY.SOLVED = {"You got a job.","Ready to get started?"}
STRINGS.QUESTSMOD.EMOTEY_MAXY.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.EMOTEY_MAXY.SKIPPED = {"No harm done."}
--[[
STRINGS.QUESTSMOD.SLEEPOVER_MAXY = {}
STRINGS.QUESTSMOD.SLEEPOVER_MAXY.EXAMINE = {"Trust me, pal? Fall asleep next to me to prove it."}
STRINGS.QUESTSMOD.SLEEPOVER_MAXY.SOLVED = {"You got guts, pal."}
STRINGS.QUESTSMOD.SLEEPOVER_MAXY.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.SLEEPOVER_MAXY.SKIPPED = {"No harm done."}
]]
STRINGS.QUESTSMOD.REFORESTER_MAXY = {}
STRINGS.QUESTSMOD.REFORESTER_MAXY.EXAMINE = {"How about you plant %i more trees, pal?","I could use some trees around. %i should do."}
STRINGS.QUESTSMOD.REFORESTER_MAXY.SOLVED = {"Good job, pal.","Thanks, pal."}
STRINGS.QUESTSMOD.REFORESTER_MAXY.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.REFORESTER_MAXY.SKIPPED = {"No harm done."}

STRINGS.QUESTSMOD.LUMBERJACK_MAXY = {}
STRINGS.QUESTSMOD.LUMBERJACK_MAXY.EXAMINE = {"Chop %i more trees around me, and I'll give you something pretty.","There are too many trees about, chop %i down for me."}
STRINGS.QUESTSMOD.LUMBERJACK_MAXY.SOLVED = {"Good job, pal.","Thanks, pal."}
STRINGS.QUESTSMOD.LUMBERJACK_MAXY.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.LUMBERJACK_MAXY.SKIPPED = {"No harm done."}

---------------------------------------------------------------------------------------------------

STRINGS.QUESTSMOD.EMOTEY_SKIN = {}
STRINGS.QUESTSMOD.EMOTEY_SKIN.EXAMINE = {"Hey fella, want som' work?\nWave and ye' got th' job.","Want t' run som' errands for me?\nWave and ye' got th' job."}
STRINGS.QUESTSMOD.EMOTEY_SKIN.SOLVED = {"Hah, alrigh' kid. Let's get started."}
STRINGS.QUESTSMOD.EMOTEY_SKIN.WANTSKIP = {"Wan' take a rain-check?"}
STRINGS.QUESTSMOD.EMOTEY_SKIN.SKIPPED = {"Alrigh'."}
--[[
STRINGS.QUESTSMOD.SLEEPOVER_SKIN = {}
STRINGS.QUESTSMOD.SLEEPOVER_SKIN.EXAMINE = {"Hey fella, want some work?\n Fall asleep next ta me ta prov'it."}
STRINGS.QUESTSMOD.SLEEPOVER_SKIN.SOLVED = {"Hah, alrigh' kid, let's get started."}
STRINGS.QUESTSMOD.SLEEPOVER_SKIN.WANTSKIP = {"Wan' take a rain-check?"}
STRINGS.QUESTSMOD.SLEEPOVER_SKIN.SKIPPED = {"Alrigh'."}
]]
STRINGS.QUESTSMOD.REFORESTER_SKIN = {}
STRINGS.QUESTSMOD.REFORESTER_SKIN.EXAMINE = {"Coul' ya plant %i more trees around, kid?","We cou' use s'more trees 'ere. %i should do."}
STRINGS.QUESTSMOD.REFORESTER_SKIN.SOLVED = {"Thanks, kid. Here's yer reward."}
STRINGS.QUESTSMOD.REFORESTER_SKIN.WANTSKIP = {"Wan' to take a rain-check?"}
STRINGS.QUESTSMOD.REFORESTER_SKIN.SKIPPED = {"Alrigh'."}

STRINGS.QUESTSMOD.LUMBERJACK_SKIN = {}
STRINGS.QUESTSMOD.LUMBERJACK_SKIN.EXAMINE = {"Coul' ya chop %i more trees around, kid?","Chop some trees for me? %i should do."}
STRINGS.QUESTSMOD.LUMBERJACK_SKIN.SOLVED = {"Thanks, kid. Here's yer reward."}
STRINGS.QUESTSMOD.LUMBERJACK_SKIN.WANTSKIP = {"Wan' to take a rain-check?"}
STRINGS.QUESTSMOD.LUMBERJACK_SKIN.SKIPPED = {"Alrigh'."}

---------------------------------------------------------------------------------------------------

STRINGS.QUESTSMOD.EMOTEY_ROD = {}
STRINGS.QUESTSMOD.EMOTEY_ROD.EXAMINE = {"Want some quick work?\nWave and you're hired.","Want some fast cash?\nWave and you're hired."}
STRINGS.QUESTSMOD.EMOTEY_ROD.SOLVED = {"Consider yourself hired."}
STRINGS.QUESTSMOD.EMOTEY_ROD.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.EMOTEY_ROD.SKIPPED = {"No harm done."}

STRINGS.QUESTSMOD.REFORESTER_ROD = {}
STRINGS.QUESTSMOD.REFORESTER_ROD.EXAMINE = {"How about you plant %i more trees, pal?","We're going to need some materials. Plant %i more trees."}
STRINGS.QUESTSMOD.REFORESTER_ROD.SOLVED = {"Job well done."}
STRINGS.QUESTSMOD.REFORESTER_ROD.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.REFORESTER_ROD.SKIPPED = {"No harm done."}

STRINGS.QUESTSMOD.LUMBERJACK_ROD = {}
STRINGS.QUESTSMOD.LUMBERJACK_ROD.EXAMINE = {"Would you kindly chop down %i more trees?","Chop %i trees for a reward."}
STRINGS.QUESTSMOD.LUMBERJACK_ROD.SOLVED = {"Job well done."}
STRINGS.QUESTSMOD.LUMBERJACK_ROD.WANTSKIP = {"You sure you want to skip this?"}
STRINGS.QUESTSMOD.LUMBERJACK_ROD.SKIPPED = {"No harm done."}

---------------------------------------------------------------------------------------------------

STRINGS.QUESTSMOD.REFORESTER_GLOMMER = {}
STRINGS.QUESTSMOD.REFORESTER_GLOMMER.EXAMINE = {"Bzzz. Plant %i more trees please. Bzzzz.","Plant %i treezzz pleazzzz."}
STRINGS.QUESTSMOD.REFORESTER_GLOMMER.SOLVED = {"Thank you. Bzzzz."}
STRINGS.QUESTSMOD.REFORESTER_GLOMMER.WANTSKIP = {"No trees?"}
STRINGS.QUESTSMOD.REFORESTER_GLOMMER.SKIPPED = {"Okay. Bzzzz."}

STRINGS.QUESTSMOD.FLOURIST_GLOMMER = {}
STRINGS.QUESTSMOD.FLOURIST_GLOMMER.EXAMINE = {"Plant some flowers? Maybe %i more. Bzzzz.","Bzzzz. Plant %i flowers?"}
STRINGS.QUESTSMOD.FLOURIST_GLOMMER.SOLVED = {"Thank you. Bzzzz."}
STRINGS.QUESTSMOD.FLOURIST_GLOMMER.WANTSKIP = {"No flowers?"}
STRINGS.QUESTSMOD.FLOURIST_GLOMMER.SKIPPED = {"Okay. Bzzzz."}

STRINGS.QUESTSMOD.FLOWERPICK_GLOMMER = {}
STRINGS.QUESTSMOD.FLOWERPICK_GLOMMER.EXAMINE = {"Pick some flowers? Maybe %i more. Bzzzz.","Bzzzz. Pick %i flowers?"}
STRINGS.QUESTSMOD.FLOWERPICK_GLOMMER.SOLVED = {"Thank you. Bzzzz."}
STRINGS.QUESTSMOD.FLOWERPICK_GLOMMER.WANTSKIP = {"No flowers?"}
STRINGS.QUESTSMOD.FLOWERPICK_GLOMMER.SKIPPED = {"Okay. Bzzzz."}

---------------------------------------------------------------------------------------------------

STRINGS.QUESTSMOD.FLOURIST_STAGEHAND = {}
STRINGS.QUESTSMOD.FLOURIST_STAGEHAND.EXAMINE = {"Be a dear and plant %i flowers?","Could you plant %i flower for me?"}
STRINGS.QUESTSMOD.FLOURIST_STAGEHAND.SOLVED = {"I can't thank you enough."}
STRINGS.QUESTSMOD.FLOURIST_STAGEHAND.WANTSKIP = {"Maybe another time?"}
STRINGS.QUESTSMOD.FLOURIST_STAGEHAND.SKIPPED = {"Sure thing, dear."}

STRINGS.QUESTSMOD.FLOWERPICK_STAGEHAND = {}
STRINGS.QUESTSMOD.FLOWERPICK_STAGEHAND.EXAMINE = {"Be a dear and pick %i flowers?","Could you pick %i flowers for me?"}
STRINGS.QUESTSMOD.FLOWERPICK_STAGEHAND.SOLVED = {"I can't thank you enough."}
STRINGS.QUESTSMOD.FLOWERPICK_STAGEHAND.WANTSKIP = {"Maybe another time?"}
STRINGS.QUESTSMOD.FLOWERPICK_STAGEHAND.SKIPPED = {"Sure thing, dear."}

---------------------------------------------------------------------------------------------------

STRINGS.QUESTSMOD.NOMOREQUEST.SKIN_COLLECTOR = {"Got nothing for ya, kid."}
STRINGS.QUESTSMOD.NEXTQUESTIN.SKIN_COLLECTOR = {"Come back in %.2f days for somethin' to do."}

STRINGS.QUESTSMOD.NOMOREQUEST.MAXY = {"Scram!","You've outlived your usefulness."}
STRINGS.QUESTSMOD.NEXTQUESTIN.MAXY ={"I'll have something ready for you in %.2f days."}

STRINGS.QUESTSMOD.NOMOREQUEST.DIVININGROD = {"....."}
STRINGS.QUESTSMOD.NEXTQUESTIN.DIVININGROD ={"Stay tuned, I've got more for you in %.2f days."}

STRINGS.QUESTSMOD.NOMOREQUEST.GLOMMER = {"Thankzz for helpingzzz."}
STRINGS.QUESTSMOD.NEXTQUESTIN.GLOMMER ={"I might have somethingz in %.2f days. Bzzzz."}

STRINGS.QUESTSMOD.NOMOREQUEST.STAGEHAND = {"T."}
STRINGS.QUESTSMOD.NEXTQUESTIN.STAGEHAND ={"I might have somethingz in %.2f days. Bzzzz."}

---------------------------------------------------------------------------------------------------

STRINGS.NAMES.SKIN_COLLECTOR = "Skin Collector"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKIN_COLLECTOR = "I bet he's sure seen a lot..."

STRINGS.CHARACTERS.WILLOW.DESCRIBE.SKIN_COLLECTOR = "On a scale of 1 to 10, how flammable are you?"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SKIN_COLLECTOR = "Will Wolfgang look like that one day?"
STRINGS.CHARACTERS.WENDY.DESCRIBE.SKIN_COLLECTOR = "Imagine all the misery he's seen in his life..."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SKIN_COLLECTOR = "I can't imagine he gets a lot of customers."
STRINGS.CHARACTERS.WX78.DESCRIBE.SKIN_COLLECTOR = "I HAVE NO SKIN FOR YOU TO COLLECT. I WIN."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.SKIN_COLLECTOR = "Gotta keep warm, eh?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SKIN_COLLECTOR = "I remember him..."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SKIN_COLLECTOR = "I like your horns! Ha!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SKIN_COLLECTOR = "A stinky old man..."

---------------------------------------------------------------------------------------------------

STRINGS.NAMES.MAXY = "Maxwell"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAXY = "I hate that guy!"

STRINGS.CHARACTERS.WILLOW.DESCRIBE.MAXY = "He's so condescending."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MAXY = "A fancy suit is no match for my muscles!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.MAXY = "I feel a strange kinship with him."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MAXY = "What a rude gentleman."
STRINGS.CHARACTERS.WX78.DESCRIBE.MAXY = "HE IS AN UNKNOWN"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MAXY = "Why does he hate me?"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MAXY = "Looking good!"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MAXY = "Arrg! Is that the antagonist to my saga?!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MAXY = "That jerk tricked us."

---------------------------------------------------------------------------------------------------

STRINGS.NAMES.DIVININGROD = "Divining Rod"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.DIVININGROD = "It's some kind of homing device."

STRINGS.CHARACTERS.WILLOW.DESCRIBE.DIVININGROD = "It's full of eletrical junk."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DIVININGROD = "Is robot box."
STRINGS.CHARACTERS.WENDY.DESCRIBE.DIVININGROD = "It is forever seeking it's lost half."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DIVININGROD = "It is a magitechnical homing device."
STRINGS.CHARACTERS.WX78.DESCRIBE.DIVININGROD = "IT WANTS ITS MOTHER"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DIVININGROD = "I wonder if it gets the hockey game."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DIVININGROD = "I can use it to find my missing parts."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DIVININGROD = "A mechanical hunting hound. For the hunt."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DIVININGROD = "Lead and I shall follow."


