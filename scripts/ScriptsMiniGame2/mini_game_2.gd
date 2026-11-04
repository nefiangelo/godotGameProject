extends Node2D

@export var itens_possiveis: Array[PackedScene]
@onready var spawns = [$SpawnUm, $SpawnDois, $SpawnTres]

# ---- VARIÁVEIS DO HUD ----
@onready var hud_fundo = $HUD/PanelContainer
@onready var fundo_tempo = $HUD/FundoTempo
@onready var label_titulo = $HUD/PanelContainer/VBoxContainer/TituloHUD
@onready var label_qtd1 = $HUD/PanelContainer/VBoxContainer/LinhaItem1/QtdItem1
@onready var label_qtd2 = $HUD/PanelContainer/VBoxContainer/LinhaItem2/QtdItem2
@onready var label_tempo = $HUD/FundoTempo/TempoTexto

# ---- VARIÁVEIS DE JOGO E CONTROLE ----
@onready var timer_jogo = $TimerJogo
@onready var timer_spawn = $Timer 
@onready var esteira_visual = $ParallaxBackground 

var objetivo_item1: int = 0
var objetivo_item2: int = 0
var jogo_ativo: bool = true

# Variáveis para controlar a esteira e os spawns
var ultimo_spawn = null
var velocidade_esteira: float = 100.0
var taxa_aceleracao: float = 2.0
var tempo_spawn_minimo: float = 0.5
var taxa_reducao_spawn: float = 0.05

func _ready() -> void:
	objetivo_item1 = randi_range(5, 15)
	objetivo_item2 = randi_range(5, 15)
	
	atualizar_textos_hud()
	estilizar_hud()

func atualizar_textos_hud() -> void:
	if label_qtd1 and label_qtd2:
		label_qtd1.text = "x" + str(objetivo_item1)
		label_qtd2.text = "x" + str(objetivo_item2)

func _process(delta: float) -> void:
	if not jogo_ativo:
		return

	# Acelera a descida gradativamente
	velocidade_esteira += taxa_aceleracao * delta
	
	# Faz o cenário rolar na mesma velocidade dos itens
	if esteira_visual:
		esteira_visual.velocidade_atual = velocidade_esteira
		
	# Reduz o tempo de espera para nascer mais itens
	if timer_spawn and timer_spawn.wait_time > tempo_spawn_minimo:
		timer_spawn.wait_time -= taxa_reducao_spawn * delta
	
	# Atualiza o cronômetro
	if label_tempo and timer_jogo:
		var tempo_restante = int(timer_jogo.time_left)
		label_tempo.text = "Tempo: " + str(tempo_restante) + "s"

func _on_timer_timeout() -> void:
	if not jogo_ativo or itens_possiveis.is_empty():
		return
		
	var cena_sorteada = itens_possiveis.pick_random()
	var novo_item = cena_sorteada.instantiate()
	
	var spawns_disponiveis = spawns.duplicate()
	if ultimo_spawn != null:
		spawns_disponiveis.erase(ultimo_spawn)
		
	var spawn_sorteado = spawns_disponiveis.pick_random()
	ultimo_spawn = spawn_sorteado
	
	novo_item.global_position = spawn_sorteado.global_position
	add_child(novo_item)

func _on_timer_jogo_timeout() -> void:
	if jogo_ativo:
		derrota()

func consertou_item(tipo_do_quebrado: int) -> void:
	if not jogo_ativo: return
	
	if tipo_do_quebrado == 1 and objetivo_item1 > 0:
		objetivo_item1 -= 1
	elif tipo_do_quebrado == 2 and objetivo_item2 > 0:
		objetivo_item2 -= 1
		
	atualizar_textos_hud()
	
	if objetivo_item1 == 0 and objetivo_item2 == 0:
		vitoria()

func vitoria() -> void:
	jogo_ativo = false
	var pontos = int(timer_jogo.time_left) * 10 
	
	if has_node("TelaFinal"):
		$TelaFinal.mostrar_tela(true, pontos)
	else:
		print("Erro: Nó 'TelaFinal' não encontrado na cena!")

func derrota() -> void:
	jogo_ativo = false
	
	if has_node("TelaFinal"):
		$TelaFinal.mostrar_tela(false, 0)
	else:
		print("Erro: Nó 'TelaFinal' não encontrado na cena!")

func _on_pause_button_pressed() -> void:
	if has_node("TelaPause"):
		$TelaPause.pausar_jogo()

func estilizar_hud() -> void:
	var estilo_caixa = StyleBoxFlat.new()
	estilo_caixa.bg_color = Color(0, 0, 0, 0.7)
	estilo_caixa.corner_radius_top_left = 16
	estilo_caixa.corner_radius_top_right = 16
	estilo_caixa.corner_radius_bottom_left = 16
	estilo_caixa.corner_radius_bottom_right = 16
	estilo_caixa.content_margin_left = 10
	estilo_caixa.content_margin_top = 10
	estilo_caixa.content_margin_right = 10
	estilo_caixa.content_margin_bottom = 10
	
	if hud_fundo:
		hud_fundo.add_theme_stylebox_override("panel", estilo_caixa)
		
	if fundo_tempo:
		fundo_tempo.add_theme_stylebox_override("panel", estilo_caixa)
		
	if label_titulo:
		label_titulo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
		label_titulo.add_theme_constant_override("shadow_offset_y", 2)
