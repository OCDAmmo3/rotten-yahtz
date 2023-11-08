extends VBoxContainer

var score_option_row_scene = preload("res://characterScenes/scorecard/score_option_row.tscn")

@onready var player = get_node("/root/BattleRollScene/Observable/Player/")
@onready var enemy = get_node("/root/BattleRollScene/Observable/Enemy/")
@onready var player_dice_pool = player.find_child("DicePool", true, false)
@onready var player_dice_values = []
@onready var player_dice_bonus_functions = []
@onready var player_has_rolled = false
@onready var _enemy_submit_pressed = false

@onready var upper_score_option_row = create_score_option(upper_total_score_option)
@onready var upper_bonus_option_row = create_score_option(upper_bonus_score_option)
@onready var upper_final_option_row = create_score_option(upper_final_total_score_option)
@onready var lower_score_option_row = create_score_option(lower_total_score_option)
@onready var grand_total_option_row = create_score_option(grand_total_score_option)
@onready var total_upper_score = 0
@onready var upper_bonus_score = 0
@onready var total_lower_score = 0
@onready var grand_total_score = 0

var _selected_score_option = null
var _selected_score = 0
var _health_to_heal = 0
var _score_to_set = "upper"

signal submit_pressed
signal enemy_can_continue

func change_visible():
	visible = not visible

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
var lower_score_options = [
	{
		"label": "3 of a kind",
		"sprite": null,
		"score_function": Callable(score_some_of_a_kind).bind(3),
		"tooltip": "Needs three of any same kind value. Add total of all dice, 3 of a kind each count twice"
	},
	{
		"label": "4 of a kind",
		"sprite": null,
		"score_function": Callable(score_some_of_a_kind).bind(4),
		"tooltip": "Needs four of any same kind value. Add total of all dice, 4 of a kind each count three times"
	},
	{
		"label": "Full House",
		"sprite": null,
		"score_function": Callable(score_full_house).bind(),
		"tooltip": "Needs three of any same kind value, two of another. Double score for top 3, heal for bottom 2"
	},
	{
		"label": "Sm Straight",
		"sprite": null,
		"score_function": Callable(score_straight).bind(4),
		"tooltip": "Needs a sequence of 4 or more values. Score for 30 + highest value in straight"
	},
	{
		"label": "Lg Straight",
		"sprite": null,
		"score_function": Callable(score_straight).bind(5),
		"tooltip": "Needs a sequence of 5 or more values. Score for 40 + highest value in straight * 2"
	},
	{
		"label": "YAHTZEE",
		"sprite": null,
		"score_function": Callable(score_yahtzee).bind(),
		"tooltip": "Needs five of any same kind value. Score for 50, also ALL dice values add to score and heal player"
	},
	{
		"label": "Chance",
		"sprite": null,
		"score_function": Callable(score_chance).bind(),
		"tooltip": "No specific requirements need met, can score at any time. Score half total roll value"
	}
]

var upper_total_score_option = {
	"label": "TOTAL SCORE",
	"sprite": null,
	"score_function": null,
	"tooltip": "Total score of all 6 numeric score values"
}
var upper_bonus_score_option = {
	"label": "BONUS",
	"sprite": null,
	"score_function": null,
	"tooltip": "If total of all numeric values is 63 or more, gain 35 bonus points - does not contribute to damage"
}
var upper_final_total_score_option = {
	"label": "UPPER TOTAL",
	"sprite": null,
	"score_function": null,
	"tooltip": "Final score for the upper section"
}
var lower_total_score_option = {
	"label": "LOWER TOTAL",
	"sprite": null,
	"score_function": null,
	"tooltip": "Total score of all lower section score values"
}
var grand_total_score_option = {
	"label": "GRAND TOTAL",
	"sprite": null,
	"score_function": null,
	"tooltip": "Grand total of top and bottom sections"
}

func _ready():
	connect("submit_pressed", Callable(get_node("/root/BattleRollScene/"), "set_player_submit_pressed").bind(true))
	connect("enemy_can_continue", Callable(enemy, "player_has_submitted").bind())
	
	create_upper_children()
	create_lower_children()

func initiate_score_selection(selected_score_node):
	_selected_score = 0
	if _selected_score_option != null:
		_selected_score_option.find_child("Right").text = ""
	player_dice_values = []
	player_dice_bonus_functions = []
	for dice in player_dice_pool.get_children():
		var animated_dice = dice.find_child("AnimatedDice", true, false)
		var dice_value = animated_dice.get_rolled_value()
		player_dice_values.push_back(dice_value)
		var dice_bonus_function = animated_dice.get_bonus_function()
		if dice_bonus_function != null:
			dice_bonus_function.call(player_dice_values, dice_value)

	player_has_rolled = player.get_has_rolled()
	_selected_score_option = selected_score_node

func create_upper_children():
	var upper_score_options_node = find_child("UpperSectionScoreOptions")
	for upper_score_option in upper_score_options:
		var score_option_row = create_score_option(upper_score_option)
		upper_score_options_node.add_child(score_option_row)

	upper_score_option_row.disabled = true
	upper_score_option_row.find_child("Right").text = "0"
	upper_score_options_node.add_child(upper_score_option_row)

	upper_bonus_option_row.disabled = true
	upper_bonus_option_row.find_child("Right").text = "0"
	upper_score_options_node.add_child(upper_bonus_option_row)

	upper_final_option_row.disabled = true
	upper_final_option_row.find_child("Right").text = "0"
	upper_score_options_node.add_child(upper_final_option_row)

func create_lower_children():
	var lower_score_options_node = find_child("LowerSectionScoreOptions")
	for lower_score_option in lower_score_options:
		var score_option_row = create_score_option(lower_score_option)
		lower_score_options_node.add_child(score_option_row)

	lower_score_option_row.disabled = true
	lower_score_option_row.find_child("Right").text = "0"
	lower_score_options_node.add_child(lower_score_option_row)

	grand_total_option_row.disabled = true
	grand_total_option_row.find_child("Right").text = "0"
	lower_score_options_node.add_child(grand_total_option_row)

func create_score_option(score_option):
	var score_option_row = score_option_row_scene.instantiate()
	score_option_row.find_child("Left").text = score_option.label
	score_option_row.find_child("Dice").texture = score_option.sprite if score_option.sprite != null else null
	if score_option.score_function != null:
		score_option_row.connect("pressed", Callable(score_option.score_function).bind(score_option_row))
	score_option_row.tooltip_text = score_option.tooltip
	return score_option_row

func score_num(score_option_node, num):
	initiate_score_selection(score_option_node)
	if not player_has_rolled:
		return
	_selected_score = player_dice_values.reduce((func(accum, value):
		return accum + value if value == num else accum
	), 0)
	score_option_node.find_child("Right").text = str(_selected_score)
	_score_to_set = "upper"

func score_some_of_a_kind(score_option_node, num_of_kind):
	initiate_score_selection(score_option_node)
	if not player_has_rolled:
		return
	var has_dice_times = {1:0,2:0,3:0,4:0,5:0,6:0}
	var has_num_of_a_kind = player_dice_values.filter(func(value):
		has_dice_times[value] += 1
		return has_dice_times[value] >= num_of_kind
	)
	if has_num_of_a_kind.size() > 0:
		_selected_score += has_num_of_a_kind[0] * num_of_kind * (num_of_kind - 2)
		_selected_score += player_dice_values.reduce((func(accum, value):
			return accum + value
		), 0)

	score_option_node.find_child("Right").text = str(_selected_score)
	_score_to_set = "lower"

func score_full_house(score_option_node):
	initiate_score_selection(score_option_node)
	if not player_has_rolled:
		return
	var has_dice_times = {1:0,2:0,3:0,4:0,5:0,6:0}
	player_dice_values.sort_custom(func(a, b): return a > b)
	for value in player_dice_values:
		has_dice_times[value] += 1
	var has_three_of_a_kind = player_dice_values.filter(func(value): return has_dice_times[value] >= 3)
	if has_three_of_a_kind.size() > 0:
		var has_different_two_of_a_kind = player_dice_values.filter(func(value):
			return has_dice_times[value] >= 2 && value != has_three_of_a_kind[0])
		if has_different_two_of_a_kind.size() > 0:
			_selected_score += 25
			_selected_score += has_three_of_a_kind[0] * 3
			_health_to_heal += has_different_two_of_a_kind[0] * 2

	score_option_node.find_child("Right").text = str(_selected_score)
	_score_to_set = "lower"

func score_straight(score_option_node, str_size):
	initiate_score_selection(score_option_node)
	if not player_has_rolled:
		return
	player_dice_values.sort()
	var sequential_size = 1
	var highest_in_straight
	var unique_values = []
	for value in player_dice_values:
		if not unique_values.has(value):
			unique_values.push_back(value)

	for index in unique_values.size():
		var value = unique_values[index]
		if index + 1 < unique_values.size() && value + 1 == unique_values[index + 1]:
			sequential_size += 1
			highest_in_straight = unique_values[index + 1]
		elif sequential_size >= str_size:
			break
		else:
			sequential_size = 1

	if sequential_size >= str_size:
		_selected_score += (str_size - 1) * 10
		_selected_score += highest_in_straight if str_size == 4 else highest_in_straight * 2

	score_option_node.find_child("Right").text = str(_selected_score)
	_score_to_set = "lower"

func score_yahtzee(score_option_node):
	initiate_score_selection(score_option_node)
	if not player_has_rolled:
		return
	var has_dice_times = {1:0,2:0,3:0,4:0,5:0,6:0}
	var has_yahtzee = player_dice_values.filter(func(value):
		has_dice_times[value] += 1
		return has_dice_times[value] >= 5
	)
	if has_yahtzee.size() > 0:
		_selected_score += 50
		for value in player_dice_values:
			_selected_score += value
			_health_to_heal += value

	score_option_node.find_child("Right").text = str(_selected_score)
	_score_to_set = "lower"

func score_chance(score_option_node):
	initiate_score_selection(score_option_node)
	if not player_has_rolled:
		return
	for value in player_dice_values:
		_selected_score += value
	_selected_score = floor(_selected_score / 2)

	score_option_node.find_child("Right").text = str(_selected_score)
	_score_to_set = "lower"

func on_submit_pressed():
	if _selected_score_option != null:
		emit_signal("submit_pressed")
		if !_enemy_submit_pressed:
			emit_signal("enemy_can_continue")
		_enemy_submit_pressed = false

func set_upper_bonus_score():
	upper_bonus_score = 35 if total_upper_score >= 63 else 0
	upper_bonus_option_row.find_child("Right").text = str(upper_bonus_score)
	set_final_upper_score()

func set_total_upper_score():
	upper_score_option_row.find_child("Right").text = str(total_upper_score)
	set_upper_bonus_score()

func set_final_upper_score():
	upper_final_option_row.find_child("Right").text = str(total_upper_score + upper_bonus_score)
	set_grand_total_score()

func set_total_lower_score():
	lower_score_option_row.find_child("Right").text = str(total_lower_score)
	set_grand_total_score()
	
func set_grand_total_score():
	grand_total_score = total_lower_score + total_upper_score + upper_bonus_score
	grand_total_option_row.find_child("Right").text = str(grand_total_score)
	
	player.find_child("PlayerHealthBar").heal_player(_health_to_heal)
	_health_to_heal = 0

func player_and_enemy_submitted():
	_selected_score_option.disabled = true
	_selected_score_option = null
	
	var multiplier = player.get_roll_count() - enemy.get_roll_count()
	player.set_damage(_selected_score * (multiplier if multiplier > 0 else 1))

	if _score_to_set == "upper":
		total_upper_score += _selected_score
	else:
		total_lower_score += _selected_score

	set_total_lower_score()
	set_total_upper_score()

func set_enemy_submit_pressed(pressed):
	_enemy_submit_pressed = pressed
