extends Node2D

@onready var vida_bar = $UI/VidaBar
@onready var jugador = $Jugador
@onready var botonFinal = $BotonFinal
@onready var line_black_collision = $LineBlack/CollisionShape2D


func _ready() -> void:
	# Empieza sin colisión
	line_black_collision.disabled = true


func _process(delta: float) -> void:
	
	vida_bar.value = jugador.vidaJugador
	



func activar_blackline():
		# Activar la colisión una sola vez cuando se use el botón
	if botonFinal.usado and line_black_collision.disabled:
		line_black_collision.disabled = false
		
