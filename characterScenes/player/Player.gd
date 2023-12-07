extends Node2D

var dice_scene = preload("res://mainScenes/Selector.tscn")
var dice_removal_selection = preload("res://diceScenes/diceSelectionScenes/DiceRemovalSelection.tscn")
var dice_pool_scene = preload("res://diceScenes/DicePoolContainer.tscn")

@onready var dice_pool = dice_pool_scene.instantiate()
@onready var player_sprite = $PlayerSprite
@onready var player_health_bar = get_node("/root/BattleRollScene/Observable/Player/PlayerHealthBar/")
@onready var _default_roll_count = 4
@onready var _roll_count = _default_roll_count
@onready var _has_rolled = false
@onready var _damage_value = 0
@onready var _player_alive = true
var enhancements = {
	"numeric": [],
	"player_load": [],
	"scoring": [],
	"chance": [],
	"enemy_load": [],
	"player_damage": [],
	"roll_end": [],
	"end_card": [],
	"determine_dice": [],
	"miscellaneous": []
}
var _dice_window_opened = false
var _removal_window_opened = false
var _money_hoarded = 0

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
		_dice_window_opened = true

func on_remove_dice_pressed():
	if !_removal_window_opened:
		var dice_removal_window = dice_removal_selection.instantiate()
		add_child(dice_removal_window)
		_removal_window_opened = true

func close_level_end_card():
	var level_end_card = get_node("/root/BattleRollScene/LevelEndCard/")
	get_node("/root/BattleRollScene/").remove_child(level_end_card)

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
		var check_button = dice.find_child("CheckButton")
		check_button.unselect()
		check_button.toggle_mode = false
		dice.find_child("AnimatedDice").reset_previous_frame()

func set_damage(damage_value):
	_damage_value = damage_value

func deal_damage():
	player_sprite.play("Deal damage")
	await player_sprite.animation_finished
	player_sprite.play("Player groove")
	await get_parent().find_child("EnemyHealthBar").take_damage(_damage_value)

func get_player_alive():
	return _player_alive

func set_player_alive(alive_bool):
	_player_alive = alive_bool
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://mainScenes/game_over.tscn")

func get_money_hoarded():
	return _money_hoarded

func add_money(money_to_add):
	_money_hoarded += money_to_add

func add_enhancement(selected):
	enhancements[selected.when_to_call].push_back(selected)

func get_enhancements():
	return enhancements
