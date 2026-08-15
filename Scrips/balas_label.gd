extends Label

func _ready():
	add_to_group("hud_balas")
	text = "0 / 0"  # estado inicial, antes de agarrar el arma

func actualizar_balas(actuales: int, maximas: int) -> void:
	text = "%d / %d" % [actuales, maximas]
