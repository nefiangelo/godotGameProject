extends Node

var pontuacao: int = 0
var tempo_restante: int = 120 #TEMPO DO JOGO
var slots_preenchidos: int = 0
var total_de_slots: int = 0

@export var label_pontos: Label
@export var label_tempo: Label

func _ready() -> void:
	add_to_group("Manager")
	atualizar_ui()
	
	# Faz a contagem automática baseada no grupo "Slots" que criamos antes!
	total_de_slots = get_tree().get_nodes_in_group("Slots").size()
	
	randomize() # Importante para embaralhar direito
	distribuir_formas_balanceadas()

func distribuir_formas_balanceadas() -> void:
	var formas_base = ["triangulo", "quadrado", "circulo", "estrela"]
	var baralho_de_formas = []
	
	# 1. Coloca 3 de CADA forma no baralho (garantindo 12 itens)
	for i in range(3):
		baralho_de_formas.append_array(formas_base)
		
	# 2. Faltam 3 itens para dar 15. Vamos sortear 3 formas diferentes para completar
	var formas_extras = formas_base.duplicate()
	formas_extras.shuffle()
	baralho_de_formas.append(formas_extras[0])
	baralho_de_formas.append(formas_extras[1])
	baralho_de_formas.append(formas_extras[2])
	
	# 3. Agora o baralho tem 15 formas. Vamos embaralhar tudo!
	baralho_de_formas.shuffle()
	
	# 4. Pega todos os slots que colocamos no grupo "Slots" e entrega uma forma pra cada
	var todos_os_slots = get_tree().get_nodes_in_group("Slots")
	
	for i in range(todos_os_slots.size()):
		# Prevenção de erro caso você coloque mais slots que o baralho
		if i < baralho_de_formas.size():
			todos_os_slots[i].definir_forma(baralho_de_formas[i])

# O sinal 'timeout' do seu nó Timer deve ser conectado aqui!
func _on_timer_timeout() -> void:
	tempo_restante -= 1
	atualizar_ui()
	
	if tempo_restante <= 0:
		fim_de_jogo()

func adicionar_ponto() -> void:
	pontuacao += 10
	slots_preenchidos += 1 # Adiciona +1 na contagem de caixas guardadas
	atualizar_ui()
	
	# Verifica se já preencheu todas as prateleiras
	if slots_preenchidos >= total_de_slots:
		fim_de_jogo()

func errar_caixa() -> void:
	# Punição por errar (perde tempo ou perde ponto, você decide!)
	pontuacao -= 5
	atualizar_ui()

func atualizar_ui() -> void:
	if label_pontos: label_pontos.text = "Pontos: " + str(pontuacao)
	if label_tempo: label_tempo.text = "Tempo: " + str(tempo_restante)

# --- EXPORTS DA TELA FINAL (Atualizado para RichTextLabel) ---
@export var tela_final: Control
@export var label_calculo_final: RichTextLabel

func fim_de_jogo() -> void:
	$Timer.stop()
	
	# 1. Pausa o jogo para a empilhadeira parar de andar no fundo
	get_tree().paused = true 
	
	# 2. Faz a tela de resultados aparecer magicamente
	if tela_final:
		tela_final.visible = true
		
	# 3. O CÁLCULO FINAL: Vamos dar pontos extras se o jogador guardou tudo antes do tempo acabar!
	var bonus_tempo = 0
	
	# Se o jogador terminou antes de zerar o relógio (ex: limpou todos os 15 slots)
	if tempo_restante > 0:
		bonus_tempo = tempo_restante * 5 # Cada segundo economizado vale 5 pontos!
		
	var pontuacao_total = pontuacao + bonus_tempo
	
	# 4. Montando o texto estilizado com BBCode (Cores, Tamanhos e Animação de Onda!)
	if label_calculo_final:
		label_calculo_final.text = (
			"[center]" +
			"[color=gray]--------------------------------------------------[/color]\n\n" +
			"Caixas Organizadas: [color=green][b]" + str(pontuacao / 10) + "[/b][/color]\n" +
			"Pontos por Caixas: [color=yellow][b]" + str(pontuacao) + " pts[/b][/color]\n" +
			"Tempo Restante: [color=aqua][b]" + str(tempo_restante) + "s[/b][/color]\n" +
			"Bônus de Velocidade: [color=orange][b]+" + str(bonus_tempo) + " pts[/b][/color]\n\n" +
			"[color=gray]--------------------------------------------------[/color]\n\n" +
			"[wave amp=40 freq=4][font_size=26][b][color=gold]TOTAL: " + str(pontuacao_total) + " PTS[/color][/b][/font_size][/wave]" +
			"[/center]"
		)

# Conecte o sinal 'pressed' do seu BotaoVoltar aqui!
func _on_botao_voltar_pressed() -> void:
	# MUITO IMPORTANTE: Despausar o motor do jogo antes de mudar de cena, senão o menu principal vai nascer travado!
	get_tree().paused = false
	
	# Troque "res://menu_principal.tscn" pelo caminho exato da sua cena de seleção de minigames
	get_tree().change_scene_to_file("res://levels/Menu/gridGames.tscn")
