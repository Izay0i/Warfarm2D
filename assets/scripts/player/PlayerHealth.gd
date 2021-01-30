extends Node2D

onready var shield = $Shield
onready var health = $Health

func update_status(_shield, _health):
	shield.value = _shield
	health.value = _health

func _ready():
	shield.max_value = get_parent().get_parent().get("shield")
	health.max_value = get_parent().get_parent().get("health")

func _process(_delta):
	global_rotation = 0
