extends ProgressBar

func _ready():
	_set_health(get_max_health())

func heal_enemy(amount_to_heal):
	var current_health = get_current_health()
	_set_health(current_health + amount_to_heal)

func lose_health(amount_to_lose):
	var current_health = get_current_health()
	_set_health(current_health - amount_to_lose)

func get_current_health():
	return int($Label.text)

func get_max_health():
	return self.max_value

func _set_health(number):
	self.value = number
	$Label.text = str(self.value)
