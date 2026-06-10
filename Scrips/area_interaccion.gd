extends Area2D

@export var accion := "Pickup"
@export var ui : CanvasLayer

func _ready():
	ui = get_tree().get_first_node_in_group("ui_interaccion")
	print(ui)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		ui.mostrar("Presiona [ E ] para " + accion)

func _on_body_exited(body):
	if body.is_in_group("player"):
		ui.ocultar()
