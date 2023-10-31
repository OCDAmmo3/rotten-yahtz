extends Button

func _ready():
	connect("pressed", Callable(get_node("/root/BattleRollScene/Scorecard/"), "change_visible").bind())
