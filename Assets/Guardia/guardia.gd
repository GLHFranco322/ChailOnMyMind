extends Node2D

@export var dialogo : DialogueResource
@export var radio_scene : PackedScene

var jugador_cerca = false

enum Estado {
	HABLAR,
	REVISAR,
	TERMINADO
}

var estado = Estado.HABLAR

@onready var area_interaccion = $AreaInteraccion

func _process(delta):

	if !jugador_cerca:
		return

	match estado:

		Estado.HABLAR:

			if Input.is_action_just_pressed("Pickup"):

				var balloon = DialogueManager.show_dialogue_balloon(dialogo)

				await balloon.tree_exited

				estado = Estado.REVISAR

				area_interaccion.accion = "revisar al guardia"

				if area_interaccion.has_overlapping_bodies():
					area_interaccion.ui.mostrar(
						"Presiona [ E ] para revisar al guardia"
					)

		Estado.REVISAR:

			if Input.is_action_just_pressed("Pickup"):

				soltar_radio()

				area_interaccion.ui.ocultar()

				area_interaccion.queue_free()

				estado = Estado.TERMINADO


func _on_area_guardia_body_entered(body):

	if body.is_in_group("player"):
		jugador_cerca = true


func _on_area_guardia_body_exited(body):

	if body.is_in_group("player"):
		jugador_cerca = false


func soltar_radio():

	if radio_scene == null:
		print("No asignaste la radio")
		return

	var radio = radio_scene.instantiate()

	get_parent().add_child(radio)

	radio.global_position = global_position + Vector2(25, 50)
