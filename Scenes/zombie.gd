extends CharacterBody2D

@export var speed : float

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed 
	
	move_and_slide()
