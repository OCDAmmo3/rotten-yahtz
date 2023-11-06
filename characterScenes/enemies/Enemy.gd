extends Node2D

var dice_scene = preload("res://diceScenes/DiceSelector.tscn")
var dice_pool_scene = preload("res://diceScenes/DicePoolContainer.tscn")

@onready var dice_pool = dice_pool_scene.instantiate()
@onready var enemy_sprite = $EnemySprite
@onready var health_points = 1000
@onready var enemy_health_bar = get_node("/root/BattleRollScene/Observable/Enemy/EnemyHealthBar/")
@onready var MAX_HEALTH = enemy_health_bar.get_max_health()
@onready var _default_roll_count = 3
@onready var _roll_count = _default_roll_count
@onready var _has_rolled = false
var _submit_score_pressed = false

func _ready():
	enemy_sprite.play("Groove")
	_load_dice()
	_load_dice_pool()

func _load_dice():
	var amount_of_dice = 3
	for n in amount_of_dice:
		var new_dice = dice_scene.instantiate()
		new_dice.find_child("CheckButton").disabled = true
		new_dice.find_child("AnimatedDice").set_values(DiceOptions.dice_options.D6)
		add_dice(new_dice)

func _load_dice_pool():
	add_child(dice_pool)

func add_dice(new_dice):
	dice_pool.get_child(0).add_child(new_dice)

func _remove_dice(selected_dice):
	dice_pool.remove_child(selected_dice)

func get_roll_count():
	return _roll_count

func roll_used():
	_roll_count = _roll_count - 1
	_has_rolled = true

func set_submit_score_pressed(submission):
	_submit_score_pressed = submission

func get_submit_score_pressed():
	return _submit_score_pressed

func rolls_reset():
	_roll_count = _default_roll_count
	_has_rolled = false
	set_submit_score_pressed(false)
	for dice in dice_pool.get_child(0).get_children():
		dice.find_child("CheckButton").unselect()
		dice.find_child("AnimatedDice").reset_previous_frame()
