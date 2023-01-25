extends Node2D

export(PackedScene) var enemy_scene
export(PackedScene) var player_scene
export(PackedScene) var gameover_scene
var player
var enemy_spawned = 0
var calc_exp
signal enemy_spawned
signal enemy_died

func _ready():
	var _enemy_died = connect("enemy_died",$CanvasLayer/HUD,"_update_exp")
	var _enemy_spawned = connect("enemy_spawned",$CanvasLayer/HUD,"_update_enemy_number")
	$PlayerPosition.position = get_viewport().size/2
	
	player = player_scene.instance()
	player.start($PlayerPosition.position)
	add_child(player)
	
	randomize()
	$CanvasLayer/Ring.position = get_viewport().size/2
	$EnemySpawner.start()


func _on_EnemySpawner_timeout():
	enemy_spawned += 1
	emit_signal("enemy_spawned", enemy_spawned)	
	var enemy = enemy_scene.instance()
	enemy.mspeed_multi = 1.0+float(enemy_spawned)/10
	var enemy_spawn_location = $Enemyline/EnemySpawnLocation
	enemy_spawn_location.offset = randi()
	
	enemy.position = enemy_spawn_location.position
	
	add_child(enemy)

func _on_enemy_killed():
	emit_signal("enemy_died", 1*enemy_spawned)
	pass
	
func _game_over():
	GameData.gamestate = GameData.GameState.GAMEOVER
	get_tree().paused = true
	var _gameover = gameover_scene.instance()
	_gameover.set_highscore(enemy_spawned)
	add_child(_gameover)

