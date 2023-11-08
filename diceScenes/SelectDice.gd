extends CheckButton

func _ready():
	connect("toggled", Callable(get_parent(), "on_selected").bind())

func unselect():
	emit_signal("toggled", false)
