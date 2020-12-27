extends Node

onready var parent = get_parent()

enum {
	IDLE,
	RUN,
	MELEE,
	SHOOT
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
			if parent.charge_up_timer.time_left > 2.0:
				parent.animted_sprite.play("charge_start")
			else:
				parent.animated_sprite.play("charge_loop")

func _physics_process(_delta):
	match state:
		IDLE:
			#possible states: run, melee
			if parent.velocity.x != 0:
				state = RUN
			elif parent.is_player_in_melee_range:
				state = MELEE
		RUN:
			#possible states: idle, melee, shoot
			if parent.velocity.x == 0:
				state = IDLE
			elif parent.is_player_in_melee_range:
				state = MELEE
		MELEE:
			#possible states: idle
			if !parent.is_player_in_melee_range:
				state = IDLE
		SHOOT:
			#possible states: idle
			if parent.charge_up_timer.time_left == 0:
				state = IDLE

	_animate()
