extends Area2D

@export var puerta_path : NodePath

@onready var puerta = get_node(puerta_path)

var player_inside = false
var cinematic = false


func _process(delta):

	if cinematic:
		return

	if player_inside and Input.is_action_just_pressed("Pickup"):

		cinematic = true

		var player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

		var camera = $"../Jugador/Camera2D2"

		# 🔥 bloquear movimiento jugador
		player.set_physics_process(false)

		# 🔥 desactivar seguimiento automático
		#camera.enabled = false

		# ==================================================
		# 🎥 MOVER CÁMARA A LA PUERTA
		# ==================================================

		var tween = create_tween()

		tween.tween_property(
			camera,
			"global_position",
			puerta.get_camera_position(),
			0.5
		)

		await tween.finished

		# ==================================================
		# 🚪 ABRIR / CERRAR PUERTA
		# ==================================================

		puerta.toggle_puerta()

		# esperar 1 segundo
		await get_tree().create_timer(1.0).timeout

		# ==================================================
		# 🎥 VOLVER AL JUGADOR
		# ==================================================

		var tween_back = create_tween()

		tween_back.tween_property(
			camera,
			"global_position",
			player.global_position,
			0.5
		)

		await tween_back.finished

		# 🔥 devolver control cámara
		camera.enabled = true

		# 🔥 devolver movimiento jugador
		player.set_physics_process(true)

		cinematic = false


func _on_body_entered(body):

	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body):

	if body.is_in_group("player"):
		player_inside = false
