extends Node

@onready var player_dice_pool = $Observable/Player/DicePoolContainer/DicePool
@onready var enemy_dice_pools = $Observable/Enemy/DicePoolContainer/DicePool

func on_roll_pressed():
	for dice_roller in player_dice_pool.get_children():
		dice_roller.roll_dice_if_selected()

	for dice_roller in enemy_dice_pools.get_children():
		dice_roller.get_child(0).get_child(1).get_child(0).roll_dice()
