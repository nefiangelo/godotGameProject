extends CharacterBody2D

# Configurações da Empilhadeira
const SPEED = 300.0
const VELOCIDADE_PLACA = 150.0

const LIMITE_ALTO = -300.0 
const LIMITE_BAIXO = 20.0 

@onready var sprite_pallet = $spritePallete
@onready var colisao_pallet = $collisionPallete

var diferenca_y: float
var segurando_caixa: bool = false # Mantém essa variável aqui!

func _ready() -> void:
	diferenca_y = colisao_pallet.position.y - sprite_pallet.position.y

func _physics_process(delta: float) -> void:
	# --- FÍSICA E MOVIMENTO ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# --- MOVIMENTO DA PLACA ---
	var direcao_placa := Input.get_axis("ui_up", "ui_down")
	
	if direcao_placa != 0:
		sprite_pallet.position.y += direcao_placa * VELOCIDADE_PLACA * delta
		sprite_pallet.position.y = clamp(sprite_pallet.position.y, LIMITE_ALTO, LIMITE_BAIXO)
		colisao_pallet.position.y = sprite_pallet.position.y + diferenca_y
