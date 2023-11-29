extends Button

func _ready():
	connect("pressed", Callable(get_parent(), "submit_chosen").bind())
