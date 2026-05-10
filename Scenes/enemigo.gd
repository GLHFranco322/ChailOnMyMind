extends CharacterBody2D

@export var speed = 60
@export var chase_speed = 180
@export var vida = 100
@export var damage = 10

@onready var anim = $AnimatedSprite2D

@onready var ray_vision = $RayCast2D
@onready var ray_up = $RayUp
@onready var ray_down = $RayDown
@onready var ray_left = $RayLeft
@onready var ray_right = $RayRight

@onready var detect_area = $Area2D
@onready var attack_area = $AttackArea

var player = null
var player_detected = false

var state = "idle"
var direction = Vector2.ZERO
var change_dir_time = 0

var is_dead = false
var can_attack = true

var last_direction = "down"


func _ready():

	add_to_group("enemy")

	anim.play("idle")

	randomize()
	set_random_direction()

	attack_area.monitoring = true


func _physics_process(delta):

	if is_dead:
		return

	match state:

		"idle":
			idle_behavior(delta)

		"chase":
			chase_behavior()

	move_and_slide()

	try_attack()


# ==================================================
# 🟢 PATRULLA
# ==================================================

func idle_behavior(delta):

	change_dir_time -= delta

	if change_dir_time <= 0:
		set_random_direction()

	velocity = direction * speed

	if player_detected and can_see_player():
		state = "chase"


func set_random_direction():

	direction = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()

	change_dir_time = randf_range(1, 3)


# ==================================================
# 🔴 PERSECUCIÓN
# ==================================================

func chase_behavior():

	if player == null:
		state = "idle"
		return

	if not is_instance_valid(player):
		state = "idle"
		player = null
		return

	if not player_detected:
		state = "idle"
		return

	if not can_see_player():
		state = "idle"
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > 40:

		var dir_to_player = (
			player.global_position - global_position
		).normalized()

		update_direction(dir_to_player)

		velocity = dir_to_player * chase_speed

	else:
		velocity = Vector2.ZERO


# ==================================================
# 👁 VISIÓN
# ==================================================

func can_see_player():

	if player == null:
		return false

	if not is_instance_valid(player):
		return false

	var dir = player.global_position - global_position

	ray_vision.target_position = dir

	ray_vision.force_raycast_update()

	if ray_vision.is_colliding():

		var collider = ray_vision.get_collider()

		if collider and collider.is_in_group("player"):
			return true

	return false


# ==================================================
# 🧭 DIRECCIONES
# ==================================================

func update_direction(dir):

	if abs(dir.x) > abs(dir.y):

		if dir.x > 0:
			last_direction = "right"
			anim.flip_h = false
		else:
			last_direction = "left"
			anim.flip_h = true

	else:

		if dir.y > 0:
			last_direction = "down"
		else:
			last_direction = "up"


func is_player_in_front():

	if player == null:
		return false

	if not is_instance_valid(player):
		return false

	var dir = player.global_position - global_position

	if abs(dir.x) > abs(dir.y):

		if dir.x > 0:
			return (
				ray_right.is_colliding()
				and ray_right.get_collider().is_in_group("player")
			)

		else:
			return (
				ray_left.is_colliding()
				and ray_left.get_collider().is_in_group("player")
			)

	else:

		if dir.y > 0:
			return (
				ray_down.is_colliding()
				and ray_down.get_collider().is_in_group("player")
			)

		else:
			return (
				ray_up.is_colliding()
				and ray_up.get_collider().is_in_group("player")
			)


# ==================================================
# ⚔ HITBOX DIRECCIONAL
# ==================================================

func update_attack_area():

	match last_direction:

		"down":
			attack_area.position = Vector2(0, 35)

		"up":
			attack_area.position = Vector2(0, -35)

		"right":
			attack_area.position = Vector2(35, 0)

		"left":
			attack_area.position = Vector2(-35, 0)


# ==================================================
# ⚔ ATAQUE
# ==================================================

func try_attack():

	if player == null:
		return

	if not is_instance_valid(player):
		return

	if not can_attack:
		return

	if global_position.distance_to(player.global_position) < 50:

		if can_see_player() and is_player_in_front():
			attack()


func attack():

	can_attack = false

	update_attack_area()

	print("ATACANDO")

	var bodies = attack_area.get_overlapping_bodies()

	print("CUERPOS:", bodies.size())

	for body in bodies:

		print(body.name)

		if body.is_in_group("player"):

			print("DAÑO AL JUGADOR")

			body.recibir_dano(damage)

	await get_tree().create_timer(1.0).timeout

	can_attack = true


# ==================================================
# 💀 DAÑO
# ==================================================

func recibir_dano(cantidad):

	if is_dead:
		return

	vida -= cantidad

	print("VIDA ENEMIGO:", vida)

	anim.modulate = Color(1, 0.3, 0.3)

	await get_tree().create_timer(0.1).timeout

	anim.modulate = Color(1, 1, 1)

	if vida <= 0:
		morir()


func morir():

	if is_dead:
		return

	is_dead = true

	velocity = Vector2.ZERO

	$CollisionShape2D.disabled = true

	detect_area.monitoring = false
	attack_area.monitoring = false

	await get_tree().create_timer(0.5).timeout

	queue_free()


# ==================================================
# 🚨 DETECCIÓN
# ==================================================

func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):

		player = body
		player_detected = true


func _on_area_2d_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):

		player_detected = false
		state = "idle"
