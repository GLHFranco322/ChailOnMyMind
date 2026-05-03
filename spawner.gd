extends Node2D

@export var enemy_scene: PackedScene
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 60.0 # 1 minuto
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_spawn_enemy)

func _on_spawn_enemy():
	if enemy_scene == null:
		push_error("Spawner: enemy_scene no está asignado en el inspector")
		return

	var enemy = enemy_scene.instantiate()
	enemy.player = "/root/Main/jugador"
	enemy.position = Vector2(200, 200) # posición inicial de prueba
	add_child(enemy)
