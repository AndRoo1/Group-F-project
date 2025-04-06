class_name Player
extends Area2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var grid_size: int = 64  # Size of each grid 
var alive: bool = true
@export var max_health : int = 100
var health : int = max_health
@export var moveable: bool = true

var was_moving: bool = false
var can_move = true
@export var attackDiceMin : int = 1
@export var attackDiceMax : int = 20
@export var defenseDiceMin : int = 6
@export var defenseDiceMax : int = 24
@export var combat_range : float = 1
var selected : bool = false

var target_position: Vector2

func _ready():
	$UI/Healthbar.max_value = max_health
	$UI/Healthbar.value = health
	target_position = position
	BattleSystem.player_turn_start.connect(turn_start)
	BattleSystem.game_started.connect(game_start)
	if BattleSystem.player_turn:
		turn_start()
	else:
		can_move = false
	if !moveable or !BattleSystem.game_currently_started or !BattleSystem.player_turn:
		disable_select_button()
	set_rotation_angle(rotation)

func _process(delta):
	if !moveable:
		return
		
	if position != target_position:
		position = position.move_toward(target_position, speed * delta)
		if !was_moving:
			BattleSystem.player_plane_start_move()
			selected = false
			disable_select_button()
		was_moving = true
		return
	else:
		if was_moving:
			stopped()
			
	
	if !can_move or !selected:
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
		set_rotation_angle(direction.angle() + PI / 2)
		target_position += direction * grid_size

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
	if area.is_in_group("enemy") and alive and position.distance_to(area.position) <= grid_size * max(combat_range, area.combat_range):
		print("ENEMY")
		BattleSystem.start_battle(self, area as Enemy)

func stopped() -> void:
	print("STOPPED")
	can_move = false
	check_overlaps()
	was_moving = false
	BattleSystem.player_plane_end_move()

func check_overlaps():
	var overlapping_areas: Array[Area2D] = get_overlapping_areas()
	for area in overlapping_areas:
		area_entered(area)

func turn_start() -> void:
	can_move = true
	selected = false
	if alive:
		BattleSystem.register_player_plane(self)
	if moveable:
		enable_select_button()

func game_start() -> void:
	if moveable and BattleSystem.player_turn:
		enable_select_button()

func _on_area_entered(area: Area2D) -> void:
	#print("aaa")
	#area_entered(area)
	pass

func die():
	queue_free()

func enable_select_button() -> void:
	$SelectButton.disabled = false
	$SelectButton.focus_mode = 1
	$SelectButton.show()

func disable_select_button() -> void:
	$SelectButton.disabled = true
	$SelectButton.release_focus()
	$SelectButton.focus_mode = 0
	$SelectButton.hide()

func _on_select_button_pressed() -> void:
	selected = true
	print("selected", self)


func _on_select_button_focus_exited() -> void:
	selected = false
