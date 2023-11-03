extends VBoxContainer

var score_option_row_scene = preload("res://characterScenes/scorecard/score_option_row.tscn")

@onready var player = get_node("/root/BattleRollScene/Observable/Player/")
@onready var enemy = get_node("/root/BattleRollScene/Observable/Enemy/")
@onready var enemy_dice_pool = enemy.find_child("DicePool", true, false)
@onready var enemy_dice_values = []
@onready var enemy_dice_bonus_functions = []
@onready var enemy_has_rolled = false

@onready var _all_score_options = []
@onready var _open_score_options = []
@onready var _possibilities = []

func _ready():
	if enemy_has_rolled:
		_find_optimal_choice()

func _find_optimal_choice():
	_find_possibilities()

func _find_possibilities():
	_set_open_score_options()

func _set_open_score_options():
	_open_score_options = []
	for score_option in _all_score_options:
		if score_option.find_child("Right").text == null:
			_open_score_options.push_back(score_option)
