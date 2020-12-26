extends KinematicBody2D

const MOVE_SPEED = 64
const EXCALIBUR_SCENE = preload("res://assets/scenes/player/Excalibur.tscn")

onready var timer = $Timer
onready var camera = $Camera2D

var player
var velocity = Vector2.ZERO

func _move_forward(delta):
	if !timer.is_stopped():
		velocity.x = MOVE_SPEED * delta
	
func _move_up(delta):
	if timer.is_stopped():
		if !is_instance_valid(player):
			_spawn_player()
		camera.current = false
		player.camera.current = true
		velocity.y = -MOVE_SPEED * delta

func _spawn_player():
	player = EXCALIBUR_SCENE.instance()
	player.position.x = get_node(".").global_position.x
	player.position.y = get_node(".").global_position.y + 50
	get_parent().add_child(player)
	player.controls_ui.visible = false
	
	player.camera.limit_left = 0
	player.camera.limit_top = -136
	player.camera.limit_right = 7360
	player.camera.limit_bottom = 736

func _physics_process(delta):
	_move_forward(delta)
	_move_up(delta)
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	print("Landing craft exited")
