extends Node

var pontos_da_fase: int = 0

func adicionar_pontos(pontos: int) -> void:
	pontos_da_fase += pontos
	print("GameManager M2 -> Pontos recebidos: ", pontos)

func calcular_pontos_vitoria(tempo_restante: float) -> int:
	# Bônus de vitória: 10 pontos por segundo que sobrou no cronômetro
	return int(tempo_restante) * 10
