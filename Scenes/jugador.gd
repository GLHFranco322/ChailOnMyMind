extends CharacterBody2D

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("Walk_right"):
		velocity.x += 1
	if Input.is_action_pressed("Walk_left"):
		velocity.x -= 1
	if Input.is_action_pressed("Walk_down"):
		velocity.y += 1
	if Input.is_action_pressed("Walk_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		self.velocity = velocity
		move_and_slide()
		update_animation(velocity)
	else:
		$AnimatedSprite2D.play("Idle")

	position = position.clamp(Vector2.ZERO, screen_size)


func update_animation(velocity: Vector2):
	if abs(velocity.x) > abs(velocity.y):
		# Movimiento horizontal
		if velocity.x > 0:
			$AnimatedSprite2D.play("Walk_right")
		else:
			$AnimatedSprite2D.play("Walk_left")
	else:
		# Movimiento vertical
		if velocity.y > 0:
			$AnimatedSprite2D.play("Walk_down")
		else:
			$AnimatedSprite2D.play("Walk_up")
