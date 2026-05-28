extends Control

@onready var lista_jogos = $listaMinigames
@onready var btn_anterior = $navButtons/BtnAnterior
@onready var btn_proximo = $navButtons/BtnProximo

var pagina_atual: int = 0
const ITENS_POR_PAGINA: int = 3

func _ready() -> void:
	# Quando a tela carregar, atualiza para mostrar só a primeira página
	atualizar_pagina()

func atualizar_pagina() -> void:
	var total_jogos = lista_jogos.get_child_count()
	
	# Percorre todos os jogos (HBoxContainers) que você criou
	for i in range(total_jogos):
		var jogo = lista_jogos.get_child(i)
		
		# Matemática simples: verifica se o jogo deve aparecer na página atual
		if i >= pagina_atual * ITENS_POR_PAGINA and i < (pagina_atual + 1) * ITENS_POR_PAGINA:
			jogo.show() # Mostra o jogo
		else:
			jogo.hide() # Esconde o jogo
			
	# Desativa os botões de seta se não tiver mais para onde ir
	btn_anterior.disabled = (pagina_atual == 0)
	btn_proximo.disabled = ((pagina_atual + 1) * ITENS_POR_PAGINA >= total_jogos)
	
func _on_btn_proximo_pressed() -> void:
	pagina_atual += 1
	atualizar_pagina()

func _on_btn_anterior_pressed() -> void:
	pagina_atual -= 1
	atualizar_pagina()
