extends PointLight2D

var activa := false

func abrir():
	activa = true
	actualizar()

func cerrar():
	activa = false
	actualizar()

func actualizar():
	if activa:
		color = Color(0, 1, 0) # verde
		energy = 2.5
	else:
		color = Color(1, 0, 0) # rojo
		energy = 2.5
