class_name BattleUI
extends Control
var player_combatant: Player
var enemy_combatant: Enemy

func _ready() -> void:
	if player_combatant != null:
		var player_sprite: Sprite2D = player_combatant.get_node("Sprite2D")
		$Player.texture = player_sprite.texture
	
	if enemy_combatant != null:
		var enemy_sprite: Sprite2D = enemy_combatant.get_node("Sprite2D")
		$Enemy.texture = enemy_sprite.texture


func _on_player_victory_button_pressed() -> void:
	BattleSystem.battle_ended.emit(true)


func _on_enemy_victory_button_pressed() -> void:
	BattleSystem.battle_ended.emit(false)
