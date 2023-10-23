extends Button

func _ready():
	connect("pressed", Callable(get_parent().get_parent().get_child(0), "submit_chosen_dice").bind())
