extends CharacterBody2D

@export var speed: int = 200
@export var vidaJugador: int = 100
@export var stamina_max: float = 50.0

@onready var bar = $ProgressBar

var stamina: float = 0.0
var is_attacking: bool = false
var last_direction = "down"

func _physics_process(delta):

	# 🚫 BLOQUEO DURANTE ATAQUE
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector = Vector2.ZERO
	var current_speed = speed
	var is_moving = false

	# Movimiento
	if Input.is_action_pressed("Walk_right"):
		$AnimatedSprite2D.flip_h = false
		input_vector.x += 1
	if Input.is_action_pressed("Walk_left"):
		$AnimatedSprite2D.flip_h = true
		input_vector.x -= 1
	if Input.is_action_pressed("Walk_down"):
		input_vector.y += 1
	if Input.is_action_pressed("Walk_up"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		is_moving = true

	# Run
	var is_running = false
	if Input.is_action_pressed("Run") and is_moving and stamina < stamina_max:
		is_running = true
		current_speed = speed * 2
	if stamina == stamina_max and is_running == true:
		current_speed = speed
	
	velocity = input_vector * current_speed
	move_and_slide()

	update_animation(input_vector)

	# Stamina
	if is_running:
		stamina += 40 * delta
	elif is_moving:
		stamina -= 15 * delta
	else:
		stamina -= 30 * delta

	stamina = clamp(stamina, 0.0, stamina_max)
	bar.value = stamina

	# ⚔️ ATAQUE
	if Input.is_action_just_pressed("Atack"):
		start_attack()


func start_attack():
	is_attacking = true
	velocity = Vector2.ZERO

	match last_direction:
		"right":
			$AnimatedSprite2D.play("atack_right")
		"left":
			$AnimatedSprite2D.play("atack_left")
		"up":
			$AnimatedSprite2D.play("atack_up")
		"down":
			$AnimatedSprite2D.play("atack_down")



func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	elif abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			last_direction = "right"
			$AnimatedSprite2D.play("Walk_right")
		else:
			last_direction = "left"
			$AnimatedSprite2D.play("Walk_left")
	else:
		if direction.y > 0:
			last_direction = "down"
			$AnimatedSprite2D.play("Walk_down")
		else:
			last_direction = "up"
			$AnimatedSprite2D.play("Walk_up")


func _on_animated_sprite_2d_animation_finished() -> void:
	print("FIN ANIM:", $AnimatedSprite2D.animation)
	if $AnimatedSprite2D.animation.begins_with("atack"):
		is_attacking = false
		$AnimatedSprite2D.play("Idle")

func recibir_dano():
	pass
