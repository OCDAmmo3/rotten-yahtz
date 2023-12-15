extends Button

func _ready():
	connect("pressed", Callable(get_parent().get_parent(), "start_game_pressed").bind())
