class_name Player
extends Area2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var grid_size: int = 64  # Size of each grid 
var alive: bool = true
@export var health : int = 100
@export var moveable: bool = true
var was_moving: bool = false
var can_move = true
@export var attackDiceMin : int = 1
@export var attackDiceMax : int = 20
@export var defenseDiceMin : int = 6
@export var defenseDiceMax : int = 24
@export var combat_range : float = 1

var target_position: Vector2

func _ready():
	target_position = position
	BattleSystem.player_turn_start.connect(turn_start)
	turn_start()

func _process(delta):
	if !moveable:
		return
		
	if position != target_position:
		position = position.move_toward(target_position, speed * delta)
		if !was_moving:
			BattleSystem.player_plane_start_move()
		was_moving = true
		return
	else:
		if was_moving:
			print("STOPPED")
			can_move = false
			check_overlaps()
			was_moving = false
			BattleSystem.player_plane_end_move()
			
	
	if !can_move:
		return
	
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_just_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_just_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_just_pressed("ui_up"):
		direction.y -= 1
	
	
	if direction != Vector2.ZERO:
		rotation = direction.angle() + PI/2
		target_position += direction * grid_size

func area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and alive and position.distance_to(area.position) <= grid_size * max(combat_range, area.combat_range):
		print("ENEMY")
		BattleSystem.start_battle(self, area as Enemy)

func check_overlaps():
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		area_entered(area)

func turn_start() -> void:
	can_move = true
	if alive:
		BattleSystem.register_player_plane(self)

func _on_area_entered(area: Area2D) -> void:
	#print("aaa")
	#area_entered(area)
	pass

func die():
	queue_free()
