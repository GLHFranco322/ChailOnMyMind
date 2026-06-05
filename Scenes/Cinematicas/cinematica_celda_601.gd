extends Node2D

func play_respiracion():
	$AudioRespiracion.play()

func play_ambiente3():
	$AudioAmbiente3.play()
	
	
func play_despertar():
	$AudioDespertar.play()

func _on_prisionero_celda_601_frame_changed():
	if $PrisioneroCelda601.animation.begins_with("Walk_left"):
		var frame = $PrisioneroCelda601.frame

		if frame == 1 or frame == 4:
			$AudioCaminar.play()
