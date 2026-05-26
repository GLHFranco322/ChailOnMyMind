extends CharacterBody2D

@export var speed : float = 100
@export var dano : float = 10
@export var distancia_minima : float
@export var vida : int = 20

var player
var player_en_rango = false
var atacando = false
var direccion_patruya = Vector2.ZERO
var cambiando_direccion = false
var muerto = false
var invulnerable = false

@onready var timer = $Timer
@onready var anim = $AnimatedSprite2D
@onready var wander_timer = $WanderTimer


func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if vida <= 0:
		morir
		queue_free()

	if player == null:
		return


	# Si está atacando no se mueve
	if atacando:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# SI DETECTA AL JUGADOR → PERSEGUIR
	if player_en_rango:

		var distancia = global_position.distance_to(player.global_position)

		if distancia > distancia_minima:

			var direction = (player.global_position - global_position).normalized()

			velocity = direction * speed

		else:

			velocity = Vector2.ZERO

	# SI NO DETECTA → PATRULLAR
	else:

		velocity = direccion_patruya * (speed * 0.5)

	move_and_slide()

func atack():

	if atacando:
		return

	if player_en_rango:

		atacando = true

		velocity = Vector2.ZERO

		var direction = player.global_position - global_position

		if abs(direction.x) > abs(direction.y):

			anim.play("attack")
			anim.flip_h = direction.x < 0

		else:

			if direction.y < 0:
				anim.play("attackUp")
			else:
				anim.play("attackDown")

		await get_tree().create_timer(0.2).timeout

		if global_position.distance_to(player.global_position) < 50:
			player.recibir_dano(dano)

		await anim.animation_finished

		atacando = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("PLAYER ENTRO")
		player_en_rango = true
		timer.start()

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

func recibir_dano(cantidad):

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

	await get_tree().create_timer(0.3).timeout

	invulnerable = false
	
func morir():

	muerto = true

	velocity = Vector2.ZERO

	timer.stop()

	anim.play("death")

	await anim.animation_finished

	queue_free()
	
