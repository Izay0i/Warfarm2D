extends Area2D

class_name PowerUp

onready var sfx = $SFX
onready var sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

func get_class():
	return "PowerUp"

func _on_PowerUp_body_entered(body):
	if body.name == "Excalibur":
		collision_shape.set_deferred("disabled", true)
		sprite.visible = false
		sfx.play()
		yield(sfx, "finished")
		queue_free()
