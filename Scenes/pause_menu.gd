extends Control

func _on_resume_pressed():
	get_tree().paused = false
	
	var pausa = get_tree().current_scene.get_node("Pausa")
	pausa.visible = false

func _on_control_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Controls.tscn")

func _on_volume_pressed():
	pass

func _on_exit_game_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menú.tscn")
