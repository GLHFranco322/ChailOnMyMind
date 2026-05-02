extends CharacterBody2D

@export var speed = 200

var is_jumping = false
var last_direction = "right"
var jump_velocity = Vector2.ZERO


func _physics_process(delta):
	var input_vector = Vector2.ZERO

	# Movimiento normal
	if not is_jumping:
		if Input.is_action_pressed("Walk_right"):
			input_vector.x += 1
		if Input.is_action_pressed("Walk_left"):
			input_vector.x -= 1
		if Input.is_action_pressed("Walk_down"):
			input_vector.y += 1
		if Input.is_action_pressed("Walk_up"):
			input_vector.y -= 1

		input_vector = input_vector.normalized()

		# Guardar última dirección horizontal
		if input_vector.x > 0:
			last_direction = "right"
		elif input_vector.x < 0:
			last_direction = "left"

		velocity = input_vector * speed
	else:
		# Durante salto mantiene dirección inicial
		velocity = jump_velocity

	# Salto
	if Input.is_action_just_pressed("Jump") and not is_jumping:
		start_jump()

	move_and_slide()

	if not is_jumping:
		update_animation(input_vector)


func start_jump():
	is_jumping = true

	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("Walk_right"):
		input_vector.x += 1
	if Input.is_action_pressed("Walk_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("Walk_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("Walk_down"):
		input_vector.y += 1

	input_vector = input_vector.normalized()

	# 🎯 Animación correcta
	if input_vector == Vector2.ZERO:
		# Idle → salto en el lugar
		$AnimatedSprite2D.play("Jump_down")
	else:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				$AnimatedSprite2D.play("Jump_right")
				last_direction = "right"
			else:
				$AnimatedSprite2D.play("Jump_left")
				last_direction = "left"
		else:
			if input_vector.y < 0:
				$AnimatedSprite2D.play("Jump_up")
			elif input_vector.y > 0:
				$AnimatedSprite2D.play("Jump_down")

	# 💥 Movimiento del salto
	if input_vector != Vector2.ZERO:
		jump_velocity = input_vector * speed * 0.8
	else:
		jump_velocity = Vector2.ZERO

	await get_tree().create_timer(0.8).timeout

	is_jumping = false
	jump_velocity = Vector2.ZERO

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.play("Idle")
	elif abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("Walk_right")
		else:
			$AnimatedSprite2D.play("Walk_left")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("Walk_down")
		else:
			$AnimatedSprite2D.play("Walk_up")
