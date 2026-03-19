extends CharacterBody2D

const SPEED = 200.0

func _physics_process(_delta: float) -> void:
	# Pega as 4 direções de uma vez só! (Setinhas ou WASD)
	# O get_vector já normaliza a velocidade na diagonal pra ele não correr mais rápido
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		# Se estiver apertando alguma tecla, aplica a velocidade
		velocity = direction * SPEED
	else:
		# Se soltar as teclas, freia o boneco até parar
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	# Tenta mover. Se bater em qualquer coisa, ele desliza pela lateral (parede)
	move_and_slide()
