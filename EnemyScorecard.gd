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

var upper_score_options = [
	{
		"label": "Ones",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-1.png"),
		"score_function": Callable(score_num).bind(1),
		"tooltip": "Count and add only ones"
	},
	{
		"label": "Twos",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-2.png"),
		"score_function": null,
		"tooltip": "Count and add only twos"
	},
	{
		"label": "Threes",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-3.png"),
		"score_function": null,
		"tooltip": "Count and add only threes"
	},
	{
		"label": "Fours",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-4.png"),
		"score_function": null,
		"tooltip": "Count and add only fours"
	},
	{
		"label": "Fives",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-5.png"),
		"score_function": null,
		"tooltip": "Count and add only fives"
	},
	{
		"label": "Sixes",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-6.png"),
		"score_function": null,
		"tooltip": "Count and add only sixes"
	}
]

func _ready():
	create_upper_children()

func initiate_score_selection():
	enemy_dice_values = []
	enemy_dice_bonus_functions = []
	for dice in enemy_dice_pool.get_children():
		var animated_dice = dice.find_child("AnimatedDice", true, false)
		var dice_value = animated_dice.get_rolled_value()
		enemy_dice_values.push_back(dice_value)
		var dice_bonus_function = animated_dice.get_bonus_function()
		if dice_bonus_function != null:
			dice_bonus_function.call(enemy_dice_values, dice_value)

	enemy_has_rolled = enemy.get_has_rolled()

func create_upper_children():
	var upper_score_options_node = find_child("UpperSectionScoreOptions")
	for upper_score_option in upper_score_options:
		var score_option_row = create_score_option(upper_score_option)
		upper_score_options_node.add_child(score_option_row)
		_all_score_options.push_back(score_option_row)

func create_score_option(score_option):
	var score_option_row = score_option_row_scene.instantiate()
	score_option_row.disabled = true
	score_option_row.find_child("Left").text = score_option.label
	score_option_row.find_child("Dice").texture = score_option.sprite if score_option.sprite != null else null
	if score_option.score_function != null:
		score_option_row.connect("pressed", Callable(score_option.score_function).bind())
	score_option_row.tooltip_text = score_option.tooltip
	return score_option_row

func find_optimal_choice():
	_find_possibilities()

func _find_possibilities():
	_set_open_score_options()
	_possibilities = []
	for _open_score_option in _open_score_options:
		_open_score_option.disabled = false
		_open_score_option.emit_signal("pressed")
	print(_possibilities)

func _set_open_score_options():
	_open_score_options = []
	for _score_option in _all_score_options:
		var score_option_text = _score_option.find_child("Right").text
		if score_option_text == "":
			_open_score_options.push_back(_score_option)

func score_num(num_to_score):
	var current_score = 0
	var non_matching_dice = []
	for dice in enemy_dice_pool.get_children():
		var animated_dice = dice.find_child("AnimatedDice", true, false)
		var dice_value = animated_dice.get_rolled_value()
		if dice_value == num_to_score:
			current_score += dice_value
		else:
			non_matching_dice.push_back(dice)

	for index in non_matching_dice.size():
		var possibility = {
			"score": current_score + num_to_score * (index + 1),
			"chance_to_roll": 1 - pow((5.0/6.0),(index + 1))
		}
		_possibilities.push_back(possibility)
