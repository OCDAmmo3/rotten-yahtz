extends Node2D

var dice_scene = preload("res://mainScenes/subScenes/Selector.tscn")
var dice_pool_scene = preload("res://diceScenes/DicePoolContainer.tscn")

@onready var dice_pool = dice_pool_scene.instantiate()
@onready var enemy_sprite = $EnemySprite
@onready var health_points = 1000
@onready var enemy_health_bar = get_node("/root/BattleRollScene/Observable/Enemy/EnemyHealthBar/")
@onready var MAX_HEALTH = enemy_health_bar.get_max_health()
@onready var _default_roll_count = 3
@onready var _roll_count = _default_roll_count
@onready var _has_rolled = false
@onready var _damage_value = 0
@onready var _enemy_alive = true

func _ready():
	enemy_sprite.play("Groove")
	_load_dice()
	_load_dice_pool()

func _load_dice():
	var amount_of_dice = 4
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

func rolls_reset():
	_roll_count = _default_roll_count
	_has_rolled = false
	for dice in dice_pool.get_child(0).get_children():
		dice.find_child("CheckButton").unselect()
		dice.find_child("AnimatedDice").reset_previous_frame()

func continue_rolling():
	if get_roll_count() != _default_roll_count:
		get_parent().get_parent().on_roll_pressed()

func player_has_submitted():
	if get_roll_count() > 0:
		continue_rolling()

func set_damage(damage_value):
	_damage_value = damage_value

func deal_damage():
	enemy_sprite.play("Deal damage")
	await enemy_sprite.animation_finished
	await get_parent().find_child("PlayerHealthBar").take_damage(_damage_value)
	enemy_sprite.play("Groove")

func get_enemy_alive():
	return _enemy_alive

func set_enemy_alive(alive_bool):
	_enemy_alive = alive_bool
	self.visible = false
	if not _enemy_alive:
		get_parent().get_parent().end_level()
