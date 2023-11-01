extends AnimatedSprite2D

@onready var timer = $Timer
@export var timer_lower_bound = 1.5
@export var timer_upper_bound = 2.5
var _dice_name
var _final_frame_options
var _final_frame_func
var _roll_value_func

signal roll_finished

func _ready():
	timer.connect("timeout", Callable(self, "_stop_roll_animation"))

func set_values(values):
	_dice_name = values.dice_name
	_final_frame_options = values.final_frame_options
	_final_frame_func = values.final_frame_func
	_roll_value_func = values.roll_value_func
	sprite_frames = values.sprite_frames

func roll_dice():
	play_roll_animation()
	await roll_finished
	return get_rolled_value()

func play_roll_animation():
	play("Dice rolling")
	timer.wait_time = randf_range(timer_lower_bound, timer_upper_bound)
	timer.start()

func _stop_roll_animation():
	stop()
	timer.stop()
	var final_number = randi_range(_final_frame_options.low, _final_frame_options.high)
	frame = _final_frame_func.call(final_number)
	emit_signal("roll_finished")

func get_rolled_value():
	return _roll_value_func.call(frame)

func get_dice_name():
	return _dice_name
