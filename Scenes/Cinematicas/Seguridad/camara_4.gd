extends Sprite2D

@onready var monitor = $Monitor4

func activar_glitch():
	monitor.material.set_shader_parameter("glitch_amount", 1.0)

func desactivar_glitch():
	monitor.material.set_shader_parameter("glitch_amount", 0.0)
