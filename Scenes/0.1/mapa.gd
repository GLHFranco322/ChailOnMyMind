extends Node2D

@export var zombie_scene: PackedScene
@onready var marker_principal = $MarkerPrincipal

func _ready():
	for marker in marker_principal.get_children():
		if marker is Marker2D:
			var zombie = zombie_scene.instantiate()
			zombie.global_position = marker.global_position
			zombie.scale = Vector2(1.5, 1.5)
			add_child(zombie)
