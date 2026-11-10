extends Control # ou CanvasLayer, dependendo de como você configurou o nó raiz!

@onready var fundo_azul = $ColorRect
@onready var painel = $PanelContainer
@onready var label_titulo = $PanelContainer/VBoxContainer/Titulo
@onready var label_status = $PanelContainer/VBoxContainer/Status
@onready var botao_menu = $PanelContainer/VBoxContainer/BotaoMenu

func _ready() -> void:
	estilizar_tela()
	
	if label_titulo:
		label_titulo.text = "FIM DO ARCADE!"
		label_titulo.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3)) # Ouro vibrante e fixo
		
	if label_status:
		label_status.bbcode_enabled = true
		label_status.fit_content = true
		
		# O efeito [wave] foi adicionado APENAS na parte do "PONTUAÇÃO GLOBAL"
		label_status.text = (
			"[center]" +
			"[font_size=26][color=#87cefa]Você completou a jornada![/color][/font_size]\n\n" +
			"[color=#333333]━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[/color]\n\n" +
			"[font_size=22][color=gray]Minigames Concluídos:[/color] [b][color=aqua]" + str(ArcadeManager.indice_atual) + "[/color][/b][/font_size]\n\n" +
			"[wave amp=30 freq=4][font_size=42][b][color=gold]PONTUAÇÃO GLOBAL\n" + str(ArcadeManager.pontuacao_total) + " PTS[/color][/b][/font_size][/wave]\n\n" +
			"[color=#333333]━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[/color]\n" +
            "[/center]"
		)

func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Menu/menuPrincipal.tscn")

func estilizar_tela() -> void:
	# 1. Cor do Fundo
	if fundo_azul:
		fundo_azul.color = Color(0.04, 0.08, 0.15, 1.0) 
		
	# 2. Estilo do HUD Central
	var estilo_painel = StyleBoxFlat.new()
	estilo_painel.bg_color = Color(0.10, 0.10, 0.12, 0.98) 
	estilo_painel.border_width_bottom = 8
	estilo_painel.border_width_top = 2
	estilo_painel.border_color = Color(0.04, 0.04, 0.05, 1.0) 
	
	estilo_painel.shadow_color = Color(0, 0, 0, 0.7)
	estilo_painel.shadow_size = 40
	estilo_painel.shadow_offset = Vector2(0, 15)
	
	estilo_painel.corner_radius_top_left = 32
	estilo_painel.corner_radius_top_right = 32
	estilo_painel.corner_radius_bottom_left = 32
	estilo_painel.corner_radius_bottom_right = 32
	estilo_painel.content_margin_left = 60
	estilo_painel.content_margin_top = 50
	estilo_painel.content_margin_right = 60
	estilo_painel.content_margin_bottom = 50
	
	if painel:
		painel.add_theme_stylebox_override("panel", estilo_painel)
	
	# 3. Título (Fixo)
	if label_titulo:
		label_titulo.add_theme_font_size_override("font_size", 56)
		label_titulo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
		label_titulo.add_theme_constant_override("shadow_offset_y", 6)
		label_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# 4. Estilo do Botão Voltar
	var estilo_btn_normal = StyleBoxFlat.new()
	estilo_btn_normal.bg_color = Color(0.15, 0.35, 0.75, 1.0) 
	estilo_btn_normal.border_width_bottom = 6
	estilo_btn_normal.border_color = Color(0.08, 0.20, 0.45, 1.0)
	estilo_btn_normal.corner_radius_top_left = 16
	estilo_btn_normal.corner_radius_top_right = 16
	estilo_btn_normal.corner_radius_bottom_left = 16
	estilo_btn_normal.corner_radius_bottom_right = 16
	estilo_btn_normal.content_margin_top = 15
	estilo_btn_normal.content_margin_bottom = 15
	
	if botao_menu:
		botao_menu.add_theme_stylebox_override("normal", estilo_btn_normal)
		
		var estilo_btn_hover = estilo_btn_normal.duplicate()
		estilo_btn_hover.bg_color = Color(0.25, 0.50, 0.95, 1.0) 
		botao_menu.add_theme_stylebox_override("hover", estilo_btn_hover)
		
		botao_menu.add_theme_font_size_override("font_size", 22)
		botao_menu.add_theme_color_override("font_color", Color.WHITE)
