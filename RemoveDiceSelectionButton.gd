extends Button

func _ready():
	connect("pressed", Callable(get_parent().get_parent().get_parent(), "on_pressed").bind())
