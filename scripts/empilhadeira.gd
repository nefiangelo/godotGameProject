extends CharacterBody2D

# Configurações da Empilhadeira
const SPEED = 300.0
const VELOCIDADE_PLACA = 150.0

const LIMITE_ALTO = -120.0 
const LIMITE_BAIXO = 20.0 

@onready var sprite_pallet = $spritePallete
@onready var colisao_pallet = $collisionPallete

# 1. Nova variável para guardar a diferença de altura entre eles
var diferenca_y: float

func _ready() -> void:
	# 2. Quando o jogo abre, ele anota a diferença exata entre a Colisão e o Sprite
	diferenca_y = colisao_pallet.position.y - sprite_pallet.position.y

func _physics_process(delta: float) -> void:
	# --- 1. FÍSICA E MOVIMENTO DA EMPILHADEIRA ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# --- 2. MOVIMENTO DA PLACA (ELEVADOR) ---
	var direcao_placa := Input.get_axis("ui_up", "ui_down")
	
	if direcao_placa != 0:
		sprite_pallet.position.y += direcao_placa * VELOCIDADE_PLACA * delta
		sprite_pallet.position.y = clamp(sprite_pallet.position.y, LIMITE_ALTO, LIMITE_BAIXO)
		
		# 3. A MÁGICA CORRIGIDA: A colisão copia a posição do sprite, 
		# mas SOMA a diferença original para manter o encaixe perfeito!
		colisao_pallet.position.y = sprite_pallet.position.y + diferenca_y
