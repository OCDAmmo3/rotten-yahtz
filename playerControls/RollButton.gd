extends Button

func _ready():
	connect("pressed", Callable(get_node("/root/BattleRollScene"), "on_roll_pressed").bind())
