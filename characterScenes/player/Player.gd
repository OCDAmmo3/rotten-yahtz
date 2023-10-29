extends Node2D

var dice_scene = preload("res://diceScenes/standard6sided/6dDiceSelector.tscn")
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

func _ready():
	player_sprite.play("Player groove")
	_load_dice()
	_load_dice_pool()

func _load_dice():
	var amount_of_dice = 6
	for n in amount_of_dice:
		var new_dice = dice_scene.instantiate()
		add_dice(new_dice)

func _load_dice_pool():
	add_child(dice_pool)

func on_add_dice_pressed():
	var dice_selection = dice_selection_window.instantiate()
	add_child(dice_selection)

func on_remove_dice_pressed():
	var dice_removal_window = dice_removal_selection.instantiate()
	add_child(dice_removal_window)

func close_dice_removal_window():
	remove_child(get_node("/root/BattleRollScene/Observable/Player/DiceRemovalSelection/"))
	remove_child(get_node("/root/BattleRollScene/Observable/Player/DiceSelectionWindow/"))

func add_dice(new_dice):
	dice_pool.get_child(0).add_child(new_dice)

func _remove_dice(selected_dice):
	dice_pool.remove_child(selected_dice)

func get_roll_count():
	return _roll_count

func roll_used():
	_roll_count = _roll_count - 1
	_has_rolled = true
	for dice in dice_pool.get_child(0).get_children():
		dice.find_child("CheckButton").toggle_mode = true

func get_has_rolled():
	return _has_rolled

func rolls_reset():
	_roll_count = _default_roll_count
	_has_rolled = false 
	for dice in dice_pool.get_child(0).get_children():
		dice.find_child("CheckButton").toggle_mode = false
