extends Node

var music_player : AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	music_player.volume_db = -15

func play_menu_music(music):

	if music_player.stream != music:
		music_player.stream = music

	if !music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()
