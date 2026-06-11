extends Area2D
signal interactuado
var jugador_cerca := false

func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("Pickup"):
		interactuado.emit()

func _on_body_entered(body):
	if body.is_in_group("player"):
		jugador_cerca = true
		print("Puede interactuar")
		
		var ui = get_tree().get_first_node_in_group("ui_interaccion")
		if ui:
			ui.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
		print("Se alejó")
		var ui = get_tree().get_first_node_in_group("ui_interaccion")
		if ui:
			ui.visible = false
