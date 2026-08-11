extends Node2D

@onready var light = $Sprite2D/LuzRoja

@export var rotation_speed := 5.0
@export var base_energy := 2.0
@export var pulse_strength := 1.0

func _ready():
	light.color = Color.RED

	$CanvasLayer/OmitirButton.modulate.a = 0.0
	
	await get_tree().create_timer(5.0).timeout
	
	var tween = create_tween()
	tween.tween_property($CanvasLayer/OmitirButton,"modulate:a",1.0,1.5)

func _process(delta):
	# Giro de la sirena
	light.rotation += rotation_speed * delta

	# Parpadeo de intensidad
	light.energy = base_energy + sin(Time.get_ticks_msec() * 0.01) * pulse_strength


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "CinematicaSeguridad":
		get_tree().change_scene_to_file("res://Scenes/Cinematicas/Inmortal/cinematica_inmortal2.tscn")

func _on_omitir_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
