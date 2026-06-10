extends Control

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	$Label.text = "Cargando..."

	await get_tree().create_timer(0.5).timeout

	get_tree().change_scene_to_file("res://Scenes/comisaria.tscn")
	
	$ProgressBar.value = 0

	for i in range(100):
		$ProgressBar.value = i
		await get_tree().create_timer(0.01).timeout
