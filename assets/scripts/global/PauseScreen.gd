extends Control

onready var resume_button = $MarginContainer/CenterContainer/VBoxContainer/ResumeButton
onready var exit_button = $MarginContainer/CenterContainer/VBoxContainer/ExitButton

func _ready():
	resume_button.grab_focus()

func _physics_process(_delta):
	if resume_button.is_hovered():
		resume_button.grab_focus()
	if exit_button.is_hovered():
		exit_button.grab_focus()

func _input(event):
	if event.is_action_pressed("exit"):
		resume_button.grab_focus()
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_ResumeButton_pressed():
	get_tree().paused = !get_tree().paused
	visible = !visible

func _on_ExitButton_pressed():
	Global.spawn_point = Vector2(-1, -1)
	Global.save_config()

	get_tree().paused = !get_tree().paused
	if get_tree().change_scene("res://assets/scenes/misc/TitleScreen.tscn") != OK:
		print("Failed to change to title screen")
