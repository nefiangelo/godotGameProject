extends Node # (ou Node2D, dependendo do tipo do seu nó raiz)

# Referências atualizadas baseadas EXATAMENTE na sua imagem (image_d2078c.png)
@onready var painel_hud = $UI/HUD/PainelHUD
@onready var label_pontuacao = $"UI/HUD/PainelHUD/VBoxContainer/Pontuação"
@onready var label_tempo = $UI/HUD/PainelHUD/VBoxContainer/Tempo

func _ready() -> void:
	estilizar_hud()

func estilizar_hud() -> void:
	# 1. Cria a caixa preta translúcida e arredondada
	var estilo_caixa = StyleBoxFlat.new()
	estilo_caixa.bg_color = Color(0, 0, 0, 0.7)
	estilo_caixa.corner_radius_top_left = 16
	estilo_caixa.corner_radius_top_right = 16
	estilo_caixa.corner_radius_bottom_left = 16
	estilo_caixa.corner_radius_bottom_right = 16
	estilo_caixa.content_margin_left = 15
	estilo_caixa.content_margin_top = 15
	estilo_caixa.content_margin_right = 15
	estilo_caixa.content_margin_bottom = 15
	
	# Aplica o estilo diretamente no seu PainelHUD
	if painel_hud:
		painel_hud.add_theme_stylebox_override("panel", estilo_caixa)
		
	# 2. Adiciona sombras nos textos para destacar
	if label_pontuacao:
		label_pontuacao.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
		label_pontuacao.add_theme_constant_override("shadow_offset_y", 2)
		
	if label_tempo:
		label_tempo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
		label_tempo.add_theme_constant_override("shadow_offset_y", 2)

# 3. Consertando o Pause
func _on_botao_pause_pressed() -> void:
	# Usa find_child para garantir que vai achar a TelaPause independentemente de onde ela estiver na árvore
	var tela_pause = find_child("TelaPause", true, false)
	if tela_pause:
		tela_pause.pausar_jogo()
	else:
		print("ERRO: O nó 'TelaPause' não foi encontrado na cena!")
