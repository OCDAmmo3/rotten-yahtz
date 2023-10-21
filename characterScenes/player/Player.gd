extends Node2D

var dice_scene = preload("res://diceScenes/standard6sided/6dDiceSelector.tscn")

@onready var dice_selection_window = get_node("/root/BattleRollScene/Control/DiceSelectionWindow/")
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
	dice_selection_window.show()

func on_remove_dice_pressed():
	var all_dice = dice_pool.get_children()
	var child_count = dice_pool.get_child_count()
	if child_count > 0:
		_remove_dice(all_dice[child_count - 1])

func add_dice(new_dice):
	dice_pool.add_child(new_dice)

func _remove_dice(selected_dice):
	dice_pool.remove_child(selected_dice)
