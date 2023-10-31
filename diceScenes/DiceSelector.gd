extends PanelContainer

@onready var dice_sprite = $DiceRoll/DiceVisual/Symbol/AnimatedDice
@onready var _selected = false

func roll_dice_if_selected():
	if _selected == false:
		return await dice_sprite.roll_dice()

func on_selected(toggled):
	_selected = toggled
	if toggled:
		dice_sprite.modulate = Color("#bbbbbb")
	else:
		dice_sprite.modulate = Color("#ffffff")

func get_dice_name():
	return dice_sprite.get_dice_name()
