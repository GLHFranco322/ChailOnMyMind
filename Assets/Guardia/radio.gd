extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Jugador"):
		print("Has obtenido la radio")
		queue_free()
