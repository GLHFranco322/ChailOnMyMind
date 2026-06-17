extends Label

func _ready() -> void:
	add_to_group("ui_mensajes")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func mostrar_texto(texto: String) -> void:
	text = texto
	visible = true

func esperar_cierre() -> void:
	# Espera hasta que se presione E
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("Pickup"):
			break
	visible = false
