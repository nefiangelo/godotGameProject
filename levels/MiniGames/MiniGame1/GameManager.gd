extends Node

var pontuacao: int = 0
var tempo_restante: int = 120 # TEMPO DO JOGO
var slots_preenchidos: int = 0
var total_de_slots: int = 0

@export var label_pontos: Label
@export var label_tempo: Label

# --- EXPORTS DA TELA FINAL ---
@export var tela_final: Control
@export var label_calculo_final: RichTextLabel
@export var botao_voltar: BaseButton # Adicionado para sumir com ele no Arcade

# --- VARIÁVEIS DO ARCADE ---
var tempo_arcade: float = 5.0
var contando_arcade: bool = false
var texto_base_final: String = ""

func _ready() -> void:
	add_to_group("Manager")
	# Garante que o script continue processando o tempo mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS 
	
	atualizar_ui()
	
	# Faz a contagem automática baseada no grupo "Slots"
	total_de_slots = get_tree().get_nodes_in_group("Slots").size()
	
	randomize() 
	distribuir_formas_balanceadas()

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

func distribuir_formas_balanceadas() -> void:
	var formas_base = ["triangulo", "quadrado", "circulo", "estrela"]
	var baralho_de_formas = []
	
	# 1. Coloca 3 de CADA forma no baralho (garantindo 12 itens)
	for i in range(3):
		baralho_de_formas.append_array(formas_base)
		
	# 2. Faltam 3 itens para dar 15.
	var formas_extras = formas_base.duplicate()
	formas_extras.shuffle()
	baralho_de_formas.append(formas_extras[0])
	baralho_de_formas.append(formas_extras[1])
	baralho_de_formas.append(formas_extras[2])
	
	# 3. Embaralha tudo!
	baralho_de_formas.shuffle()
	
	# 4. Entrega uma forma pra cada slot
	var todos_os_slots = get_tree().get_nodes_in_group("Slots")
	for i in range(todos_os_slots.size()):
		if i < baralho_de_formas.size():
			todos_os_slots[i].definir_forma(baralho_de_formas[i])

func _on_timer_timeout() -> void:
	# Se o jogo acabar pelo timer, previne que o relógio continue caindo negativamente
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_ui()
		
		if tempo_restante <= 0:
			fim_de_jogo()

func adicionar_ponto() -> void:
	pontuacao += 10
	slots_preenchidos += 1 
	atualizar_ui()
	
	if slots_preenchidos >= total_de_slots:
		fim_de_jogo()

func errar_caixa() -> void:
	pontuacao -= 5
	atualizar_ui()

func atualizar_ui() -> void:
	if label_pontos: label_pontos.text = "Pontos: " + str(pontuacao)
	if label_tempo: label_tempo.text = "Tempo: " + str(tempo_restante)

func fim_de_jogo() -> void:
	if has_node("Timer"):
		$Timer.stop()
	
	get_tree().paused = true 
	
	if tela_final:
		tela_final.visible = true
		
	var bonus_tempo = 0
	if tempo_restante > 0:
		bonus_tempo = tempo_restante * 5
		
	var pontuacao_total = pontuacao + bonus_tempo
	ArcadeManager.registrar_pontos(pontuacao_total)
	
	# Salva a parte fixa do texto para a animação do cronômetro injetar depois
	texto_base_final = (
		"[center]" +
		"[color=gray]--------------------------------------------------[/color]\n\n" +
		"Caixas Organizadas: [color=green][b]" + str(pontuacao / 10) + "[/b][/color]\n" +
		"Pontos por Caixas: [color=yellow][b]" + str(pontuacao) + " pts[/b][/color]\n" +
		"Tempo Restante: [color=aqua][b]" + str(tempo_restante) + "s[/b][/color]\n" +
		"Bônus de Velocidade: [color=orange][b]+" + str(bonus_tempo) + " pts[/b][/color]\n\n" +
		"[color=gray]--------------------------------------------------[/color]\n\n" +
		"[font_size=26][b][color=gold]TOTAL DA FASE: " + str(pontuacao_total) + " PTS[/color][/b][/font_size]\n"
	)
	
	if ArcadeManager.modo_arcade:
		if botao_voltar:
			botao_voltar.hide()
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
