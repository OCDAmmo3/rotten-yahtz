extends HBoxContainer

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

@onready var dice_pool = get_node("/root/BattleRollScene/Observable/Player/DicePoolContainer/DicePool")
var dice_selectable = preload("res://diceScenes/diceSelectionScenes/DiceRemovalSelectable.tscn")

func _ready():
	_create_removable_dice_selectables()

func _create_removable_dice_selectables():
	var dice_pool_options = []
	for dice in dice_pool.get_children():
		var dice_option = dice_options.filter(
			func (dice_details):
				return dice_details.name == dice.get_dice_name()
		).front()
		if dice_option != null:
			dice_pool_options.push_back(dice_option)

	for dice_option in dice_pool_options:
		var dice_option_node = dice_selectable.instantiate()
		dice_option_node.create_node_values(dice_option)
		add_child(dice_option_node)

func remove_selected(dice_name, node):
	var dice_node = dice_pool.get_children().filter(
		func (child_dice):
			var child_dice_name = child_dice.get_dice_name()
			return child_dice_name == dice_name
	).front()
	dice_pool.remove_child(dice_node)
	remove_child(node)
	get_parent().close_dice_removal_window()
