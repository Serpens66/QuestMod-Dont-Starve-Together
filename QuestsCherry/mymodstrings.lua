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
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.EXAMINE = {"Hey kid, ya mind fallin' asleep next ta me?"} -- when translating, make sure you keep exactly the same order and amount of %i, %f and %s ! %.1f means a float number, with 1 decimal place
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SOLVED = {"Yep, just what I though. Here's your reward."}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.WANTSKIP = {"Want to take a rain-check?"}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SKIPPED = {"Alright."}

GLOBAL.STRINGS.QUESTSMOD.REFORESTER = {}
GLOBAL.STRINGS.QUESTSMOD.REFORESTER.EXAMINE = {"Do ya mind planting %i more trees around, kid?"} -- when translating, make sure you keep exactly the same order and amount of %i, %f and %s ! %.1f means a float number, with 1 decimal place
GLOBAL.STRINGS.QUESTSMOD.REFORESTER.SOLVED = {"Thanks. Here's your reward."}
GLOBAL.STRINGS.QUESTSMOD.REFORESTER.WANTSKIP = {"Want to take a rain-check?"}
GLOBAL.STRINGS.QUESTSMOD.REFORESTER.SKIPPED = {"Alright."}

if not GLOBAL.STRINGS.QUESTSMOD.NOMOREQUEST then
    GLOBAL.STRINGS.QUESTSMOD.NOMOREQUEST = {}
end
if not GLOBAL.STRINGS.QUESTSMOD.NEXTQUESTIN then
    GLOBAL.STRINGS.QUESTSMOD.NEXTQUESTIN = {}
end

GLOBAL.STRINGS.QUESTSMOD.NOMOREQUEST.SKIN_COLLECTOR = {"Got nothing for ya, kid."}
GLOBAL.STRINGS.QUESTSMOD.NEXTQUESTIN.SKIN_COLLECTOR = {"Come back in %.2f days for somethin' to do."}
GLOBAL.STRINGS.QUESTSMOD.NOMOREQUEST.MAXY = {"Scram!","You've outlived your usefulness."}
GLOBAL.STRINGS.QUESTSMOD.NEXTQUESTIN.MAXY ={"I'll have something ready for you in %.2f days."}

GLOBAL.STRINGS.NAMES.SKIN_COLLECTOR = "Skin Collector"

GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKIN_COLLECTOR = "I bet he's sure seen a lot..."

GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.SKIN_COLLECTOR = "On a scale of 1 to 10, how flammable are you?"
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SKIN_COLLECTOR = "Will Wolfgang look like that one day?"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.SKIN_COLLECTOR = "Imagine all the misery he's seen in his life..."
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SKIN_COLLECTOR = "I can't imagine he gets a lot of customers."
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.SKIN_COLLECTOR = "I HAVE NO SKIN FOR YOU TO COLLECT. I WIN."
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.SKIN_COLLECTOR = "Gotta keep warm, eh?"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SKIN_COLLECTOR = "I remember him..."
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SKIN_COLLECTOR = "I like your horns! Ha!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.SKIN_COLLECTOR = "A stinky old man..."

GLOBAL.STRINGS.NAMES.MAXY = "Maxwell"

GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAXY = "I hate that guy!"

GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.MAXY = "He's so condescending."
GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MAXY = "A fancy suit is no match for my muscles!"
GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.MAXY = "I feel a strange kinship with him."
GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MAXY = "What a rude gentleman."
GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.MAXY = "HE IS AN UNKNOWN"
GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.MAXY = "Why does he hate me?"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MAXY = "Looking good!"
GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MAXY = "Arrg! Is that the antagonist to my saga?!"
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.MAXY = "That jerk tricked us."

