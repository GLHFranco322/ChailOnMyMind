extends Node2D

@onready var menu_music = preload("res://Assets/Sonidos/CinematicasSounds/Escape/Raining_Sala_segura_soundtrack.mp3")

func _ready():
	MusicManager.play_menu_music(menu_music)


func _on_prisionero_celda_601_frame_changed():
	if $PrisioneroCelda601.animation.begins_with("Walk_down"):
		var frame = $PrisioneroCelda601.frame

		if frame == 1 or frame == 4:
			$AudioCaminar.play()
			
func play_Lluvia():
	$AudioLluvia.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Escape":
		get_tree().change_scene_to_file("res://Scenes/EscapeFinish.tscn")
