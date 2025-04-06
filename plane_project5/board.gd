extends Node2D

@onready var plane_holo = $plane_holo
@onready var radio_holo = $radio_tower_holo
@onready var motherbase_holo = $motherbase_holo
@onready var artillery_holo = $artillery_holo
@onready var startGameButton : Button = $"../hud/StartGameButton"
@onready var motherbaseButton : Button = $"../hud/building_backboard_node/motherbase_summon"
@onready var deductTimer : Timer = get_node("../hud/pointsHUD/deductTimer")
@onready var pointsDeducted = get_node("../hud/pointsHUD/pointsDeducted")
@onready var pointsLabel = get_node("../hud/pointsHUD/pointsLabel")
@onready var planeHUD = get_node("../hud/plane_backboard_node")
@onready var buildingHUD = get_node("../hud/building_backboard_node")  
@onready var build_mode = false #placing radar
@onready var plane_mode = false#placing plane
@onready var plane_type = 0 # different plane types 1 thru 5
@onready var building_type = 0 #1=radar 2=motherbase 3=artillary
@onready var can_place = true
@onready var coord = 1
@onready var squareX = 1
@onready var squareY = 1
@onready var points = 1000 #
@onready var motherbasePlace = false
@onready var motherbaseinUse = false
var buying_hidden = false

var deduct_timer_queued = false

func _ready():
	motherbase_holo.visible = false
	radio_holo.visible = false
	plane_holo.visible = false
	planeHUD.hide()
	$"../hud/BuildingsHud".grab_focus()
	#planeHUD.position.y = 150
	BattleSystem.enemy_plane_killed.connect(enemy_plane_killed)
	BattleSystem.player_turn_start.connect(player_turn_start)
	BattleSystem.player_turn_end.connect(player_turn_end)

func player_turn_start():
	print("PLAYER TURN START TRIGGERED ON BOARD")
	var player_planes = get_tree().get_nodes_in_group("player")
	var moveable_planes_left = false
	for plane: Player in player_planes:
		if plane.moveable:
			moveable_planes_left = true
			break
	if moveable_planes_left or points >= 100:
		if buying_hidden:
			$"../AnimationPlayer".play_backwards("HideButtons")
			buying_hidden = false
	else:
		await get_tree().create_timer(0.5).timeout
		BattleSystem.start_enemy_turn()

func player_turn_end():
	if !buying_hidden:
		$"../AnimationPlayer".play("HideButtons")
		buying_hidden = true

func enemy_plane_killed(enemy: Enemy):
	add_points(enemy.point_reward)

func _process(delta):
	coord = get_viewport().get_mouse_position()
	squareX = floor(coord.x/64) #takes X cord from coords	floor rounds down. coord = mouse cord.
	squareY = floor(coord.y/64) #takes Y cord from coords	dividing by 64 aligns to grid
	
	if squareX >= 5: #keeps mouse tracking within user area
		squareX = 4 
	if squareY >= 8:
		squareY = 7
	
#	if Input.is_action_just_pressed("placePlaneStart"):
#		$plane_holo.play("planeHolo")
#		plane_mode = !plane_mode
#		make_plane()
	
#	if Input.is_action_just_pressed("buildModeStart"):
#		build_mode = !build_mode  # inverts bool state
#		make_radar()  # changes radar visibility
	
	if build_mode: #if true
		radio_holo.position = Vector2(squareX*64+32,squareY*64+32) #moves radioholo to mouse
		motherbase_holo.position = Vector2(squareX*64+32,squareY*64+32)
		artillery_holo.position = Vector2(squareX * 64 + 32, squareY * 64 + 32)
	if plane_mode:
		plane_holo.position = Vector2(squareX*64+32,squareY*64+32) #moves radioholo to mouse
		
	if build_mode == true && building_type == 1 && can_place == true && Input.is_action_just_pressed("build"): #build is just another way of saying left clickkkk blehh
		var radio_tower_scene = preload("res://player_radio_tower.tscn")  #path to scene
		var new_tower = radio_tower_scene.instantiate()  # makes radio tower
		new_tower.position = Vector2(squareX*64+32,squareY*64+32)  # Place it at the mouse position
		#get_tree().current_scene.add_child(new_tower) # 
		add_child(new_tower)
		build_mode = false
		make_radar()

	if build_mode == true && building_type == 2 && can_place == true && Input.is_action_just_pressed("build"): #build is just another way of saying left clickkkk blehh
		var air_artillery_scene = preload("res://player_air_artillery.tscn")  #path to scene
		var new_tower = air_artillery_scene.instantiate()  # makes artillery
		new_tower.position = Vector2(squareX*64+32,squareY*64+32)  # Place it at the mouse position
		#get_tree().current_scene.add_child(new_tower) # 
		add_child(new_tower)
		build_mode = false
		make_artillery()
	
	if build_mode == true && motherbaseinUse == false &&building_type == 3 && can_place == true && Input.is_action_just_pressed("build"): #build is just another way of saying left clickkkk blehh
		var motherbase_scene = preload("res://player_motherbase.tscn")  #path to scene
		var new_tower = motherbase_scene.instantiate()  # makes mother
		new_tower.position = Vector2(squareX*64+32,squareY*64+32)  # Place it at the mouse position
		#get_tree().current_scene.add_child(new_tower) # 
		add_child(new_tower)
		build_mode = false
		make_motherbase()
		motherbaseinUse = true
		print("mother is here")
	
	var plane_scenes = ["res://playerplane.tscn","res://playerplane2.tscn","res://playerplane3.tscn","res://playerplane4.tscn","res://playerplane5.tscn"]
	if plane_mode && Input.is_action_just_pressed("build"):
		var plane_scene = load(plane_scenes[plane_type - 1])  #path to scene
		var new_plane = plane_scene.instantiate()  # makes plane
		new_plane.position = Vector2(squareX*64+32,squareY*64+32)  # Place it at the mouse position
		#get_tree().current_scene.add_child(new_plane) # 
		add_child(new_plane)
		plane_mode = false
		plane_holo.visible = plane_mode
		
	if pointsLabel:
		pointsLabel.text = str(points)
	else:
		print("Error: pointsLabel not found!")
		

func make_radar():
	radio_holo.visible = build_mode #makes the visibility of hologram = build mode bool
	
func make_motherbase():
	motherbase_holo.visible = build_mode #makes the visibility of hologram = build mode bool

func make_plane():
	plane_holo.visible = plane_mode

func make_artillery():
	artillery_holo.visible = build_mode 

func planeButtonPressed() -> void: # this is essentially copy paste for other planes 
	if points >= 100: #buying system
		add_points(-100)
		plane_type = 1
		$plane_holo.play("planeHolo") #hologram
		plane_mode = !plane_mode
		make_plane()
	else: #not enough money :(
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()
		

func plane2ButtonPressed() -> void:
	if points >= 120:
		add_points(-120)
		#code
		plane_type = 2
		$plane_holo.play("planeHolo") #hologram
		plane_mode = !plane_mode
		make_plane()
	else:
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()

func plane3ButtonPressed() -> void:
	if points >= 140:
		add_points(-140)
		#code
		plane_type = 3
		$plane_holo.play("planeHolo") #hologram
		plane_mode = !plane_mode
		make_plane()
	else:
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()

func plane4ButtonPressed() -> void:
	if points >= 160:
		add_points(-160)
		#code
		plane_type = 4
		$plane_holo.play("planeHolo") #hologram
		plane_mode = !plane_mode
		make_plane()
	else:
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()

func plane5ButtonPressed() -> void:
	if points >= 180:
		add_points(-180)
		#code
		plane_type = 5
		$plane_holo.play("planeHolo") #hologram
		plane_mode = !plane_mode
		make_plane()
	else:
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()
	
func radarButtonPressed() -> void:
	if points >= 200:
		points = points - 200
		building_type = 1
		build_mode = !build_mode  # inverts bool state
		make_radar()  # changes radar visibility
		pointsDeducted.text = str(-200)
		deductTimer.start()
	else: #not enough money :(
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()
		
func artilleryButtonPressed() -> void:
	if points >= 200:
		points = points - 200
		building_type = 2
		build_mode = !build_mode  # inverts bool state
		make_artillery()  #
		pointsDeducted.text = str(-200)
		deductTimer.start()
	else:
		pointsDeducted.text = ("INSUFFICIENT POINTS!")
		deductTimer.start()
		
func motherbaseButtonPressed() -> void:
	building_type = 3
	build_mode = !build_mode  # inverts bool state
	make_motherbase()  # changes radar visibility
	motherbasePlace = true
	if motherbaseinUse:
		pointsDeducted.text = ("Only one motherbase!")
		deductTimer.start()
	startGameButton.disabled = false
	motherbaseButton.disabled = true
	$"../hud/StartGameButton/MotherbaseLabel".hide()

	

func PlanesHudPressed() -> void: #make planes appear make buildings go away
	buildingHUD.hide()
	planeHUD.show()


func BuildingsHudPressed() -> void: #make buildings appear make planes go away
	buildingHUD.show()
	planeHUD.hide()


func _on_deduct_timer_timeout() -> void:
	pointsDeducted.text = ("")

func add_points(points_to_add: int) -> void:
	points += points_to_add
	pointsDeducted.text = ("+" if points_to_add > 0 else "") + str(points_to_add)
	pointsDeducted.add_theme_color_override("font_color", Color(0, 1, 0) if points_to_add > 0 else Color(1, 0, 0))
	if is_inside_tree():
		deductTimer.start()
	else:
		deduct_timer_queued = true
	pointsLabel.text = str(points)
	


func _on_start_game_button_pressed() -> void:
	BattleSystem.start_game()
	$"../hud/StartGameButton".disabled = true
	$"../hud/StartGameButton".hide()
	$"../hud/BuildingsHud".hide()
	$"../hud/PlanesHud".hide()
	PlanesHudPressed()
	


func _on_deduct_timer_tree_entered() -> void:
	if deduct_timer_queued:
		deduct_timer_queued = false
		deductTimer.start()
