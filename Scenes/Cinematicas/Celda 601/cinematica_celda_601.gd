extends Node2D

@export var dialogo: DialogueResource


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
			

func mostrar_dialogo():
	var balloon = DialogueManager.show_dialogue_balloon(dialogo, "start")

	await balloon.tree_exited

	print("Diálogo terminado")

	fin_cinematica()

func fin_cinematica():
	get_tree().change_scene_to_file("res://Scenes/comisaria.tscn")

func _on_animation_player_2_animation_finished(anim_name: StringName):
	if anim_name == "Celda601":
		mostrar_dialogo()
		
