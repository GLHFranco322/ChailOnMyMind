extends AnimatedSprite2D

func play_idle():
	play("IdleInmortal")
	
func play_Carga():
	play("CargaPortal")
	
func play_Presentacion():
	play("Spawn")

func play_GarraPortal():
	play("Portal")
	
func play_AbrirPortal():
	play("AtaquePortal")

func play_AtaqueFrontal():
	play("AtackDown")
