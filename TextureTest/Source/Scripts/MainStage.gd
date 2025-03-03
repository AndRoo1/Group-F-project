extends Node

var game_scene_resource: Resource = load("res://Source/Scenes/Stages/base.tscn")
var game_scene: Node = game_scene_resource.instantiate()
var battle_scene_resource: Resource = load("res://Source/Scenes/UI/battle.tscn")
var battle_scene: BattleUI = null
var current_scene: Node = null

func _ready() -> void:
	BattleSystem.battle_started.connect(start_battle)
	BattleSystem.battle_ended.connect(end_battle)
	switch_scene(game_scene)

func switch_scene(new_scene: Object) -> void:
	if new_scene == null:
		return
	
	if new_scene.is_inside_tree():
		current_scene = new_scene
		return

		#Add new scene below old scene to keep 
	#the same index once old_scene is removed
	if current_scene and current_scene.is_inside_tree():
		current_scene.add_sibling(new_scene)
		remove_child(current_scene)
	else:
		add_child(new_scene)
	current_scene = new_scene

func start_battle(player_combatant: Player, enemy_combatant: Enemy) -> void:
	battle_scene = battle_scene_resource.instantiate()
	print("start bt", player_combatant, enemy_combatant)
	battle_scene.player_combatant = player_combatant
	battle_scene.enemy_combatant = enemy_combatant
	switch_scene(battle_scene)

func end_battle(player_won: bool) -> void:
	if player_won:
		battle_scene.enemy_combatant.get_parent().remove_child(battle_scene.enemy_combatant)
	else:
		battle_scene.player_combatant.get_parent().remove_child(battle_scene.player_combatant)
		battle_scene.player_combatant.alive = false
		battle_scene.player_combatant.monitoring = false
	switch_scene(game_scene)
	
