name = "QuestsSerp"
description = "Requires QuestAPI.\n\nAdds a collection of Quests to the pigking." 
author = "Serpens"
forumthread = ""

version = "0.8.1"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = -1000 -- loaded before the API mod


configuration_options = 
{
    {
		name = "number",
		label = "NumberEmote",
		hover = "How many of those Emote-Quests should be added to the pigking?\nThe recommend number depends on how many other quests exist\nto get a good mix.",
		options = 
		{
            {description = "0", data = 0, hover="\n"},
            {description = "1", data = 1, hover="\n"},
            {description = "3", data = 3, hover="\n"},
            {description = "6", data = 6, hover="\n"},
            {description = "8", data = 8, hover="\n"},
            {description = "10", data = 10, hover="\n"},
            {description = "15", data = 15, hover="\n"},
            {description = "20", data = 20, hover="\n"},
            {description = "25", data = 25, hover="\n"},
            {description = "30", data = 30, hover="\n"},
        },
		default = 10,
    },
}
