extends Control

func _on_back_2_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")


func _on_back_2_mouse_entered():
	SoundManager.play_hover()
