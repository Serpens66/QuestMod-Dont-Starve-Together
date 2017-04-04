name = "QuestsHunt"
description = "Needs QuestAPI Mod\n\nThis mod adds for nearly every surface mob a -hunt x prefab- quest to the pigking.\nIn settings you can choose how many such quests and for what mobs you want them.\nThe quests get harder the more days you survived and also fit to the current season.\nThe mobs won't spawn, so you must find regular ones. Mobs killed by your followers are also counted" 
author = "Serpens"
forumthread = ""

version = "0.8.2"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = -1010 -- loaded before the API mod, but after questmod (the lower the number, the later it is loaded)


local mobs = {"Antlion", "Bearger", "Bee", "Beefalo", "Birds", "Butterfly", "Buzzard", "Catcoon", "Clockworks", "Deerclops", "Dragonfly", "Frog", "Glommer", "Hound", "Koalefant", "Krampus", "Leif", "Lightninggoat", "Lureplant",
 "Merm", "Mole", "Moose", "Mosquito", "Mossling", "Penguin", "Perd", "Pig", "Rabbit", "Shadow Creatures", "Shadow Pieces", "Spat", "Spider", "Spiderqueen", "Spider_Warrior", "Tallbird", "Tentacle", "Walrus", "Warg", }

 
--  fuer settings kann man auch global.strings versuchen
 
local configs = 
{
    {
		name = "number",
		label = "NumberQuests",
		hover = "How many of those Hunt-Quests should be added to the pigking?",
		options = 
		{
            {description = "0", data = 0, hover="\n"},
            {description = "1", data = 1, hover="\n"},
            {description = "3", data = 3, hover="\n"},
            {description = "6", data = 6, hover="\n"},
            {description = "10", data = 10, hover="\n"},
            {description = "15", data = 15, hover="\n"},
            {description = "20", data = 20, hover="\n"},
            {description = "25", data = 25, hover="\n"},
            {description = "30", data = 30, hover="\n"},
        },
		default = 10,
    },
    {
		name = "null",
		label = "\n",
		hover = "\n",
		options = 
		{
            {description = "\n", data = false, hover="\n"},
        },
		default = false,
    },
}

for i=1,#mobs do -- there is no pairs in modinfo available 
    configs[i+2] = {
        name = mobs[i],
        label = mobs[i],
        hover = "Should "..mobs[i].." be a possible target of a hunt quest?",
        options = {
            {description = "No", data = false, hover="\n"},
            {description = "Yes", data = true, hover="\n"},
        },
        default = true,
    }
end


configuration_options = previous_configuration or old_config or configs or {}