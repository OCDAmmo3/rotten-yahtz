extends Node2D

var dice_scene = preload("res://diceScenes/DiceSelector.tscn")
var dice_removal_selection = preload("res://diceScenes/diceSelectionScenes/DiceRemovalSelection.tscn")
var dice_selection_window = preload("res://diceScenes/diceSelectionScenes/DiceSelectionWindow.tscn")
var dice_pool_scene = preload("res://diceScenes/DicePoolContainer.tscn")

@onready var dice_pool = dice_pool_scene.instantiate()
@onready var player_sprite = $PlayerSprite
@onready var player_health_bar = get_node("/root/BattleRollScene/Observable/Player/PlayerHealthBar/")
@onready var MAX_HEALTH = player_health_bar.get_max_health()
@onready var difficulty = 0
@onready var _default_roll_count = 4
@onready var _roll_count = _default_roll_count
@onready var _has_rolled = false
var _dice_window_opened = false
var _removal_window_opened = false

func _ready():
	player_sprite.play("Player groove")
	_load_dice()
	_load_dice_pool()

func _load_dice():
	var amount_of_dice = 6
	for n in amount_of_dice:
		var new_dice = dice_scene.instantiate()
		new_dice.find_child("AnimatedDice").set_values(DiceOptions.dice_options.D6)
		new_dice.find_child("CheckButton").toggle_mode = false
		add_dice(new_dice)

func _load_dice_pool():
	add_child(dice_pool)

func on_add_dice_pressed():
	if !_dice_window_opened:
		var dice_selection = dice_selection_window.instantiate()
		add_child(dice_selection)
		_dice_window_opened = true

func on_remove_dice_pressed():
	if !_removal_window_opened:
		var dice_removal_window = dice_removal_selection.instantiate()
		add_child(dice_removal_window)
		_removal_window_opened = true

func close_dice_selection_window():
	remove_child(get_node("/root/BattleRollScene/Observable/Player/DiceRemovalSelection/"))
	_removal_window_opened = false
	remove_child(get_node("/root/BattleRollScene/Observable/Player/DiceSelectionWindow/"))
	_dice_window_opened = false

func add_dice(new_dice):
	dice_pool.get_child(0).add_child(new_dice)

func _remove_dice(selected_dice):
	dice_pool.remove_child(selected_dice)

func get_roll_count():
	return _roll_count

func roll_used():
	for dice in dice_pool.get_child(0).get_children():
		dice.find_child("CheckButton").toggle_mode = true

	_roll_count -= 1
	_has_rolled = true

func get_has_rolled():
	return _has_rolled

func rolls_reset():
	_roll_count = _default_roll_count
	_has_rolled = false 
	for dice in dice_pool.get_child(0).get_children():
		dice.find_child("CheckButton").toggle_mode = false
		dice.find_child("AnimatedDice").reset_previous_frame()

func deal_damage(_damage_value):
	get_parent().find_child("EnemyHealthBar").lose_health(_damage_value)
