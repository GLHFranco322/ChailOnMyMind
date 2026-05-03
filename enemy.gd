extends CharacterBody2D

@export var speed := 120.0
@export var gravity := 900.0
@export var health := 3
@export var damage := 1
@export var detection_range := 250.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Area2D

var player: Node2D = null

func _ready():
	# Buscar jugador
	player = get_tree().get_first_node_in_group("player")
	
	# Conectar señal del área de daño
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta):
	apply_gravity(delta)
	handle_ai()
	move_and_slide()
	update_animation()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_ai():
	if player == null:
		velocity.x = 0
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= detection_range:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed
	else:
		velocity.x = 0

func update_animation():
	if velocity.x != 0:
		anim.play("run")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("idle")

# ========================
# DAÑO AL JUGADOR
# ========================
func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

# ========================
# RECIBIR DAÑO
# ========================
func take_damage(amount):
	health -= amount
	
	anim.play("hurt")
	
	if health <= 0:
		die()

func die():
	anim.play("death")
	
	# Espera a que termine animación (opcional)
	await anim.animation_finished
	
	queue_free()
