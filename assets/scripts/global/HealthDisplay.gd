extends Node2D

const BAR_RED = preload("res://assets/textures/miscs/health/barHorizontal_red.png")
const BAR_GREEN = preload("res://assets/textures/miscs/health/barHorizontal_green.png")
const BAR_YELLOW = preload("res://assets/textures/miscs/health/barHorizontal_yellow.png")

onready var health_bar = $HealthBar

func update_healthbar(value):
	health_bar.texture_progress = BAR_GREEN
	if value < health_bar.max_value * 0.7:
		health_bar.texture_progress = BAR_YELLOW
	if value < health_bar.max_value * 0.35:
		health_bar.texture_progress = BAR_RED
	if value < health_bar.max_value:
		show()
	health_bar.value = value

func _ready():
	hide()
	if get_parent() && get_parent().get("health"):
		health_bar.max_value = get_parent().health

func _process(_delta):
	global_rotation = 0
