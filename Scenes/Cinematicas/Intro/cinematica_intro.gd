extends Node2D

func play_reloj():
	$AudioReloj.play()

func stop_reloj():
	$AudioReloj.stop()

func play_tiempo():
	$AudioTiempo.play()
	
func play_ambiente():
	$AudioAmbiente.play()




func _on_animation_player_1_animation_finished(anim_name: StringName):
	if anim_name == "CinematicaIntro":
		print("Terminó la animación")
		get_tree().change_scene_to_file("res://Scenes/Cinematicas/Celda 601/cinematica_celda601.tscn")


func _on_audio_reloj_finished():
	get_tree().change_scene_to_file("res://Scenes/Cinematicas/Celda 601/cinematica_celda601.tscn")
