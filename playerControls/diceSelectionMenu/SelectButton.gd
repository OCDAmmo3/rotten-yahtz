extends Button

func _ready():
	connect("pressed", Callable(get_node("/root/BattleRollScene/Control/DiceSelectionWindow/DiceSelectionOptions/"), "submit_chosen_dice").bind())
