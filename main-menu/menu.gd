extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game_menu.tscn")



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
