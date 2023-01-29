extends Node2D

export(PackedScene) var level1_scene
export(PackedScene) var menu_scene

func _ready():
	get_tree().paused = false
	GameData.gamestate = GameData.GameState.INIT
	GameData.effects_menu_select = $Audio/Effects/Select
	GameData.effects_menu_press = $Audio/Effects/Press
	
	init()
	

func init():
	$Audio/Music/Titelmusic.play()
	var menu = menu_scene.instance()
	add_child(menu)
	
func start_game():
	GameData.gamestate = GameData.GameState.INGAME
	var level1 = level1_scene.instance()
	add_child(level1)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused == false and GameData.gamestate == GameData.GameState.INGAME:
			var menu = menu_scene.instance()
			add_child(menu)
