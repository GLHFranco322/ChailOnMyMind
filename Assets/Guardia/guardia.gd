extends Node2D

@export var dialogo : DialogueResource

var jugador_cerca = false

func _process(_delta):

	if !jugador_cerca:
		return

	if Input.is_action_just_pressed("Pickup"):

		var balloon = DialogueManager.show_dialogue_balloon(dialogo)

		await balloon.tree_exited


func _on_area_guardia_body_entered(body):

	if body.is_in_group("player"):
		jugador_cerca = true


func _on_area_guardia_body_exited(body):

	if body.is_in_group("player"):
		jugador_cerca = false
