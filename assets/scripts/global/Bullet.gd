extends Area2D

class_name Bullet

const BULLET_SPEED = 200

onready var timer = $Timer
onready var sprite = $Sprite

var tag
var velocity = Vector2.ZERO
var direction = 1

func set_tag(t):
	tag = t

func get_tag():
	return tag

func set_bullet_direction(dir):
	direction = dir
	sprite.scale.x = direction

func get_class():
	return "Bullet"

func _physics_process(delta):
	velocity.x = BULLET_SPEED * delta * direction
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	if !is_instance_valid(timer):
		get_parent().add_child(timer)
	timer.start()

#static body detection
func _on_Bullet_body_entered(body):
	if (body.name == "Excalibur" && tag == "LANCER") || tag == "PLAYER":
		queue_free()

	#print("Hit the " + body.get_name())	
	#print(body.global_position)

func _on_Timer_timeout():
	print("Bullet exited the screen after 5s")
	queue_free()
