extends Area2D

var ocupado: bool = false
var caixa_na_mira: Area2D = null

# Conecte o sinal "area_entered" do Area2D aqui
func _on_area_entered(area: Area2D) -> void:
	# Verifica se é uma caixa (usando o método que criamos antes) e se o slot tá vazio
	if area.has_method("parar_na_esteira") and not ocupado:
		caixa_na_mira = area

# Conecte o sinal "area_exited" do Area2D aqui
func _on_area_exited(area: Area2D) -> void:
	if area == caixa_na_mira:
		caixa_na_mira = null

func _process(_delta: float) -> void:
	# Se tiver uma caixa na área, o slot estiver livre e o jogador apertar ESPAÇO
	if caixa_na_mira and not ocupado and Input.is_action_just_pressed("ui_accept"):
		guardar_caixa()

func guardar_caixa() -> void:
	var pallete = caixa_na_mira.get_parent()
	
	# Subindo a árvore de nós para achar a Empilhadeira
	# Estrutura atual: Empilhadeira -> spritePallete -> Caixa
	if pallete and pallete.get_parent().name == "Empilhadeira":
		var empilhadeira = pallete.get_parent()
		
		# 1. Tira a caixa da empilhadeira e coloca como filha DESTE slot
		caixa_na_mira.reparent(self)
		
		# 2. Centraliza a caixa perfeitamente no meio do quadradinho do slot
		caixa_na_mira.position = Vector2.ZERO
		
		# 3. Atualiza os status para o jogo saber o que aconteceu
		ocupado = true
		empilhadeira.segurando_caixa = false
		caixa_na_mira = null
		
		print("Caixa guardada com sucesso no slot!")
