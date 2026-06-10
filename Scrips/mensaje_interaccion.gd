extends CanvasLayer

@onready var mensaje = $Mensaje

func _ready():
	mensaje.visible = false

func mostrar(texto):
	mensaje.text = texto
	mensaje.visible = true

func ocultar():
	mensaje.visible = false
