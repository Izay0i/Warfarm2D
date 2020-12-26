extends Node2D

onready var shield = $Shield
onready var health = $Health
onready var shield_text = $Label
onready var health_text = $Label2

func update_status(_shield, _health):
	shield.value = _shield
	health.value = _health

	shield_text.text = "SHIELD"
	health_text.text = "HEALTH"

func _ready():
	shield.max_value = get_parent().get_parent().get("shield")
	health.max_value = get_parent().get_parent().get("health")

func _process(_delta):
	global_rotation = 0
