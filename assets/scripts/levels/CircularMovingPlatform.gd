extends Node2D

onready var animation_player = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name):
	animation_player.play(anim_name)
