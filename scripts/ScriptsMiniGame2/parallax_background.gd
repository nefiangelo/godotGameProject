extends ParallaxBackground

var velocidade_atual: float = 0.0

func _process(delta: float) -> void:
	# Apenas empurra o offset com base na velocidade que o minigame determinar
	scroll_offset.y += velocidade_atual * delta
