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
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout

	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/laberinto.tscn")

func _on_options_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_quit_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().quit()


func _on_play_mouse_entered():
	SoundManager.play_hover()


func _on_options_mouse_entered():
	SoundManager.play_hover()


func _on_quit_mouse_entered():
	SoundManager.play_hover()
