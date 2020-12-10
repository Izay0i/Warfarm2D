extends Node

class_name GrineerFSM

onready var parent = get_parent()
onready var timer = get_parent().timer

enum {
	IDLE,
	RUN,
	SHOOT
}

var state = IDLE

func _animate():
	match state:
		IDLE:
			parent.animated_sprite.play("idle")
		RUN:
			parent.animated_sprite.play("run")
		SHOOT:
			parent.animated_sprite.play("shoot")

func _physics_process(delta):
	if parent.timer.is_stopped():
		parent.timer.reset_timer()

	match state:
		IDLE:
			if parent.velocity.x != 0:
				state = RUN
		RUN:
			if !parent.timer.is_stopped():
				state = IDLE
		SHOOT:
			pass

	_animate()
