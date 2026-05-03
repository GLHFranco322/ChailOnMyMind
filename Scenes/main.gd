extends Node2D

@onready var player = $Jugador
@onready var vida_bar = $CanvasLayer/BarraVida

func _process(delta):
	vida_bar.value = player.vidaJugador
