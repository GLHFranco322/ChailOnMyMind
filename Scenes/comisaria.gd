extends Node2D

@onready var vida_bar = $UI/VidaBar
@onready var jugador = $Jugador
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	print(vida_bar)
	print(jugador)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vida_bar.value = jugador.vidaJugador
