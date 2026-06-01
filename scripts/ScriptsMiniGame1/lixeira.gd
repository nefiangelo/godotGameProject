extends Area2D

var caixa_na_mira: Area2D = null

func _ready() -> void:
	# Conecta os próprios sinais para saber se a caixa entrou na área
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(_delta: float) -> void:
	# Se tiver uma caixa na lixeira e o jogador apertar ESPAÇO (ou a tecla de ação)
	if caixa_na_mira and Input.is_action_just_pressed("ui_accept"):
		descartar_caixa()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("parar_na_esteira"): # Garante que é uma caixa
		caixa_na_mira = area

func _on_area_exited(area: Area2D) -> void:
	if area == caixa_na_mira:
		caixa_na_mira = null

func descartar_caixa() -> void:
	var pallete = caixa_na_mira.get_parent()
	if pallete and pallete.get_parent().name == "Empilhadeira":
		var empilhadeira = pallete.get_parent()
		
		# Opcional: Avisa o GameManager se você quiser tirar pontos por desperdício
		get_tree().call_group("Manager", "errar_caixa") 
		
		# Destrói a caixa e libera as mãos da empilhadeira
		caixa_na_mira.queue_free()
		empilhadeira.segurando_caixa = false
		caixa_na_mira = null
		print("Caixa jogada no lixo!")
