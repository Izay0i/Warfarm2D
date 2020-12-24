extends KinematicBody2D

class_name CaptainVor

onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

onready var force_field = $ForceField
onready var baton_hitbox = $BatonHitbox
onready var melee_range = $MeleeRange

onready var baton_sfx = $BatonSFX
onready var hurt_stx = $HurtSFX

onready var camera = $Camera2D
onready var charge_up_timer = $ChargeUpTimer

const GRAVITY = 10
const SPEED = 150

var rng = RandomNumberGenerator.new()

var shield_health = 200
var health = 1000
var velocity = Vector2.ZERO
var normal = -1

var is_player_in_melee_range = false

func get_class():
	return "CaptainVor"

func _take_damage(damage):
	if shield_health > 0:
		shield_health -= damage
	else:
		health -= damage

func _handle_status():
	if shield_health <= 0:
		force_field.visible = false

func _handle_movement():
	if force_field.visible:
		velocity.x = 0
	else:
		velocity.x = SPEED * normal

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_wall():
		normal *= -1
		animated_sprite.scale.x = -normal
		baton_hitbox.scale.x = -normal
		melee_range.scale.x = -normal

func _physics_process(_delta):
	_handle_status()
	_handle_movement()

func _on_ForceField_area_entered(area):
	randomize()
	if area.get_class() == "Bullet" && area.get_tag() == "PLAYER":
		_take_damage(10 + rng.randi_range(-5, 2))
		hurt_stx.play()

	if area.name == "SwordHit":
		_take_damage(15 + rng.randi_range(-3, 7))
		hurt_stx.play()

func _on_BatonHitbox_body_entered(body):
	if body.name == "Excalibur":
		baton_sfx.play()

func _on_MeleeRange_body_entered(body):
	if body.name == "Excalibur":
		is_player_in_melee_range = true

func _on_MeleeRange_body_exited(_body):
	is_player_in_melee_range = false
