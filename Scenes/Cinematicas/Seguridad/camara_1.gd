extends Sprite2D

@onready var camara = $Sprite2D/Camara1

func activar_glitch():
	camara.material.set_shader_parameter("glitch_amount", 5.0)

func desactivar_glitch():
	camara.material.set_shader_parameter("glitch_amount", 0.0)
