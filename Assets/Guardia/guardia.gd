extends Node2D

@export var dialogo : DialogueResource
@export var radio_scene : PackedScene

var jugador_cerca = false
var ya_entrego_radio = false

func _process(delta):

	if jugador_cerca and Input.is_action_just_pressed("Pickup"):

		if !ya_entrego_radio:

			ya_entrego_radio = true

			var balloon = DialogueManager.show_dialogue_balloon(dialogo)

			await balloon.tree_exited

			entregar_radio()


func entregar_radio():

	var radio = radio_scene.instantiate()
	get_parent().add_child(radio)

	radio.global_position = global_position + Vector2(0, 50)

func _on_area_guardia_body_entered(body: Node2D):
	if body.is_in_group("player"):
		jugador_cerca = true


func _on_area_guardia_body_exited(body: Node2D):
	if body.is_in_group("player"):
		jugador_cerca = false
