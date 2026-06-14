extends Node2D

@onready var vida_bar = $UI/VidaBar
@onready var jugador = $Jugador
@onready var botonFinal = $BotonFinal
@onready var line_black_collision = $Mapa/LineBlack/CollisionShape2D
@onready var marker_principal = $MarkerPrincipal
@export var zombie_scene: PackedScene = preload("res://Scenes/zombie.tscn")

func _ready() -> void:
	# Empieza sin colisión
	line_black_collision.disabled = true
	
	for marker in marker_principal.get_children():
		if marker is Marker2D:
			var zombie = zombie_scene.instantiate()
			zombie.global_position = marker.global_position
			zombie.scale = Vector2(0.7, 0.7)
			add_child(zombie)


func _process(delta: float) -> void:
	
	vida_bar.value = jugador.vidaJugador
	



func activar_blackline():
		# Activar la colisión una sola vez cuando se use el botón
	if botonFinal.usado and line_black_collision.disabled:
		line_black_collision.disabled = false
		
