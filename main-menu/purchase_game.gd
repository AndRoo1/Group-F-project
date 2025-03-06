extends Control




func _on_purchase_pressed() -> void:
	get_tree().change_scene_to_file("res://full_game.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://game_menu.tscn")
