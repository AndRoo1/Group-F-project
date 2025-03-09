extends Node2D

@onready var radio_holo = $radio_tower_holo
@onready var radio_tower = $radio_tower
@onready var build_mode = false
@onready var coord = 1
@onready var squareX = 1
@onready var squareY = 1

func _ready():
	radio_holo.visible = false

func _process(delta):
	coord = get_viewport().get_mouse_position()
	squareX = floor(coord.x/64) #takes X cord from coords	floor rounds down. coord = mouse cord.
	squareY = floor(coord.y/64) #takes Y cord from coords	dividing by 64 aligns to grid
	
	if squareX >= 5: #keeps mouse tracking within user area
		squareX = 4 
	if squareY >= 8:
		squareY = 7
	
	if Input.is_action_just_pressed("buildModeStart"):
		build_mode = !build_mode  # inverts bool state
		make_radar()  # changes radar visibility
	
	if build_mode:
		radio_holo.position = Vector2(squareX*64+32,squareY*64+32) #moves radioholo to m
		
	if build_mode == true && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		radio_tower.position  = get_global_mouse_position()


func make_radar():
	radio_holo.visible = build_mode #makes the visibility of hologram = build mode bool

		









func _on_a_mouse_entered_1_a():
	pass


func _on_a_mouse_entered_2_a():
	pass


func _on_a_mouse_entered_3_a() -> void:
	pass
	
	
func _on_a_mouse_entered_4_a() -> void:
	pass # Replace with function body.
	
	
func _on_a_mouse_entered_5_a() -> void:
	pass # Replace with function body.
	
	
func _on_a_mouse_entered_6_a() -> void:
	pass # Replace with function body.
	
	
func _on_a_mouse_entered_7_a() -> void:
	pass # Replace with function body.
	
	
func _on_a_mouse_entered_8_a() -> void:
	pass
	
	#COLUMN B==========================================================
	
func _on_b_mouse_entered_1_b() -> void:
	pass # Replace with function body.
	
	
func _on_b_mouse_entered_2_b() -> void:
	pass # Replace with function body.


func _on_b_mouse_entered_3_b() -> void:
	pass # Replace with function body.
	
	
func _on_b_mouse_entered_4_b() -> void:
	pass # Replace with function body.
	

func _on_b_mouse_entered_5_b() -> void:
	pass # Replace with function body.


func _on_b_mouse_entered_6_b() -> void:
	pass # Replace with function body.


func _on_b_mouse_entered_7_b() -> void:
	pass # Replace with function body.


func _on_b_mouse_entered_8_b() -> void:
	pass # Replace with function body.

#COLUMN C ==================================================================

func _on_c_mouse_entered_1_c() -> void:
	pass # Replace with function body.


func _on_c_mouse_entered_2_c() -> void:
	pass # Replace with function body.
	

func _on_c_mouse_entered_3_c() -> void:
	pass # Replace with function body.


func _on_c_mouse_entered_4_c() -> void:
	pass # Replace with function body.


func _on_c_mouse_entered_5_c() -> void:
	pass # Replace with function body.


func _on_c_mouse_entered_6_c() -> void:
	pass # Replace with function body.


func _on_c_mouse_entered_7_c() -> void:
	pass # Replace with function body.


func _on_c_mouse_entered_8_c() -> void:
	pass # Replace with function body.

#COLUMN D =======================================================

func _on_d_mouse_entered_1_d() -> void:
	pass # Replace with function body.


func _on_d_mouse_entered_2_d() -> void:
	pass # Replace with function body.


func _on_d_mouse_entered_3_d() -> void:
	pass # Replace with function body.


func _on_d_mouse_entered_4_d() -> void:
	pass # Replace with function body.


func _on_d_mouse_entered_5_d():
	pass


func _on_d_mouse_entered_6_d() -> void:
	pass # Replace with function body.


func _on_d_mouse_entered_7_d() -> void:
	pass # Replace with function body.


func _on_d_mouse_entered_8_d() -> void:
	pass # Replace with function body.

#COLUMN E ==========================================================

func _on_e_mouse_entered_1_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_2_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_3_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_4_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_5_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_6_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_7_e() -> void:
	pass # Replace with function body.


func _on_e_mouse_entered_8_e() -> void:
	pass # Replace with function body.
