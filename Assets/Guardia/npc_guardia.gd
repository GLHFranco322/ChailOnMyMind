extends StaticBody2D

@export var dialogue_resource: DialogueResource

var cam
var jugador

func _ready():
	$AreaInteraccion.interactuado.connect(_on_interactuado)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_interactuado():
	jugador = get_tree().get_first_node_in_group("player")
	print("Inicio")
	cam = get_tree().get_first_node_in_group("player").get_node("Camera2D2")

	jugador.bloquear_movimiento(true)


	var tween = create_tween()
	tween.tween_property(cam, "offset:y", 50, 0.5)

	DialogueManager.show_dialogue_balloon(dialogue_resource)
	print("Fin")
	
func _on_dialogue_ended(_resource):
	if cam:
		var tween = create_tween()
		tween.tween_property(cam, "offset:y", 0, 0.5)
		
	if jugador:
		jugador.bloquear_movimiento(false)

	
