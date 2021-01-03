extends Node

onready var parent = get_parent()

enum {
	IDLE,
	RUN,
	MELEE,
	SHOOT,
	DEFEAT
}

var state = IDLE

func _animate():
	match state:
		IDLE:
			parent.animated_sprite.play("idle")
		RUN:
			parent.animated_sprite.play("walk")
		MELEE:
			parent.animation_player.play("melee")
		SHOOT:
			#lazy
			#but
			#if it works i dont care
			if parent.charge_up_timer.time_left > 8.0 && parent.charge_up_timer.time_left <= 13.0:
				parent.animated_sprite.play("charge_start")
			if parent.charge_up_timer.time_left > 1.0 && parent.charge_up_timer.time_left <= 8.0:
				parent.animated_sprite.play("charge_loop")
		DEFEAT:
			parent.animated_sprite.play("defeat")

func _physics_process(_delta):
	match state:
		IDLE:
			#possible states: run, melee, shoot, defeat
			if !parent.force_field.visible:
				if parent.velocity.x != 0:
					state = RUN
				elif parent.is_player_in_melee_range:
					state = MELEE
				elif parent.health <= 0:
					state = DEFEAT
			elif parent.charge_up_timer.time_left <= 13.0:
				state = SHOOT
		RUN:
			#possible states: idle, defeat
			if parent.velocity.x == 0:
				state = IDLE
			elif parent.health <= 0:
				state = DEFEAT
		MELEE:
			#possible states: idle
			if !parent.is_player_in_melee_range:
				state = IDLE
		SHOOT:
			#possible states: idle
			if parent.charge_up_timer.time_left <= 1.0:
				state = IDLE

	_animate()
