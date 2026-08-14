extends StaticBody2D

var abierta = false
@onready var collision = $CollisionShape2D
@onready var sonido_puerta = $AudioPuerta

func toggle_puerta():
	abierta = !abierta
	$CollisionShape2D.disabled = abierta
	if abierta:
		$Sprite2D.hide()
		sonido_puerta.play()
	else:
		$Sprite2D.show()
	print("PUERTA:", abierta)

func get_camera_position():
	return collision.global_position
