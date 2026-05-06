extends CharacterBody2D

@export var speed: int = 80
@export var vida: int = 50
@export var knockback_force: float = 120
@export var invul_time: float = 0.2

var player = null
var chasing = false
var is_dead = false
var invulnerable = false


func _ready():
	add_to_group("enemy")


func _physics_process(delta):
	if is_dead:
		return

	if player and chasing:
		var distance = global_position.distance_to(player.global_position)
		var direction = (player.global_position - global_position).normalized()
		
		var stop_distance = 30.0
		
		if distance > stop_distance:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")


func recibir_dano(cantidad: int = 10, direccion := Vector2.ZERO):
	if is_dead or invulnerable:
		return
	
	invulnerable = true
	
	vida -= cantidad
	print("ENEMIGO VIDA:", vida)

	# 🔥 knockback
	velocity = direccion * knockback_force
	move_and_slide()

	# 🔴 feedback visual
	$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

	if vida <= 0:
		morir()
		return

	await get_tree().create_timer(invul_time).timeout
	invulnerable = false


func morir():
	is_dead = true
	chasing = false
	velocity = Vector2.ZERO

	$CollisionShape2D.disabled = true
	$Area2D.monitoring = false

	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	
	if body.name == "Jugador":
		player = body
		chasing = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chasing = false
