extends VBoxContainer

var score_option_row_scene = preload("res://characterScenes/scorecard/score_option_row.tscn")

@onready var player = get_node("/root/BattleRollScene/Observable/Player/")
@onready var player_dice_pool = player.find_child("DicePool", true, false)
@onready var player_dice_values = player_dice_pool.get_children().map(func(dice):
	return dice.find_child("AnimatedDice", true, false).get_rolled_value()
)
@onready var upper_score_option_row = create_score_option(upper_total_score_option)
@onready var lower_score_option_row = create_score_option(lower_total_score_option)
@onready var total_upper_score = 0
@onready var total_lower_score = 0

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
		"tooltip": "Add total of all dice, 3 of a kind each count twice"
	},
	{
		"label": "4 of a kind",
		"sprite": null,
		"score_function": Callable(score_some_of_a_kind).bind(4),
		"tooltip": "Add total of all dice, 4 of a kind each count three times"
	},
	{
		"label": "Full House",
		"sprite": null,
		"score_function": Callable(score_full_house).bind(),
		"tooltip": "Double score for top 3, heal for bottom 2"
	},
	{
		"label": "Sm Straight",
		"sprite": null,
		"score_function": Callable(score_straight).bind(4),
		"tooltip": "Score for 30 + highest value in straight"
	},
	{
		"label": "Lg Straight",
		"sprite": null,
		"score_function": Callable(score_straight).bind(5),
		"tooltip": "Score for 40 + highest value in straight * 2"
	}
]

var upper_total_score_option = {
	"label": "SCORE TOTAL",
	"sprite": null,
	"score_function": null,
	"tooltip": "Total score of all 6 numeric score values"
}
var lower_total_score_option = {
	"label": "LOWER TOTAL",
	"sprite": null,
	"score_function": null,
	"tooltip": "Total score of all lower section score values"
}

signal changed_upper_total

func _ready():
	create_upper_children(upper_score_options)
	create_lower_children(lower_score_options)

func get_player_dice_values():
	player_dice_values = player_dice_pool.get_children().map(func(dice):
		return dice.find_child("AnimatedDice", true, false).get_rolled_value()
	)

func create_upper_children(upper_score_options):
	var upper_score_options_node = find_child("UpperSectionScoreOptions")
	for upper_score_option in upper_score_options:
		var score_option_row = create_score_option(upper_score_option)
		upper_score_options_node.add_child(score_option_row)

	upper_score_option_row.disabled = true
	upper_score_options_node.add_child(upper_score_option_row)

func create_lower_children(lower_score_options):
	var lower_score_options_node = find_child("LowerSectionScoreOptions")
	for lower_score_option in lower_score_options:
		var score_option_row = create_score_option(lower_score_option)
		lower_score_options_node.add_child(score_option_row)

	lower_score_option_row.disabled = true
	lower_score_options_node.add_child(lower_score_option_row)

func create_score_option(score_option):
	var score_option_row = score_option_row_scene.instantiate()
	score_option_row.find_child("Left").text = score_option.label
	score_option_row.find_child("Dice").texture = score_option.sprite if score_option.sprite != null else null
	if score_option.score_function != null:
		score_option_row.connect("pressed", Callable(score_option.score_function).bind(score_option_row))
	score_option_row.tooltip_text = score_option.tooltip
	return score_option_row

func score_num(score_option_node, num):
	get_player_dice_values()
	var score = player_dice_values.reduce((func(accum, value):
		return accum + value if value == num else accum
	), 0)
	score_option_node.find_child("Right").text = str(score)
	score_option_node.disabled = true

	total_upper_score += score
	set_total_upper_score()

func score_some_of_a_kind(score_option_node, num_of_kind):
	get_player_dice_values()
	var score = 0
	var has_dice_times = {1:0,2:0,3:0,4:0,5:0,6:0}
	var has_three_of_a_kind = player_dice_values.filter(func(value):
		has_dice_times[value] += 1
		return has_dice_times[value] >= num_of_kind
	)
	if has_three_of_a_kind.size() > 0:
		score = player_dice_values.reduce((func(accum, value):
			return accum + value * (num_of_kind - 1) if has_three_of_a_kind.has(value) else accum + value
		), 0)

	score_option_node.find_child("Right").text = str(score)
	score_option_node.disabled = true
	
	total_lower_score += score
	set_total_lower_score()

func score_full_house(score_option_node):
	get_player_dice_values()
	var score = 0
	var has_dice_times = {1:0,2:0,3:0,4:0,5:0,6:0}
	player_dice_values.sort_custom(func(a, b): return a > b)
	for value in player_dice_values:
		has_dice_times[value] += 1
	var has_three_of_a_kind = player_dice_values.filter(func(value): return has_dice_times[value] >= 3)
	if has_three_of_a_kind.size() > 0:
		var has_different_two_of_a_kind = player_dice_values.filter(func(value):
			return has_dice_times[value] >= 2 && value != has_three_of_a_kind[0])
		if has_different_two_of_a_kind.size() > 0:
			score += 25
			score += has_three_of_a_kind[0] * 3
			player.find_child("PlayerHealthBar").heal_player(has_different_two_of_a_kind[0] * 2)

	score_option_node.find_child("Right").text = str(score)
	score_option_node.disabled = true

	total_lower_score += score
	set_total_lower_score()

func score_straight(score_option_node, str_size):
	get_player_dice_values()
	var score = 0
	player_dice_values.sort()
	var sequential_size = 0
	var highest_in_straight
	var unique_values = []
	for value in player_dice_values:
		if not unique_values.has(value):
			unique_values.push_back(value)

	for index in unique_values.size():
		var value = unique_values[index]
		print("sequential", sequential_size, value)
		if index + 1 < unique_values.size() && value + 1 == unique_values[index + 1]:
			sequential_size += 1
			highest_in_straight = unique_values[index + 1]
		elif sequential_size >= str_size:
			break
		else:
			sequential_size = 0

	if sequential_size >= str_size:
		score += (str_size - 1) * 10
		score += highest_in_straight if str_size == 4 else highest_in_straight * 2

	score_option_node.find_child("Right").text = str(score)
	score_option_node.disabled = true

	total_lower_score += score
	set_total_lower_score()

func set_total_upper_score():
	upper_score_option_row.find_child("Right").text = str(total_upper_score)

func set_total_lower_score():
	lower_score_option_row.find_child("Right").text = str(total_lower_score)
	
