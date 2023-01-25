extends Control

signal death

func _ready():
	var _death = connect("death",get_parent().get_parent(),"_game_over")
	#get player hp

func _update_hp(val):
	$Container/Health.value -= val
	if $Container/Health.value == 0:
		emit_signal("death")

func _update_exp(val):
	$Container/Exp.value += val

func _update_enemy_number(val):
	$EnemyOverlay/NumberEnemys.text = str(val)
