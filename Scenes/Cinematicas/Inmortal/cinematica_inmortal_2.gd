extends Node2D

@onready var light = $Sprite2D/LuzRoja

@export var rotation_speed := 5.0
@export var base_energy := 2.0
@export var pulse_strength := 1.0


func _ready():
	light.color = Color.RED

func _process(delta):
	light.rotation += rotation_speed * delta
	light.energy = base_energy + sin(Time.get_ticks_msec() * 0.01) * pulse_strength
	

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "CinematicaInmortalContexto":
		get_tree().change_scene_to_file("res://Scenes/Cinematicas/almismotiempo.tscn")
