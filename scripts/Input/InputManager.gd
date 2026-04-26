extends Node

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_ESCAPE:
			var unit_manager = get_tree().get_first_node_in_group("unit_manager")
			if unit_manager:
				unit_manager.deselect_active_unit()
