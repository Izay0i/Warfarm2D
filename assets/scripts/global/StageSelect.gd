extends Node2D

onready var stage_one_button = $StageOneButton
onready var stage_two_button = $StageTwoButton
onready var back_button = $BackButton
onready var bg_ambience = $BackgroundAmbience

func _ready():
	if !Global.music_on:
		bg_ambience.stream_paused = true

func _physics_process(_delta):
	stage_two_button.disabled = !Global.tutorial_finished

func _on_StageOneButton_pressed():
	if get_tree().change_scene("res://assets/scenes/levels/earth/StageOne.tscn") != OK:
		print("Failed to change to stage one")

func _on_StageTwoButton_pressed():
	if Global.tutorial_finished:
		if get_tree().change_scene("res://assets/scenes/levels/earth/StageTwo.tscn") != OK:
			print("Failed to change to stage two")

func _on_BackButton_pressed():
	if get_tree().change_scene("res://assets/scenes/misc/TitleScreen.tscn") != OK:
		print("Failed to change to title screen")
