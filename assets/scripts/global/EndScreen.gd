extends Control

func _on_VideoPlayer_finished():
	if get_tree().change_scene("res://assets/scenes/misc/TitleScreen.tscn") != OK:
		print("Failed to change to title screen")
