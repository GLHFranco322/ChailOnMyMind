extends Node

@onready var player = $AudioStreamPlayer

func _ready() -> void:
	player.play()

func stop_music() -> void:
	player.stop()

func set_volume(value: float) -> void:
	player.volume_db = value
