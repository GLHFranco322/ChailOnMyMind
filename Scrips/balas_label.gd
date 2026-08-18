extends Label

func _ready():
	add_to_group("hud_balas")
	visible = false
	text = ""

func actualizar_balas(actuales: int, maximas: int) -> void:
	text = "%d / %d" % [actuales, maximas]
	visible = true
