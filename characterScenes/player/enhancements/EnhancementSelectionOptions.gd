extends HBoxContainer

@onready var player_node = get_node("/root/BattleRollScene/Observable/Player/")
@onready var _amount_of_enhancement_options = 2
@onready var enhancement_options = EnhancementSelectables.enhancement_options
var selected

var enhancement_selectable = preload("res://mainScenes/subScenes/Selectable.tscn")

func create_enhancement_selectables():
	selected = null
	var unique_enhancement_options = []
	while unique_enhancement_options.size() < _amount_of_enhancement_options:
		var enhancement_option = enhancement_options[randi_range(0, enhancement_options.size() - 1)]
		if unique_enhancement_options.find(enhancement_option) < 0:
			unique_enhancement_options.push_back(enhancement_option)

	for enhancement_option in unique_enhancement_options:
		var enhancement_option_node = enhancement_selectable.instantiate()
		enhancement_option_node.create_node_values(enhancement_option)
		add_child(enhancement_option_node)

func new_selected(node_to_select, chosen_enhancement_node):
	var selectable_options = get_children()
	selected = chosen_enhancement_node
	for option in selectable_options:
		if node_to_select == null || option != node_to_select:
			option.unselect()
		else:
			option.find_child("Sprite").modulate = Color("#bbbbbb")

func submit_chosen_enhancement():
	if selected != null:
		player_node.add_enhancement(selected)
		get_parent().get_parent().on_selection_made()

func set_better_odds():
	_amount_of_enhancement_options = 3
