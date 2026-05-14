extends Node

var click_player : AudioStreamPlayer
var hover_player : AudioStreamPlayer

@onready var click_sound = preload("res://Assets/Sonidos/Click.mp3")
@onready var hover_sound = preload("res://Assets/Sonidos/click_001.ogg")

func _ready():
	
	click_player = AudioStreamPlayer.new()
	add_child(click_player)
	
	click_player.stream = click_sound
	click_player.volume_db = -10
	
	hover_player = AudioStreamPlayer.new()
	add_child(hover_player)

	hover_player.stream = hover_sound
	hover_player.volume_db = -20

func play_click():
	
	click_player.pitch_scale = randf_range(0.98, 1.02)
	click_player.play()

func play_hover():

	if !hover_player.playing:
		hover_player.pitch_scale = randf_range(0.98, 1.02)
		hover_player.play()
