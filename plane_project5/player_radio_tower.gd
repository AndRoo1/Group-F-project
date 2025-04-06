extends Player

@onready var fogLeft = 8
@onready var coord = 1
@onready var squareX = 1
@onready var squareY = 1
@onready var fog_mode = false
@onready var fogPos = $fogPos
@onready var fogNum = $UI/fogNum


func _ready():
	super()
	$fogPos/AnimatedSprite2D.play("fogAnimation")
#	place_fog()
	fog_mode = !fog_mode  # inverts bool state
	make_fog()

func _process(delta: float) -> void:
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
		new_fog.global_position = Vector2(squareX*64,squareY*64)# Place it at the mouse position
		#get_tree().current_scene.add_child(new_fog)
		add_child(new_fog)
		fogLeft = fogLeft - 1
		print(fogLeft)
		if fogLeft == 0:
			fog_mode = false
			fogNum.hide()
		fogNum.text = str(fogLeft)

func make_fog():
	fogPos.visible = fog_mode #sets the fog to the state defined by fog_mode [if its on or off]
