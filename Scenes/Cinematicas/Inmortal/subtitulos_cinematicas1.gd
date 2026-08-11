extends CanvasLayer

@onready var nombre = $MarginContainer/Panel/LabelNombre
@onready var texto = $MarginContainer/Panel/LabelTexto

func _ready():
	visible = false

func mostrar_dialogo(quien: String, mensaje: String):
	visible = true
	nombre.text = quien
	texto.text = ""

	for letra in mensaje:
		texto.text += letra
		await get_tree().create_timer(0.03).timeout


##CinematicaCarcel
func Martin_01():
	mostrar_dialogo("Martin", "¿Esto es real?")

func Martin_02():
	mostrar_dialogo("Martin", "¿Qué es todo ese ruido?")


##CinematicaInmortalEncuentro
func guardia_01():
	mostrar_dialogo("Guardia", "Central, estoy revisando el sector C.")

func guardia_02():
	mostrar_dialogo("Guardia", "No veo nada por ahora...")

func guardia_03():
	mostrar_dialogo("Guardia","¿Hay alguien ahí?")

func guardia_04():
	mostrar_dialogo("Guardia", "Salga ahora mismo.")

func guardia_05():
	mostrar_dialogo("Guardia", "¡Alto!")

func guardia_06():
	mostrar_dialogo("Guardia", "¡No te muevas!")

func guardia_07():
	mostrar_dialogo("Guardia", "¿Qué mierda es eso?")

func guardia_08():
	mostrar_dialogo("Guardia", "No...")

func guardia_09():
	mostrar_dialogo("Guardia", "No, no, no...")

func guardia_10():
	mostrar_dialogo("Guardia", "¿Por qué no muere?")

func guardia_11():
	mostrar_dialogo("Guardia", "¡Central, ayúdenme!")

func guardia_12():
	mostrar_dialogo("Guardia", "¡AHHHHH!")
	
##CinematicaSaladeSeguridad

func guardia_13():
	mostrar_dialogo("Guardia", "Central, continúo sin novedades.")
	
func guardia_14():
	mostrar_dialogo("Guardia", "Estoy revisando las cámaras.")

func guardia_15():
	mostrar_dialogo("Guardia", "Qué raro...")

func guardia_16():
	mostrar_dialogo("Guardia", "¿Otra vez problemas con estas porquerías?")

func guardia_17():
	mostrar_dialogo("Guardia", "Mantenimiento va a tener trabajo mañana...")

func guardia_18():
	mostrar_dialogo("Guardia", "¿Qué es eso?")

func guardia_19():
	mostrar_dialogo("Guardia", "¿Hay alguien ahí?")

func guardia_20():
	mostrar_dialogo("Guardia", "Central, creo que tengo a alguien en el bloque C.")

func guardia_21():
	mostrar_dialogo("Guardia", "¿Quién carajo es ese...?")

func guardia_22():
	mostrar_dialogo("Guardia", "¿Qué...?")

func guardia_23():
	mostrar_dialogo("Guardia", "No me gusta esto...")

func guardia_24():
	mostrar_dialogo("Guardia", "¡Mierda!")

func guardia_25():
	mostrar_dialogo("Guardia", "¡Central, respondan!")

func guardia_26():
	mostrar_dialogo("Guardia", "¡Central!")

func guardia_27():
	mostrar_dialogo("Guardia", "Tengo que salir de acá.")
	
func ocultar_dialogo():
	visible = false
