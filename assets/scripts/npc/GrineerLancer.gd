extends KinematicBody2D

class_name GrineerLancer

const BULLET_SCENE = preload("res://assets/scenes/misc/Bullet.tscn")

onready var animated_sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var bullet_position = $Position2D
onready var detection_area = $DetectionArea
onready var timer = $Timer
onready var death_timer = $DeathTimer
onready var collision_shape = $CollisionShape2D
onready var health_display = $HealthDisplay

const GRAVITY = 10
const SPEED = 100

var rng = RandomNumberGenerator.new()

var health = 300
var velocity = Vector2.ZERO
var normal = -1
var is_enemy_spotted = false
var active = false

func get_class():
	return "GrineerLancer"

func _teleport(pos):
	self.global_position = pos

func _start_timer():
	timer.one_shot = true
	timer.start()

func _start_death_timer():
	death_timer.start()

func _shoot_bullet(direction):
	var bullet = BULLET_SCENE.instance()
	bullet.set_tag("LANCER")
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position.global_position	
	bullet.set_bullet_direction(direction)

func _take_damage(damage):
	health -= damage
	health_display.update_healthbar(health)

func _handle_status():
	if health <= 0:
		velocity = Vector2.ZERO
		collision_shape.disabled = true
		if death_timer.is_stopped():
			_start_death_timer()

func _handle_movement():
	if health > 0:
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
			detection_area.position.x *= -1
			animated_sprite.scale.x = -normal

		if !raycast.is_colliding():
			normal *= -1
			raycast.position.x *= -1
			bullet_position.position.x *= -1
			detection_area.position.x *= -1
			animated_sprite.scale.x = -normal

func _ready():
	_start_timer()

func _physics_process(_delta):
	if active:
		_handle_status()
		_handle_movement()

func _on_DetectionArea_body_entered(body):
	if body.name == "Excalibur":
		is_enemy_spotted = true

func _on_DetectionArea_body_exited(body):
	if body.name == "Excalibur":
		is_enemy_spotted = false

func _on_Timer_timeout():
	timer.one_shot = false

func _on_CollisionArea_area_entered(area):
	if active:
		rng.randomize()
		if area.get_class() == "Bullet" && area.get_tag() == "PLAYER":
			_take_damage(20 + rng.randi_range(-3, 5))
			print(health)

		if area.name == "SwordHit":
			_take_damage(35 + rng.randi_range(-5, 5))
			print(health)

	if area.name == "FallArea1":
		_teleport(Vector2(1728, 288))

	if area.name == "FallArea2":
		_teleport(Vector2(3840, 384))

	if area.name == "FallArea3":
		_teleport(Vector2(5952, 296))

	if area.name == "FallArea4":
		_teleport(Vector2(9152, 360))

func _on_DeathTimer_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func _on_VisibilityNotifier2D_screen_exited():
	active = false
