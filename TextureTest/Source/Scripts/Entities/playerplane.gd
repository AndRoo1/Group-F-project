class_name Player
extends Area2D

const MOVEMENT_SPEED: float = 256
var alive: bool = true

func _physics_process(delta: float) -> void:
	var movement_direction: Vector2 = Vector2()
	movement_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	movement_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	transform.origin += (movement_direction.normalized() * MOVEMENT_SPEED * delta)


func _on_area_entered(area: Area2D) -> void:
	print("aaa")
	if area.is_in_group("enemy") and alive:
		print("ENEMY")
		BattleSystem.battle_started.emit(self, area)
