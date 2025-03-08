class_name BattleUI
extends Control
var player_combatant: Player
var enemy_combatant: Enemy
var playerDice : int
var enemyDice : int

func _ready() -> void:
	if player_combatant != null:
		var player_sprite: Sprite2D = player_combatant.get_node("Sprite2D")
		$Player.texture = player_sprite.texture
	
	
	if enemy_combatant != null:
		var enemy_sprite: Sprite2D = enemy_combatant.get_node("Sprite2D")
		$Enemy.texture = enemy_sprite.texture
	randomize()
	
	$playerHealth.text = str(player_combatant.health)
	$enemyHealth.text = str(enemy_combatant.health)
	



func _on_player_victory_button_pressed() -> void:
	BattleSystem.battle_ended.emit(true)


func _on_enemy_victory_button_pressed() -> void:
	BattleSystem.battle_ended.emit(false)

func randomise() -> void:
	playerDice = randi_range(1,20)
	enemyDice = randi_range(3,19)

func _on_attack_button_pressed() -> void:
	randomise()
	$AttackButton/DiceLabel.text = str(playerDice)
	$AttackButton/DiceLabel2.text = str(enemyDice)
	if playerDice > enemyDice:
		enemy_combatant.health -= playerDice
	elif enemyDice > playerDice:
		player_combatant.health -= enemyDice
	else:
		print("draw!")
	$AttackButton.disabled = true
	$DefenseButton.disabled = true
	$playerHealth.text = str(player_combatant.health)
	$enemyHealth.text = str(enemy_combatant.health)
	await get_tree().create_timer(3).timeout
	if player_combatant.health <= 0:
		BattleSystem.battle_ended.emit(false, true)
	elif enemy_combatant.health <= 0:
		BattleSystem.battle_ended.emit(true, true)
	else:
		BattleSystem.battle_ended.emit(false, false)
	

func _on_defense_button_pressed() -> void:
	randomise()
	$AttackButton/DiceLabel.text = str(playerDice)
	$AttackButton/DiceLabel2.text = str(enemyDice)
	if playerDice > enemyDice:
		pass
	elif enemyDice > playerDice:
		player_combatant.health -= enemyDice-playerDice
	else:
		print("draw!")
	$AttackButton.disabled = true
	$DefenseButton.disabled = true
	$playerHealth.text = str(player_combatant.health)
	$enemyHealth.text = str(enemy_combatant.health)
	await get_tree().create_timer(3).timeout
	if player_combatant.health <= 0:
		BattleSystem.battle_ended.emit(false, true)
	elif enemy_combatant.health <= 0:
		BattleSystem.battle_ended.emit(true, true)
	else:
		BattleSystem.battle_ended.emit(false, false)
	
	
