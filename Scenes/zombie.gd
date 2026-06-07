extends CharacterBody2D

@export var speed : float = 100
@export var dano : float = 10
@export var distancia_minima : float
@export var vida : int = 20
@export var invulnerable_time: float = 0.5

var player
var player_en_rango = false
var atacando = false
var direccion_patruya = Vector2.ZERO
var cambiando_direccion = false
var muerto = false
var invulnerable = false
var en_knockback = false


@onready var timer = $Timer
@onready var anim = $AnimatedSprite2D
@onready var wander_timer = $WanderTimer
@onready var hitbox_ataque = $HitboxAtaque

func _ready():
	player = get_tree().get_first_node_in_group("player")

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
		if distancia > distancia_minima:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			timer.stop()  # ← lejos: no atacar
		else:
			velocity = Vector2.ZERO
			if not timer.is_stopped():
				pass
			else:
				timer.start()  # ← cerca: habilitar ataques
	else:
		velocity = direccion_patruya * (speed * 0.5)
		timer.stop()

	move_and_slide()

func atack():
	if atacando:
		return
	if player_en_rango:
		var diff = player.global_position - global_position
		var en_rango = abs(diff.x) < 25 or abs(diff.y) < 25
		if not en_rango:
			return
			
		atacando = true
		velocity = Vector2.ZERO
		
		var direction = player.global_position - global_position

		if abs(direction.x) > abs(direction.y):
			anim.flip_h = direction.x < 0
			anim.play("attack")
			hitbox_ataque.position = Vector2(10 * sign(direction.x), 0)
		else:
			if direction.y < 0:
				anim.play("attackUp")
				hitbox_ataque.position = Vector2(0, -20)
			else:
				anim.play("attackDown")
				hitbox_ataque.position = Vector2(0, 20)

		await get_tree().create_timer(0.2).timeout
		
		hitbox_ataque.monitoring = true
		await get_tree().create_timer(0.1).timeout
		hitbox_ataque.monitoring = false

		await anim.animation_finished
		atacando = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("PLAYER ENTRO")
		player_en_rango = true
		# timer.start() ← ya no va acá

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		print("PLAYER SALIO")
		player_en_rango = false
		timer.stop()

func _on_timer_timeout():
	atack()

func _on_wander_timer_timeout():

	# Direcciones aleatorias
	var x = randf_range(-1, 1)
	var y = randf_range(-1, 1)

	direccion_patruya = Vector2(x, y).normalized()

func recibir_dano(cantidad, origen: Vector2 = Vector2.ZERO):
	if muerto:
		return
	if invulnerable:
		return

	invulnerable = true
	vida -= cantidad
	print("Vida zombie:", vida)

	# Flash rojo
	anim.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color(1, 1, 1)

	if vida <= 0:
		morir()
		return

	# Knockback
	if origen != Vector2.ZERO:
		en_knockback = true
		var dir = (global_position - origen).normalized()
		velocity = dir * 150.0  # ← mucho más suave
		await get_tree().create_timer(0.3).timeout  # ← menos tiempo
		en_knockback = false
		velocity = Vector2.ZERO

	await get_tree().create_timer(invulnerable_time).timeout
	invulnerable = false
	
func morir():
	muerto = true
	velocity = Vector2.ZERO
	timer.stop()
	anim.visible = false
	queue_free()
	


func _on_hitbox_ataque_body_entered(body):
	if body.is_in_group("player"):
		body.recibir_dano(dano, global_position)
