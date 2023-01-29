extends Area2D

var maxdistance = 150
var speed = 200.0

enum AtkState {
	RETURN,
	ATTACK,
	READY
}
export var atkState = AtkState.READY

var t: float
var mouse_pos
export var max_range_pos: Vector2

export var test: float

func _physics_process(delta):
	match atkState:
		AtkState.RETURN:
			var dist = abs(cartesian2polar(position.x, position.y).x)
			t += delta
			position = position.linear_interpolate(Vector2(0,0),t/5)
			if dist < 5:
				_reset_gloves()
				atkState = AtkState.READY
		AtkState.ATTACK:
			t += delta
			set_pos()


func set_pos():
	test = $Path/PathFollower.offset
	$Path/PathFollower.offset = t * speed
	position = $Path/PathFollower.position
	if position == max_range_pos:
		t = 0.0
		atkState = AtkState.RETURN

func add_curve() -> Curve2D:
	var curve = Curve2D.new()
	mouse_pos = get_viewport().get_mouse_position()	
	var v = (mouse_pos-global_position) / scale
	max_range_pos = v.normalized() * maxdistance
	curve.add_point(Vector2(0,0))
	curve.add_point(max_range_pos)
	return curve

func jab():
	$Path.curve = add_curve()
	atkState = AtkState.ATTACK
	$Glove.play("Jab")


func hook():
	$Path.curve = add_curve()
	if self.is_in_group("Glove_Front"):
		$Path.curve.set_point_out(0,Vector2(-max_range_pos.y,max_range_pos.x))
		$Path.curve.set_point_in(1,Vector2(-max_range_pos.y,max_range_pos.x))
	else:
		$Path.curve.set_point_out(0,Vector2(max_range_pos.y,-max_range_pos.x))
		$Path.curve.set_point_in(1,Vector2(max_range_pos.y,-max_range_pos.x))
	atkState = AtkState.ATTACK
	$Glove.play("Jab")
	
	
func set_anim(anim):
	if atkState == AtkState.READY:
		$Glove.animation = anim


func set_flip_v(bar):
	$Glove.flip_v = bar


func _on_Glove_Front_area_entered(_area):
	_reset_gloves()


func _on_Glove_Back_area_entered(_area):
	_reset_gloves()
	
	
func _reset_gloves():
	t = 0.0
#	$Path/PathFollower.offset = 0
	atkState = AtkState.READY
	position = Vector2(0,0)
	set_anim("Idle")
