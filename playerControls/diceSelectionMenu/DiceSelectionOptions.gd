extends HBoxContainer

@onready var player_node = get_node("/root/BattleRollScene/Observable/Player/")
@onready var dice_selector_node = preload("res://mainScenes/subScenes/Selector.tscn")
@onready var _amount_of_dice_options = 3
@onready var dice_options = DiceSelectables.dice_options
var selected

var dice_selectable = preload("res://mainScenes/subScenes/Selectable.tscn")

func create_dice_selectables():
	selected = null
	var unique_dice_options = []
	while unique_dice_options.size() < _amount_of_dice_options:
		var dice_option = dice_options[randi_range(0, dice_options.size() - 1)]
		if unique_dice_options.find(dice_option) < 0:
			unique_dice_options.push_back(dice_option)

	for dice_option in unique_dice_options:
		var dice_option_node = dice_selectable.instantiate()
		dice_option_node.create_node_values(dice_option, true)
		add_child(dice_option_node)

func new_selected(node_to_select, chosen_dice_node):
	var selectable_options = get_children()
	selected = chosen_dice_node
	for option in selectable_options:
		if node_to_select == null || option != node_to_select:
			option.unselect()
		else:
			option.find_child("Sprite").modulate = Color("#bbbbbb")

func submit_chosen_dice():
	if selected != null:
		var new_dice = dice_selector_node.instantiate()
		new_dice.find_child("AnimatedDice").set_values(selected)
		player_node.add_dice(new_dice)
		get_parent().get_parent().on_selection_made()

func set_better_odds():
	_amount_of_dice_options = 4
