extends GutTest

var dice_scene = preload("res://diceScenes/standard6sided/DiceSelector.tscn")
var dice

func before_each():
	seed(1337)
	dice = dice_scene.instantiate()
	add_child(dice)

func test_dice_rolls():
	var dice_value = await dice.roll_dice()
	
	assert_eq(dice_value, 3)
