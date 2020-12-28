extends Node

class_name GrineerFSM

onready var parent = get_parent()

enum {
	IDLE,
	RUN,
	SHOOT,
	DIE
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
		DIE:
			parent.animated_sprite.play("die")

func _physics_process(_delta):
	match state:
		IDLE:
			if parent.velocity.x != 0:
				state = RUN
			elif parent.is_enemy_spotted:
				state = SHOOT
			elif parent.health <= 0:
				state = DIE
		RUN:
			if parent.velocity.x == 0:
				state = IDLE
			elif parent.is_enemy_spotted:
				state = SHOOT
			elif parent.health <= 0:
				state = DIE
		SHOOT:
			if !parent.is_enemy_spotted:
				state = IDLE
			elif parent.health <= 0:
				state = DIE

	_animate()
