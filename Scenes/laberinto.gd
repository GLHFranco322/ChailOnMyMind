extends Node2D

@onready var player = $Jugador
@onready var vida_bar = $CanvasLayer/BarraVida



func _process(_delta):

	if player == null:
		return

	if not is_instance_valid(player):
		return

	vida_bar.value = player.vidaJugador
