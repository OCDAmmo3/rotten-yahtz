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
@onready var _optimal_choice = null

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
		"score_function": Callable(score_num).bind(2),
		"tooltip": "Count and add only twos"
	},
	{
		"label": "Threes",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-3.png"),
		"score_function": Callable(score_num).bind(3),
		"tooltip": "Count and add only threes"
	},
	{
		"label": "Fours",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-4.png"),
		"score_function": Callable(score_num).bind(4),
		"tooltip": "Count and add only fours"
	},
	{
		"label": "Fives",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-5.png"),
		"score_function": Callable(score_num).bind(5),
		"tooltip": "Count and add only fives"
	},
	{
		"label": "Sixes",
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-6.png"),
		"score_function": Callable(score_num).bind(6),
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
	_optimal_choice = null
	_find_possibilities()
	var max_score = [{"current_score": 0}]
	var highest_value = [{"value": 0}]
	for possibility in _possibilities:
		if possibility.current_score > max_score[0].current_score:
			max_score = [possibility]
		elif possibility.current_score == max_score[0].current_score:
			max_score.push_back(possibility)
		if possibility.value > highest_value[0].value:
			highest_value = [possibility]
		elif possibility.value == highest_value[0].value:
			highest_value.push_back(possibility)

	if highest_value.size() > 1:
		for possibility in highest_value:
			var thing = max_score.find(possibility)
			if thing != -1:
				_optimal_choice = possibility
	
	if _optimal_choice == null:
		highest_value.sort_custom(func(a,b): return a.current_score > b.current_score)
		_optimal_choice = highest_value[0]

	_optimal_choice.dice_selection_func.call()

func _find_possibilities():
	_set_open_score_options()
	_possibilities = []
	for _open_score_option in _open_score_options:
		_open_score_option.disabled = false
		await _open_score_option.emit_signal("pressed")
		_open_score_option.disabled = true

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

	var possibility = {
		"dice_selection_func": Callable(select_numeric).bind(num_to_score),
		"current_score": current_score,
		"value": float(current_score) / float(enemy_dice_pool.get_child_count() * num_to_score)
	}
	for index in non_matching_dice.size():
		possibility[str(index + 1)] = {
			"score": current_score + num_to_score * (index + 1),
			"chance_to_roll": find_chance_of_certain_dice_value(float(non_matching_dice.size()), float(index + 1), 6.0)
		}
	_possibilities.push_back(possibility)

func select_numeric(num_to_select):
	for dice in enemy_dice_pool.get_children():
		var dice_check_button = dice.find_child("CheckButton")
		dice_check_button.disabled = false
		dice_check_button.emit_signal("toggled", false)
		if dice.find_child("AnimatedDice").get_rolled_value() == num_to_select:
			dice_check_button.emit_signal("toggled", true)
			dice_check_button.disabled = true

func find_chance_of_certain_dice_value(num_of_dice_to_be_rolled, desired_num_of_dice, num_of_faces):
	var num_of_valid_combinations = n_choose_k(num_of_dice_to_be_rolled, desired_num_of_dice)
	var probability_of_certain_dice_value = 1.0 / num_of_faces
	var probability_of_desired_dice = pow(probability_of_certain_dice_value, desired_num_of_dice)
	var probability_other_dice_against = pow(1.0 - probability_of_certain_dice_value, num_of_dice_to_be_rolled - desired_num_of_dice)

	return num_of_valid_combinations * probability_of_desired_dice * probability_other_dice_against

func n_choose_k(n, k):
	return calc_factorial(n) / (calc_factorial(n - k) * calc_factorial(k))

func calc_factorial(num):
	var factorial_total = 1
	for n in num:
		factorial_total *= n + 1
	return factorial_total
