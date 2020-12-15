extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()

onready var shake_tween = $ShakeTween
onready var frequency = $Frequency
onready var duration = $Duration

var amplitude = 0

func start(duration = 0.2, frequency = 15, amplitude = 16):
	self.amplitude = amplitude
	self.duration.wait_time = duration
	self.frequency.wait_time = 1 / float(frequency)

	self.duration.start()
	self.frequency.start()

	_new_shake()

func _new_shake():
	var rand = Vector2.ZERO
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	shake_tween.interpolate_property(camera, "offset", camera.offset, rand, frequency.wait_time, TRANS, EASE)
	shake_tween.start()

func _reset():
	shake_tween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, frequency.wait_time, TRANS, EASE)
	shake_tween.start()

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	frequency.stop()
