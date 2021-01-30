extends Node

const LANCER_SCENE = preload("res://assets/scenes/npc/GrineerLancer.tscn")
const BOMBARD_SCENE = preload("res://assets/scenes/npc/GrineerBombard.tscn")

onready var bg_ambience = $BackgroundAmbience

onready var excalibur = $Excalibur
onready var console = $Console
onready var blue_gate = $BlueGate

onready var objective_timer = $ObjectiveTimer

onready var spawn_timer = $SpawnTimer
onready var spawn_area_1 = $SpawnArea1
onready var spawn_area_2 = $SpawnArea2

onready var trigger_area = $TriggerArea
onready var trigger_collision_shape = $TriggerArea/CollisionShape2D

onready var lowtus = $CanvasLayer/Lowtus
onready var dialog_label = $CanvasLayer/Lowtus/DialogLabel
onready var dialog_timer = $CanvasLayer/Lowtus/DialogTimer
onready var intro = $CanvasLayer/Lowtus/Intro
onready var ending = $CanvasLayer/Lowtus/Ending
onready var spotted = $CanvasLayer/Lowtus/TowerSpotted

onready var objective_frame = $CanvasLayer/ObjectiveFrame
onready var objective_label = $CanvasLayer/ObjectiveLabel

func _set_camera_limit(left, top, right, bottom):
	excalibur.camera.limit_left = left
	excalibur.camera.limit_top = top
	excalibur.camera.limit_right = right
	excalibur.camera.limit_bottom = bottom

func _spawn_enemy(position, array):
	array.shuffle()
	var enemy = array.front()
	self.add_child(enemy)
	enemy.global_position = position

func _play_intro():
	intro.play()
	lowtus.visible = true
	dialog_label.text = "We have located the enemy's planetary communication tower.\nCapture the tower and remain in control long enough to decode incoming messages."

func _play_ending():
	ending.play()
	lowtus.visible = true
	dialog_label.text = "We have successfully decoded the message.\nHead to extraction."

func _play_tower_spotted():
	spotted.play()
	lowtus.visible = true
	dialog_label.text = "Tower captured, beginning stream decode now."

func _ready():
	Global.current_stage = self.filename
	Global.save_config()

	_set_camera_limit(0, 0, 1024, 1152)

func _physics_process(_delta):
	if console.health <= 0 && objective_timer.time_left > 0:
		if get_tree().change_scene("res://assets/scenes/misc/GameOverScreen.tscn") != OK:
			print("Failed to change to game over screen")

	if dialog_timer.time_left == 3:
		_play_intro()

	if !objective_timer.is_stopped():
		objective_label.text = "Defend the tower\nfor %d seconds." % objective_timer.time_left

func _on_CamTransit_body_entered(body):
	if body.name == "Excalibur":
		_set_camera_limit(0, 0, 1600, 1152)

func _on_SpawnTimer_timeout():
	_spawn_enemy(spawn_area_1.position, [LANCER_SCENE.instance(), BOMBARD_SCENE.instance()])
	_spawn_enemy(spawn_area_2.position, [LANCER_SCENE.instance(), BOMBARD_SCENE.instance()])

	if objective_timer.time_left > 0:
		spawn_timer.start()

func _on_ObjectiveTimer_timeout():
	blue_gate.queue_free()
	_play_ending()

	for enemy in self.get_children():
		if enemy.get_class() == "GrineerLancer" || enemy.get_class() == "GrineerBombard":
			enemy.queue_free()

func _on_LisetArea_body_entered(body):
	if body.name == "Excalibur":
		if get_tree().change_scene("res://assets/scenes/levels/earth/StageTwo.tscn") != OK:
			print("Failed to change to stage two")

func _on_Intro_finished():
	lowtus.visible = false
	trigger_collision_shape.set_deferred("disabled", false)

func _on_Ending_finished():
	if Global.levels_unlocked == 2:
		Global.levels_unlocked = 3

	lowtus.visible = false

	if bg_ambience.playing:
		bg_ambience.stream_paused = true

func _on_TowerSpotted_finished():
	lowtus.visible = false
	objective_frame.visible = true
	objective_label.visible = true
	objective_timer.start()
	spawn_timer.start()

	if !bg_ambience.playing && Global.music_on:
		bg_ambience.play()

func _on_TriggerArea_body_entered(body):
	if body.name == "Excalibur":
		_play_tower_spotted()
		trigger_collision_shape.set_deferred("disabled", true)
