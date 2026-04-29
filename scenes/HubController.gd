extends Node2D


func _on_button_pressed():
	RunGenerator.start_new_contract()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	
