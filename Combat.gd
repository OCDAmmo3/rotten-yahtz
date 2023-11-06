extends Node

@onready var player_dice_pool = $Observable/Player/DicePoolContainer/DicePool.get_children()
@onready var enemy_dice_pools = $Observable/Enemy/DicePoolContainer/DicePool.get_children()
@onready var player = $Observable/Player
@onready var enemy = $Observable/Enemy
@onready var _currently_rolling = false
@onready var _dice_finished_rolling = 0
@onready var all_dice = []

signal all_dice_finished_rolling

func _ready():
	if player.get_roll_count() > 1:
		all_dice += player_dice_pool
	if enemy.get_roll_count() > 1:
		all_dice += enemy_dice_pools
	for dice in all_dice:
		dice.find_child("AnimatedDice").connect("roll_finished", Callable(func():
			_dice_finished_rolling += 1
			if _all_dice_finished_rolling():
				emit_signal("all_dice_finished_rolling")
			).bind())

func on_roll_pressed():
	if _currently_rolling:
		return
	_currently_rolling = true
	if player.get_roll_count() > 0:
		_dice_finished_rolling = 0
		for dice_roller in player_dice_pool:
			dice_roller.roll_dice_if_selected()
		player.roll_used()
	else:
		print("can't do that")
		#want to present player scorecard at this point

	if enemy.get_roll_count() > 0:
		for dice_roller in enemy_dice_pools:
			dice_roller.roll_dice_if_selected()
		enemy.roll_used()
	else:
		print("definitely can't do that")
		#want to determine enemy score at this point, not display

	await all_dice_finished_rolling
	$EnemyScorecard.find_optimal_choice()
	_currently_rolling = false

func rolls_reset():
	_currently_rolling = false
	player.rolls_reset()
	enemy.rolls_reset()

func _all_dice_finished_rolling():
	var unselected_dice = 0
	for dice in all_dice:
		if !dice.get_dice_selected():
			unselected_dice += 1
	return _dice_finished_rolling == unselected_dice
