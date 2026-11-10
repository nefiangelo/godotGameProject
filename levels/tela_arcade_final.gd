extends Control

@onready var fundo_azul = $ColorRect
@onready var painel = $PanelContainer
@onready var label_titulo = $PanelContainer/VBoxContainer/Titulo
@onready var label_status = $PanelContainer/VBoxContainer/Status
@onready var botao_menu = $PanelContainer/VBoxContainer/BotaoMenu

var tempo_animacao: float = 0.0
var posicao_original_y: float = 0.0

func _ready() -> void:
	estilizar_tela()
	
	if label_titulo:
		posicao_original_y = label_titulo.position.y
		label_titulo.text = "FIM DO ARCADE!"
		label_titulo.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2)) # Dourado
		
	if label_status:
		# AS DUAS LINHAS QUE SALVAM O TEXTO:
		label_status.bbcode_enabled = true
		label_status.fit_content = true
		
		# Puxa o total de minigames jogados e a pontuação somada do Autoload
		label_status.text = (
			"[center]" +
			"[color=white]Você completou a jornada![/color]\n\n" +
			"[color=gray]--------------------------------------------------[/color]\n\n" +
			"Minigames Concluídos: [color=aqua][b]" + str(ArcadeManager.indice_atual) + "[/b][/color]\n\n" +
			"[wave amp=40 freq=4][font_size=32][b][color=gold]PONTUAÇÃO GLOBAL: " + str(ArcadeManager.pontuacao_total) + " PTS[/color][/b][/font_size][/wave]\n\n" +
			"[color=gray]--------------------------------------------------[/color]\n" +
            "[/center]"
		)

func _process(delta: float) -> void:
	# Efeito "minhoca" flutuante no título
	if label_titulo:
		tempo_animacao += delta * 8.0
		var deslocamento = sin(tempo_animacao) * 6.0
		label_titulo.position.y = posicao_original_y + deslocamento

# Lembre-se de conectar o sinal pressed() do BotaoMenu aqui!
func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Menu/menuPrincipal.tscn")

func estilizar_tela() -> void:
	# 1. Cor do Fundo
	if fundo_azul:
		fundo_azul.color = Color(0.05, 0.15, 0.3, 1.0) # Azul Escuro Estiloso
		
	# 2. Estilo do HUD Central
	var estilo_painel = StyleBoxFlat.new()
	estilo_painel.bg_color = Color(0.12, 0.12, 0.12, 0.95) 
	estilo_painel.border_width_bottom = 8
	estilo_painel.border_color = Color(0.05, 0.05, 0.05, 1.0) 
	estilo_painel.corner_radius_top_left = 24
	estilo_painel.corner_radius_top_right = 24
	estilo_painel.corner_radius_bottom_left = 24
	estilo_painel.corner_radius_bottom_right = 24
	estilo_painel.content_margin_left = 60
	estilo_painel.content_margin_top = 40
	estilo_painel.content_margin_right = 60
	estilo_painel.content_margin_bottom = 40
	painel.add_theme_stylebox_override("panel", estilo_painel)
	
	# 3. Textos e Sombras
	label_titulo.add_theme_font_size_override("font_size", 56)
	label_titulo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
	label_titulo.add_theme_constant_override("shadow_offset_y", 4)
	label_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# 4. Estilo do Botão Voltar
	var estilo_btn_normal = StyleBoxFlat.new()
	estilo_btn_normal.bg_color = Color(0.2, 0.4, 0.8, 1.0) # Azul corporativo/Arcade
	estilo_btn_normal.corner_radius_top_left = 12
	estilo_btn_normal.corner_radius_top_right = 12
	estilo_btn_normal.corner_radius_bottom_left = 12
	estilo_btn_normal.corner_radius_bottom_right = 12
	estilo_btn_normal.content_margin_top = 10
	estilo_btn_normal.content_margin_bottom = 10
	botao_menu.add_theme_stylebox_override("normal", estilo_btn_normal)
	
	var estilo_btn_hover = estilo_btn_normal.duplicate()
	estilo_btn_hover.bg_color = Color(0.3, 0.5, 0.9, 1.0) # Clareia ao passar o mouse
	botao_menu.add_theme_stylebox_override("hover", estilo_btn_hover)
