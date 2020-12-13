extends Node

const LANCER_SCENE = preload("res://assets/scenes/npc/GrineerLancer.tscn")
const BOMBARD_SCENE = preload("res://assets/scenes/npc/GrineerBombard.tscn")

#Going into game dev was a mistake
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
	Vector2(8571, 144),
	Vector2(9616, 400)
]

func _spawn_lancers():
	for pos in spawn_positions_lancer:
		_create_lancer(pos)

func _spawn_bombard():
	for pos in spawn_positions_bombard:
		_create_bombard(pos)

func _create_bombard(position):
	var bombard = BOMBARD_SCENE.instance()
	bombard.position = position
	get_parent().add_child(bombard)

func _create_lancer(position):
	var lancer = LANCER_SCENE.instance()
	lancer.position = position
	get_parent().add_child(lancer)

func _ready():
	call_deferred("_spawn_lancers")
	call_deferred("_spawn_bombard")
