extends StaticBody2D

var abierta = false
@onready var collision = $CollisionShape2D
@onready var luz = $PointLight2D

@export var dialogue_resource: DialogueResource

var jugador

func _ready():
	$AreaInteraccion.interactuado.connect(_on_interactuado)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_interactuado():
	jugador = get_tree().get_first_node_in_group("player")
	if abierta:
		return

	jugador.bloquear_movimiento(true)
	
	DialogueManager.show_dialogue_balloon(dialogue_resource)
	
func _on_dialogue_ended(_resource):
	if jugador:
		jugador.bloquear_movimiento(false)

func toggle_puerta():
	abierta = !abierta
	$CollisionShape2D.disabled = abierta
	if abierta:
		$Sprite2D.hide()
		luz.abrir()
		# Desactivar interacción
		$AreaInteraccion.monitoring = false
		
	else:
		$Sprite2D.show()
		luz.cerrar()
	print("PUERTA:", abierta)

func get_camera_position():
	return collision.global_position


func _on_area_2d_body_entered(body: Node2D):
	if abierta and body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/Cinematicas/Escape/cinematica_escape.tscn")
