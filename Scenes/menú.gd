extends Control

@onready var light = $PointLight2D
@onready var menu_music = preload("res://Assets/Musica/Prologue Theme.mp3")

func _ready():
	MusicManager.play_menu_music(menu_music)

var target_energy = 1.0

func _process(delta):
	
	if randf() < 0.08:
		target_energy = randf_range(0.6, 1.4)
	
	light.energy = lerp(light.energy, target_energy, delta * 8)

func _on_play_pressed():
	MusicManager.stop_music()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_options_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()
