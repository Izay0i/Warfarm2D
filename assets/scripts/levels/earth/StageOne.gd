extends Node

const MAX_ENEMIES = 13

const LANCER_SCENE = preload("res://assets/scenes/npc/GrineerLancer.tscn")
const BOMBARD_SCENE = preload("res://assets/scenes/npc/GrineerBombard.tscn")
const POWERUP_SCENE = preload("res://assets/scenes/misc/PowerUp.tscn")

onready var objective = $CanvasLayer/ObjectiveLabel
onready var objective_frame = $CanvasLayer/ObjectiveFrame
onready var lotus_ui = $CanvasLayer/Lowtus/LowtusUI
onready var dialog_label = $CanvasLayer/Lowtus/DialogLabel
onready var intro = $CanvasLayer/Lowtus/Intro
onready var ending = $CanvasLayer/Lowtus/Ending
onready var grineer_ship = $GrineerShip
onready var lowtus = $CanvasLayer/Lowtus
onready var tilemap = $TileMap
onready var bg_ambience = $BackgroundAmbience
onready var water_sfx = $WaterSFX
onready var dj_text = $Guides/DoubleJumpText
onready var dj_notifier_area = $FallAreas/DJNotifierArea/CollisionShape2D
onready var congrats_text = $Guides/CongratsText

var enemies_left = 0
var played_intro = false
var played_ending = false

#I'm running out of time
#NPC spawns
onready var spawn_positions_lancer : PoolVector2Array = [
	Vector2(3384, 688),
	Vector2(3880, 560),
	Vector2(4960, 464),
	Vector2(5448, 560),
	Vector2(5224, 560),
	Vector2(5936, 336),
	Vector2(5624, 336),
	Vector2(6024, 560),
	Vector2(6256, 688),
	Vector2(6440, 688),
	Vector2(6760, 400)
]

onready var spawn_positions_bombard : PoolVector2Array = [
	Vector2(5758, 336),
	Vector2(6976, 400)
]

onready var spawn_positions_powerup : PoolVector2Array = [
	Vector2(6232, 144)
]

func _spawn_lancers():
	for pos in spawn_positions_lancer:
		_create_lancer(pos)

func _create_lancer(position):
	var lancer = LANCER_SCENE.instance()
	lancer.position = position
	lancer.add_to_group("enemies")
	get_parent().add_child(lancer)

func _spawn_bombards():
	for pos in spawn_positions_bombard:
		_create_bombard(pos)

func _create_bombard(position):
	var bombard = BOMBARD_SCENE.instance()
	bombard.position = position
	bombard.add_to_group("enemies")
	get_parent().add_child(bombard)

func _spawn_power_ups():
	for pos in spawn_positions_powerup:
		_create_power_up(pos)

func _create_power_up(position):
	var powerup = POWERUP_SCENE.instance()
	powerup.position = position
	get_parent().add_child(powerup)

func _free_entities():
	for entity in self.get_parent().get_children():
		if entity.get_class() == "GrineerLancer" || entity.get_class() == "GrineerBombard":
			entity.queue_free()

		if entity.get_class() == "Bullet" || entity.get_class() == "HomingMissile":
			entity.queue_free()

		if entity.get_class() == "PowerUp":
			entity.queue_free()

func _play_intro():
		if !played_intro:
			lowtus.visible = true
			intro.play()
			played_intro = true
			dialog_label.text = "There is a large platoon of Grineer Marines\nstationed here.\nLeave no one standing."

func _play_ending():
		if played_intro:
			if enemies_left == 0 && !ending.is_playing() && !played_ending:
				bg_ambience.stop()
				lowtus.visible = true
				objective.visible = false
				objective_frame.visible = false
				ending.play()
				played_ending = true
				dialog_label.text = "All targets eliminated.\nLet's get out of here."

func _ready():
	Global.current_stage = self.filename
	Global.spawn_point = Vector2(-1, -1)
	Global.save_config()

	if !Global.music_on:
		bg_ambience.stream_paused = true

	call_deferred("_free_entities")
	call_deferred("_spawn_lancers")
	call_deferred("_spawn_bombards")
	call_deferred("_spawn_power_ups")

func _physics_process(_delta):
	enemies_left = get_tree().get_nodes_in_group("enemies").size()
	objective.text = "Eliminate all targets.\nEnemies left: %d/%d" % [enemies_left, MAX_ENEMIES]
	_play_ending()

func _on_Intro_finished():
	objective.visible = true
	objective_frame.visible = true
	lowtus.visible = false

func _on_Ending_finished():
	Global.tutorial_finished = true
	Global.save_config()

	lowtus.visible = false
	grineer_ship.enable_collision()
	grineer_ship.animated_sprite.play("hover")

func _on_FallArea1_body_entered(body):
	if body.name != "TileMap":
		body.global_position = Vector2(448, 512)
		water_sfx.play()

func _on_FallArea2_body_entered(body):
	if body.name != "TileMap":
		body.global_position = Vector2(2048, 448)
		water_sfx.play()

func _on_FallArea3_body_entered(body):
	if body.name != "TileMap":
		body.global_position = Vector2(4032, 512)
		water_sfx.play()

func _on_DJNotifierArea_body_entered(body):
	if body.name == "Excalibur":
		dj_text.visible = true

func _on_DjNotifierDisableArea_body_entered(body):
	if body.name == "Excalibur":
		dj_notifier_area.set_deferred("disabled", true)

func _on_TriggerStart_body_entered(body):
	if body.name == "Excalibur":
		congrats_text.visible = false
		body.controls_ui.visible = true
		_play_intro()
