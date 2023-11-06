extends Button

func _ready():
	connect("pressed", Callable(get_node("/root/BattleRollScene/EnemyScorecard/"), "change_visible").bind())
