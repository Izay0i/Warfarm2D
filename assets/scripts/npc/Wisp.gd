extends Node2D

class_name Wisp

onready var animation_player = $AnimationPlayer
onready var health_display = $AnimatedSprite/HealthDisplay

var health = 100
var rng = RandomNumberGenerator.new()

func get_class():
	return "Wisp"

func _physics_process(_delta):
	health_display.update_healthbar(health)

	if health <= 0:
		yield(get_tree().create_timer(0.1), "timeout")
		queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "circle":
		#animation_player.stop(true)
		animation_player.play()

func _on_Area2D_area_entered(area):
	if area.name == "SwordHit":
		#health -= 30 + rng.randi_range(-3, 4)
		pass
