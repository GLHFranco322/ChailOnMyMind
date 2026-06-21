extends CharacterBody2D

var direction: float = 0.0
var speed: float = 600.0

func _ready() -> void:
	add_collision_exception_with(get_tree().get_first_node_in_group("player"))
	rotation = direction  # ← agregado: rota el sprite hacia la dirección del disparo
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(queue_free)

func _physics_process(_delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(direction)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is TileMapLayer or collider is TileMap:
			queue_free()
			return

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemigos"):
		body.recibir_dano(40, global_position)
		queue_free()
