extends Control

onready var continue_button = $ContinueButton
onready var exit_button = $ExitButton

func _ready():
	continue_button.grab_focus()

func _physics_process(_delta):
	if continue_button.is_hovered():
		continue_button.grab_focus()

	if exit_button.is_hovered():
		exit_button.grab_focus()

func _on_ContinueButton_pressed():
	if get_tree().change_scene(Global.current_stage) != OK:
			print("Failed to change to current stage")

func _on_ExitButton_pressed():
	Global.spawn_point = Vector2(-1, -1)
	Global.save_config()

	if get_tree().change_scene("res://assets/scenes/misc/TitleScreen.tscn") != OK:
		print("Failed to change to title screen")
