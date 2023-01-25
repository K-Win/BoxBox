extends Area2D

var maxdistance = 100
var speed = 400.0
var startpos = Vector2.ZERO

func _ready():
	startpos = position
#	$Jab.play()
	
func _physics_process(delta):
	var dir = Vector2.RIGHT.rotated(rotation)
	position += speed * dir * delta
	var dist = abs(cartesian2polar(position.x - startpos.x, position.y - startpos.y).x)
	if dist > maxdistance:
		delete()
	
func delete():
	call_deferred("free")

func _on_Glove_Jab_area_entered(_area):
	delete()
