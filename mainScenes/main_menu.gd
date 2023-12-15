extends Node2D

func start_game_pressed():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://mainScenes/Combat.tscn")
