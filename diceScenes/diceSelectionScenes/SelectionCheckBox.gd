extends CheckBox

func _ready():
	connect("toggled", Callable(get_parent().get_parent().get_parent(), "on_selected").bind())
