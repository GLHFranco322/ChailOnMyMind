extends Area2D 

@export var puerta_path : NodePath 
@export var broken_wall_path : NodePath 
@export var inmortal_path : NodePath        # ← nuevo export

@onready var puerta = get_node(puerta_path) 
@onready var broken_wall = get_node(broken_wall_path) 
@onready var inmortal = get_node(inmortal_path)    # ← nuevo
@onready var sonido_boton = $AudioStreamPlayer
@onready var sonido_risainmortal = $AudioStreamPlayer2


var player_inside = false 
var cinematic = false 
var usado = false 


func _process(delta): 
	if cinematic: 
		return 
	if player_inside and Input.is_action_just_pressed("Pickup"): 
		activar_boton() 
 
func activar_boton(): 
	if cinematic or usado: 
		return 
		
	$AreaInteraccion.visible = false
	$AreaInteraccion.monitoring = false

	sonido_boton.play()

	usado = true 
	cinematic = true 
 
	var player = get_tree().get_first_node_in_group("player") 
	if player == null: 
		cinematic = false 
		return 
 
	var camera = $"../Jugador/Camera2D2" 
 
	player.set_physics_process(false) 
 
	# ================================================== 
	# MOVER CÁMARA A LA PUERTA 
	# ================================================== 
	var tween_puerta = create_tween() 
	tween_puerta.tween_property(camera, "global_position", puerta.get_camera_position(), 0.5) 
	await tween_puerta.finished 
 
	puerta.toggle_puerta() 
	await get_tree().create_timer(1.0).timeout 
 
	# ================================================== 
	# MOVER CÁMARA A LA PARED 
	# ================================================== 
	var tween_wall = create_tween() 
	tween_wall.tween_property(camera, "global_position", broken_wall.get_camera_position(), 0.5) 
	await tween_wall.finished 
 
	# Activar colisión de la línea negra
	var comisaria = get_parent()
	if comisaria.has_method("activar_blackline"):
		comisaria.activar_blackline()

	# Romper pared y mover al Inmortal al mismo tiempo
	# Romper pared y esperar que termine
	await broken_wall.romper()

	# Recién ahora mover al Inmortal
	sonido_risainmortal.volume_db = 0.0
	sonido_risainmortal.play()
	var tween_inmortal = create_tween()
	tween_inmortal.tween_property(
		inmortal,
		"global_position",
		Vector2(-250.0, -1645.0),
		1.2
	)
	tween_inmortal.parallel().tween_property(
	sonido_risainmortal,"volume_db",-20.0,3.0)
	
	await tween_inmortal.finished
	
	sonido_risainmortal.stop()
	sonido_risainmortal.volume_db = 0.0
	
	await get_tree().create_timer(0.5).timeout
 
	# ================================================== 
	# VOLVER AL JUGADOR 
	# ================================================== 
	var tween_back = create_tween() 
	tween_back.tween_property(camera, "global_position", player.global_position, 0.5) 
	await tween_back.finished 
 
	player.set_physics_process(true) 
	cinematic = false 
 
 
func _on_body_entered(body): 
	if body.is_in_group("player"): 
		player_inside = true 
 
func _on_body_exited(body): 
	if body.is_in_group("player"): 
		player_inside = false
