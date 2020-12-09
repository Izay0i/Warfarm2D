extends Area2D

const BULLET_SPEED = 200

onready var timer = $Timer
onready var sprite = $Sprite

var velocity = Vector2.ZERO
var direction = 1

func _ready():
	timer.wait_time = 2.0
	timer.one_shot = true

func set_bullet_direction(dir):
	direction = dir
	sprite.scale.x = direction

func _process(delta):
	velocity.x = BULLET_SPEED * delta * direction
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	if !is_instance_valid(timer):
		get_parent().add_child(timer)
		timer.start()

#static body detection
func _on_Bullet_body_entered(body):
	queue_free()
	print("Hit the " + body.get_name())	
	print(body.global_position)

func _on_Timer_timeout():
	print("Bullet exited the screen after 2s")
	queue_free()
