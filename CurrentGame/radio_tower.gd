extends Area2D

# Define the boundaries of your rectangle
#var rect_x = 100
#var rect_y = 100
#var rect_width = 200
#var rect_height = 150

#func _process(delta):
	# Get the current mouse position
	#var mouse_pos = get_viewport().get_mouse_position()
	
	# Check if the mouse is within the rectangle
	#if mouse_pos.x >= rect_x and mouse_pos.x <= rect_x + rect_width and mouse_pos.y >= rect_y and mouse_pos.y <= rect_y + rect_height:
		#print("Mouse is inside the rectangle!")
	#else:
		#print("Mouse is outside the rectangle.")

var hp_radar = 75

var fight_mode: bool = false

func _on_area_entered(area: Area2D):
	if area.name == "plane":
		fight_mode = true
		print("fightmode on")

func _on_area_exited(area: Area2D) -> void:
	fight_mode = false

func _process(delta: float) -> void:
	if fight_mode == true and Input.is_action_just_pressed("spacebar"):
		hp_radar = hp_radar - 25
		print("hp is:", hp_radar)
		
