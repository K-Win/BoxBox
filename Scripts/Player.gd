extends Area2D

signal hit
export var speed = 400
export var hp = 100
var screen_size
var jab_f = true
var mouse_pos
onready var jab_timer = $JabTimer
onready var hook_timer = $HookTimer
var jab_cd = 0.5
var calc_damage = 0
var max_range = 200
#var damage
onready var curve = Curve2D.new()

var is_flipped = false

export(PackedScene) var jab_scene
export(PackedScene) var hook_scene

func _ready():
	jab_timer.wait_time = jab_cd
	var _connect_hit = get_node("../Player").connect("hit", get_node("../CanvasLayer/HUD"), "_update_hp")
	screen_size = get_viewport_rect().size
	set_anim("Idle")
	
	#curve
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(0,0))

func _process(delta):
	
	mouse_pos = get_viewport().get_mouse_position()
	var velocity = Vector2.ZERO
	
	$Gloves.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("jab") and jab_timer.is_stopped():
		jab()
	if Input.is_action_just_pressed("hook") and hook_timer.is_stopped():
		hook()
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		set_anim("Running")
	else:
		set_anim("Idle")
	
	flip_anim()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func start(pos):
	position = pos


func set_anim(anim):
	$Body.animation = anim
	$Gloves/Glove_Front.animation = anim
	$Gloves/Glove_Back.animation = anim

func flip_anim():
	if mouse_pos > position and is_flipped:
		$Body.flip_h = false
		$Gloves/Glove_Front.flip_v = false
		$Gloves/Glove_Back.flip_v = false
		is_flipped = false
	elif mouse_pos < position and !is_flipped:
		$Body.flip_h = true
		$Gloves/Glove_Front.flip_v = true
		$Gloves/Glove_Back.flip_v = true
		is_flipped = true
	
func jab():
	if jab_scene:
		if jab_f != true:
			jab_f = true
			#sprite wechseln
		var jab = jab_scene.instance()

		add_child(jab)
		jab.position = $Gloves/Glovespawn.position
		jab.rotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		jab_timer.start()
		$RandomJabSFXPlayer.play_random()

func hook():
	if hook_scene:
		hook_timer.start()
		hook_timer.paused = true
		var hook = hook_scene.instance()
		add_child(hook)
		var curve_endpoint
		var v = (mouse_pos - position ) / scale
		if v.length() > max_range:
			curve_endpoint = v.normalized()*max_range
		else:
			curve_endpoint = v
		curve.set_point_position(1, curve_endpoint)
		curve.set_point_out(0,Vector2(v.y,-v.x))
		curve.set_point_in(1,Vector2(curve_endpoint.y/2,-curve_endpoint.x/2))
		hook.set_curve(curve)
		hook.set_endpoint(curve_endpoint)
		hook.position = $Gloves/Glovespawn.position
		$RandomJabSFXPlayer.play_random()

func _on_HitBox_area_entered(_area):
	#check for enemytype, set calc_damage based on enemy type and emit signal
	calc_damage = 10
	$DamageSound.play()
	hp = hp -calc_damage
	emit_signal("hit", calc_damage)

func _on_hook_completed():
	hook_timer.paused = false
