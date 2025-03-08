class_name Enemy
extends Area2D

const MOVEMENT_SPEED: float = 100
@export var health : int = 80
var player: Player

func _physics_process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		var direction_to_player: Vector2 = transform.origin.direction_to(player.position)
		transform.origin += (direction_to_player * MOVEMENT_SPEED * delta)
