extends Node

var modo_arcade: bool = false
var pontuacao_total: int = 0
var ordem_dos_jogos: Array = []
var indice_atual: int = 0

# Substitua pelos caminhos EXATOS das suas cenas de minigame!
var caminho_jogo1 = "res://levels/Minigames/MiniGame1/Minigame1.tscn" 
var caminho_jogo2 = "res://levels/Minigames/MiniGame2/Minigame2.tscn"

func iniciar_arcade() -> void:
	modo_arcade = true
	pontuacao_total = 0
	indice_atual = 0
	
	ordem_dos_jogos = [caminho_jogo1, caminho_jogo2]
	ordem_dos_jogos.shuffle()
	
	# call_deferred garante uma transição segura e sem engasgos
	get_tree().call_deferred("change_scene_to_file", ordem_dos_jogos[0])

func registrar_pontos(pontos_da_fase: int) -> void:
	if modo_arcade:
		pontuacao_total += pontos_da_fase

func proxima_fase() -> void:
	indice_atual += 1
	
	if indice_atual < ordem_dos_jogos.size():
		# Ainda tem jogo na lista, carrega o próximo com segurança!
		get_tree().call_deferred("change_scene_to_file", ordem_dos_jogos[indice_atual])
	else:
		# Fim do Arcade!
		modo_arcade = false
		
		# 1. VERIFIQUE SE ESTE CAMINHO BATE EXATAMENTE COM O SEU ARQUIVO
		var caminho_pódio = "res://levels/TelaArcadeFinal.tscn"
		
		# 2. Muda de cena com segurança usando call_deferred
		get_tree().call_deferred("change_scene_to_file", caminho_pódio)
		
		# Imprime no console para garantir que o script chegou até aqui
		print("Arcade zerado! Redirecionando para: ", caminho_pódio)
