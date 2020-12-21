extends Node

const ELEVATOR_SCENE = preload("res://assets/scenes/tileset/Elevator.tscn")

onready var tilemap = $TileMap
onready var excalibur = $Excalibur
onready var distortion_intro = $DistortionWorldIntro
onready var distortion_loop = $DistortionWorldLoop

onready var spawn_timer = $ElevatorSpawner/SpawnTimer
onready var spawner_1 = $ElevatorSpawner/Spawner
onready var spawner_2 = $ElevatorSpawner/Spawner2

onready var planet_bg = $ParallaxBackground/PurplePlanet
onready var bg_1 = $ParallaxBackground/Background1
onready var bg_2 = $ParallaxBackground/Background2
onready var bg_3 = $ParallaxBackground/Background3
onready var bg_4 = $ParallaxBackground/Background4
onready var bg_5 = $ParallaxBackground/Background5

func _set_camera_limit(left, top, right, bottom):
	excalibur.camera.limit_left = left
	excalibur.camera.limit_top = top
	excalibur.camera.limit_right = right
	excalibur.camera.limit_bottom = bottom

func _ready():
	_set_camera_limit(80, 0, 896, 672)

func _spawn_elevator(spawner):
	var elevator = ELEVATOR_SCENE.instance()
	get_parent().add_child(elevator)
	elevator.global_position = spawner.global_position

func _free_entities():
	for projectile in self.get_parent().get_children():
		if projectile.get_class() == "Bullet" || projectile.get_class() == "HomingMissile":
			projectile.queue_free()

	for wisp in self.get_node("Wisps").get_children():
		wisp.queue_free()

	for grineer in self.get_node("Grineers").get_children():
		grineer.queue_free()

	for power_up in self.get_node("PowerUps").get_children():
		power_up.queue_free()

func _on_DistortionWorldIntro_finished():
	if !distortion_loop.playing:
		distortion_loop.play()

#Show me your motivation
func _on_TransitionToMain_body_entered(body):
	if body.name == "Excalibur":
		yield(get_tree().create_timer(0.7), "timeout")

		planet_bg.visible = false
		bg_1.visible = true
		bg_2.visible = true
		bg_3.visible = true
		bg_4.visible = true
		bg_5.visible = true

		_set_camera_limit(160, 1024, 1920, 1760)
		excalibur.global_position = Vector2(256, 1250)

func _on_CamTransit1_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(160, 1760, 1920, 2208)

func _on_CamTransit2_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(160, 2192, 864, 2944)

func _on_CamTransit3_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(512, 2192, 864, 2944)

func _on_CamTransit4_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(896, 2208, 1920, 2720)

func _on_CamTransit5_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(832, 2752, 1632, 2944)

func _on_CamTransit6_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(512, 2192, 864, 2944)

func _on_CamTransit7_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(1952, 1888, 2240, 2784)

func _on_CamTransit8_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(2464, 1312, 3200, 2176)

func _on_CamTransit9_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(3200, 1248, 4160, 1568)

func _on_CamTransit10_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(2272, 2176, 4352, 2624)

func _on_CamTransit11_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(2272, 2656, 4224, 3008)

func _on_CamTransit12_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(3904, 3072, 4224, 3328)

func _on_CamTransit13_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(5184, 2080, 6144, 2368)

		bg_2.visible = false
		bg_3.visible = false
		bg_4.visible = false
		bg_5.visible = false

func _on_CamTransit14_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(5664, 1920, 6144, 2368)

func _on_Door1_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(3232, 1600, 4352, 2144)
		excalibur.global_position = Vector2(3344, 1776)

func _on_Door2_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(4256, 2496, 7136, 3328)
		excalibur.global_position = Vector2(4368, 3280)

#Boss door
func _on_Door3_body_entered(body):
	if body.name == "Excalibur":
		_free_entities()
		distortion_intro.stop()
		distortion_loop.stop()
		_set_camera_limit(4384, 1824, 5184, 2240)
		excalibur.global_position = Vector2(4496, 2192)

func _on_Despawner_body_entered(body):
	if body.get_parent().get_class() == "Elevator":
		body.queue_free()

func _on_Despawner2_body_entered(body):
	if body.get_parent().get_class() == "Elevator":
		body.queue_free()

func _on_SpawnTimer_timeout():
	_spawn_elevator(spawner_1)
	_spawn_elevator(spawner_2)
	spawn_timer.start()
