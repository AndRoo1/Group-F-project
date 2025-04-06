class_name BattleUI
extends Control
var player_combatant: Player
var enemy_combatant: Enemy
var playerDice : int
var enemyDice : int
var player_defending : bool = false
var enemy_defending : bool = false
const ATTACK_COLOR : Color = Color(0.906, 0.314, 0.365)
const DEFENSE_COLOR : Color = Color(0.329, 0.531, 0.875)
const DAMAGE_COLOR : Color = Color(1, 0.1, 0.1)

func _ready() -> void:
	if player_combatant != null:
		# Set the player icon on the left to the player plane sprite
		var player_sprite: Sprite2D = player_combatant.get_node("Sprite2D")
		$Player.texture = player_sprite.texture
		$Player.material = player_sprite.material
	
	
	if enemy_combatant != null:
		# Set the enemy icon on the left to the enemy plane sprite
		var enemy_sprite: Sprite2D = enemy_combatant.get_node("Sprite2D")
		$Enemy.texture = enemy_sprite.texture
		$Enemy.material = enemy_sprite.material
	randomize()
	
	# Set health labels to their respective combatants health
	$playerHealth.text = str(player_combatant.health)
	$enemyHealth.text = str(enemy_combatant.health)
	


	#$DiceLabel.text = str(playerDice)

# The following four functions randomise the player/enemy dice based on whether they're picking to attack or defend
func randomise_player_attack() -> void:
	playerDice = randi_range(player_combatant.attackDiceMin,player_combatant.attackDiceMax)

func randomise_enemy_attack() -> void:
	enemyDice = randi_range(enemy_combatant.attackDiceMin,enemy_combatant.attackDiceMax)

func randomise_player_defense() -> void:
	playerDice = randi_range(player_combatant.defenseDiceMin,player_combatant.defenseDiceMax)
	
func randomise_enemy_defense() -> void:
	enemyDice = randi_range(enemy_combatant.defenseDiceMin,enemy_combatant.defenseDiceMax)

# Whether the enemy attacks or not during a clash is based on their attack chance
func _on_attack_button_pressed() -> void:
	clash(true, randf() < enemy_combatant.attack_chance)

func _on_defense_button_pressed() -> void:
	clash(false, randf() < enemy_combatant.attack_chance)

func clash(player_attacking: bool, enemy_attacking: bool) -> void:
	# The following conditions check whether the player and enemy are defending or not
	# and randomise their dice values based on this
	if player_attacking:
		player_defending = false
		$DiceLabel.add_theme_color_override("font_color", ATTACK_COLOR)
		randomise_player_attack()
	else:
		player_defending = true
		$DiceLabel.add_theme_color_override("font_color", DEFENSE_COLOR)
		randomise_player_defense()
	
	if enemy_attacking:
		enemy_defending = false
		$DiceLabel2.add_theme_color_override("font_color", ATTACK_COLOR)
		randomise_enemy_attack()
	else:
		enemy_defending = true
		$DiceLabel2.add_theme_color_override("font_color", DEFENSE_COLOR)
		randomise_enemy_defense()
	
	$DiceLabel.text = str(playerDice)
	$DiceLabel2.text = str(enemyDice)
	
	# Clash calculation - first we check who has the higher dice value, then we check if the winner is attacking or defending
	if playerDice > enemyDice:
		if player_attacking:
			player_attack_win()
		else:
			player_defense_win()
	elif enemyDice > playerDice:
		if enemy_attacking:
			enemy_attack_win()
		else:
			enemy_defense_win()
	else:
		print("draw!")
	do_battle_stuff()

# On attack victories, change the health of the loser by the attack value
# If the loser was defending, they take less damage, based on the dice value
func player_attack_win():
	enemy_combatant.set_health(enemy_combatant.health - (playerDice - enemyDice * int(enemy_defending)))
	$enemyHealth.add_theme_color_override("font_color", Color(1, 0.1, 0.1))

func player_defense_win():
	pass

func enemy_attack_win():
	player_combatant.set_health(player_combatant.health - (enemyDice - playerDice * int(player_defending)))
	$playerHealth.add_theme_color_override("font_color", DAMAGE_COLOR)

func enemy_defense_win():
	pass

func do_battle_stuff():
	# Disable the attack and defense buttons for the period of the clash
	# and set the health values to their proper values
	# afterwards, calculate if either of the planes die
	$AttackButton.disabled = true
	$DefenseButton.disabled = true
	$playerHealth.text = str(player_combatant.health)
	$enemyHealth.text = str(enemy_combatant.health)
	await get_tree().create_timer(3).timeout
	if player_combatant.health <= 0:
		BattleSystem.end_battle(false, true)
	elif enemy_combatant.health <= 0:
		BattleSystem.kill_enemy_plane(enemy_combatant)
		BattleSystem.end_battle(true, true)
	else:
		BattleSystem.end_battle(false, false)
