extends Node

class_name StateMachine

onready var parent = get_parent()

enum {
	IDLE,
	RUN,
	JUMP,
	FALL,
	SHOOT,
	MELEE
}

var state = IDLE

func _animate():
	match state:
		IDLE:
			parent.animated_sprite.play("idle")
		RUN:
			parent.animated_sprite.play("run")
		JUMP:
			parent.animated_sprite.play("jump")
		FALL:
			parent.animated_sprite.play("fall")
		SHOOT:
			if parent.is_special_move:
				parent.animated_sprite.play("shoot")
		MELEE:
			if parent.is_special_move:
				parent.animation_player.play("melee")

func _physics_process(_delta):
	match state:
		IDLE:
			#possible states: run, jump, fall, slide, melee, shoot
			if parent.move_direction != 0:
				state = RUN
			elif parent.velocity.y < 0:
				state = JUMP
			elif parent.velocity.y > 0 && !parent.is_on_floor():
				state = FALL
			elif Input.is_action_pressed("melee"):
				parent.is_special_move = true
				state = MELEE
			elif Input.is_action_pressed("shoot"):
				parent.is_special_move = true
				state = SHOOT
		RUN:
			#possible states: idle, jump, fall
			if parent.move_direction == 0:
				state = IDLE
			elif parent.velocity.y < 0:
				state = JUMP
			elif parent.velocity.y > 0 && !parent.is_on_floor():
				state = FALL
		JUMP:
			#possible states: fall
			if parent.velocity.y > 0:
				state = FALL
			elif parent.is_on_floor(): #failsafe
				state = IDLE
		FALL:
			#possible states: idle
			if parent.is_on_floor():
				state = IDLE
		MELEE:
			#possible states: idle, fall
			if !parent.is_special_move:
				state = IDLE
			if !parent.is_on_floor():
				state = FALL
		SHOOT:
			#possible states: idle, fall
			if !parent.is_special_move:
				state = IDLE
			if !parent.is_on_floor():
				state = FALL

	_animate()

#Never mistake youthful selfishness for genuine malice. No one isn't kind of an asshole in their early 20s. And if they actually weren't, they were probably sociopaths.
#YOU'RE A SOCIOPATH
