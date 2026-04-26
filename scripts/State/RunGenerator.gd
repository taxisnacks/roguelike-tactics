#  Every contract start, generate a run object 
extends Node

var run_id
var contract_type # get from ContractResource
var total_floors # equal contract_type.total_floors
var floors = []

func _on_button_pressed():
	# in a demo state, in future should select 2-4 floors randomly and store them in some "current_run" object
	get_tree().change_scene_to_file("res://scenes/Room_Demo_001.tscn")
	
	# load a combat encounter scene that instantiates the room
	
	pass
