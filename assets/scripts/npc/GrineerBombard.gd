extends KinematicBody2D

class_name GrineerBombard

const MISSILE_SCENE = preload("res://assets/scenes/misc/HomingMissile.tscn")

onready var animated_sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var missile_position = $Bombard/Position2D
onready var detection_area = $DetectionArea
onready var timer = $Timer
onready var death_timer = $DeathTimer
onready var collision_shape = $CollisionShape2D
onready var bombard = $Bombard
onready var health_display = $HealthDisplay

const GRAVITY = 10
const SPEED = 100

var rng = RandomNumberGenerator.new()

var target = null
var health = 500
var velocity = Vector2.ZERO
var normal = -1
var is_enemy_spotted = false
var active = false

func get_class():
	return "GrineerBombard"

func _start_timer():
	timer.one_shot = true
	timer.start()

func _start_death_timer():
	death_timer.start()

func _shoot_missile():
	var missile = MISSILE_SCENE.instance()
	get_parent().add_child(missile)
	missile.start(missile_position.global_transform, target)

func _find_target():
	var units = detection_area.get_overlapping_bodies()
	if units.size() > 0:
		var closet = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closet.global_position):
				closet = unit
		target = closet
	else:
		target = null

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
				_shoot_missile()
				_start_timer()

		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)

		if is_on_wall():
			normal *= -1
			raycast.position.x *= -1
			missile_position.position.x *= -1
			animated_sprite.scale.x = -normal
			detection_area.scale.x = -normal
			detection_area.position.x *= -1

		if !raycast.is_colliding():
			normal *= -1
			raycast.position.x *= -1
			missile_position.position.x *= -1
			animated_sprite.scale.x = -normal
			detection_area.scale.x = -normal
			detection_area.position.x *= -1

func _ready():
	_start_timer()

func _physics_process(_delta):
	if active:
		if !target:
			_find_target()
		
		_handle_status()
		_handle_movement()

func _on_DetectionArea_body_entered(body):
	if body.name == "Excalibur":
		is_enemy_spotted = true

func _on_DetectionArea_body_exited(body):
	if body.name == "Excalibur":
		is_enemy_spotted = false

	if body == target:
		target = null

func _on_Timer_timeout():
	timer.one_shot = false

func _on_CollisionArea_area_entered(area):
	if active:
		rng.randomize()
		if area.get_class() == "Bullet" && area.get_tag() == "PLAYER":
			_take_damage(10 + rng.randi_range(-5, 5))
			print(health)

		if area.name == "SwordHit":
			_take_damage(25 + rng.randi_range(-6, 5))
			print(health)

func _on_DeathTimer_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func _on_VisibilityNotifier2D_screen_exited():
	active = false
