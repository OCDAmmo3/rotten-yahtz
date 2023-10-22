extends PanelContainer

@onready var dice_sprite = $DiceRoll/DiceVisual/Symbol/AnimatedDice
@onready var _selected = false

func roll_dice():
	if _selected == false:
		dice_sprite.play_roll_animation()
		await dice_sprite.roll_finished
		return dice_sprite.get_rolled_value()

func on_selected(toggled):
	_selected = toggled

func get_dice_name():
	return dice_sprite.get_dice_name()
