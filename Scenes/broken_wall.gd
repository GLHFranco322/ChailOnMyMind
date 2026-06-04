extends StaticBody2D

var destruida = false

func romper():
	
	if destruida:
		return
	
	destruida = true
	
	var posicion_original = global_position
	
	# Vibración lenta
	for i in range(5):
		
		global_position = posicion_original + Vector2(4, 0)
		await get_tree().create_timer(0.10).timeout
		
		global_position = posicion_original + Vector2(-4, 0)
		await get_tree().create_timer(0.10).timeout
	
	# Volver al centro
	global_position = posicion_original
	
	# Pequeña pausa dramática
	await get_tree().create_timer(0.2).timeout
	
	queue_free()


func get_camera_position():
	return global_position
