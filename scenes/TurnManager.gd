extends Node

enum phase { PLAYER, ENEMY }

signal turn_started(phase)
signal turn_ended(phase)

var current_phase: int = phase.PLAYER
var player_units: Array = []

#Input function, should probably move
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_SPACE:
			var unit_manager = get_tree().get_first_node_in_group("unit_manager") 
			unit_manager.deselect_active_unit()
			end_player_turn()

func _ready():
	var unit_manager = get_tree().get_first_node_in_group("unit_manager") # grab units from UnitManager
	if unit_manager:
		player_units = unit_manager.get_units_in_faction(Unit.faction.PLAYER) # if not empty, get player units

func start_player_turn():
	var unit_manager = get_tree().get_first_node_in_group("unit_manager") # grab units from UnitManager
	if unit_manager:
		player_units = unit_manager.get_units_in_faction(Unit.faction.PLAYER) # if not empty, get player units
	current_phase = phase.PLAYER
	print(" PLAYER TURN START. ")
	
	for unit in player_units:
		unit.start_turn()
		
	emit_signal("turn_started", current_phase)

func end_player_turn():
	print (" PLAYER TURN END. ")
	
	var unit_manager = get_tree().get_first_node_in_group("unit_manager")
	if unit_manager:
		unit_manager.active_unit = null
	
	emit_signal("turn_ended", current_phase)
	enemy_turn()

func enemy_turn():
	print (" ENEMY TURN START. ")
	current_phase = phase.ENEMY
	var unit_manager = get_tree().get_first_node_in_group("unit_manager")
	var enemy_ai_controller = get_tree().get_first_node_in_group("enemy_ai_controller")
	if unit_manager == null:
		start_player_turn()
		return

	var enemies: Array[Unit] = unit_manager.get_units_in_faction(Unit.faction.ENEMY)
	for enemy in enemies:
		enemy.start_turn()
	for enemy in enemies:
		await enemy_ai_controller.take_enemy_action(enemy, unit_manager)
		await get_tree().create_timer(0.15).timeout
	print (" ENEMY TURN END. ")
	start_player_turn()
