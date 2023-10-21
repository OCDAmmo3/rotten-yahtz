extends Button

func _ready():
	connect("pressed", Callable(get_node("/root/BattleRollScene/Observable/Player/"), "on_add_dice_pressed").bind())
