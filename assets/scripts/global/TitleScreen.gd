extends Node2D

onready var margin_container = $MarginContainer
onready var start_button = $MarginContainer/VBoxContainer/VBoxContainer/StartButton
onready var exit_button = $MarginContainer/VBoxContainer/VBoxContainer/ExitButton

func _ready():
	start_button.grab_focus()

func _physics_process(_delta):
	if start_button.is_hovered():
		start_button.grab_focus()

	if exit_button.is_hovered():
		exit_button.grab_focus()

func _on_StartButton_pressed():
	if get_tree().change_scene("res://assets/scenes/levels/earth/StageOne.tscn") != OK:
		print("Failed to change to stage one")

func _on_ExitButton_pressed():
	get_tree().quit()
