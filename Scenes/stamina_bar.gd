extends ProgressBar

func _ready() -> void:
	add_to_group("StaminaBar")
	visible = false
	value = 0
