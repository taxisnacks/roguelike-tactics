#  Every contract start, generate a run object 
extends Node

var run_id: String = ""
var contract_type # get from ContractResource eventually
var floors: Array[String] = [] # get from contract_type.total_floors eventually
var current_floor_index: int = 0
var total_floors: int = 0
var run_active: bool = false


const ROOM_POOL: Array[String] = [
	"res://scenes/Rooms/Demo Rooms/Room_Demo_001.tscn",
	"res://scenes/Rooms/Demo Rooms/Room_Demo_002.tscn",
	"res://scenes/Rooms/Demo Rooms/Room_Demo_003.tscn",
	"res://scenes/Rooms/Demo Rooms/Room_Demo_004.tscn",
]

func start_new_contract() -> void:
	randomize()
	run_id = str(Time.get_unix_time_from_system())
	total_floors = randi_range(2, 4)
	current_floor_index = 0
	floors.clear()
	
	for i in range(total_floors):
		floors.append(_pick_room(i))
	
	run_active = true
	print("Run started: ", run_id, " floors= ", total_floors, " sequence= ", floors)

func _pick_room(_floor_index: int) -> String:
	if ROOM_POOL.is_empty():
		print("ERROR: No rooms in room pool.")
		return ""
	return ROOM_POOL[randi() % ROOM_POOL.size()]
	
func record_encounter_win() -> bool:
	if not run_active:
		return false

	if current_floor_index >= total_floors - 1:
		run_active = false
		return true

	current_floor_index += 1
	return false

func record_encounter_loss() -> void:
	run_active = false

func has_active_run() -> bool:
	return run_active
	
