extends Node

signal encounter_resolved(player_won: bool)

var _resolved: bool = false

func _process(_delta: float) -> void:
	if _resolved:
		return

	var unit_manager = get_tree().get_first_node_in_group("unit_manager")
	if unit_manager == null:
		return

	var players: Array[Unit] = unit_manager.get_units_in_faction(Unit.faction.PLAYER)
	var enemies: Array[Unit] = unit_manager.get_units_in_faction(Unit.faction.ENEMY)

	if enemies.is_empty():
		_resolved = true
		emit_signal("encounter_resolved", true)
	elif players.is_empty():
		_resolved = true
		emit_signal("encounter_resolved", false)
