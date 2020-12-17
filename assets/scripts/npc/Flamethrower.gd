extends StaticBody2D

class_name Flamethrower

func get_class():
	return "Flamethrower"

func _physics_process(_delta):
	$Fire/AnimationPlayer.play("fire")
