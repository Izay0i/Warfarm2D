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
	get_tree().change_scene("res://assets/scenes/misc/TitleScreen.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
