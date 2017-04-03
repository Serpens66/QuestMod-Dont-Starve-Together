-----------------------------------------------------
-- ## Quest Strings
-- they should have this form: GLOBAL.STRINGS.QUESTSMOD.  and then the unique name of the quest (questname): GLOBAL.STRINGS.QUESTSMOD.MYQUESTSMODNAME
-- you can also include "%s" or %i" in the strings, to add variable info. Eg. "Build %i houses". In your modmain, in the talking key of your quest in the init of quest,
-- you can add string.format(GLOBAL.STRINGS.QUESTSMOD.MYQUESTSMODNAME,number), to add your random number to the string, to variate the quest.
local STRINGS = GLOBAL.STRINGS
local require = GLOBAL.require


if not GLOBAL.STRINGS.QUESTSMOD then
    GLOBAL.STRINGS.QUESTSMOD = {}
end

GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER = {}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.NEAR = {"Hey, kid, mind fallin' asleep next ta me?",""} -- when translating, make sure you keep exactly the same order and amount of %i, %f and %s ! %.1f means a float number, with 1 decimal place
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.FAR = {"Hey, kid, mind fallin' asleep next ta me?",""}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SOLVED = {"Yep, just what I though. Here's your reward."}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.WANTSKIP = {"Want to take a rain-check?"}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SKIPPED = {"Alright."}

GLOBAL.STRINGS.NAMES.SKIN_COLLECTOR = "Skin Collector"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKIN_COLLECTOR = "What a weird guy."

GLOBAL.STRINGS.QUESTSMOD.NOMOREQUEST = {"Got nothing for ya, kid.","",""}
GLOBAL.STRINGS.QUESTSMOD.NEXTQUESTIN = {"Come back in %.2f days for a new job.","","",""}