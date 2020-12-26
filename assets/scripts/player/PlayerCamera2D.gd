extends Camera2D

const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 0.1

onready var prev_camera_pos = get_camera_position()
onready var tween = $ShiftTween

var facing = 0

func _check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if facing != 0 && facing != new_facing:
		facing = new_facing
		#var target_offset = get_viewport_rect().size.x * facing
		tween.interpolate_property(self, "position:x", position.x, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()

func _process(_delta):
	_check_facing()
	prev_camera_pos = get_camera_position()

func _on_Excalibur_grounded_updated(is_grounded):
	drag_margin_v_enabled = !is_grounded
