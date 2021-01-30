extends Area2D

class_name HomingMissile

export var speed = 175
export var steer_force = 50.0

onready var particles = $Particles2D
onready var animated_sprite = $AnimatedSprite
onready var sprite = $Sprite
onready var launch_sfx = $LaunchSFX
onready var explode_sfx = $ExplodeSFX

var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func get_class():
	return "HomingMissile"

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func start(_transform, _target):
	target = _target
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed

func _explode():
	particles.emitting = false
	set_physics_process(false)
	sprite.visible = false
	animated_sprite.play("explode")
	explode_sfx.play()
	yield(animated_sprite, "animation_finished")
	queue_free()

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta

func _on_HomingMissile_body_entered(body):
	if body.name == "Excalibur" || body.name == "Console":
		_explode()

func _on_Timer_timeout():
	_explode()
