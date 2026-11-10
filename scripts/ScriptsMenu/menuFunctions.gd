extends Control



func _on_arcade_pressed() -> void:
	ArcadeManager.iniciar_arcade()

func _on_botao_jogar_pressed() -> void:
	# Garante que o jogo avulso nunca ache que é o Arcade
	ArcadeManager.modo_arcade = false 
	
	get_tree().change_scene_to_file("res://levels/Menu/gridGames.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_ajuda_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Menu/ajuda.tscn")
