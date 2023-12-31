extends Node2D

@export var enhancement_options = [
	{
		"name": "High Roller",
		"sprite": preload("res://characterScenes/assets/enhancements/HighRoller.png"),
		"tooltip": "If more than 5 dice are usable for a numeric score option, earn double score for each bonus dice.",
		"main_function": Callable(func(score, dice_values, num_to_score):
			var more_than_five = dice_values.size() - 5
			if more_than_five > 0:
				score += more_than_five * num_to_score
			return score
			).bind(),
		"when_to_call": "numeric",
		"rarity": "C"
	},
	{
		"name": "Better Odds",
		"sprite": preload("res://characterScenes/assets/enhancements/BetterOdds.png"),
		"tooltip": "Receive 1 extra option for dice and enhancement selection options after battles.",
		"main_function": null,
		"when_to_call": "end_card",
		"rarity": "C"
	},
	{
		"name": "Deuces Wild",
		"sprite": preload("res://characterScenes/assets/enhancements/HighRoller.png"),
		"tooltip": "Once per battle, each 2 rolled in a set can count as any number value.",
		"main_function": null,
		"active": true,
		"when_to_call": "determine_dice",
		"rarity": "C"
	},
	{
		"name": "Snake Eyes",
		"sprite": preload("res://characterScenes/assets/enhancements/HighRoller.png"),
		"tooltip": "Each 1 rolled counts twice.",
		"main_function": null,
		"when_to_call": "miscellaneous",
		"rarity": "R"
	},
	{
		"name": "Smaller Straight",
		"sprite": preload("res://characterScenes/assets/enhancements/HighRoller.png"),
		"tooltip": "Small Straight can be scored with a run of 3 or 4.",
		"main_function": Callable(func():
			).bind(),
		"when_to_call": "small_straight",
		"rarity": "R"
	}
]
