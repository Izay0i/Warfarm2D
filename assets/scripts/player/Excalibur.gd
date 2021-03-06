extends KinematicBody2D

#signal grounded_updated(is_grounded)

const BULLET_SCENE = preload("res://assets/scenes/misc/Bullet.tscn")

const DEBUG = false

const MAX_HEALTH = 300
const MAX_SHIELD = 300
const MAX_JUMPS = 2

export var move_speed = 200
export var health = MAX_HEALTH
export var shield = MAX_SHIELD

onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer
onready var sword_hitbox = $AnimatedSprite/SwordHit/CollisionShape2D
onready var bullet_position = $Position2D
onready var timer = $Timer
onready var recharge_timer = $RechargeTimer
onready var raycast = $RayCast2D
onready var test_for_spike = $TestForSpike
onready var camera = $Camera2D
onready var sword_sfx = $SwordSFX
onready var hurt_sfx = $HurtSFX
onready var player_health = $CanvasLayer/PlayerHealth
onready var controls_ui = $CanvasLayer/ControlsUI
onready var screen_shake = $Camera2D/ScreenShake

var gravity
var max_jump_velocity
var min_jump_velocity

var rng = RandomNumberGenerator.new()

var move_direction = 0
var velocity = Vector2.ZERO

var jump_count = 0
var on_ground = false
var can_move = false
var is_on_spike = false
var is_in_laser = false
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
	self.global_position = pos

func _take_damage(damage):
	hurt_sfx.play()
	recharge_timer.start()
	if shield > 0:
		shield -= damage
	else:
		health -= damage

#shield and health
func _handle_status():
	player_health.update_status(shield, health)

	if recharge_timer.is_stopped() && shield < MAX_SHIELD:
		shield += 1

	if shield < 0:
		shield = 0

	if health > MAX_HEALTH:
		health = MAX_HEALTH
	elif health <= 0:
		if get_tree().change_scene("res://assets/scenes/misc/GameOverScreen.tscn") != OK:
			print("Failed to change to game over screen")

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
		test_for_spike.scale.y = move_direction

func _handle_movement():
	if can_move:
		if Input.is_action_pressed("left") || Input.is_action_pressed("right"):
			#if !is_on_floor() || raycast.is_colliding():
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

#func _handle_shooting():
#	if Input.is_action_pressed("shoot") && !Input.is_action_pressed("melee"):
#		if move_direction == 0:
#				if timer.is_stopped():
#					if is_facing_right:
#						_shoot_bullet(1)
#					else:
#						_shoot_bullet(-1)
#					_reset_timer()

func _get_input():
	if DEBUG:
		if Input.is_action_pressed("debug"):
			_teleport(Vector2(7008, 2528))

#	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
#	if !is_on_floor() || raycast.is_colliding():
#		velocity.x = lerp(velocity.x, move_speed * move_direction, 1.0)
	_handle_direction()
	_handle_movement()
	_handle_jumping()
	#_handle_shooting()

func _apply_gravity(delta):
	velocity.y += gravity * delta

func _apply_movement():
	if is_on_floor() && !can_move:
		can_move = true
	
	var slope_stop = true if get_floor_velocity().x == 0 else false
	velocity = move_and_slide(velocity, Vector2.UP, slope_stop)

func _ready():
	move_speed = 3.25 * Global.UNIT_SIZE
	gravity = 0.87 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	
	_reset_timer()

func _physics_process(delta):
	if is_in_laser:
		_take_damage(20)

	if is_on_spike || (test_for_spike.is_colliding() && test_for_spike.get_collider().name == "CrystalSpike"):
		_take_damage(10)

	_handle_status()
	_get_input()
	_apply_gravity(delta)
	_apply_movement()

#	var was_grounded = is_grounded
#	is_grounded = is_on_floor()
#
#	if was_grounded == null || is_grounded != was_grounded:
#		emit_signal("grounded_updated", is_grounded)

func _on_AnimatedSprite_animation_finished():
	is_special_move = false

func _on_Timer_timeout():
	timer.one_shot = false

func _on_Area2D_area_entered(area):
	if area.get_class() == "PowerUp":
		health += 125
		return

	rng.randomize()
	if area.get_class() == "HomingMissile":
		_take_damage(200 + rng.randi_range(-3, 10))
		screen_shake.start()
		return

	if area.get_class() == "Bullet" && area.get_tag() == "LANCER":
		_take_damage(80 + rng.randi_range(-2, 2))
		return

	if area.get_parent().get_parent().get_class() == "Wisp":
		_take_damage(85 + rng.randi_range(-2, 2))
		return

	if area.name == "BatonHitbox":
		_take_damage(50 + rng.randi_range(5, 15))
		velocity.y -= 512
		return

	if area.name == "LaserHitbox":
		is_in_laser = true
		return

	if area.get_parent().get_class() == "Flamethrower":
		_take_damage(MAX_HEALTH * 0.45)
		return

func _on_Area2D_area_exited(area):
	if area.name == "LaserHitbox":
		is_in_laser = false

func _on_SwordSFX_finished():
	sound_has_played = true

func _on_Area2D_body_entered(body):
	if body.name == "CrystalSpike":
		is_on_spike = true

func _on_Area2D_body_exited(body):
	if body.name == "CrystalSpike":
		is_on_spike = false

func _on_SwordHit_body_entered(_body):
	sword_sfx.play()
	screen_shake.start(0.1, 15, 5)

func _on_SwordHit_area_entered(area):
	if area.get_class() == "Bullet" && area.get_tag() == "LANCER":
		area.queue_free()
		sword_sfx.play()
