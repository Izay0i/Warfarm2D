extends Node2D

onready var start_button = $StartButton
onready var exit_button = $ExitButton
onready var music_checkbox = $MusicOn

func _ready():
	Global.load_config()
	music_checkbox.pressed = Global.music_on
	start_button.grab_focus()

func _physics_process(_delta):
	if start_button.is_hovered():
		start_button.grab_focus()

	if exit_button.is_hovered():
		exit_button.grab_focus()

func _on_StartButton_pressed():
	if get_tree().change_scene("res://assets/scenes/misc/StageSelect.tscn") != OK:
		print("Failed to change to stage select")

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_MusicOn_pressed():
	Global.music_on = music_checkbox.pressed
	Global.save_config()
