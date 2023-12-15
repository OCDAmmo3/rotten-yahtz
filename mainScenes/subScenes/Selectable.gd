extends Control

var _given_when_chosen

func on_selected(button_pressed):
	if button_pressed:
		get_parent().new_selected(self, _given_when_chosen)

func create_node_values(values, is_dice = false):
	$SpriteContainer/Sprite.texture = values.sprite
	$SpriteContainer/Sprite.scale.x = .14
	$SpriteContainer/Sprite.scale.y = .14
	$Label.text = values.name
	$SpriteContainer/Sprite/SelectionCheckBox.tooltip_text = values.tooltip
	if is_dice:
		_given_when_chosen = values.node
	else:
		_given_when_chosen = values

func unselect():
	$SpriteContainer/Sprite.modulate = Color("#ffffff")
	$SpriteContainer/Sprite/SelectionCheckBox.button_pressed = false
