extends Control





func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://minigame_1.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_ajuda_pressed() -> void:
	get_tree().change_scene_to_file("res://ajuda.tscn")
