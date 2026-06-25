extends Area2D

@export var bicho_scene: PackedScene = preload("res://Scenes/bicho.tscn")
@export var spawner_path: NodePath

var ya_activado: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if ya_activado:
		return
	if body.is_in_group("player"):
		ya_activado = true
		spawnear_bichos()

func spawnear_bichos() -> void:
	var spawner = get_node(spawner_path)
	for marker in spawner.get_children():
		if marker is Marker2D:
			await get_tree().create_timer(0.05).timeout
			var bicho = bicho_scene.instantiate()
			bicho.global_position = marker.global_position
			bicho.scale = Vector2(0.7, 0.7)
			bicho.usar_navegacion = false
			get_tree().current_scene.add_child(bicho)
	print("Bichos spawneados en sus markers")
