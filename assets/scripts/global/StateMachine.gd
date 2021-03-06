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
var anim = [ "melee", "melee_alt" ]

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
#		SHOOT:
#			if parent.is_special_move:
#				parent.animated_sprite.play("shoot")
		MELEE:
			if parent.is_special_move:
				name = anim[0]
				parent.animation_player.play(name)

func _physics_process(_delta):
	match state:
		IDLE:
			#possible states: run, jump, fall,  melee
			if parent.move_direction != 0:
				state = RUN
			elif !parent.raycast.is_colliding():
				if parent.velocity.y < 0:
					state = JUMP
				elif parent.velocity.y > 0:
					state = FALL
			elif Input.is_action_just_pressed("melee"):
				parent.is_special_move = true
				state = MELEE
				anim.shuffle()
#			elif Input.is_action_pressed("shoot"):
#				parent.is_special_move = true
#				state = SHOOT
		RUN:
			#possible states: idle, jump, fall, melee
			if parent.move_direction == 0:
				state = IDLE
			elif !parent.raycast.is_colliding():
				if parent.velocity.y < 0:
					state = JUMP
				elif parent.velocity.y > 0:
					state = FALL
			elif Input.is_action_just_pressed("melee"):
				parent.is_special_move = true
				state = MELEE
				anim.shuffle()
		JUMP:
			#possible states: fall, melee
			if parent.velocity.y > 0:
				state = FALL
			elif parent.is_on_floor(): #failsafe
				state = IDLE
			elif Input.is_action_just_pressed("melee"):
				parent.is_special_move = true
				state = MELEE
				anim.shuffle()
		FALL:
			#possible states: idle, jump, melee
			if parent.is_on_floor():
				state = IDLE
			elif Input.is_action_just_pressed("jump"):
				state = JUMP
			elif Input.is_action_just_pressed("melee"):
				parent.is_special_move = true
				state = MELEE
				anim.shuffle()
		MELEE:
			#possible states: idle
			if !parent.is_special_move:
				state = IDLE
#		SHOOT:
#			#possible states: idle, fall
#			if !parent.is_special_move:
#				state = IDLE
#			if !parent.raycast.is_colliding():
#				state = FALL

	_animate()

#Never mistake youthful selfishness for genuine malice. No one isn't kind of an asshole in their early 20s. And if they actually weren't, they were probably sociopaths.
#YOU'RE A SOCIOPATH
