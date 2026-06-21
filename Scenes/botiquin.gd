extends Area2D

@export var mensaje: String = "TE CURASTE +30 DE VIDA"
@export var cantidad_curacion: int = 30

var jugador_cerca: CharacterBody2D = null
#var ya_agarrado: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if jugador_cerca:
		if Input.is_action_just_pressed("Pickup"):
			agarrar_item()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = null

func agarrar_item() -> void:
	#ya_agarrado = true
	jugador_cerca.curar(cantidad_curacion)
	mostrar_mensaje(mensaje)
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	await get_tree().create_timer(1.5).timeout
	queue_free()

func mostrar_mensaje(texto: String) -> void:
	var ui = get_tree().get_first_node_in_group("ui_mensajes")
	if ui:
		ui.mostrar_texto(texto.to_upper())
