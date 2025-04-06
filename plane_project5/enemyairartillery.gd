extends Area2D

@export var explosion_radius: float = 100.0
@export var explosion_delay: float = 0.1
@export var fade_duration: float = 2.5

var exploded = false

func _ready():
	connect("area_entered", _on_area_entered)


	#$Sprite2D.visible = false
	$Sprite2D.modulate = Color(1, 1, 1, 1)  # Ensure full alpha (no transparency)
	$Explode.visible = false  # keeps explosion hidden until it triggers

	# timer for explosion delay
	$Timer.wait_time = explosion_delay
	$Timer.one_shot = true
	$Timer.connect("timeout", _on_Timer_timeout)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "artillerytrigger" and not exploded:
		$Sprite2D.visible = true 
		exploded = true
		print("Explosion triggered by:", area.name)

		# delete the plane 
		var plane: Player = area.get_parent()
		if plane:
			plane.queue_free()
			if BattleSystem.plane_moving:
				BattleSystem.player_plane_end_move()

		# fade out artillery sprite
		var tween = create_tween()
		tween.tween_property($Sprite2D, "modulate:a", 0.0, fade_duration)

		$Timer.start()


func _on_Timer_timeout() -> void:
	explode()

func explode() -> void:

	# explosion effect
	$Explode.visible = true
	$Explode.frame = 0
	$Explode.play("explode")

	# waits for the explosion
	await $Explode.animation_finished
	var plane = get_node("") 
	queue_free()
