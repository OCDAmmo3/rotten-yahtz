extends Node

var level_end_card_node = preload("res://mainScenes/level_end_card.tscn")

@onready var player_dice_pool = $Observable/Player/DicePoolContainer/DicePool.get_children()
@onready var enemy_dice_pools = $Observable/Enemy/DicePoolContainer/DicePool.get_children()
@onready var player = $Observable/Player
@onready var enemy = $Observable/Enemy
@onready var _currently_rolling = false
@onready var _enemy_dice_finished = 0
@onready var _player_dice_finished = 0
@onready var _player_submit_pressed = false
@onready var _enemy_submit_pressed = false
@onready var _player_finished_rolling = false
@onready var _enemy_finished_rolling = false

signal player_dice_finished_rolling
signal enemy_dice_finished_rolling
signal player_and_enemy_submitted
signal all_done_rolling

func _ready():
	connect("player_and_enemy_submitted", Callable(find_child("Scorecard"), "player_and_enemy_submitted").bind())
	connect("player_and_enemy_submitted", Callable(find_child("EnemyScorecard"), "player_and_enemy_submitted").bind())
	connect("player_dice_finished_rolling", player_finished_rolling)
	connect("enemy_dice_finished_rolling", enemy_finished_rolling)
	
	if not player.get_player_alive():
		print("this where everything break")

	for dice in player_dice_pool:
		dice.find_child("AnimatedDice").connect("roll_finished", Callable(func():
			_player_dice_finished += 1
			if _player_dice_finished_rolling():
				emit_signal("player_dice_finished_rolling")
			).bind())
	for dice in enemy_dice_pools:
		dice.find_child("AnimatedDice").connect("roll_finished", Callable(func():
			_enemy_dice_finished += 1
			if _enemy_dice_finished_rolling():
				emit_signal("enemy_dice_finished_rolling")
			).bind())

func on_roll_pressed():
	if _currently_rolling:
		return
	_currently_rolling = true
	if player.get_roll_count() > 0 and not _player_submit_pressed:
		_player_dice_finished = 0
		for dice_roller in player_dice_pool:
			dice_roller.roll_dice_if_selected()
		player.roll_used()
	else:
		print("can't do that")
		#want to present player scorecard at this point

	if enemy.get_roll_count() > 0 and not _enemy_submit_pressed:
		_enemy_dice_finished = 0
		for dice_roller in enemy_dice_pools:
			dice_roller.roll_dice_if_selected()
		enemy.roll_used()
	else:
		print("definitely can't do that")
		#want to determine enemy score at this point, not display

	await all_done_rolling
	$EnemyScorecard.find_optimal_choice()
	_currently_rolling = false
	if _player_submit_pressed and not _enemy_submit_pressed:
		await get_tree().create_timer(0.5).timeout
		enemy.continue_rolling()

func rolls_reset():
	_currently_rolling = false
	$Scorecard.set_enemy_submit_pressed(false)
	player.rolls_reset()
	enemy.rolls_reset()

func _player_dice_finished_rolling():
	var unselected_dice = 0
	for dice in player_dice_pool:
		if !dice.get_dice_selected():
			unselected_dice += 1
	return _player_dice_finished == unselected_dice

func _enemy_dice_finished_rolling():
	var unselected_dice = 0
	for dice in enemy_dice_pools:
		if !dice.get_dice_selected():
			unselected_dice += 1
	return _enemy_dice_finished == unselected_dice

func set_enemy_submit_pressed(pressed):
	_enemy_submit_pressed = pressed
	$Scorecard.set_enemy_submit_pressed(pressed)
	if _enemy_submit_pressed and _player_submit_pressed:
		await all_submitted()

func set_player_submit_pressed(pressed):
	_player_submit_pressed = pressed
	if _enemy_submit_pressed and _player_submit_pressed:
		await all_submitted()

func all_submitted():
	rolls_reset()
	_player_finished_rolling = false
	_enemy_finished_rolling = false
	emit_signal("player_and_enemy_submitted")
	set_enemy_submit_pressed(false)
	set_player_submit_pressed(false)

	await player.deal_damage()
	if enemy.get_enemy_alive():
		await enemy.deal_damage()

func player_finished_rolling():
	_player_finished_rolling = true
	if _enemy_finished_rolling:
		emit_signal("all_done_rolling")

func enemy_finished_rolling():
	_enemy_finished_rolling = true
	if _player_finished_rolling:
		emit_signal("all_done_rolling")

func end_level():
	var level_end_card = level_end_card_node.instantiate()
	add_child(level_end_card)
	level_end_card.set_score_values($Scorecard.get_upper_total(), $Scorecard.get_lower_total(), $Scorecard.get_grand_total())
