class_name Enemy
extends Area2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var grid_size: int = 64  # Size of each grid 
var alive: bool = true
@export var max_health : int = 80
var health : int = max_health
@export var moveable: bool = true
var was_moving: bool = false
var can_move = false
@export var attackDiceMin : int = 1
@export var attackDiceMax : int = 15
@export var defenseDiceMin : int = 1
@export var defenseDiceMax : int = 18
@export var combat_range : float = 1
@export_range(0, 1) var attack_chance : float = 1

@export var point_reward : int = 50

var target_position: Vector2

func _ready() -> void:
	BattleSystem.enemy_turn_start.connect(turn_start)
	$UI/Healthbar.max_value = max_health
	$UI/Healthbar.value = health
	set_rotation_angle(rotation)
	# turn_start()

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	if position != target_position:
		position = position.move_toward(target_position, speed * delta)
		if !was_moving:
			BattleSystem.enemy_plane_start_move()
		was_moving = true
		return
	else:
		if was_moving:
			stopped()
			
	
	if !can_move:
		return

func set_health(new_health : int) -> void:
	health = new_health
	$UI/Healthbar.value = health

func set_rotation_angle(angle : float) -> void:
	rotation = angle
	$UI.rotation = -angle
	#$Rotator.rotation = angle
	#$Sprite2D.rotation = angle
	#$CollisionShape2D.rotation = angle

func area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and alive and position.distance_to(area.position) <= max(combat_range, area.combat_range) * grid_size:
		print("PLAYER DETECTED")
		BattleSystem.start_battle(area as Player, self)

func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func stopped() -> void:
	print("ENEMY STOPPED")
	can_move = false
	check_overlaps()
	was_moving = false
	BattleSystem.enemy_plane_end_move()
	BattleSystem.enemy_plane_finished_acting(self)

func check_overlaps():
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		area_entered(area)

func turn_start() -> void:
	if alive:
		BattleSystem.register_enemy_plane(self)

func start_acting() -> void:
	if alive:
		await get_tree().create_timer(0.2).timeout
		if moveable:
			target_position = BattleSystem.get_enemy_target_position(self)
			if target_position == position:
				BattleSystem.enemy_plane_start_move()
				stopped()
			else:
				set_rotation_angle((target_position - position).angle() + PI / 2)
				can_move = true
		else:
			check_overlaps()
			BattleSystem.enemy_plane_finished_acting(self)
	else:
		BattleSystem.enemy_plane_finished_acting(self)

func die():
	queue_free()
