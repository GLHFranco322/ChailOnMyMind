extends Control

@onready var menu_music = preload("res://Assets/Musica/03 HoliznaCC0 - Game Over 3.mp3")

func _ready():
	MusicManager.play_menu_music(menu_music)

func _on_reintentar_pressed():
	MusicManager.stop_music()
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Laberinto.tscn")


func _on_menú_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menú.tscn")


func _on_reintentar_mouse_entered():
	SoundManager.play_hover()


func _on_menú_mouse_entered():
	SoundManager.play_hover()
