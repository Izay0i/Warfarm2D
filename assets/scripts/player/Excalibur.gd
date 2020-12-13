extends KinematicBody2D

export var move_speed = 200
export var health = 300
export var shield = 200

signal grounded_updated(is_grounded)

const BULLET_SCENE = preload("res://assets/scenes/misc/Bullet.tscn")

const DEBUG = true

const SLOPE_STOP = 64
const MAX_JUMPS = 2
#const FALL_LIMIT = 512

onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var sword_hitbox = $AnimatedSprite/SwordHit/CollisionShape2D
onready var bullet_position = $Position2D
onready var timer = $Timer
onready var raycast = $RayCast2D
onready var camera = $Camera2D
onready var sword_sfx = $SwordSFX
onready var player_health = $PlayerHealth

var gravity
var max_jump_velocity
var min_jump_velocity

var rng = RandomNumberGenerator.new()

var move_direction = 0
var velocity = Vector2.ZERO

var jump_count = 0
var on_ground = false
var can_move = false
var is_special_move = false
var is_facing_right = true
var is_grounded

var sound_has_played = true

var max_jump_height = 3 * Global.UNIT_SIZE
var min_jump_height = 1.2 * Global.UNIT_SIZE
var jump_duration = 0.38

func _reset_timer():
	timer.one_shot = true
	timer.start()

func _shoot_bullet(direction):
	var bullet = BULLET_SCENE.instance()
	bullet.set_tag("PLAYER")
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position.global_position	
	bullet.set_bullet_direction(direction)

func _teleport(pos):
	get_parent().get_node("Excalibur").global_position = pos

func _take_damage(damage):
	if shield > 0:
		shield -= damage
	else:
		health -= damage

	print("Shield: %d Health: %d" % [shield, health])

#shield and health
func _handle_status():
	player_health.update_status(shield, health)

	if shield < 0:
		shield = 0

	if health < 0:
		health = 0
		if get_tree().reload_current_scene() != OK:
			print("Failed to reload current scene")

func _handle_direction():
	#player
	if Input.is_action_pressed("right"):
		move_direction = 1
		is_facing_right = true
	elif Input.is_action_pressed("left"):
		move_direction = -1
		is_facing_right = false
	else:
		move_direction = 0

	#bullet
	if Input.is_action_pressed("left"):
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1
	if Input.is_action_pressed("right"):
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1

	#sprite & hitbox
	if move_direction != 0:
		animated_sprite.scale.x = move_direction
		sword_hitbox.scale.x = move_direction

func _handle_movement():
	if can_move:
		if Input.is_action_pressed("left") || Input.is_action_pressed("right"):
			if !is_on_floor() || raycast.is_colliding():
				velocity.x = lerp(velocity.x, move_speed * move_direction, 0.5)
		else:
			velocity.x *= move_direction

func _handle_jumping():
	if is_on_floor():
		if !on_ground:
			jump_count = 0
			on_ground = true
	else:
		if on_ground:
			jump_count = 2
			on_ground = false

	if Input.is_action_just_pressed("jump"):
		if jump_count < MAX_JUMPS:
			jump_count += 1
			velocity.y = min_jump_velocity
			on_ground = false

func _handle_shooting():
	if Input.is_action_pressed("shoot") && !Input.is_action_pressed("melee"):
		if move_direction == 0:
				if timer.is_stopped():
					if is_facing_right:
						_shoot_bullet(1)
					else:
						_shoot_bullet(-1)
					_reset_timer()

func _get_input():
	if DEBUG:
		if Input.is_action_pressed("debug"):
			_teleport(Vector2(5248, 64))

#	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
#	if !is_on_floor() || raycast.is_colliding():
#		velocity.x = lerp(velocity.x, move_speed * move_direction, 1.0)
	_handle_direction()
	_handle_movement()
	_handle_jumping()
	_handle_shooting()

func _apply_gravity(delta):
	velocity.y += gravity * delta

func _apply_movement():
	if is_on_floor() && can_move == false:
		can_move = true
	
	velocity = move_and_slide(velocity, Vector2.UP, SLOPE_STOP)

func _ready():
	move_speed = 3.25 * Global.UNIT_SIZE
	gravity = 0.87 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	
	_reset_timer()

func _physics_process(delta):
	_handle_status()

	_get_input()
	_apply_gravity(delta)
	_apply_movement()

	var was_grounded = is_grounded
	is_grounded = is_on_floor()

	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)

#	if get_parent().get_node("Excalibur").global_position.y > FALL_LIMIT:
#		_teleport(Vector2(3840, 384))

func _on_AnimatedSprite_animation_finished():
	is_special_move = false

func _on_SwordHit_body_entered(_body):
	pass

func _on_Timer_timeout():
	timer.one_shot = false

func _on_Area2D_area_entered(area):
	if area.name == "FallArea1":
		_teleport(Vector2(1728, 288))

	if area.name == "FallArea2":
		_teleport(Vector2(3840, 384))

	if area.name == "FallArea3":
		_teleport(Vector2(5952, 296))

	if area.name == "FallArea4":
		_teleport(Vector2(9152, 360))

	rng.randomize()
	if area.get_class() == "HomingMissile":
		_take_damage(50 + rng.randi_range(-7, 10))

	if area.get_class() == "Bullet" && area.get_tag() == "LANCER":
		_take_damage(25 + rng.randi_range(-3, 2))

func _on_SwordSFX_finished():
	sound_has_played = true
