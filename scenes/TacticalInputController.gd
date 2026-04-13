extends Node


var hover_tile: Vector2i = Vector2i(-1, -1)
var hover_target = null
@onready var unit_manager = get_tree().get_first_node_in_group("unit_manager")
@onready var enemy_ai_controller = get_tree().get_first_node_in_group("enemy_ai_controller")
@onready var turn_manager = get_tree().get_first_node_in_group("turn_manager")
@onready var map = get_tree().get_first_node_in_group("map")

func _process(_delta):
	var unit = unit_manager.active_unit
	if unit_manager == null or unit == null:
		return
	if unit.is_moving:
		return
	
	var tile: Vector2i = map.world_to_tile(map.get_global_mouse_position())
	if tile == hover_tile:
		return

	hover_tile = tile
	hover_target = unit_manager.get_unit_at_tile(tile)
	map.attack_target = null
	map.preview_path.clear()

	# ATTACK PREVIEW
	if hover_target != null \
	and hover_target.unit_faction != unit.unit_faction \
	and unit.can_attack_target(hover_target):
		print("Target found successfully")
		map.attack_target = hover_target
		
	# MOVEMENT PREVIEW
	elif tile in map.reachable_tiles:
		var unit_tile = map.world_to_tile(unit.global_position)
		map.preview_path = map.find_path(unit_tile, tile, unit)
	
	# DEBUG print("Hover: ", hover_target, "Attack target: ", attack_target) 
	map.queue_redraw()

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		
		var unit = unit_manager.active_unit
		if unit == null or unit.action_points <= 0:
			return

		# ATTACK
		if map.attack_target && enemy_ai_controller.can_attack(unit, map.attack_target):
			unit.execute_attack(map.attack_target)
			unit_manager.deselect_active_unit()
			map.clear_action_state()
			return

		# MOVE
		if map.preview_path.is_empty():
			return

		if unit == null:
			return

		if unit.action_points <= 0:
			print("Insufficient AP, cannot move!")
			return

		# await movement
		await unit.move_along_path(map.preview_path)

		# spend movement AFTER animation
		unit.spend_movement(1)
		
		# deselect unit (optional, unsure yet if want(i.e action after move))
		unit.set_selected(false)
		unit_manager.active_unit = null

		# Clear visuals
		map.clear_action_state()
