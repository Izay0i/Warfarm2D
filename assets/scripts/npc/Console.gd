extends StaticBody2D

onready var health_display = $HealthDisplay

var health = 2000

func _take_damage(damage):
	health -= damage
	health_display.update_healthbar(health)

func _on_Area2D_area_entered(area):
	if area.get_class() == "Bullet" && area.get_tag() == "LANCER":
		_take_damage(10)
		return

	if area.get_class() == "HomingMissile":
		_take_damage(30)
		return
