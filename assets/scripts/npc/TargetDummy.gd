extends StaticBody2D

onready var health_display = $HealthDisplay

var health = 6

func _physics_process(_delta):
	health_display.update_healthbar(health)

	if health == 0:
		yield(get_tree().create_timer(0.2), "timeout")
		queue_free()

func _on_CollisionArea_area_entered(area):
	if area.name == "SwordHit":
		health -= 2
