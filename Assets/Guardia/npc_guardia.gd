extends StaticBody2D

@export var dialogue_resource: DialogueResource

func _ready():
	$AreaInteraccion.interactuado.connect(_on_interactuado)

func _on_interactuado():
	var cam = get_tree().get_first_node_in_group("player").get_node("Camera2D2")

	var tween = create_tween()
	tween.tween_property(cam, "offset:y", 30, 0.5)

	DialogueManager.show_dialogue_balloon(dialogue_resource)

	await get_tree().create_timer(3.0).timeout

	var tween2 = create_tween()
	tween2.tween_property(cam, "offset:y", 0, 0.5)
	
func _on_area_interaccion_interactuado():
	DialogueManager.show_dialogue_balloon(dialogue_resource)
	
