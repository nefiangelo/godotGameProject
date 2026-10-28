extends CanvasLayer

# 1. Isso cria o campo "Imagem Tutorial" no Inspector!
@export var imagem_tutorial: Texture2D

# 2. Pegue a referência do seu TextureRect onde a imagem vai aparecer
# (Arraste o nó para cá ou digite o nome exato dele)
@onready var texture_rect = $TextureRect 

func _ready():
	hide()

func pausar_jogo():
	# 3. Atualiza a imagem do tutorial antes de mostrar a tela
	if imagem_tutorial != null:
		texture_rect.texture = imagem_tutorial
		
	show()
	get_tree().paused = true

func _on_botao_voltar_ao_jogo_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_botao_sair_pressed() -> void:
	get_tree().paused = false # Importante despausar antes de sair!
	get_tree().change_scene_to_file("res://levels/Menu/menuPrincipal.tscn")
