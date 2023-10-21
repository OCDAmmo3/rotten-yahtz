extends Control

var _given_dice_when_chosen

func on_selected(button_pressed: bool):
	if button_pressed:
		get_parent().new_selected(self, _given_dice_when_chosen)

func create_node_values(dice_values):
	$Control/Sprite.texture = dice_values.sprite
	$Control/Sprite.scale.x = .14
	$Control/Sprite.scale.y = .14
	$Label.text = dice_values.name
	_given_dice_when_chosen = dice_values.node

func unselect():
	$Control/Sprite/SelectionCheckBox.button_pressed = false
