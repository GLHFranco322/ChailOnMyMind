extends CharacterBody2D

@export var damage: int = 9999
@export var speed: float = 100.0
@export var player: NodePath   # se asigna en el inspector o por código

var nav_agent: NavigationAgent2D
var life_timer: Timer

func _ready():
	nav_agent = NavigationAgent2D.new()
	add_child(nav_agent)

	life_timer = Timer.new()
	life_timer.wait_time = 60.0
	life_timer.one_shot = true
	add_child(life_timer)
	life_timer.start()
	life_timer.timeout.connect(queue_free)

func _physics_process(_delta):
	var player_node = get_node_or_null(player)
	if player_node:
		# perseguir al jugador siempre
		nav_agent.target_position = player_node.global_position
		var next = nav_agent.get_next_path_position()
		var dir = (next - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

		# condición: si está al lado del jugador
		if global_position.distance_to(player_node.global_position) < 10.0:
			attack_player(player_node)

func take_damage(_amount: int):
	# inmortal: no recibe daño
	pass

func attack_player(player_node):
	if player_node.has_method("take_damage"):
		player_node.take_damage(damage)
