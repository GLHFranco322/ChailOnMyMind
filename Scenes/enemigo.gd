extends CharacterBody2D

@export var speed: int = 80
@export var vida: int = 50

var player = null
var chasing = false

func _physics_process(delta):
	if player and chasing:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
#		update_animation(direction)
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")


# func update_animation(direction: Vector2):
#	if abs(direction.x) > abs(direction.y):
#		if direction.x > 0:
#			$AnimatedSprite2D.play("walk_right")
#		else:
#			$AnimatedSprite2D.play("walk_left")
#	else:
#		if direction.y > 0:
#			$AnimatedSprite2D.play("walk_down")
#		else:
#			$AnimatedSprite2D.play("walk_up")


func recibir_dano(cantidad: int = 10):
	vida -= cantidad
	if vida <= 0:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		player = body
		chasing = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chasing = false
