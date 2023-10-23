extends Button

func _ready():
	connect("pressed", Callable(get_parent(), "on_skip_pressed").bind())
