extends KinematicBody2D

class_name CaptainVor

const LANCER_SCENE = preload("res://assets/scenes/npc/GrineerLancer.tscn")
const POWERUP_SCENE = preload("res://assets/scenes/misc/PowerUp.tscn")

onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimatedSprite/AnimationPlayer

onready var force_field = $ForceField
onready var baton_hitbox = $BatonHitbox
onready var melee_range = $MeleeRange
onready var raycast = $RayCast2D

onready var intro = $Intro
onready var baton_sfx = $BatonSFX
onready var force_field_sfx = $ForceFieldSFX
onready var hurt_stx = $HurtSFX
onready var death_sfx = $DeathSFX

onready var camera = $Camera2D

onready var intro_timer = $IntroTimer
onready var spawn_timer = $SpawnTimer
onready var death_timer = $DeathTimer

onready var boss_bar = $CanvasLayer/BossBar
onready var health_bar = $CanvasLayer/BossBar/HealthBar

const GRAVITY = 10
const SPEED = 200

var rng = RandomNumberGenerator.new()

var shield_health = 350
var health = 1000
var velocity = Vector2.ZERO
var normal = -1

var cut_scene = true
var is_player_in_melee_range = false

func get_class():
	return "CaptainVor"

func _spawn_entity(array):
	array.shuffle()
	var entity = array.front()
	entity.global_position = self.global_position
	get_parent().add_child(entity)

func _take_damage(damage):
	if !cut_scene:
		if shield_health > 0:
			shield_health -= damage
		else:
			health -= damage

func _handle_status():
	if shield_health <= 0:
		force_field.visible = false
		if spawn_timer.is_stopped():
			spawn_timer.start()
	else:
		force_field.visible = true

	if health <= 0:
		if death_timer.is_stopped():
			death_timer.start()
		if death_sfx.playing:
			death_sfx.play()

func _handle_movement():
	if cut_scene || is_player_in_melee_range || health <= 0:
		velocity.x = 0
	else:
		velocity.x = SPEED * normal

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP, true)

	if is_on_wall():
		normal *= -1
		raycast.position.x *= -1
		baton_hitbox.position.x *= -1
		melee_range.position.x *= -1
		animated_sprite.scale.x = -normal * 2

func _ready():
	health_bar.max_value = health

	camera.limit_left = 4384
	camera.limit_top = 1824
	camera.limit_right = 5184
	camera.limit_bottom = 2240
	camera.current = true

func _physics_process(_delta):
	if intro_timer.time_left == 3:
		intro.play()

	health_bar.value = health
	if health <= 0:
		queue_free()

	_handle_status()
	_handle_movement()

func _on_ForceField_area_entered(area):
	randomize()
	if area.name == "SwordHit":
		if force_field.visible:
			_take_damage(15 + rng.randi_range(-3, 7))
			force_field_sfx.play()

func _on_BatonHitbox_body_entered(body):
	if body.name == "Excalibur":
		baton_sfx.play()

func _on_MeleeRange_body_entered(body):
	if body.name == "Excalibur":
		is_player_in_melee_range = true

func _on_MeleeRange_body_exited(body):
	if body.name == "Excalibur":
		is_player_in_melee_range = false

func _on_CollisionArea_area_entered(area):
	if area.name == "SwordHit":
		_take_damage(10 + rng.randi_range(-5, 5))
		if !force_field.visible:
			hurt_stx.play()

func _on_SpawnTimer_timeout():
	_spawn_entity([LANCER_SCENE.instance(), POWERUP_SCENE.instance()])

func _on_Intro_finished():
	cut_scene = false
	boss_bar.visible = true
	camera.current = false

func _on_DeathTimer_timeout():
	queue_free()
