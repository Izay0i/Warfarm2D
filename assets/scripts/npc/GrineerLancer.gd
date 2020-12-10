extends KinematicBody2D

onready var timer = $Timer
onready var animated_sprite = $AnimatedSprite
onready var raycast = $RayCast2D

const GRAVITY = 10
const SPEED = 100

var velocity = Vector2.ZERO
var normal = -1

func reset_timer():
	timer.one_shot = true
	timer.start()

func handle_movement(delta):
	velocity.x = SPEED * normal
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_wall():
		normal *= -1
		animated_sprite.scale.x = -normal
		raycast.position.x *= -1

	if !raycast.is_colliding():
		normal *= -1
		animated_sprite.scale.x = -normal
		raycast.position.x *= -1

func _on_Timer_timeout():
	timer.one_shot = false

func _physics_process(delta):
	handle_movement(delta)
