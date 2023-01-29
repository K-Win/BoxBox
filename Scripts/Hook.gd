extends Node2D

var t := 0.0
var endpoint
signal hook_completed
#onready var player = get_parent()

func _ready():
	var _hook_completed = connect("hook_completed",get_parent(),"_on_hook_completed")

func set_curve(curve):
	var curve_pool = curve.tessellate()
#	$HookPath.position = player.position
	$HookPath.points = curve_pool
	$HookPath/Path2D.curve = curve
	endpoint = curve_pool[curve_pool.size()-1]
#	$LineToPlayer.set_point_position(0, position)
#	$LineToPlayer.set_point_position(1, position + curve_pool[curve_pool.size()-1])

func set_endpoint(curve_endpoint):
	endpoint = curve_endpoint

func _process(delta):
	t += delta
	$HookPath/Path2D/PathFollow2D.offset = t * 400
	if $HookPath/Path2D/PathFollow2D.position == endpoint:
		delete()

func delete():
	emit_signal("hook_completed")
	queue_free()

func _on_Glove_Hook_area_entered(_area):
	delete()
