extends KinematicBody2D

const BULLET_SCENE = preload("res://assets/scenes/misc/Bullet.tscn")

onready var animated_sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var bullet_position = $Position2D
onready var detection_area = $DetectionArea
onready var timer = $Timer

const GRAVITY = 10
const SPEED = 100

var health = 300
var velocity = Vector2.ZERO
var normal = -1
var is_enemy_spotted = false

func _start_timer():
	timer.one_shot = true
	timer.start()

func _shoot_bullet(direction):
	var bullet = BULLET_SCENE.instance()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position.global_position	
	bullet.set_bullet_direction(direction)

func _handle_movement(delta):
	if is_enemy_spotted == false:
		velocity.x = SPEED * normal
	else:
		velocity.x = 0
		if timer.is_stopped():
			_shoot_bullet(normal)
			_start_timer()

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_wall():
		normal *= -1
		raycast.position.x *= -1
		bullet_position.position.x *= -1
		animated_sprite.scale.x = -normal
		detection_area.scale.x = -normal

	if !raycast.is_colliding():
		normal *= -1
		raycast.position.x *= -1
		bullet_position.position.x *= -1
		animated_sprite.scale.x = -normal
		detection_area.scale.x = -normal

func _ready():
	_start_timer()

func _physics_process(delta):
	_handle_movement(delta)

func _on_DetectionArea_body_entered(body):
	if body.name == "Excalibur":
		is_enemy_spotted = true

func _on_DetectionArea_body_exited(body):
	if body.name == "Excalibur":
		is_enemy_spotted = false

func _on_Timer_timeout():
	timer.one_shot = false
