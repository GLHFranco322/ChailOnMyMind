extends CharacterBody2D
 
@export var speed: int
@export var vida_max: int = 100
@export var stamina_max: float = 50.0
@export var invulnerable_time: float = 0.5
@export var dano_ataque: float = 20

@onready var bar = $ProgressBar
@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var sonido_ataque = $SonidoAtaque
@onready var sonido_dano = $AudioDaño
## @onready var sonido_muerte = $AudioMuerte
@onready var sonido_pasos = $AudioCaminar

var tiempo_paso: float = 0.0

var bullet = preload("res://Scenes/bullet.tscn")  # ← bala
var tiene_gun: bool = false                        # ← antes true, ahora false
var max_bullets: int = 10
var current_bullets: int = 0                       # ← antes 20, ahora 0                    # ← empieza sin balas

var vidaJugador: int
var stamina: float = 0.0
var is_attacking: bool = false
var last_direction = "down"
var invulnerable: bool = false
var is_dead: bool = false
var cansado: bool = false
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

	if cansado:
		current_speed = 100
	elif Input.is_action_pressed("Run") and is_moving and stamina > 0:
		is_running = true
		current_speed = speed * 2
	
	velocity = input_vector * current_speed
	move_and_slide()
	update_animation(input_vector)
	
# SONIDO DE PISADAS
	if is_moving:                        

		if not is_running:
			tiempo_paso -= delta       

			if tiempo_paso <= 0:
				sonido_pasos.play()
				tiempo_paso = 0.35

		else:
			tiempo_paso -= delta

			if tiempo_paso <= 0:
				sonido_pasos.play()
				tiempo_paso = 0.20

	else:
		tiempo_paso = 0.0
		
########
	
	if is_running:
		stamina -= 40 * delta
	elif not is_moving and not cansado:
		stamina += 30 * delta
	elif not cansado:
		stamina += 10 * delta

	if stamina <= 0 and not cansado:
		stamina = 0
		cansado = true
		await get_tree().create_timer(3.0).timeout
		cansado = false
	
	stamina = clamp(stamina, 0.0, stamina_max)
	bar.value = stamina
	
	if Input.is_action_just_pressed("Attack") and not is_attacking:
		start_attack()
	
	# Disparo
	if tiene_gun and Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if current_bullets <= 0:
		print("Sin balas!")
		return
	
	var newBullet = bullet.instantiate()
	# La bala sale hacia donde apunta el mouse
	var dir = (get_global_mouse_position() - global_position).angle()
	newBullet.direction = dir
	newBullet.global_position = global_position
	get_tree().current_scene.add_child(newBullet)
	
	current_bullets -= 1
	print("Balas restantes: ", current_bullets)

func pick_up_gun() -> void:
	tiene_gun = true
	current_bullets = max_bullets
	print("Gun equipada! Balas: ", current_bullets)

func add_bullets(amount: int) -> void:
	if not tiene_gun:
		return
	current_bullets = min(current_bullets + amount, max_bullets)
	print("Balas: ", current_bullets)

# ... el resto de tus funciones quedan igual


func start_attack():
	print("ATACANDO") # debug
	
	is_attacking = true
	already_hit = false
	velocity = Vector2.ZERO
	
	sonido_ataque.play()
	
	update_hitbox_direction()
	enable_hitbox() # ESTO FALTABA
	
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
			hitbox.position = Vector2(0, 25.5)
		"up":
			hitbox.position = Vector2(0, -25.5)
		"right":
			hitbox.position = Vector2(40, 0)
		"left":
			hitbox.position = Vector2(-40, 0)


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



func recibir_dano(cantidad, origen: Vector2 = Vector2.ZERO) -> void:
	if invulnerable or is_dead:
		return

	invulnerable = true
	vidaJugador -= cantidad
	print("Vida restante:", vidaJugador)
	
	#Sonido de Daño
	sonido_dano.play()

	# Flash rojo
	anim.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color(1, 1, 1)

	if vidaJugador <= 0:
		morir()
		return

	# Knockback del jugador
	if origen != Vector2.ZERO:
		var dir = (global_position - origen).normalized()
		velocity = dir * 200.0
		move_and_slide()

	await get_tree().create_timer(invulnerable_time).timeout
	invulnerable = false


func morir() -> void:
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	
	#Sonido de Muerte
	## sonido_muerte.play()
	
	anim.play("death")

	await anim.animation_finished

	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func _on_hitbox_body_entered(body):
	if (body.is_in_group("enemy") or body.is_in_group("Enemigos")) and not already_hit:
		body.recibir_dano(dano_ataque, global_position)  # ← pasás tu posición como origen
		already_hit = true


func enable_hitbox():
	print("HITBOX ON")
	hitbox.monitoring = true
	hitbox.visible = true

func disable_hitbox():
	print("HITBOX OFF")
	hitbox.monitoring = false
	hitbox.visible = false

func bloquear_movimiento(valor: bool):
	set_physics_process(not valor)

func curar(cantidad: int) -> void:
	vidaJugador = min(vidaJugador + cantidad, vida_max)
	print("Vida curada! Vida actual: ", vidaJugador)
	
	var vida_bar = get_tree().get_first_node_in_group("VidaBar")
	if vida_bar:
		vida_bar.value = vidaJugador
