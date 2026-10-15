extends Area2D

enum Categoria { BOM, DEFEITUOSO, LIXO }
@export var tipo_do_item: Categoria = Categoria.DEFEITUOSO

var arrastando: bool = false
var offset_mouse: Vector2 = Vector2.ZERO
var velocidade_descida: float = 100.0

# Nova variável para guardar a zona onde o item está pairando
var zona_atual: Area2D = null

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando = true
			offset_mouse = global_position - get_global_mouse_position()
		else:
			arrastando = false
			# O CLIQUE FOI SOLTO. Hora de checar se caiu em uma zona!
			verificar_drop()

func _process(delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() + offset_mouse
	else:
		global_position.y += velocidade_descida * delta

# ---- NOVOS SINAIS DE COLISÃO ----

func _on_area_entered(area: Area2D) -> void:
	# Se a área que encostamos pertence ao grupo que criamos no cenário, guardamos ela
	if area.is_in_group("zona_drop"):
		zona_atual = area

func _on_area_exited(area: Area2D) -> void:
	# Se o item saiu de cima da área antes de soltar o mouse, apagamos a memória
	if area == zona_atual:
		zona_atual = null

# ---- A LÓGICA DO JOGO ----

func verificar_drop() -> void:
	# Se soltou no meio da esteira, apenas sai da função e o item volta a cair
	if zona_atual == null:
		return 
		
	var acertou = false
	
	# Avalia se a categoria do item bate com o nome exato da zona na sua árvore de nós
	if tipo_do_item == Categoria.BOM and zona_atual.name == "ZonaMesa":
		acertou = true
	elif tipo_do_item == Categoria.DEFEITUOSO and zona_atual.name == "ZonaMech":
		acertou = true
	elif tipo_do_item == Categoria.LIXO and zona_atual.name == "ZonaIncinerador":
		acertou = true
		
	if acertou:
		print("ACERTOU! Item descartado corretamente.")
		# Futuramente: GameManager.adicionar_pontos(10)
	else:
		print("ERROU! O item foi parar no lugar errado.")
		# Futuramente: GameManager.perder_vida()
		
	# O item sempre é destruído após ser solto dentro de alguma das zonas
	queue_free()
