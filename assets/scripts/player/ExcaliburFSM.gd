extends Node

#var current_state
#
#func _ready():
#	#add_state("idle")
#	#add_state("run")
#	#add_state("jump")
#	#add_state("fall")
#	#add_state("slide")
#	#add_state("melee")
#	#add_state("shoot")
#	#call_deferred("set_state", states.idle)
#	pass
#
#func _input(event):
#	if [states.idle, states.run].has(state):
#		if event.is_action_pressed("jump") && parent.is_on_floor():
#			parent.velocity.y = parent.min_jump_velocity
#			state = states.jump
#
#	if event.is_action_pressed("melee") && parent.is_on_floor():
#		current_state = "melee"
#
#func _state_logic(delta):
#	parent._handle_move_input()
#	parent._apply_gravity(delta)
#	parent._apply_movement()
#
#func _get_transition(delta):
#	match state:
#		states.idle:
#			if !parent.is_on_floor():
#				if parent.velocity.y < 0:
#					return states.jump
#				elif parent.velocity.y > 0:
#					return states.fall
#			elif parent.velocity.x != 0:
#				return states.run
#		states.run:
#			if !parent.is_on_floor():
#				if parent.velocity.y < 0:
#					return states.jump
#				elif parent.velocity.y > 0:
#					return states.fall
#			elif parent.move_direction == 0:
#				return states.idle
#		states.jump:
#			if parent.is_on_floor():
#				return states.idle
#			elif parent.velocity.y >= 0:
#				return states.fall
#		states.fall:
#			if parent.is_on_floor():
#				return states.idle
#			elif parent.velocity.y < 0:
#				return states.jump
#		states.melee:
#			return states.idle
#		states.slide:
#			return states.slide
#		states.shoot:
#			return states.shoot
#	return null
#
#func _enter_state(new_state, old_state):
#	match new_state:
#		states.idle:
#			parent.animated_sprite.play("idle")
#		states.run:
#			parent.animated_sprite.play("run")
#		states.jump:
#			#parent.animed_sprite.play("jump")
#			pass
#		states.fall:
#			parent.animated_sprite.play("fall")
#		states.shoot:
#			parent.animated_sprite.play("shoot")	
#		states.slide:
#			parent.animation_player.play("slide")
#		states.melee:
#			parent.animation_player.play("melee")
#
#func _exit_state(old_state, new_state):
#	pass
