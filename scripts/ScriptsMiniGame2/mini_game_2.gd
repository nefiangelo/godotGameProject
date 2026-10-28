extends Node2D

@export var itens_possiveis: Array[PackedScene]
@onready var spawns = [$SpawnUm, $SpawnDois, $SpawnTres]

# ---- VARIÁVEIS DO HUD ----
@onready var hud_fundo = $HUD/PanelContainer
@onready var fundo_tempo = $HUD/FundoTempo
@onready var label_titulo = $HUD/PanelContainer/VBoxContainer/TituloHUD
@onready var label_qtd1 = $HUD/PanelContainer/VBoxContainer/LinhaItem1/QtdItem1
@onready var label_qtd2 = $HUD/PanelContainer/VBoxContainer/LinhaItem2/QtdItem2
@onready var label_tempo = $HUD/FundoTempo/TempoTexto

# ---- VARIÁVEIS DE JOGO ----
@onready var timer_jogo = $TimerJogo
var objetivo_item1: int = 0
var objetivo_item2: int = 0
var jogo_ativo: bool = true

# Variáveis para controlar a esteira
var ultimo_spawn = null
var velocidade_esteira: float = 100.0
var taxa_aceleracao: float = 2.0

func _ready() -> void:
    objetivo_item1 = randi_range(5, 15)
    objetivo_item2 = randi_range(5, 15)
    
    atualizar_textos_hud()
    estilizar_hud()

func atualizar_textos_hud() -> void:
    if label_qtd1 and label_qtd2:
        label_qtd1.text = "x" + str(objetivo_item1)
        label_qtd2.text = "x" + str(objetivo_item2)

func _process(delta: float) -> void:
    if not jogo_ativo:
        return

    velocidade_esteira += taxa_aceleracao * delta
    
    if label_tempo and timer_jogo:
        var tempo_restante = int(timer_jogo.time_left)
        label_tempo.text = "Tempo: " + str(tempo_restante) + "s"

func _on_timer_timeout() -> void:
    if not jogo_ativo or itens_possiveis.is_empty():
        return
        
    var cena_sorteada = itens_possiveis.pick_random()
    var novo_item = cena_sorteada.instantiate()
    
    var spawns_disponiveis = spawns.duplicate()
    if ultimo_spawn != null:
        spawns_disponiveis.erase(ultimo_spawn)
        
    var spawn_sorteado = spawns_disponiveis.pick_random()
    ultimo_spawn = spawn_sorteado
    
    novo_item.global_position = spawn_sorteado.global_position
    novo_item.velocidade_descida = velocidade_esteira
    add_child(novo_item)

func _on_timer_jogo_timeout() -> void:
    if jogo_ativo:
        derrota()

func consertou_item(tipo_do_quebrado: int) -> void:
    print("3. O Minigame recebeu o ID: ", tipo_do_quebrado)
    
    if not jogo_ativo: return
    
    if tipo_do_quebrado == 1 and objetivo_item1 > 0:
        objetivo_item1 -= 1
    elif tipo_do_quebrado == 2 and objetivo_item2 > 0:
        objetivo_item2 -= 1
        
    atualizar_textos_hud()
    print("4. Atualizou HUD! Faltam -> Item 1: ", objetivo_item1, " | Item 2: ", objetivo_item2)
    
    if objetivo_item1 == 0 and objetivo_item2 == 0:
        vitoria()

func vitoria() -> void:
    jogo_ativo = false
    print("VITÓRIA! Você consertou tudo a tempo!")

func derrota() -> void:
    jogo_ativo = false
    print("GAME OVER! O tempo acabou.")

func _on_pause_button_pressed() -> void:
    if has_node("TelaPause"):
        $TelaPause.pausar_jogo()

func estilizar_hud() -> void:
    var estilo_caixa = StyleBoxFlat.new()
    estilo_caixa.bg_color = Color(0, 0, 0, 0.7)
    estilo_caixa.corner_radius_top_left = 16
    estilo_caixa.corner_radius_top_right = 16
    estilo_caixa.corner_radius_bottom_left = 16
    estilo_caixa.corner_radius_bottom_right = 16
    estilo_caixa.content_margin_left = 10
    estilo_caixa.content_margin_top = 10
    estilo_caixa.content_margin_right = 10
    estilo_caixa.content_margin_bottom = 10
    
    if hud_fundo:
        hud_fundo.add_theme_stylebox_override("panel", estilo_caixa)
        
    if fundo_tempo:
        fundo_tempo.add_theme_stylebox_override("panel", estilo_caixa)
        
    if label_titulo:
        label_titulo.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
        label_titulo.add_theme_constant_override("shadow_offset_y", 2)
