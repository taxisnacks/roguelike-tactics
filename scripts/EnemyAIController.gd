extends Node

func choose_nearest_target(enemy: Unit, unit_manager):
	var player_units = unit_manager.get_units_in_faction(Unit.faction.PLAYER)
	if player_units.is_empty():
		print(enemy.name, " found no players to target.")
		return null
	var nearest_target: Unit = player_units[0]
	var current_nearest = enemy.tile_pos.distance_to(nearest_target.tile_pos)
	for unit in player_units:
		var current_distance = unit.tile_pos.distance_to(enemy.tile_pos)
		if current_distance < current_nearest:
			current_nearest = current_distance
			nearest_target = unit
	print(enemy.name, " targets ", nearest_target)
	return nearest_target 

func can_attack(enemy: Unit, target: Unit):
	return enemy.can_attack_target(target)

func take_enemy_action(enemy: Unit, unit_manager) -> void:
	if enemy == null or not enemy.is_alive:
		print("no enemies left to take a turn.")
		return
	if enemy.action_points <= 0:
		print("no action points left for enemies, continue.")
		return

	var target: Unit = choose_nearest_target(enemy, unit_manager)
	if target == null or not target.is_alive:
		print(enemy.name, " found no alive targets.")
		return

	# Attack immediately if already in range
	if can_attack(enemy, target):
		print(enemy.name, " can attack, attempting.")
		enemy.execute_attack(target)
		return

	# Otherwise move toward a tile that can attack, if possible
	var map = get_tree().get_first_node_in_group("map")
	if map == null:
		print(enemy.name, " tried to move, but failed to get node in map group")
		return

	var reachable: Array[Vector2i] = map.get_reachable_tiles(enemy.tile_pos, enemy.unit_data.move_range, enemy)
	var chase_tile := enemy.tile_pos
	var best_chase_dist := enemy.tile_pos.distance_to(target.tile_pos)

	for tile in reachable:
		if tile == enemy.tile_pos:
			continue
		var d := tile.distance_to(target.tile_pos)
		if d < best_chase_dist:
			best_chase_dist = d
			chase_tile = tile

	var chosen_tile := chase_tile

	if chase_tile != enemy.tile_pos:
		var chase_path: Array[Vector2i] = map.find_path(enemy.tile_pos, chase_tile, enemy)
		for i in range(1, chase_path.size()):
			var step := chase_path[i]
			if step.distance_to(target.tile_pos) <= enemy.get_attack_range() \
			and map.has_line_of_sight(step, target.tile_pos):
				chosen_tile = step
				break

	if chosen_tile != enemy.tile_pos:
		var move_path: Array[Vector2i] = map.find_path(enemy.tile_pos, chosen_tile, enemy)
		if not move_path.is_empty():
			print(enemy.name, " is moving.")
			await enemy.move_along_path(move_path)
			enemy.spend_movement(1) # or AP model of your choice
		else:
			print(enemy.name, " tried to move, but path comes up empty.")

	# 3) Re-check attack after movement
	if enemy.action_points > 0 and can_attack(enemy, target):
		print(enemy.name, " can attack after move, attempting.")
		enemy.execute_attack(target)
