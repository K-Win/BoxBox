extends KinematicBody2D

onready var player = get_node("../Player")
var movement_speed = 200
var mspeed_multi = 1.0
signal dead

func _ready():
	var _player_died = connect("dead",get_parent(),"_on_enemy_killed")
	$AnimatedSprite.animation = "Running"
	$AnimatedSprite.playing = true
	pass

func _physics_process(delta):
	player = get_node("../Player")

	var velocity = (player.position - position).normalized()
	if velocity.x != 0:
		$AnimatedSprite.animation = "Running"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "Running"

	var _move = move_and_collide(velocity * movement_speed * mspeed_multi * delta)


func _on_Hitbox_area_entered(_area):
	emit_signal("dead")
	call_deferred("free")
	$HitSound.play()
