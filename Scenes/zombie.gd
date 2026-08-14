extends CharacterBody2D
@export var speed : float = 60
@export var dano : float = 20
@export var vida : int = 30
@export var usar_navegacion: bool = true

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
@onready var sonido_ataque = $AudioAtaque
@onready var sonido_dano = $AudioDaño


func _ready():
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
			if usar_navegacion:
				nav_agent.target_position = player.global_position
				var next_pos = nav_agent.get_next_path_position()
				var direction = (next_pos - global_position).normalized()
				velocity = direction * speed
			else:
				var direction = (player.global_position - global_position).normalized()
				velocity = direction * speed
			timer.stop()
		else:
			velocity = Vector2.ZERO
			if timer.is_stopped() and puede_atacar:
				timer.start()
	else:
		if usar_navegacion:
			if nav_agent.is_navigation_finished():
				var x = randf_range(-100, 100)
				var y = randf_range(-100, 100)
				nav_agent.target_position = global_position + Vector2(x, y)
			var next_pos = nav_agent.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
			velocity = direction * (speed * 0.5)
		else:
			velocity = Vector2.ZERO
		timer.stop()
	move_and_slide()

func atack():
	if atacando or not puede_atacar:
		return
	if player_en_rango:
		var distancia = global_position.distance_to(player.global_position)
		print("ATACK -> distancia: ", distancia)
		if distancia > obtener_rango_ataque():
			print("ATACK CANCELADO, muy lejos")
			return
		atacando = true
		velocity = Vector2.ZERO
		
		#Sonido de ataque
		sonido_ataque.play()
		
		var direction = player.global_position - global_position
		if abs(direction.x) > abs(direction.y):
			anim.flip_h = direction.x < 0
			anim.play("attack")
			if direction.x > 0:
				hitbox_ataque.position = Vector2(27.0, 0)
				hitbox_ataque.rotation = 0
			else:
				hitbox_ataque.position = Vector2(-27.0, 0)
				hitbox_ataque.rotation = 0
		else:
			if direction.y < 0:
				anim.play("attackUp")
				hitbox_ataque.position = Vector2(0, -37.0)
				hitbox_ataque.rotation = deg_to_rad(90)
			else:
				anim.play("attackDown")
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
	print("Vida zombie:", vida)
	
	#Sonido de Daño Recibido
	sonido_dano.play()
	
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
	
	sonido_dano.play()
	
	anim.visible = false
	queue_free()

func _on_hitbox_ataque_body_entered(body):
	if body.is_in_group("player"):
		var distancia = global_position.distance_to(body.global_position)
		print("HITBOX -> distancia: ", distancia)
		if distancia <= obtener_rango_ataque():
			body.recibir_dano(dano, global_position)
