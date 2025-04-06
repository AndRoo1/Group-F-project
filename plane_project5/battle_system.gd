extends Node

signal battle_started(player_combatant: Player, enemy_combatant: Enemy)
signal battle_ended(player_won: bool, battle_end: bool)
signal player_turn_start
signal player_turn_end
signal enemy_turn_start
signal enemy_turn_end
signal game_started
signal motherbase_placed
signal enemy_plane_killed(enemy: Enemy)

var game_currently_started: bool = false

var player_turn: bool = true

var movable_player_planes_available: int = 0
var player_planes_available: int = 0
var player_planes_moved: int = 0
var player_planes: Array[Player] = []

var movable_enemy_planes_available: int = 0
var enemy_planes_available: int = 0
var enemy_planes_moved: int = 0
var enemy_planes: Array[Enemy] = []
var enemy_plane_acting_index = 0
var enemy_target_positions: Array[Vector2] = []
var enemy_targets: Array[Node2D] = []

var plane_moving: bool = false
var in_battle: bool = false

var next_enemy_act_queued: bool = false

func start_player_turn():
	print("Start Player Turn Called")
	if !player_turn:
		print("Started Player Turn")
		player_planes_available = 0
		movable_player_planes_available = 0
		player_planes = []
		player_planes_moved = 0
		player_turn = true
		player_turn_start.emit()
		enemy_turn_end.emit()
	
func start_enemy_turn():
	print("Start Enemy Turn Called")
	if player_turn:
		print("Started Enemy Turn")
		enemy_planes = []
		enemy_planes_available = 0
		movable_enemy_planes_available = 0
		enemy_plane_acting_index = 0
		enemy_planes_moved = 0
		enemy_targets = []
		enemy_target_positions = []
		player_turn = false
		player_turn_end.emit()
		enemy_turn_start.emit()

func register_player_plane(player_plane: Player):
	player_planes_available += 1
	if player_plane.moveable:
		movable_player_planes_available += 1
	player_planes.append(player_plane)

func register_enemy_plane(enemy_plane: Enemy):
	enemy_planes_available += 1
	if enemy_plane.moveable:
		movable_enemy_planes_available += 1
	enemy_planes.append(enemy_plane)
	if enemy_planes_available == len(get_tree().get_nodes_in_group("enemy")):
		enemy_planes.shuffle()
		pick_enemy_plane_to_act()

func plane_start_move():
	plane_moving = true

func plane_end_move():
	plane_moving = false

func player_plane_start_move():
	player_planes_moved += 1
	plane_start_move()

func player_plane_end_move():
	plane_end_move()
	if !in_battle:
		check_for_player_end_of_turn()

func enemy_plane_start_move():
	enemy_planes_moved += 1
	plane_start_move()

func enemy_plane_end_move():
	plane_end_move()
	if !in_battle:
		check_for_enemy_end_of_turn()

func check_for_player_end_of_turn():
	if player_planes_moved >= movable_player_planes_available:
		start_enemy_turn()

func check_for_enemy_end_of_turn():
	if enemy_planes_moved >= movable_enemy_planes_available:
		start_player_turn()

func start_battle(player_combatant: Player, enemy_combatant: Enemy):
	battle_started.emit(player_combatant, enemy_combatant)
	in_battle = true
	
func end_battle(player_won: bool, battle_end: bool):
	in_battle = false
	plane_moving = false
	battle_ended.emit(player_won, battle_end)
	print("BATTLE ENDED")
	if player_turn:
		check_for_player_end_of_turn()
	else:
		check_for_enemy_end_of_turn()
		if next_enemy_act_queued:
			next_enemy_act_queued = false
			if enemy_plane_acting_index < len(enemy_planes):
				pick_enemy_plane_to_act()
			else:
				start_player_turn()

func pick_enemy_plane_to_act():
	enemy_planes[enemy_plane_acting_index].start_acting()

func enemy_plane_finished_acting(enemy_plane: Enemy):
	enemy_plane_acting_index += 1
	if !in_battle:
		if enemy_plane_acting_index < len(enemy_planes):
			pick_enemy_plane_to_act()
		else:
			start_player_turn()
	else:
		next_enemy_act_queued = true

func get_enemy_target_position(enemy: Enemy) -> Vector2:
	var min_distance: float = 10000000
	var min_distance_node: Node2D = null
	var target_position = enemy.position
	for player in get_tree().get_nodes_in_group("player"):
		var distance_to_player = enemy.position.distance_to(player.position)
		if min_distance_node == null or (!enemy_targets.has(min_distance_node) and distance_to_player <= min_distance and player.alive) or len(enemy_targets) >= player_planes_available:
			min_distance = distance_to_player
			min_distance_node = player
	if min_distance_node != null:
		var difference_vector = min_distance_node.position - enemy.position
		var direction_to: Vector2 = sign(difference_vector)
		
		if direction_to.x != 0 and direction_to.y != 0:
			var axis: int = randi() % 2
			target_position[axis] += direction_to[axis] * enemy.grid_size
			if enemy_target_positions.has(target_position):
				axis = 1 - axis
				target_position = enemy.position 
				target_position[axis] += direction_to[axis] * enemy.grid_size
		elif direction_to.x != 0:
			target_position.x += direction_to.x * enemy.grid_size
		elif direction_to.y != 0:
			target_position.y += direction_to.y * enemy.grid_size
		else:
			min_distance_node = null
		
	if min_distance_node == null or enemy_target_positions.has(target_position):
		var new_test_vector = enemy.position + Vector2(-enemy.grid_size, 0)
		if !enemy_target_positions.has(new_test_vector):
			enemy_target_positions.append(new_test_vector)
			return new_test_vector
		
		var y_direction = randi() % 2
		new_test_vector = enemy.position + Vector2(0, (y_direction * 2 - 1) * enemy.grid_size)
		if !enemy_target_positions.has(new_test_vector):
			enemy_target_positions.append(new_test_vector)
			return new_test_vector
		
		new_test_vector = enemy.position + Vector2(0, -(y_direction * 2 - 1) * enemy.grid_size)
		if !enemy_target_positions.has(new_test_vector):
			enemy_target_positions.append(new_test_vector)
			return new_test_vector
		
		new_test_vector = enemy.position + Vector2(enemy.grid_size, 0)
		if !enemy_target_positions.has(new_test_vector):
			enemy_target_positions.append(new_test_vector)
			return new_test_vector
		
		enemy_target_positions.append(enemy.position)
		return enemy.position
	else:
		enemy_targets.append(min_distance_node)
		enemy_target_positions.append(target_position)
		return target_position

func place_motherbase():
	motherbase_placed.emit()

func kill_enemy_plane(enemy: Enemy):
	enemy_plane_killed.emit(enemy)

func start_game():
	game_currently_started = true
	game_started.emit()

func lose():
	get_tree().change_scene_to_file("res://lose.tscn")
	#print("YOU LOSE")

func win():
	get_tree().change_scene_to_file("res://win.tscn")
	#print("YOU WIN")
