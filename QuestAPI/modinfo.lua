name = "QuestsAPI"
description = "Required for QuestMods.\nThen it adds quests and optional blueprintmode to the game.\nRewards:\nBlueprintMode+Shop=Blueprints+coins\nBlueprintmode=Blueprints+fewcoins+items\nShopmode=Manycoins\nIf both modes are disabled, you will get random items as a reward.\nBlueprints you found can be bought at the shop for 1 coin, so every player can get the recipes."
author = "Serpens"
forumthread = ""

version = "0.8.2"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = -1100 -- load last


configuration_options = 
{
	-- {
		-- name = "difficulty",
		-- label = "Difficulty",
		-- hover = "Dont change this for a running game.", -- really?
		-- options = 
		-- {
            -- {description = "Easy", data = 1, hover="More starting items, an easy adventure."},
            -- {description = "Medium", data = 2, hover="Moderate starting items, a normal adventure."},
            -- {description = "Hard", data = 3, hover="Few starting items, a hard adventure."},
        -- },
		-- default = 2,
    -- },
    {
		name = "newquest",
		label = "NextQuest",
		hover = "How much time should pass by, before getting a new quest\nafter SOLVING the previous one?\nWhen changing during a game, this won't affect present waiting time.",
		options = 
		{
            {description = "Instant", data = 0, hover="Directly after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Quarter day", data = 1/4, hover="A quarter day after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Half day", data = 1/2, hover="A half day after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Whole day", data = 1, hover="A whole day after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Two days", data = 2, hover="Two days after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Three days", data = 3, hover="Three days after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Seven days", data = 7, hover="Seven days after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Fourteen days", data = 14, hover="Fourteen days after completing a quest,\nyou get a new quest, if one is available."},
        },
		default = 1,
    },
    {
		name = "newquestskipped",
		label = "NextQSkipped",
		hover = "How much time should pass by, before getting a new quest\nafter SKIPPING the previous one?\nWhen changing during a game, this won't affect present waiting time.",
		options = 
		{
            {description = "Instant", data = 0, hover="Directly after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Quarter day", data = 1/4, hover="A quarter day after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Half day", data = 1/2, hover="A half day after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Whole day", data = 1, hover="A whole day after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Two days", data = 2, hover="Two days after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Three days", data = 3, hover="Three days after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Seven days", data = 7, hover="Seven days after completing a quest,\nyou get a new quest, if one is available."},
            {description = "Fourteen days", data = 14, hover="Fourteen days after completing a quest,\nyou get a new quest, if one is available."},
        },
		default = 1/2,
    },
    {
		name = "loopquests",
		label = "LoopQuests",
		hover = "After all quests are completed/skipped, do start all quests again?\nIf disabled, every quest is only offered one time, even when you skip it!", 
		options = 
		{
            {description = "No", data = false, hover="\n"},
            {description = "Yes", data = true, hover="Default"},
        },
		default = true,
    },
    {
		name = "shopkeeperstuff",
		label = "Shop",
		hover = "Should it be possible to buy basic items from shopkeeper ingame?",
		options = 
		{
			{description = "Off", data = false, hover="\n"},
            {description = "On", data = true, hover="Default"},
        },
		default = true,
	},
    {
		name = "findcoins",
		label = "Findcoins",
		hover = "Chance to find Coins while looting something\nWith coins you can buy stuff or blueprints at shop,\ndepending on the other modsettings.",
		options = 
		{
            {description = "None", data = 0, hover="\n"},
            {description = "Very Low", data = 0.006, hover="\n"},
            {description = "Low", data = 0.015, hover="\n"},
            {description = "Medium", data = 0.03, hover="Default"},
            {description = "High", data = 0.1, hover="\n"},
            {description = "Very High", data = 0.5, hover="\n"},
            {description = "Insane High", data = 1, hover="\n"},
        },
		default = 0.03,
    },
    {
		name = "blueprintonly",
		label = "Blueprint Mode",
		hover = "No Researchlabs.\nInstead you have to collect blueprints you get by quests.\nFound blueprints became buyable at shopkeeper\nDont change this for a running game.",
		options = 
		{
            {description = "Off", data = false, hover="Default"},
            {description = "On", data = true, hover="\n"},
        },
		default = false,
	},
    {
		name = "findblueprints",
		label = "FindBluePrints",
		hover = "Chance to find blueprints while working/slow-picking something\nOnly needed if BlueprintMode active.",
		options = 
		{
            {description = "None", data = 0, hover="\n"},
            {description = "Very Low", data = 0.003, hover="\n"},
            {description = "Low", data = 0.006, hover="\n"},
            {description = "Medium", data = 0.015, hover="Default"},
            {description = "High", data = 0.08, hover="\n"},
            {description = "Very High", data = 0.15, hover="\n"},
            {description = "Insane High", data = 0.9, hover="\n"},
        },
		default = 0.015,
    },
    
    -- {
		-- name = "null",
		-- label = "Dont change following after world created:",
		-- hover = "\n",
		-- options = 
		-- {
            -- {description = "\n", data = false, hover="\n"},
        -- },
		-- default = false,
	-- },
    
    
}
