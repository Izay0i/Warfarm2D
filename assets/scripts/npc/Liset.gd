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
	player.position = get_node(".").global_position
	get_parent().add_child(player)
	print(get_parent().name)

func _physics_process(delta):
	_move_forward(delta)
	_move_up(delta)
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	print("Landing craft exited")
