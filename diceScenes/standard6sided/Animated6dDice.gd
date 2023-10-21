extends AnimatedSprite2D

@onready var timer = $Timer
@export var timer_lower_bound = 1.5
@export var timer_upper_bound = 2.5

signal roll_finished

func play_roll_animation():
	play("Dice rolling")
	timer.wait_time = randf_range(timer_lower_bound, timer_upper_bound)
	timer.connect("timeout", Callable(self, "_stop_roll_animation"))
	timer.start()

func _stop_roll_animation():
	stop()
	timer.stop()
	frame = randi_range(0, 5)
	emit_signal("roll_finished")

func get_rolled_value():
	return frame + 1
