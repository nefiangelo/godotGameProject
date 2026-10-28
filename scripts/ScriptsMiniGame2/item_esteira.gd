extends Area2D

enum Categoria { BOM, DEFEITUOSO, LIXO }
@export var tipo_do_item: Categoria = Categoria.DEFEITUOSO
@export var id_conserto: int = 0 

var arrastando: bool = false
var offset_mouse: Vector2 = Vector2.ZERO
var velocidade_descida: float = 100.0
var zona_atual: Area2D = null

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando = true
			offset_mouse = global_position - get_global_mouse_position()
			# Muda para o ícone de agarrar/arrastar
			Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		else:
			arrastando = false
			# Volta para a mãozinha apontando ao soltar (pois o mouse continua em cima do item)
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			verificar_drop()

func _process(delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() + offset_mouse
	else:
		if zona_atual == null or zona_atual.name != "ZonaMesa":
			global_position.y += velocidade_descida * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("zona_drop"):
		zona_atual = area

func _on_area_exited(area: Area2D) -> void:
	if area == zona_atual:
		zona_atual = null

func verificar_drop() -> void:
	if zona_atual == null:
		# Se soltou no vazio e ele vai continuar caindo, tira a mãozinha
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		return 
		
	var acertou = false
	
	if tipo_do_item == Categoria.BOM and zona_atual.name == "ZonaMesa":
		acertou = true
	elif tipo_do_item == Categoria.DEFEITUOSO and zona_atual.name == "ZonaMech":
		acertou = true
	elif tipo_do_item == Categoria.LIXO and zona_atual.name == "ZonaIncinerador":
		acertou = true
		
	# COMUNICAÇÃO COM O MINIGAME (Com Prints para Debug)
	if acertou and tipo_do_item == Categoria.DEFEITUOSO:
		print("1. O item bateu na zona certa! Meu ID é: ", id_conserto)
		
		if get_parent().has_method("consertou_item"):
			print("2. Achei a função no Minigame! Enviando aviso...")
			get_parent().consertou_item(id_conserto)
		else:
			print("ERRO: O nó pai não tem a função consertou_item!")
			
	if zona_atual.name == "ZonaMesa":
		return
		
	# ATENÇÃO AQUI: Como o item vai ser deletado, forçamos o mouse a voltar ao normal!
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	queue_free()

func _on_mouse_entered() -> void:
	# Quando o mouse entra na imagem, vira a mão de clique
	if not arrastando:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	# Quando o mouse sai da imagem, volta a ser a setinha
	if not arrastando:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
