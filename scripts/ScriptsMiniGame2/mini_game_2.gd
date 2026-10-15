extends Node2D

@export var itens_possiveis: Array[PackedScene]
@onready var spawns = [$SpawnUm, $SpawnDois, $SpawnTres]

# Novas variáveis para controlar a inteligência e velocidade da esteira
var ultimo_spawn = null
var velocidade_esteira: float = 100.0 # Velocidade inicial
var taxa_aceleracao: float = 2.0 # O quanto a velocidade aumenta por segundo

func _process(delta: float) -> void:
	# Aumenta a velocidade da esteira constantemente a cada frame
	velocidade_esteira += taxa_aceleracao * delta

func _on_timer_timeout() -> void:
	if itens_possiveis.is_empty():
		return
		
	# 1. Sorteia e cria a cópia do item
	var cena_sorteada = itens_possiveis.pick_random()
	var novo_item = cena_sorteada.instantiate()
	
	# 2. SPAWN INTELIGENTE: Cria uma cópia da lista de spawns e remove o último usado
	var spawns_disponiveis = spawns.duplicate()
	if ultimo_spawn != null:
		spawns_disponiveis.erase(ultimo_spawn)
		
	# Sorteia apenas entre os que sobraram, garantindo que não repita a mesma esteira seguida
	var spawn_sorteado = spawns_disponiveis.pick_random()
	ultimo_spawn = spawn_sorteado # Atualiza a memória de qual foi o último
	
	# 3. Posiciona o item
	novo_item.global_position = spawn_sorteado.global_position
	
	# 4. ACELERAÇÃO: Passa a velocidade atualizada da esteira para o item
	novo_item.velocidade_descida = velocidade_esteira
	
	# 5. Adiciona na tela
	add_child(novo_item)
