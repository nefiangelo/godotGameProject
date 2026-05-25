extends Area2D

@export var lista_de_caixas: Array[PackedScene] = []
@export var posicao_spawn: Vector2 = Vector2(600, 270) 

var empilhadeira_na_area = null
var caixa_pronta_para_coleta = null

func _ready() -> void:
	randomize()
	spawnar_caixa_na_esteira()

# --- 1. SINAIS PARA A EMPILHADEIRA (BODIES) ---
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Empilhadeira":
		empilhadeira_na_area = body

func _on_body_exited(body: Node2D) -> void:
	if body == empilhadeira_na_area:
		empilhadeira_na_area = null

# --- 2. SINAIS PARA A CAIXA SIMPLIFICADA (AREAS) ---
func _on_area_entered(area: Area2D) -> void:
	if area.has_method("parar_na_esteira"):
		caixa_pronta_para_coleta = area
		area.parar_na_esteira()

func _on_area_exited(area: Area2D) -> void:
	if area == caixa_pronta_para_coleta:
		caixa_pronta_para_coleta = null

# --- 3. LOGICA DE COLOETA ---
func _process(_delta: float) -> void:
	if empilhadeira_na_area and caixa_pronta_para_coleta and Input.is_action_just_pressed("ui_accept"):
		if not empilhadeira_na_area.segurando_caixa:
			coletar_caixa()

func spawnar_caixa_na_esteira() -> void:
	# Segurança: se você esquecer de colocar caixas na lista, o jogo não crasha
	if lista_de_caixas.size() == 0:
		print("Aviso: Adicione as caixas na lista do Inspector!")
		return
		
	# A MÁGICA DO SORTEIO:
	# randi() gera um número gigante aleatório. 
	# O '%' limita esse número ao tamanho da sua lista (de 0 a 3, se tiver 4 caixas).
	var indice_aleatorio = randi() % lista_de_caixas.size()
	
	# Pega a cena sorteada e instancia ela
	var nova_caixa = lista_de_caixas[indice_aleatorio].instantiate()
	
	get_parent().add_child.call_deferred(nova_caixa)
	nova_caixa.global_position = posicao_spawn

func coletar_caixa() -> void:
	var caixa = caixa_pronta_para_coleta
	caixa.reparent(empilhadeira_na_area.sprite_pallet, true)
	
	# Posição local perfeita no garfo
	caixa.position = Vector2(40, -10) 
	
	empilhadeira_na_area.segurando_caixa = true
	caixa_pronta_para_coleta = null
	print("Caixa coletada sem física pesada!")
	
	await get_tree().create_timer(3.0).timeout
	spawnar_caixa_na_esteira()
