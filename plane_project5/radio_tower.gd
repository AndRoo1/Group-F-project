extends Area2D

#var rect_x = 100
#var rect_y = 100
#var rect_width = 200
#var rect_height = 150

#func _process(delta):
	#var mouse_pos = get_viewport().get_mouse_position()
	
	#if mouse_pos.x >= rect_x and mouse_pos.x <= rect_x + rect_width and mouse_pos.y >= rect_y and mouse_pos.y <= rect_y + rect_height:
		#print("Mouse is inside the rectangle!")
	#else:
		#print("Mouse is outside the rectangle.")

@onready var fogLeft = 8
@onready var coord = 1
@onready var squareX = 1
@onready var squareY = 1
@onready var fog_mode = false
@onready var fogPos = $fogPos

func _ready():
	$fogPos/AnimatedSprite2D.play("fogAnimation")
#	place_fog()
	fog_mode = !fog_mode  # inverts bool state
	make_fog()

var hp_radar = 100

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
		
	coord = get_viewport().get_mouse_position()
	squareX = floor(coord.x/64) #takes X cord from coords	floor rounds down. coord = mouse cord.
	squareY = floor(coord.y/64) #takes Y cord from coords	dividing by 64 aligns to grid
	
	if squareX >= 5: #keeps mouse tracking within user area
		squareX = 4 
	if squareY >= 8:
		squareY = 7
	
	if fog_mode == true:
		fogPos.global_position = Vector2(squareX*64,squareY*64)

	if fog_mode == true && fogLeft > 0 && Input.is_action_just_pressed("build"): #build is just another way of saying left clickkkk blehh #path to scene
		var new_fog = fogPos.duplicate() # makes fog
		new_fog.global_position = Vector2(squareX*64,squareY*64)  # Place it at the mouse position
		get_tree().current_scene.add_child(new_fog)
		fogLeft = fogLeft - 1 
		print(fogLeft)
		if fogLeft == 0:
			fog_mode = false

func make_fog():
	fogPos.visible = fog_mode #sets the fog to the state defined by fog_mode [if its on or off]
