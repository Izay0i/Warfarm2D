extends Node

onready var tilemap = $TileMap
onready var excalibur = $Excalibur
onready var distortion_intro = $DistortionWorldIntro
onready var distortion_loop = $DistortionWorldLoop

func _set_camera_limit(left, right, top, bottom):
	excalibur.camera.limit_left = left
	excalibur.camera.limit_right = right
	excalibur.camera.limit_top = top
	excalibur.camera.limit_bottom = bottom

func _ready():
	#_set_camera_limit(80, 896, 0, 672)
	_set_camera_limit(0, 100000, 0, 100000)

func _on_DistortionWorldIntro_finished():
	if !distortion_loop.is_playing():
		distortion_loop.play()

func _on_TransitionToMain_body_entered(body):
	if body.name == "Excalibur":
		#_set_camera_limit(160, 1664, 0, 1728)
		#yield(get_tree().create_timer(0.5), "timeout")
		excalibur.global_position = Vector2(256, 1184)
