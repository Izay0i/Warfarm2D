extends Node

const MAX_SPAWN_LIMIT = 25
const DUMMY_SCENE = preload("res://assets/scenes/npc/TargetDummy.tscn")

#Going into game dev was a mistake
#NPC spawns
#onready var spawn_positions : PoolVector2Array = [ 
#
#]
#
#func _spawn_enemies():
#	for pos in spawn_positions:
#		_create_enemy(pos)
#
#func _create_enemy(position):
#	var dummy = DUMMY_SCENE.instance()
#	dummy.position = position
#	get_parent().add_child(dummy)
#
#func _ready():
#	call_deferred("_spawn_enemies")
