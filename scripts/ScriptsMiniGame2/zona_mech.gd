extends Area2D

@onready var barra_progresso = $ProgressBar
@onready var timer_conserto = $TimerConserto

var ocupado: bool = false
var id_item_atual: int = 0

# Variável para acessar o estilo do preenchimento e mudar a cor depois, se quiser
var estilo_preenchimento: StyleBoxFlat

func _ready() -> void:
	barra_progresso.hide()
	barra_progresso.max_value = timer_conserto.wait_time
	
	# Chama a função para deixar a barra bonita assim que o jogo começa
	estilizar_barra()

func _process(_delta: float) -> void:
	if ocupado:
		# A barra diminui acompanhando o tempo restante
		barra_progresso.value = timer_conserto.time_left

func receber_item(id_conserto: int) -> bool:
	if ocupado:
		return false 
		
	ocupado = true
	id_item_atual = id_conserto
	barra_progresso.show()
	timer_conserto.start()
	return true

func _on_timer_conserto_timeout() -> void:
	ocupado = false
	barra_progresso.hide()
	
	if get_parent().has_method("consertou_item"):
		get_parent().consertou_item(id_item_atual)

# ---- NOVA FUNÇÃO DE ESTILIZAÇÃO ----
func estilizar_barra() -> void:
	# 1. Estilo do Fundo da Barra (a parte vazia)
	var estilo_fundo = StyleBoxFlat.new()
	estilo_fundo.bg_color = Color(0.15, 0.15, 0.15, 0.9) # Cinza bem escuro
	estilo_fundo.corner_radius_top_left = 6
	estilo_fundo.corner_radius_top_right = 6
	estilo_fundo.corner_radius_bottom_left = 6
	estilo_fundo.corner_radius_bottom_right = 6
	
	# Dá uma pequena margem para o preenchimento não encostar na borda absoluta
	estilo_fundo.expand_margin_left = 2
	estilo_fundo.expand_margin_right = 2
	estilo_fundo.expand_margin_top = 2
	estilo_fundo.expand_margin_bottom = 2

	# 2. Estilo do Preenchimento (a parte que esvazia)
	estilo_preenchimento = StyleBoxFlat.new()
	estilo_preenchimento.bg_color = Color(1.0, 0.7, 0.1, 1.0) # Cor Laranja/Amarelada (estilo "construção")
	estilo_preenchimento.corner_radius_top_left = 4
	estilo_preenchimento.corner_radius_top_right = 4
	estilo_preenchimento.corner_radius_bottom_left = 4
	estilo_preenchimento.corner_radius_bottom_right = 4

	# 3. Aplica os visuais no nó ProgressBar
	barra_progresso.add_theme_stylebox_override("background", estilo_fundo)
	barra_progresso.add_theme_stylebox_override("fill", estilo_preenchimento)
