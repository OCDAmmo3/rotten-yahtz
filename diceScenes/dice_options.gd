extends Node2D

@export var dice_options = {
	"D2": {
		"dice_name": "D2",
		"final_frame_options": {
			"low": 0,
			"high": 1
		},
		"final_frame_func": Callable(func(final_number): return 0 if final_number == 0 else 8),
		"roll_value_func": Callable(func(current_frame): return 1 if current_frame == 0 else 2),
		"sprite_frames": load("res://diceScenes/diceAnimations/D2AnimatedDice.tres"),
		"bonus_function": null
	},
	"D4": {
		"dice_name": "D4",
		"final_frame_options": {
			"low": 0,
			"high": 3
		},
		"final_frame_func": Callable(func(final_number): return final_number).bind(),
		"roll_value_func": Callable(func(current_frame): return current_frame + 1).bind(),
		"sprite_frames": load("res://diceScenes/diceAnimations/D4AnimatedDice.tres"),
		"bonus_function": null
	},
	"D6": {
		"dice_name": "D6",
		"final_frame_options": {
			"low": 0,
			"high": 5
		},
		"final_frame_func": Callable(func(final_number): return final_number).bind(),
		"roll_value_func": Callable(func(current_frame): return current_frame + 1).bind(),
		"sprite_frames": load("res://diceScenes/diceAnimations/D6AnimatedDice.tres"),
		"bonus_function": null
	},
	"D5": {
		"dice_name": "D5",
		"final_frame_options": {
			"low": 0,
			"high": 4
		},
		"final_frame_func": Callable(func(final_number): return final_number).bind(),
		"roll_value_func": Callable(func(current_frame): return current_frame + 1).bind(),
		"sprite_frames": load("res://diceScenes/diceAnimations/D5AnimatedDice.tres"),
		"bonus_function": null
	},
	"D21": {
		"dice_name": "D21",
		"final_frame_options": {
			"low": 0,
			"high": 20
		},
		"final_frame_func": Callable(func(final_number): return final_number).bind(),
		"roll_value_func": Callable(func(current_frame):
				if [0,6,11,15,18,20].has(current_frame):
					return 6
				elif [1,7,12,16,19].has(current_frame):
					return 5
				elif [2,8,13,17].has(current_frame):
					return 4
				elif [3,9,14].has(current_frame):
					return 3
				elif [4,10].has(current_frame):
					return 2
				else:
					return 1
				).bind(),
		"sprite_frames": load("res://diceScenes/diceAnimations/D21AnimatedDice.tres"),
		"bonus_function": null
	},
	"LowRoller": {
		"dice_name": "Low Roller",
		"final_frame_options": {
			"low": 0,
			"high": 2
		},
		"final_frame_func": Callable(func(final_number): return final_number).bind(),
		"roll_value_func": Callable(func(current_frame): return current_frame + 1).bind(),
		"sprite_frames": load("res://diceScenes/diceAnimations/LowRollerAnimatedDice.tres"),
		"bonus_function": Callable(func(current_values, value): current_values.push_back(value)).bind()
	}
}
