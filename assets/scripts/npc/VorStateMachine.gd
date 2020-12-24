extends Node

onready var parent = get_parent()

enum {
	RUN,
	MELEE,
	SHOOT
}

var state = RUN

func _animate():
	match state:
		RUN:
			if parent.charge_up_timer.time_left == 0 && parent.is_player_in_melee_range:
				state = MELEE
			elif parent.charge_up_timer.time_left > 0 && parent.force_field.visible:
				state = SHOOT
		MELEE:
			if !(parent.is_player_in_melee_range && parent.force_field.visible):
				state = RUN
		SHOOT:
			if parent.charge_up_timer.time_left == 0:
				state = RUN

func _physics_process(_delta):
	match state:
		RUN:
			parent.animated_sprite.play("run")
		MELEE:
			parent.animation_player.play("melee")
		SHOOT:
			if parent.charge_up_timer.time_left > 2.0:
				parent.animted_sprite.play("charge_start")
			else:
				parent.animated_sprite.play("charge_loop")

	_animate()
