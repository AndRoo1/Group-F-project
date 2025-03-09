class_name Player
extends Area2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var grid_size: int = 64  # Size of each grid 
var alive: bool = true
@export var health : int = 100


var target_position: Vector2

func _ready():
	target_position = position

func _process(delta):
	if position != target_position:
		position = position.move_toward(target_position, speed * delta)
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
		target_position += direction * grid_size


func _on_area_entered(area: Area2D) -> void:
	print("aaa")
	if area.is_in_group("enemy") and alive:
		print("ENEMY")
		BattleSystem.battle_started.emit(self, area)
