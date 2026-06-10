extends Area2D

var jugador_cerca = false

func _ready():

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):

	if jugador_cerca and Input.is_action_just_pressed("Pickup"):

		print("Radio recogida")

		queue_free()

func _on_body_entered(body):

	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body):

	if body.is_in_group("player"):
		jugador_cerca = false
