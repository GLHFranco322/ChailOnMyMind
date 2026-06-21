extends CharacterBody2D

@export var speed: float
@export var dano: float
@export var vida: int
@export var usar_navegacion: bool = false  # ← default a false para bichos

var player
var player_en_rango = false
var atacando = false
var muerto = false
var en_knockback = false
var puede_atacar = true

@onready var timer = $Timer
@onready var anim = $AnimatedSprite2D
@onready var hitbox_ataque = $HitboxAtaque
@onready var nav_agent = $NavigationAgent2D

func _ready():
	anim.flip_h = true
	player = get_tree().get_first_node_in_group("player")

func obtener_rango_ataque() -> float:
	var direction = player.global_position - global_position
	if abs(direction.x) > abs(direction.y):
		return Vector2(27.0, 0).length()
	else:
		if direction.y < 0:
			return 37.0
		else:
			return 38.0

func _physics_process(delta):
	if muerto:
		return
	if en_knockback:
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
		move_and_slide()
		return
	if player == null:
		return
	if atacando:
		move_and_slide()
		return
	
	if player_en_rango:
		var distancia = global_position.distance_to(player.global_position)
		if distancia > obtener_rango_ataque():
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			timer.stop()
		else:
			velocity = Vector2.ZERO
			if timer.is_stopped() and puede_atacar:
				timer.start()
	else:
		# Persigue siempre al jugador en línea recta, sin pathfinding
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * (speed * 0.5)
		timer.stop()
	
	move_and_slide()

func atack():
	if atacando or not puede_atacar:
		return
	if player_en_rango:
		var distancia = global_position.distance_to(player.global_position)
		if distancia > obtener_rango_ataque():
			return
		atacando = true
		velocity = Vector2.ZERO
		var direction = player.global_position - global_position
		if abs(direction.x) > abs(direction.y):
			anim.flip_h = direction.x < 0
			anim.play("Attack")
			if direction.x > 0:
				hitbox_ataque.position = Vector2(27.0, 0)
				hitbox_ataque.rotation = 0
			else:
				hitbox_ataque.position = Vector2(-27.0, 0)
				hitbox_ataque.rotation = 0
		else:
			if direction.y < 0:
				anim.play("AttackUp")
				hitbox_ataque.position = Vector2(0, -37.0)
				hitbox_ataque.rotation = deg_to_rad(90)
			else:
				anim.play("AttackDown")
				hitbox_ataque.position = Vector2(0, 38.0)
				hitbox_ataque.rotation = deg_to_rad(90)
		await get_tree().create_timer(0.2).timeout
		hitbox_ataque.monitoring = true
		await get_tree().create_timer(0.1).timeout
		hitbox_ataque.monitoring = false
		await anim.animation_finished
		atacando = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_en_rango = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_en_rango = false
		timer.stop()

func _on_timer_timeout():
	atack()

func recibir_dano(cantidad, origen: Vector2 = Vector2.ZERO):
	if muerto:
		return
	vida -= cantidad
	anim.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color(1, 1, 1)
	if vida <= 0:
		morir()
		return
	
	puede_atacar = false
	timer.stop()
	
	if origen != Vector2.ZERO:
		en_knockback = true
		var dir = (global_position - origen).normalized()
		velocity = dir * 300.0
		await get_tree().create_timer(0.3).timeout
		en_knockback = false
		velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.5).timeout
	puede_atacar = true

func morir():
	muerto = true
	velocity = Vector2.ZERO
	timer.stop()
	anim.visible = false
	queue_free()

func _on_hitbox_ataque_body_entered(body):
	if body.is_in_group("player"):
		var distancia = global_position.distance_to(body.global_position)
		if distancia <= obtener_rango_ataque():
			body.recibir_dano(dano, global_position)
