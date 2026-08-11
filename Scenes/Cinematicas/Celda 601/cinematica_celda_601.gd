extends Node2D

func play_respiracion():
	$AudioRespiracion.play()

func play_ambiente3():
	$AudioAmbiente3.play()
	
func play_disparo():
	$AudioDisparo.play()
	
func play_extraño():
	$"AudioExtraño".play()
	
func play_despertar():
	$AudioDespertar.play()

func _on_prisionero_celda_601_frame_changed():
	if $PrisioneroCelda601.animation.begins_with("Walk_left"):
		var frame = $PrisioneroCelda601.frame

		if frame == 1 or frame == 4:
			$AudioCaminar.play()

func _on_animation_player_2_animation_finished(anim_name: StringName):
	if anim_name == "Acto 3":
		get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
