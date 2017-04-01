-----------------------------------------------------
-- ## Quest Strings
-- they should have this form: GLOBAL.STRINGS.QUESTSMOD.  and then the unique name of the quest (questname): GLOBAL.STRINGS.QUESTSMOD.MYQUESTSMODNAME
-- you can also include "%s" or %i" in the strings, to add variable info. Eg. "Build %i houses". In your modmain, in the talking key of your quest in the init of quest,
-- you can add string.format(GLOBAL.STRINGS.QUESTSMOD.MYQUESTSMODNAME,number), to add your random number to the string, to variate the quest.
if not GLOBAL.STRINGS.QUESTSMOD then
    GLOBAL.STRINGS.QUESTSMOD = {}
end

GLOBAL.STRINGS.QUESTSMOD.KILLQUEST = {}
GLOBAL.STRINGS.QUESTSMOD.KILLQUEST.NEAR = {"KILL","KILL %i/%i %s","HUNT %i/%i %s","KILL %i/%i %s","HUNT %i/%i %s","",}
GLOBAL.STRINGS.QUESTSMOD.KILLQUEST.FAR = {"KILL","KILL %i/%i %s","HUNT %i/%i %s","KILL %i/%i %s","HUNT %i/%i %s","",}
GLOBAL.STRINGS.QUESTSMOD.KILLQUEST.SOLVED = {"GOOD HUNTER"}
GLOBAL.STRINGS.QUESTSMOD.KILLQUEST.WANTSKIP = {"TOO HARD?"}
GLOBAL.STRINGS.QUESTSMOD.KILLQUEST.SKIPPED = {"OKAY..."}
