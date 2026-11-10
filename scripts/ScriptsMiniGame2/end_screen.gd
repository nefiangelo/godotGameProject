extends Control


# O Godot vai gerar essa função quando você conectar o sinal:
func _on_botao_voltar_pressed() -> void:
	# 1. Despausa o jogo para não travar o menu
	get_tree().paused = false
	
	# 2. Volta para a grade de minigames
	get_tree().change_scene_to_file("res://levels/Menu/gridGames.tscn")
