extends Node2D

@export var dice_options = [
	{
		"name": "D6",
		"node": DiceOptions.dice_options.D6,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-6.png"),
		"tooltip": "Standard 6 sided dice with values 1-6",
		"rarity": "C"
	},
	{
		"name": "D4",
		"node": DiceOptions.dice_options.D4,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d4/4-sided-4.png"),
		"tooltip": "Standard 4 sided dice with values 1-4",
		"rarity": "C"
	},
	{
		"name": "D2",
		"node": DiceOptions.dice_options.D2,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d2/coin_dice_5.png"),
		"tooltip": "Standard 2 sided coin with values 1 and 2",
		"rarity": "C"
	},
	{
		"name": "D5",
		"node": DiceOptions.dice_options.D5,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-5.png"),
		"tooltip": "Standard 5 sided dice with values 1-5",
		"rarity": "C"
	},
	{
		"name": "D21",
		"node": DiceOptions.dice_options.D21,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-6.png"),
		"tooltip": "21 sided dice with 6 sixes, 5 fives, 4 fours, 3 threes, 2 twos and 1 one",
		"rarity": "R"
	},
	{
		"name": "Low Roller",
		"node": DiceOptions.dice_options.LowRoller,
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-3.png"),
		"tooltip": "6 sided dice with values 1-3 twice, value counting towards score twice",
		"rarity": "C"
	}
]
