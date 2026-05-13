extends Control

func _on_control_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Controls.tscn")

func _on_volume_pressed():
	pass

func _on_back_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menú.tscn")


func _on_control_mouse_entered():
	SoundManager.play_hover()


func _on_volume_mouse_entered():
	SoundManager.play_hover()


func _on_back_mouse_entered():
	SoundManager.play_hover()
