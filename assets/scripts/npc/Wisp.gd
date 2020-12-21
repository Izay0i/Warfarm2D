extends Node2D

class_name Wisp

onready var animation_player = $AnimationPlayer

func get_class():
	return "Wisp"

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "circle":
		#animation_player.stop(true)
		animation_player.play()
