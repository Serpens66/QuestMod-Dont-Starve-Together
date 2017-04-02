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
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.NEAR = {"Fall asleep next to me, kid.",""} -- when translating, make sure you keep exactly the same order and amount of %i, %f and %s ! %.1f means a float number, with 1 decimal place
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.FAR = {"Fall asleep next to me, kid.",""}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SOLVED = {"You're quite the snorer."}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.WANTSKIP = {"Want to take a rain-check?"}
GLOBAL.STRINGS.QUESTSMOD.SLEEPOVER.SKIPPED = {"Alright."}

GLOBAL.STRINGS.NAMES.SKIN_COLLECTOR = "Skin Collector"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SKIN_COLLECTOR = "What a weird guy."

GLOBAL.STRINGS.QUESTSMOD.NOMOREQUEST = {"Got nothing for ya, kid.","",""}
GLOBAL.STRINGS.QUESTSMOD.NEXTQUESTIN = {"Come back in %.2f days for a new job.","","",""}


-- GLOBAL.STRINGS.QUESTSMOD.EMOTE = {}
-- GLOBAL.STRINGS.QUESTSMOD.EMOTE.NEAR = {"Want to see %i %s within %.1f seconds",""} -- when translating, make sure you keep exactly the same order and amount of %i, %f and %s ! %.1f means a float number, with 1 decimal place
-- GLOBAL.STRINGS.QUESTSMOD.EMOTE.FAR = {"%s for me %i times in %.1f seconds!",""}
-- GLOBAL.STRINGS.QUESTSMOD.EMOTE.SOLVED = {"That was nice!"}
-- GLOBAL.STRINGS.QUESTSMOD.EMOTE.WANTSKIP = {"You dont wan't to %s?"}
-- GLOBAL.STRINGS.QUESTSMOD.EMOTE.SKIPPED = {"Okay, sad..."}

-- GLOBAL.STRINGS.QUESTSMOD.PIGHATS = {}
-- GLOBAL.STRINGS.QUESTSMOD.PIGHATS.NEAR = {"WANT %i FUNNY HATS","SHOW %i PIGS WITH HATS","SHOW ME %i HATS","WANT LAUGH","",""}
-- GLOBAL.STRINGS.QUESTSMOD.PIGHATS.FAR = {"WANT %i FUNNY HATS","SHOW %i PIGS WITH HATS","SHOW ME %i HATS","WANT LAUGH","",""}
-- GLOBAL.STRINGS.QUESTSMOD.PIGHATS.SOLVED = {"THAT IS FUNNY!"}
-- GLOBAL.STRINGS.QUESTSMOD.PIGHATS.WANTSKIP = {"NO HATS?"}
-- GLOBAL.STRINGS.QUESTSMOD.PIGHATS.SKIPPED = {"OKAY..."}

-- GLOBAL.STRINGS.QUESTSMOD.BUILDPIGHOUSES = {}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDPIGHOUSES.NEAR = {"BUILD NEAR HOME","HELP BUILD","NEED %i/%i MORE PIGS","BUILD %i/%i HOUSES NEAR","","",} -- important how many pighouses and near pigking
-- GLOBAL.STRINGS.QUESTSMOD.BUILDPIGHOUSES.FAR = {"BUILD NEAR HOME","HELP BUILD","NEED %i/%i MORE PIGS","BUILD %i/%i HOUSES NEAR","","",}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDPIGHOUSES.SOLVED = {"GOOD HOUSES","AH NEW PIGS"}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDPIGHOUSES.WANTSKIP = {"NO HOUSES?"}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDPIGHOUSES.SKIPPED = {"OKAY..."}

-- GLOBAL.STRINGS.QUESTSMOD.BUILDWALL = {}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDWALL.NEAR = {"BUILD WALL NEAR","HELP BUILD","BUILD %i/%i WALLS NEAR","","",}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDWALL.FAR = {"BUILD WALL NEAR","HELP BUILD","BUILD %i/%i WALLS NEAR","","",}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDWALL.SOLVED = {"GOOD WALL",}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDWALL.WANTSKIP = {"NO WALL?"}
-- GLOBAL.STRINGS.QUESTSMOD.BUILDWALL.SKIPPED = {"OKAY..."}

-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEMERM = {}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEMERM.NEAR = {"The merms worship maxwell...","Did you see the statue?","The merms will protect the statue with their lives.","","",}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEMERM.FAR = {"Maybe it would be better if this statue would be destroyed","Someone should destroy that statue","","",}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEMERM.SOLVED = {}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEMERM.WANTSKIP = {}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEMERM.SKIPPED = {"OKAY..."}

-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEPIG = {}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEPIG.NEAR = {"The pigs worship maxwell...","Did you see the statue?","The pigs will protect the statue with their lives.","","",}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEPIG.FAR = {"Maybe it would be better if this statue would be destroyed","Someone should destroy that statue","",""}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEPIG.SOLVED = {}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEPIG.WANTSKIP = {}
-- GLOBAL.STRINGS.QUESTSMOD.DESTROYSTATUEPIG.SKIPPED = {"OKAY..."}

-- GLOBAL.STRINGS.QUESTSMOD.TEENBIRD = {}
-- GLOBAL.STRINGS.QUESTSMOD.TEENBIRD.NEAR = {"Show me %i teenbird"}
-- GLOBAL.STRINGS.QUESTSMOD.TEENBIRD.FAR = {"Show me %i teenbird"}
-- GLOBAL.STRINGS.QUESTSMOD.TEENBIRD.SOLVED = {}
-- GLOBAL.STRINGS.QUESTSMOD.TEENBIRD.WANTSKIP = {}
-- GLOBAL.STRINGS.QUESTSMOD.TEENBIRD.SKIPPED = {"OKAY..."}

-- GLOBAL.STRINGS.QUESTSMOD.CRITTER = {}
-- GLOBAL.STRINGS.QUESTSMOD.CRITTER.NEAR = {"Show me a %s"}
-- GLOBAL.STRINGS.QUESTSMOD.CRITTER.FAR = {"Show me a %s"}
-- GLOBAL.STRINGS.QUESTSMOD.CRITTER.SOLVED = {}
-- GLOBAL.STRINGS.QUESTSMOD.CRITTER.WANTSKIP = {}
-- GLOBAL.STRINGS.QUESTSMOD.CRITTER.SKIPPED = {"OKAY..."}

-----------------------------------------------------
