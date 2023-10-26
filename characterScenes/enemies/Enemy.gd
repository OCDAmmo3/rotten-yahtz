extends Node2D

var dice_scene = preload("res://diceScenes/standard6sided/6dDiceRoller.tscn")
var dice_pool_scene = preload("res://diceScenes/DicePoolContainer.tscn")

@onready var dice_pool = dice_pool_scene.instantiate()
@onready var enemy_sprite = $EnemySprite
@onready var health_points = 100
@onready var enemy_health_bar = get_node("/root/BattleRollScene/Observable/Enemy/EnemyHealthBar/")
@onready var MAX_HEALTH = enemy_health_bar.get_max_health()

func _ready():
	enemy_sprite.play("Groove")
	enemy_health_bar.heal_enemy(MAX_HEALTH)
	_load_dice()
	_load_dice_pool()

func _load_dice():
	var amount_of_dice = 3
	for n in amount_of_dice:
		var new_dice = dice_scene.instantiate()
		add_dice(new_dice)

func _load_dice_pool():
	add_child(dice_pool)

func add_dice(new_dice):
	dice_pool.get_child(0).add_child(new_dice)

func _remove_dice(selected_dice):
	dice_pool.remove_child(selected_dice)
