extends Node

@onready var dice_pool = $Control/DicePoolContainer/DicePool

func on_roll_pressed():
	for dice_roller in dice_pool.get_children():
		dice_roller.roll_dice()
