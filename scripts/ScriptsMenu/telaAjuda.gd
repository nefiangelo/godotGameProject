extends Control

# Array para guardar as imagens no Inspector
@export var imagens_tutorial: Array[Texture2D]

# Referências aos nós da cena
@onready var img_tutorial = $img_Tutorial_1
@onready var btn_anterior = $ButtonAnterior
@onready var btn_prox = $ButtonProx

var indice_atual: int = 0

func _ready() -> void:
	# Atualiza a tela assim que a cena de ajuda for aberta
	atualizar_tela()

func atualizar_tela() -> void:
	# Verifica se o array tem imagens para evitar erros
	if imagens_tutorial.is_empty():
		return
		
	# Troca a textura e gerencia os botões
	img_tutorial.texture = imagens_tutorial[indice_atual]
	btn_anterior.disabled = (indice_atual == 0)
	btn_prox.disabled = (indice_atual == imagens_tutorial.size() - 1)

func _on_button_anterior_pressed() -> void:
	if indice_atual > 0:
		indice_atual -= 1
		atualizar_tela()

func _on_button_prox_pressed() -> void:
	if indice_atual < imagens_tutorial.size() - 1:
		indice_atual += 1
		atualizar_tela()

# Sua função original mantida intacta
func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Menu/menuPrincipal.tscn")
