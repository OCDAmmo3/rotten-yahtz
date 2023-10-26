extends Node

@onready var player_dice_pool = $Observable/Player/DicePoolContainer/DicePool
@onready var enemy_dice_pools = $Observable/Enemy/DicePoolContainer/DicePool
@onready var player = $Observable/Player
@onready var enemy = $Observable/Enemy

func on_roll_pressed():
	if player.get_roll_count() > 0:
		for dice_roller in player_dice_pool.get_children():
			dice_roller.roll_dice_if_selected()
		player.roll_used()
	else:
		print("can't do that")
		#want to present player scorecard at this point

	if enemy.get_roll_count() > 0:
		for dice_roller in enemy_dice_pools.get_children():
			dice_roller.get_child(0).get_child(1).get_child(0).roll_dice()
		enemy.roll_used()
	else:
		print("definitely can't do that")
		#want to determine enemy score at this point, not display
