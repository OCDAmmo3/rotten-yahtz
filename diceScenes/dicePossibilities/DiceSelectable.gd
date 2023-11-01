extends Control

var _given_dice_when_chosen

func on_selected(button_pressed):
	if button_pressed:
		get_parent().new_selected(self, _given_dice_when_chosen)

func create_node_values(dice_values):
	$SpriteContainer/Sprite.texture = dice_values.sprite
	$SpriteContainer/Sprite.scale.x = .14
	$SpriteContainer/Sprite.scale.y = .14
	$Label.text = dice_values.name
	$SpriteContainer/Sprite/SelectionCheckBox.tooltip_text = dice_values.tooltip
	_given_dice_when_chosen = dice_values.node

func unselect():
	$SpriteContainer/Sprite.modulate = Color("#ffffff")
	$SpriteContainer/Sprite/SelectionCheckBox.button_pressed = false
