extends Control

func _on_control_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Controls.tscn")

func _on_volume_pressed():
	pass

func _on_back_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menú.tscn")
