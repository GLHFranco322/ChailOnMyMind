extends CharacterBody2D

@export var waypoints: Array[Marker2D]
@export var speed: float

var current_index = 0
var is_waiting = false

func _physics_process(delta: float) -> void:
	if is_waiting:
		return
	
	var min_distance = 5.0
	var target_position = waypoints[current_index].global_position
	var direction = target_position - global_position
	var distance = direction.length()
	direction = direction.normalized()
	velocity = direction * speed
	
	if distance < min_distance:
		current_index += 1
		velocity = Vector2.ZERO
		$Timer.start()
		is_waiting = true
		if current_index >= waypoints.size():
			current_index = 0


	move_and_slide()



func _on_timer_timeout() -> void:
	is_waiting = false
