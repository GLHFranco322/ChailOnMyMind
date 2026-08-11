extends Control

var escena_a_cargar := "res://Scenes/comisaria.tscn"

func _ready():
	ResourceLoader.load_threaded_request(escena_a_cargar)

func _process(_delta):
	var progreso = []
	var estado = ResourceLoader.load_threaded_get_status(escena_a_cargar,progreso)
	
	if progreso.size() > 0:
		$Control/ProgressBar2.value = progreso[0] * 100.0

	if estado == ResourceLoader.THREAD_LOAD_LOADED:
		var escena = ResourceLoader.load_threaded_get(escena_a_cargar)
		get_tree().change_scene_to_packed(escena)
