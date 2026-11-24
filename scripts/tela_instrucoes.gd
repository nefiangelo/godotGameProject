extends CanvasLayer

@export_multiline var texto_tutorial: String = ""

# Referências dos nós (garanta que os nomes na sua árvore estejam idênticos a estes)
@onready var painel = $PanelContainer
@onready var label_titulo = $PanelContainer/VBoxContainer/Titulo
@onready var label_texto = $PanelContainer/VBoxContainer/TextoTutorial
@onready var botao_comecar = $PanelContainer/VBoxContainer/BotaoComecar

func _ready() -> void:
	# 1. Congela a fase inteira (timers, física, etc)
	get_tree().paused = true
	show()
	
	# 2. Chama a estilização visual automática
	estilizar_tela()
	
	# 3. Força a ativação do BBCode e insere o texto
	if label_texto:
		label_texto.bbcode_enabled = true
		# label_texto.fit_content = true
		
		if texto_tutorial != "":
			label_texto.text = texto_tutorial
		else:
			label_texto.text = "[center][color=red]Escreva as regras no painel Inspector![/color][/center]"
			
	if label_titulo:
		label_titulo.text = "COMO JOGAR"

func _on_botao_comecar_pressed() -> void:
	# Descongela o jogo e destrói a tela de tutorial
	get_tree().paused = false
	queue_free()

func estilizar_tela() -> void:
	# 1. Estilo do Painel (Fundo escuro e arredondado)
	if painel:
		var estilo_painel = StyleBoxFlat.new()
		estilo_painel.bg_color = Color(0.12, 0.12, 0.12, 0.95)
		estilo_painel.border_width_bottom = 6
		estilo_painel.border_color = Color(0.05, 0.05, 0.05, 1.0)
		estilo_painel.corner_radius_top_left = 24
		estilo_painel.corner_radius_top_right = 24
		estilo_painel.corner_radius_bottom_left = 24
		estilo_painel.corner_radius_bottom_right = 24
		estilo_painel.content_margin_left = 40
		estilo_painel.content_margin_top = 40
		estilo_painel.content_margin_right = 40
		estilo_painel.content_margin_bottom = 40
		painel.add_theme_stylebox_override("panel", estilo_painel)
		
	# 2. Estilo do Título
	if label_titulo:
		label_titulo.add_theme_font_size_override("font_size", 48)
		label_titulo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
		label_titulo.add_theme_constant_override("shadow_offset_y", 4)
		label_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
	# 3. Estilo do Botão Começar (Verde)
	if botao_comecar:
		var estilo_btn = StyleBoxFlat.new()
		estilo_btn.bg_color = Color(0.2, 0.6, 0.2, 1.0) 
		estilo_btn.corner_radius_top_left = 12
		estilo_btn.corner_radius_top_right = 12
		estilo_btn.corner_radius_bottom_left = 12
		estilo_btn.corner_radius_bottom_right = 12
		estilo_btn.content_margin_top = 15
		estilo_btn.content_margin_bottom = 15
		botao_comecar.add_theme_stylebox_override("normal", estilo_btn)
		
		var estilo_btn_hover = estilo_btn.duplicate()
		estilo_btn_hover.bg_color = Color(0.3, 0.7, 0.3, 1.0)
		botao_comecar.add_theme_stylebox_override("hover", estilo_btn_hover)
