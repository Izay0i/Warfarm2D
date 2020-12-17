extends Node

const MAX_ENEMIES = 37

const LANCER_SCENE = preload("res://assets/scenes/npc/GrineerLancer.tscn")
const BOMBARD_SCENE = preload("res://assets/scenes/npc/GrineerBombard.tscn")
const POWERUP_SCENE = preload("res://assets/scenes/misc/PowerUp.tscn")

onready var objective = $CanvasLayer/ObjectiveLabel
onready var objective_frame = $CanvasLayer/ObjectiveFrame
onready var lotus_ui = $CanvasLayer/Lowtus/LowtusUI
onready var dialog_label = $CanvasLayer/Lowtus/DialogLabel
onready var dialog_timer = $CanvasLayer/Lowtus/DialogTimer
onready var intro = $CanvasLayer/Lowtus/Intro
onready var ending = $CanvasLayer/Lowtus/Ending
onready var grineer_ship = $GrineerShip
onready var lowtus = $CanvasLayer/Lowtus
onready var tilemap = $TileMap
onready var bg_ambience = $BackgroundAmbience

var enemies_left = 0
var played_intro = false
var played_ending = false

#I'm running out of time
#NPC spawns
onready var spawn_positions_lancer : PoolVector2Array = [
	Vector2(592, 272),
	Vector2(1040, 400),
	Vector2(1280, 400),
	Vector2(1120, 16),
	Vector2(1248, 16),
	Vector2(1576, 112),
	Vector2(1680, 240),
	Vector2(2160, 304),
	Vector2(2544, 176),
	Vector2(2704, 112),
	Vector2(3088, 432),
	Vector2(2872, 464),
	Vector2(3296, 48),
	Vector2(3552, 240),
	Vector2(3600, 432),
	Vector2(3752, 432),
	Vector2(3896, 432),
	Vector2(4624, 304),
	Vector2(4760, 112),
	Vector2(5248, 112),
	Vector2(5048, 112),
	Vector2(5824, 464),
	Vector2(5632, 464),
	Vector2(7072, 208),
	Vector2(8176, 464),
	Vector2(8512, 368),
	Vector2(8112, 272),
	Vector2(8216, 656),
	Vector2(8416, 656),
	Vector2(8584, 656),
	Vector2(9016, 176),
	Vector2(9904, 112)
]

onready var spawn_positions_bombard : PoolVector2Array = [
	Vector2(6555, 304),
	Vector2(7906, 656),
	Vector2(8304, 656),
	Vector2(8571, 144),
	Vector2(9616, 400)
]

onready var spawn_positions_powerup : PoolVector2Array = [
	Vector2(1072, -144),
	Vector2(3592, 392),
	Vector2(5352, 248),
	Vector2(7688, 552),
	Vector2(8792, 392)
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

func _ready():
	call_deferred("_free_entities")
	call_deferred("_spawn_lancers")
	call_deferred("_spawn_bombards")
	call_deferred("_spawn_power_ups")

func _physics_process(_delta):
	if !played_intro:
		for node in get_children():
			if node.name == "Excalibur":
				if dialog_timer.is_stopped():
					dialog_timer.start()
				if dialog_timer.time_left == 3 && !intro.is_playing():
					lowtus.visible = true
					intro.play()
					played_intro = true
					dialog_label.text = "There is a large platoon of Grineer Marines\nstationed here.\nLeave no one standing."

	enemies_left = get_tree().get_nodes_in_group("enemies").size() - 1
	objective.text = "Enemies left: %d/%d" % [enemies_left, MAX_ENEMIES]

	if played_intro:
		if enemies_left == 0 && !ending.is_playing() && !played_ending:
			bg_ambience.stop()
			grineer_ship.enable_collision()
			grineer_ship.animated_sprite.play("hover")
			lowtus.visible = true
			objective.visible = false
			objective_frame.visible = false
			ending.play()
			played_ending = true
			dialog_label.text = "All targets eliminated.\nLet's get out of here."

func _on_Intro_finished():
	objective.visible = true
	objective_frame.visible = true
	lowtus.visible = false

func _on_Ending_finished():
	lowtus.visible = false
