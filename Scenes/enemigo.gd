extends CharacterBody2D

@export var speed: int = 80
@export var vida: int = 50

var player = null
var chasing = false
var is_dead = false


func _ready():
	add_to_group("enemy") # 🔥 IMPORTANTE


func _physics_process(delta):
	if is_dead:
		return

	if player and chasing:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")


func recibir_dano(cantidad: int = 10):
	if is_dead:
		return
	
	vida -= cantidad
	print("ENEMIGO VIDA:", vida)

	# 🔥 feedback visual simple (golpe)
	$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

	if vida <= 0:
		morir()


func morir():
	is_dead = true
	chasing = false
	velocity = Vector2.ZERO

	# ❌ desactiva colisiones para que no moleste más
	$CollisionShape2D.disabled = true
	$Area2D.monitoring = false

	# 💀 sin animación por ahora → desaparece con delay
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
