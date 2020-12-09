extends KinematicBody2D

const GRAVITY = 10
const SPEED = 100

var velocity = Vector2.ZERO
var normal = -1

func _physics_process(delta):
	velocity.x = SPEED * normal
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$AnimatedSprite.play("run")

	if is_on_wall():
		normal *= -1
		$AnimatedSprite.scale.x = -normal
		$RayCast2D.position.x *= -1

	if !$RayCast2D.is_colliding():
		normal *= -1
		$AnimatedSprite.scale.x = -normal
		$RayCast2D.position.x *= -1
