extends CanvasLayer

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "titulo_transicion":
		get_tree().change_scene_to_file("res://Scenes/Cinematicas/Intro/cinematica_intro.tscn")
