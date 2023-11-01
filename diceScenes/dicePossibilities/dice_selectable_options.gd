extends Node2D

@export var dice_options = [
	{
		"name": "D6",
		"node": DiceOptions.dice_options.D6,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-6.png"),
		"tooltip": "Standard 6 sided dice with values 1-6"
	},
	{
		"name": "D4",
		"node": DiceOptions.dice_options.D4,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d4/4-sided-4.png"),
		"tooltip": "Standard 4 sided dice with values 1-4"
	},
	{
		"name": "D2",
		"node": DiceOptions.dice_options.D2,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d2/coin_dice_5.png"),
		"tooltip": "Standard 2 sided coin with values 1 and 2"
	}
]
