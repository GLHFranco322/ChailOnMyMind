extends Area2D

@export var item : Item

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		Inventario.agregar_item(item)
		queue_free()
