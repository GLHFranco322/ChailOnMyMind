extends Node2D

@export var radio_scene: PackedScene

var jugador_cerca = false
var revisado = false

func _process(delta):
	if jugador_cerca and !revisado:
		if Input.is_action_just_pressed("interact"):
			revisar_guardia()

func revisar_guardia():
	revisado = true

	print("Has revisado al guardia.")

	# Crear radio
	if radio_scene:
		var radio = radio_scene.instantiate()
		get_parent().add_child(radio)
		radio.global_position = global_position + Vector2(20, 0)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true
		print("Presiona E para revisar al guardia")

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
