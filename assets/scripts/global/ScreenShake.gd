extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()

onready var shake_tween = $ShakeTween
onready var frequency = $Frequency
onready var duration = $Duration

var amplitude = 0

func start(_duration = 0.2, _frequency = 15, _amplitude = 16):
	amplitude = _amplitude
	duration.wait_time = _duration
	frequency.wait_time = 1 / float(_frequency)

	duration.start()
	frequency.start()

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
