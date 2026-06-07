extends Control

func _ready():
	visible = false

func _process(delta):
	testEsc()

func resume():
	get_tree().paused = false
	visible = false

func pause():
	get_tree().paused = true
	visible = true

func testEsc():
	if Input.is_action_just_pressed("Paused"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout

func _on_control_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Controls.tscn")


func _on_exit_game_pressed():
	SoundManager.play_click()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menú.tscn")


func _on_control_mouse_entered():
	SoundManager.play_hover()


func _on_reanudar_mouse_entered():
	SoundManager.play_hover()


func _on_exit_game_mouse_entered():
	SoundManager.play_hover()
