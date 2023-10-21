extends HBoxContainer

@onready var player_node = get_node("/root/BattleRollScene/Observable/Player/")
@onready var amount_of_dice_options = 3
var selected

var dice_options = [
	{
		"name": "D6",
		"node": preload("res://diceScenes/standard6sided/6dDiceSelector.tscn"),
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d6/dice-6.png")
	},
	{
		"name": "D4",
		"node": preload("res://diceScenes/standard4sided/4dDiceSelector.tscn"),
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d4/4-sided-4.png")
	},
	{
		"name": "D2",
		"node": preload("res://diceScenes/standard2sided/2dDiceSelector.tscn"),
		"sprite": preload("res://diceScenes/assets/diceFaceImages/d2/coin_dice_5.png")
	}
]
var dice_selectable = preload("res://diceScenes/dicePossibilities/DiceSelectable.tscn")

func _ready():
	_create_dice_selectables()

func _create_dice_selectables():
	var unique_dice_options = []
	while unique_dice_options.size() < amount_of_dice_options:
		var dice_option = dice_options[randi_range(0, dice_options.size() - 1)]
		if unique_dice_options.find(dice_option) < 0:
			unique_dice_options.push_back(dice_option)

	for dice_option in unique_dice_options:
		var dice_option_node = dice_selectable.instantiate()
		dice_option_node.create_node_values(dice_option)
		add_child(dice_option_node)

func new_selected(node_to_select, chosen_dice_node):
	var selectable_options = get_children()
	selected = chosen_dice_node
	for option in selectable_options:
		if option != node_to_select:
			option.unselect()

func submit_chosen_dice():
	if selected != null:
		var new_dice = selected.instantiate()
		player_node.add_dice(new_dice)
		get_parent().hide()
