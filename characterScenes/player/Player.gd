extends Node2D

var dice_scene = preload("res://diceScenes/standard6sided/6dDiceSelector.tscn")
var dice_removal_selection = preload("res://diceScenes/diceSelectionScenes/DiceRemovalSelection.tscn")
var dice_selection_window = preload("res://diceScenes/diceSelectionScenes/DiceSelectionWindow.tscn")

@onready var dice_pool = get_node("/root/BattleRollScene/Control/DicePoolContainer/DicePool/")
@onready var player_sprite = $PlayerSprite
@onready var health_points = 100
@onready var player_health_bar = get_node("/root/BattleRollScene/Observable/Player/PlayerHealthBar/")
@onready var MAX_HEALTH = player_health_bar.get_max_health()
@onready var difficulty = 0

func _ready():
	player_sprite.play("Player groove")
	player_health_bar.heal_player(MAX_HEALTH)
	_load_dice()

func _load_dice():
	var amount_of_dice = 6
	for n in amount_of_dice:
		var new_dice = dice_scene.instantiate()
		add_dice(new_dice)

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
	dice_pool.add_child(new_dice)

func _remove_dice(selected_dice):
	dice_pool.remove_child(selected_dice)
