extends CanvasLayer

@onready var painel = $PanelContainer
@onready var label_titulo = $PanelContainer/VBoxContainer/Titulo
@onready var label_status = $PanelContainer/VBoxContainer/Status
@onready var botao_menu = $PanelContainer/VBoxContainer/BotaoMenu

func _ready() -> void:
	hide()
	estilizar_tela()

func mostrar_tela(venceu: bool, pontos: int = 0) -> void:
	show()
	get_tree().paused = true
	
	if venceu:
		label_titulo.text = "VITÓRIA!"
		label_titulo.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
		label_status.text = "Você consertou os itens a tempo!\nPontos ganhos: " + str(pontos)
	else:
		label_titulo.text = "GAME OVER"
		label_titulo.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))
		label_status.text = "O tempo acabou e a produção falhou!"

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://levels/Menu/menuPrincipal.tscn")

func estilizar_tela() -> void:
	var estilo_painel = StyleBoxFlat.new()
	estilo_painel.bg_color = Color(0.12, 0.12, 0.12, 1.0) 
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
	
	label_titulo.add_theme_font_size_override("font_size", 48)
	label_titulo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
	label_titulo.add_theme_constant_override("shadow_offset_y", 4)
	label_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	label_status.add_theme_font_size_override("font_size", 24)
	label_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var estilo_btn_normal = StyleBoxFlat.new()
	estilo_btn_normal.bg_color = Color(0.3, 0.3, 0.3, 1.0)
	estilo_btn_normal.corner_radius_top_left = 12
	estilo_btn_normal.corner_radius_top_right = 12
	estilo_btn_normal.corner_radius_bottom_left = 12
	estilo_btn_normal.corner_radius_bottom_right = 12
	botao_menu.add_theme_stylebox_override("normal", estilo_btn_normal)
	
	var estilo_btn_hover = estilo_btn_normal.duplicate()
	estilo_btn_hover.bg_color = Color(0.4, 0.4, 0.4, 1.0) 
	botao_menu.add_theme_stylebox_override("hover", estilo_btn_hover)
