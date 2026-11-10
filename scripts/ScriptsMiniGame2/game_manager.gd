extends Node

var pontuacao: int = 0
var itens_consertados: int = 0

@export var tela_final: Control
@export var label_calculo_final: RichTextLabel
@export var botao_voltar: BaseButton # Permite tanto Button quanto TextureButton

# --- VARIÁVEIS DO ARCADE ---
var tempo_arcade: float = 5.0
var contando_arcade: bool = false
var texto_base_final: String = ""

func _ready() -> void:
	add_to_group("Manager")
	# Garante que esse script continue rodando mesmo com o jogo pausado!
	process_mode = Node.PROCESS_MODE_ALWAYS 

func _process(delta: float) -> void:
	if contando_arcade:
		tempo_arcade -= delta
		var segundos = int(ceil(tempo_arcade))
		
		var texto_arcade = "\n[wave amp=30 freq=5][color=yellow][b]PONTUAÇÃO GLOBAL ARCADE: " + str(ArcadeManager.pontuacao_total) + " PTS[/b][/color][/wave]\n"
		var texto_cronometro = "\n[color=aqua][b]PRÓXIMO JOGO EM: " + str(segundos) + "s[/b][/color]\n"
		
		# Atualiza a tela a cada frame com os segundos caindo
		if label_calculo_final:
			label_calculo_final.text = texto_base_final + texto_arcade + texto_cronometro + "[/center]"
			
		if tempo_arcade <= 0:
			contando_arcade = false
			get_tree().paused = false
			ArcadeManager.proxima_fase()

func adicionar_ponto(pontos: int) -> void:
	pontuacao += pontos
	itens_consertados += 1

func fim_de_jogo(tempo_restante: int) -> void:
	get_tree().paused = true 
	
	if tela_final:
		tela_final.visible = true
		
	var bonus_tempo = 0
	if tempo_restante > 0:
		bonus_tempo = tempo_restante * 5
		
	var pontuacao_total = pontuacao + bonus_tempo
	ArcadeManager.registrar_pontos(pontuacao_total)
	
	# Salva a parte fixa do texto para juntarmos com o cronômetro depois
	texto_base_final = (
		"[center]" +
		"[color=gray]--------------------------------------------------[/color]\n\n" +
		"Itens Consertados: [color=green][b]" + str(itens_consertados) + "[/b][/color]\n" +
		"Pontos por Consertos: [color=yellow][b]" + str(pontuacao) + " pts[/b][/color]\n" +
		"Tempo Restante: [color=aqua][b]" + str(tempo_restante) + "s[/b][/color]\n" +
		"Bônus de Velocidade: [color=orange][b]+" + str(bonus_tempo) + " pts[/b][/color]\n\n" +
		"[color=gray]--------------------------------------------------[/color]\n\n" +
		"[font_size=26][b][color=gold]TOTAL DA FASE: " + str(pontuacao_total) + " PTS[/color][/b][/font_size]\n"
	)
	
	if ArcadeManager.modo_arcade:
		if botao_voltar:
			botao_voltar.hide() # Some com o botão de voltar!
		contando_arcade = true
		tempo_arcade = 5.0
	else:
		# Lógica Normal (Avulso)
		if botao_voltar:
			botao_voltar.show() 
		if label_calculo_final:
			label_calculo_final.text = texto_base_final + "[/center]"

func _on_botao_voltar_pressed() -> void:
	get_tree().paused = false 
	if not ArcadeManager.modo_arcade:
		get_tree().change_scene_to_file("res://levels/Menu/gridGames.tscn")
