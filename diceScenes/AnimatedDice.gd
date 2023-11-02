extends AnimatedSprite2D

@onready var timer = $Timer
@export var timer_lower_bound = 1.5
@export var timer_upper_bound = 2.5
var _dice_name
var _final_frame_func
var _roll_value_func
var _bonus_function
var _previous_frame = null

signal roll_finished

func _ready():
	timer.connect("timeout", Callable(self, "_stop_roll_animation"))

func set_values(values):
	_dice_name = values.dice_name
	_final_frame_func = values.final_frame_func
	_roll_value_func = values.roll_value_func
	_bonus_function = values.bonus_function
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
	frame = _final_frame_func.call(_previous_frame)
	_previous_frame = frame
	emit_signal("roll_finished")

func reset_previous_frame():
	_previous_frame = null

func get_rolled_value():
	return _roll_value_func.call(frame)

func get_bonus_function():
	return _bonus_function

func get_dice_name():
	return _dice_name
