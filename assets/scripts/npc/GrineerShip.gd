extends KinematicBody2D

onready var collision_shape = $CollisionShape2D
onready var animated_sprite = $AnimatedSprite
onready var area = $ChangeSceneArea/CollisionShape2D

func enable_collision():
	area.set_deferred("disabled", false)

func disable_collision():
	area.set_deferred("disabled", true)

func _on_ChangeSceneArea_body_entered(body):
	if body.name == "Excalibur":
		if get_tree().change_scene("res://assets/scenes/levels/earth/StageTwo.tscn") != OK:
			print("Failed to change to title screen")
