extends Area2D

@export var zombie_scene: PackedScene = preload("res://Scenes/zombie.tscn")
@export var spawner_path: NodePath

var ya_activado: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if ya_activado:
		return
	if body.is_in_group("player"):
		ya_activado = true
		spawnear_zombies()

func spawnear_zombies() -> void:
	var spawner = get_node(spawner_path)
	for marker in spawner.get_children():
		if marker is Marker2D:
			await get_tree().create_timer(0.05).timeout
			var zombie = zombie_scene.instantiate()
			zombie.global_position = marker.global_position
			zombie.scale = Vector2(0.7, 0.7)
			zombie.usar_navegacion = true
			get_tree().current_scene.add_child(zombie)
	print("Zombies spawneados en sus markers")
