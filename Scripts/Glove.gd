extends Area2D

var animation
var maxdistance = 150
var speed = 500.0
var startpos = Vector2.ZERO
var flag_jab = false
var flag_omw = false

func _ready():
	startpos = position

func _physics_process(delta):
	if flag_jab:
		var dist = abs(cartesian2polar(position.x - startpos.x, position.y - startpos.y).x)
		if !flag_omw:
			var dir = Vector2.RIGHT.rotated(rotation)
			position += speed * dir * delta
			if dist > maxdistance:
				flag_omw = true
				$Glove.play("Jab",true)
		else:
			var dir = Vector2.LEFT.rotated(-rotation)
			position += speed * dir * delta
			if dist < 10:
				_reset_gloves()
				flag_omw = false


func jab():
	flag_jab = true
	$Glove.play("Jab")

func set_anim(anim):
	if !flag_jab:
		$Glove.animation = anim

func set_flip_v(bar):
	$Glove.flip_v = bar


func _on_Glove_Front_area_entered(_area):
	_reset_gloves()

func _on_Glove_Back_area_entered(_area):
	_reset_gloves()
	
func _reset_gloves():
	flag_jab = false
	position = startpos
	set_anim("Idle")
