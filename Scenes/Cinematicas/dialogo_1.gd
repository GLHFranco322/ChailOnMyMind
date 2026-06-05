extends Sprite2D

@export var texto:String = "":
	set(value):
		visible = true
		texto = value
		$Timer.start()
		
var index = 0;
		
func _ready():
	pass
	
func _procces(delta):
	pass

func _on_timer_timeout():
	if index >= texto.length():
		$Timer_escondedialogo.start()
		$Timer.stop()
	else:
		$Label.text = $Label.text + texto[index]
		index += 1


func _on_timer_escondedialogo_timeout() -> void:
	visible = false
