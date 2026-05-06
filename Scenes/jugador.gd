extends CharacterBody2D

@export var speed: int = 200
@export var vida_max: int = 100
@export var stamina_max: float = 50.0
@export var invulnerable_time: float = 0.5

@onready var bar = $ProgressBar
@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var hitbox_sprite = $Hitbox/Sprite2D

var vidaJugador: int
var stamina: float = 0.0
var is_attacking: bool = false
var last_direction = "down"
var invulnerable: bool = false
var is_dead: bool = false

var already_hit: bool = false


func _ready() -> void:
	vidaJugador = vida_max
	add_to_group("player")
	
	anim.animation_finished.connect(_on_animation_finished)
	
	hitbox.monitoring = false
	hitbox.visible = false


func _physics_process(delta):
	if is_dead:
		$CollisionShape2D.disabled = true
		return
	
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector = Vector2.ZERO
	var current_speed = speed
	var is_moving = false

	if Input.is_action_pressed("Walk_right"):
		anim.flip_h = false
		input_vector.x += 1
	if Input.is_action_pressed("Walk_left"):
		anim.flip_h = true
		input_vector.x -= 1
	if Input.is_action_pressed("Walk_down"):
		input_vector.y += 1
	if Input.is_action_pressed("Walk_up"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		is_moving = true

	var is_running = false
	if Input.is_action_pressed("Run") and is_moving and stamina < stamina_max:
		is_running = true
		current_speed = speed * 2
	
	if stamina == stamina_max and is_running:
		current_speed = speed
	
	velocity = input_vector * current_speed
	move_and_slide()

	update_animation(input_vector)

	if is_running:
		stamina += 40 * delta
	elif is_moving:
		stamina -= 15 * delta
	else:
		stamina -= 30 * delta

	stamina = clamp(stamina, 0.0, stamina_max)
	bar.value = stamina

	if Input.is_action_just_pressed("Attack") and not is_attacking:
		start_attack()


func start_attack():
	print("ATACANDO") # debug

	is_attacking = true
	already_hit = false
	velocity = Vector2.ZERO
	
	update_hitbox_direction()
	enable_hitbox() # 👈 🔥 ESTO FALTABA
	
	match last_direction:
		"right":
			anim.flip_h = false
			anim.play("attack_right")
		"left":
			anim.flip_h = true
			anim.play("attack_right")
		"up":
			anim.play("attack_up")
		"down":
			anim.play("attack_down")


# 🔥 NUEVO: mover hitbox según dirección (CORTO ALCANCE)
func update_hitbox_direction():
	match last_direction:
		"down":
			hitbox.position = Vector2(0, 40)
		"up":
			hitbox.position = Vector2(0, 0)
		"right":
			hitbox.position = Vector2(40, 20)
		"left":
			hitbox.position = Vector2(-40, 20)


func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		if not is_attacking:
			anim.play("Idle")
	elif abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			last_direction = "right"
			if not is_attacking:
				anim.play("Walk_right")
		else:
			last_direction = "left"
			if not is_attacking:
				anim.play("Walk_left")
	else:
		if direction.y > 0:
			last_direction = "down"
			if not is_attacking:
				anim.play("Walk_down")
		else:
			last_direction = "up"
			if not is_attacking:
				anim.play("Walk_up")




func _on_animation_finished():
	if anim.animation.begins_with("attack"):
		is_attacking = false
		disable_hitbox() # seguridad extra
		anim.play("Idle")

	elif anim.animation == "death":
		queue_free()


func recibir_dano(cantidad: int = 10) -> void:
	if invulnerable:
		return

	invulnerable = true
	vidaJugador -= cantidad
	print("Vida restante:", vidaJugador)

	if vidaJugador <= 0:
		morir()
		return

	await get_tree().create_timer(invulnerable_time).timeout
	invulnerable = false


func morir() -> void:
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("death")


func _on_hitbox_body_entered(body):
	print("COLISION CON:", body.name)

	if body.is_in_group("enemy") and not already_hit:
		print("LE PEGO")
		body.recibir_dano(20)
		already_hit = true


func enable_hitbox():
	print("HITBOX ON")
	hitbox.monitoring = true
	hitbox.visible = true

func disable_hitbox():
	print("HITBOX OFF")
	hitbox.monitoring = false
	hitbox.visible = false
