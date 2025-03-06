extends Control




func _on_purchase_pressed() -> void:
	get_tree().change_scene_to_file("res://purchase_game.tscn")


func _on_play_demo_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
