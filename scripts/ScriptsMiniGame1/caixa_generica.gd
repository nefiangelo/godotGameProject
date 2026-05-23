extends Area2D

const VELOCIDADE_ESTEIRA = -120.0 # Velocidade limpa de movimento
var na_esteira = true

func _physics_process(delta: float) -> void:
	if na_esteira:
		# Move a caixa para a esquerda usando matemática simples, sem forças físicas
		position.x += VELOCIDADE_ESTEIRA * delta

func parar_na_esteira() -> void:
	na_esteira = false
