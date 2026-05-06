extends Node

@onready var scene_container: Node = get_parent().get_node("SceneContainer")
@onready var combat_rules: Node = get_parent().get_node("CombatRules")

func _ready() -> void:
	if not RunGenerator.has_active_run():
		push_warning("No active run found. Returning to hub.")
		get_tree().change_scene_to_file("res://scenes/Hub.tscn")
		return

	if combat_rules.has_signal("encounter_resolved"):
		combat_rules.encounter_resolved.connect(_on_encounter_resolved)
	
	_load_current_floor()

func _load_current_floor() -> void:
	for child in scene_container.get_children():
		child.queue_free()

	var room_scene_path = RunGenerator.get_current_floor_scene()
	if room_scene_path.is_empty():
		push_error("Failed to load room. Returning to hub.")
		get_tree().change_scene_to_file("res://scenes/Hub.tscn")
		return

	var room_scene := load(room_scene_path) as PackedScene
	if room_scene == null:
		push_error("Invalid room scene path: %s" % room_scene_path)
		get_tree().change_scene_to_file("res://scenes/Hub.tscn")
		return

	scene_container.add_child(room_scene.instantiate())

func _on_encounter_resolved(player_won: bool) -> void:
	if player_won:
		var run_complete := RunGenerator.record_encounter_win()
		if run_complete:
			get_tree().change_scene_to_file("res://scenes/Hub.tscn")
		else:
			_load_current_floor()
	else:
		RunGenerator.record_encounter_loss()
		get_tree().change_scene_to_file("res://scenes/Hub.tscn")
