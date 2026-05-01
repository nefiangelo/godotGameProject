extends Control

#BOTÃO VOLTAR
func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Menu/menuPrincipal.tscn")

#BOTÃO MINIGAME 1
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/MiniGames/miniGame1.tscn")
