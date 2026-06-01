extends Area2D

# O Slot não precisa mais da lista de formas aqui
var forma_aceita: String = ""

@export var arte_triangulo: Texture2D
@export var arte_quadrado: Texture2D
@export var arte_circulo: Texture2D
@export var arte_estrela: Texture2D

var ocupado: bool = false
var caixa_na_mira: Area2D = null

func _ready() -> void:
	# APAGAMOS O SORTEIO DAQUI!
	# O Slot agora nasce vazio e espera o GameManager chamar a função abaixo:
	pass

# --- NOVA FUNÇÃO QUE O GAMEMANAGER VAI CHAMAR ---
func definir_forma(nova_forma: String) -> void:
	forma_aceita = nova_forma
	var indicador = $SpriteSlot
	
	match forma_aceita:
		"triangulo":
			indicador.texture = arte_triangulo
		"quadrado":
			indicador.texture = arte_quadrado
		"circulo":
			indicador.texture = arte_circulo
		"estrela":
			indicador.texture = arte_estrela

func _process(_delta: float) -> void:
	# Se tiver uma caixa na área, o slot estiver livre e o jogador apertar ESPAÇO
	if caixa_na_mira and not ocupado and Input.is_action_just_pressed("ui_accept"):
		guardar_caixa()

# Conecte o sinal "area_entered" do nó SlotPrateleira aqui!
func _on_area_entered(area: Area2D) -> void:
	# Verifica se a área que entrou é uma caixa e se o slot tá vazio
	if area.has_method("parar_na_esteira") and not ocupado:
		caixa_na_mira = area

# Conecte o sinal "area_exited" do nó SlotPrateleira aqui!
func _on_area_exited(area: Area2D) -> void:
	if area == caixa_na_mira:
		caixa_na_mira = null

func guardar_caixa() -> void:
	var pallete = caixa_na_mira.get_parent()
	
	# Subindo a árvore de nós para achar a Empilhadeira
	if pallete and pallete.get_parent().name == "Empilhadeira":
		var empilhadeira = pallete.get_parent()
		
		# A HORA DA VERDADE: As formas combinam?
		if caixa_na_mira.forma_da_caixa == forma_aceita:
			# ACERTOU! Chama o Juiz para dar ponto
			get_tree().call_group("Manager", "adicionar_ponto")
			
			caixa_na_mira.reparent(self)
			caixa_na_mira.position = Vector2.ZERO
			ocupado = true
			empilhadeira.segurando_caixa = false
			caixa_na_mira = null
			print("Caixa guardada com sucesso no slot!")
			
		else:
			# ERROU! Chama o Juiz para tirar ponto/tempo
			get_tree().call_group("Manager", "errar_caixa")
			
			caixa_na_mira.queue_free() # Destrói a caixa para liberar a empilhadeira
			empilhadeira.segurando_caixa = false
			caixa_na_mira = null
			print("Forma errada! A caixa foi descartada.")
