extends Area2D

#general variables
signal hit
var screen_size
var mouse_pos

#player variables
export var speed = 400
export var hp = 100
var is_flipped = false
#gloves
onready var glove_front = $Gloves/Glove_Front
onready var glove_back = $Gloves/Glove_Back
#provisional variables
var calc_damage = 0


func _ready():
	
	var _connect_hit = get_node("../Player").connect("hit", get_node("../CanvasLayer/HUD"), "_update_hp")
	screen_size = get_viewport_rect().size
	set_anim("Idle")


func _process(delta):
	
	mouse_pos = get_viewport().get_mouse_position()
	var velocity = Vector2.ZERO
	
#	$Gloves.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("jab"):
		jab()
	if Input.is_action_just_pressed("hook"):
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
	glove_front.set_anim(anim)
	glove_back.set_anim(anim)


func flip_anim():
	if mouse_pos > position and is_flipped:
		$Body.flip_h = false
		glove_front.set_flip_v(false)
		glove_back.set_flip_v(false)
		is_flipped = false
	elif mouse_pos < position and !is_flipped:
		$Body.flip_h = true
		glove_front.set_flip_v(true)
		glove_back.set_flip_v(true)
		is_flipped = true
	
	
func jab():
	if can_attack(glove_front):
		glove_front.jab()
	elif can_attack(glove_back):
		glove_back.jab()

func hook():
	if can_attack(glove_front):
		glove_front.hook()
	elif can_attack(glove_back):
		glove_back.hook()

func can_attack(glove)-> bool:
	return glove.atkState == glove.AtkState.READY


func _on_HitBox_area_entered(_area):
	#check for enemytype, set calc_damage based on enemy type and emit signal
	calc_damage = 10
	$DamageSound.play()
	hp = hp -calc_damage
	emit_signal("hit", calc_damage)
