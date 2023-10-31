extends VBoxContainer

var _expected_name

func on_pressed():
	get_parent().remove_selected(_expected_name, self)

func create_node_values(dice_values):
	$Control/Sprite.texture = dice_values.sprite
	$Control/Sprite.scale.x = .14
	$Control/Sprite.scale.y = .14
	$Label.text = dice_values.name
	_expected_name = dice_values.name
