extends StaticBody2D

var abierta = false
@onready var collision = $CollisionShape2D
@onready var luz = $PointLight2D

func toggle_puerta():
	abierta = !abierta
	$CollisionShape2D.disabled = abierta
	if abierta:
		$Sprite2D.hide()
		luz.abrir()
	else:
		$Sprite2D.show()
		luz.cerrar()
	print("PUERTA:", abierta)

func get_camera_position():
	return collision.global_position


func _on_area_2d_body_entered(body: Node2D):
	if abierta and body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/Cinematicas/Escape/cinematica_escape.tscn")
