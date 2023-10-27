extends VBoxContainer

var score_option_row_scene = preload("res://characterScenes/scorecard/score_option_row.tscn")

@onready var player = get_node("/root/BattleRollScene/Observable/Player/")
@onready var player_dice_pool = player.find_child("DicePool", true, false)
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
	var score = player_dice_pool.get_children().reduce((func(accum, dice):
		var dice_value = dice.find_child("AnimatedDice", true, false).get_rolled_value()
		return accum + dice_value if dice_value == num else accum
	), 0)
	score_option_node.find_child("Right").text = str(score)
	score_option_node.disabled = true

	total_upper_score += score
	set_total_upper_score()

func score_some_of_a_kind(score_option_node, num_of_kind):
	var score = 0
	var has_dice_times = {1:0,2:0,3:0,4:0,5:0,6:0}
	var has_three_of_a_kind = player_dice_pool.get_children().map(func(dice):
		return dice.find_child("AnimatedDice", true, false).get_rolled_value()
	).filter(func(value):
		has_dice_times[value] += 1
		
		return has_dice_times[value] >= num_of_kind
	)
	if has_three_of_a_kind.size() > 0:
		score = player_dice_pool.get_children().reduce((func(accum, dice):
			var dice_value = dice.find_child("AnimatedDice", true, false).get_rolled_value()
			return accum + dice_value * (num_of_kind - 1) if has_three_of_a_kind.has(dice_value) else accum + dice_value
		), 0)

	score_option_node.find_child("Right").text = str(score)
	score_option_node.disabled = true
	
	total_lower_score += score
	set_total_lower_score()

func set_total_upper_score():
	upper_score_option_row.find_child("Right").text = str(total_upper_score)

func set_total_lower_score():
	lower_score_option_row.find_child("Right").text = str(total_lower_score)
	
