extends ProgressBar

func heal_player(amount_to_heal):
	var current_health = get_current_health()
	self.value = current_health + amount_to_heal

func lose_health(amount_to_lose):
	var current_health = get_current_health()
	self.value = current_health - amount_to_lose

func get_current_health():
	return self.value

func get_max_health():
	return self.max_value
