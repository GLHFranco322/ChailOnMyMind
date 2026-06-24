extends CanvasLayer

@onready var nombre = $MarginContainer/Panel/LabelNombre
@onready var texto = $MarginContainer/Panel/LabelTexto

func mostrar_dialogo(quien: String, mensaje: String):
	nombre.text = quien
	texto.text = ""

	for letra in mensaje:
		texto.text += letra
		await get_tree().create_timer(0.05).timeout

	visible = true

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
	mostrar_dialogo("Guardia", "¡Última advertencia, no te muevas!")

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
	
func ocultar_dialogo():
	visible = false
