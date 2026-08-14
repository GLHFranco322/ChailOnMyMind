extends Area2D

@export var mensaje: String = "AGARRASTE LA PISTOLA"
@export var mensaje_instrucciones: String = "PARA DISPARAR APUNTA CON EL MOUSE Y DISPARÁ CON CLICK IZQUIERDO"

@onready var sonido_equipar = $AudioEquipar

var jugador_cerca: CharacterBody2D = null
var ya_agarrado: bool = false


func _process(_delta: float) -> void:
	if jugador_cerca and not ya_agarrado:
		if Input.is_action_just_pressed("Pickup"):
			agarrar_item()
			sonido_equipar.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = null

func agarrar_item() -> void:
	ya_agarrado = true
	jugador_cerca.pick_up_gun()
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$AreaInteraccion.monitoring = false
	
	await mostrar_mensaje_pausado(mensaje)
	await mostrar_mensaje_pausado(mensaje_instrucciones)
	
	queue_free()

func mostrar_mensaje_pausado(texto: String) -> void:
	var ui = get_tree().get_first_node_in_group("ui_mensajes")
	if ui:
		get_tree().paused = true
		ui.mostrar_texto(texto.to_upper())
		await ui.esperar_cierre()
		get_tree().paused = false
