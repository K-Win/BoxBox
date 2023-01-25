extends CanvasLayer

export(PackedScene) var options_scene
onready var bStart = $MarginContainer/CenterContainer/VBoxContainer/Start
var state = GameData.gamestate

func _ready():
	if state == GameData.GameState.INGAME:
		get_tree().paused = true
		bStart.text = "Resume"

	
	
func _process(_delta):
	if bStart.get_focus_owner() == null:
		bStart.grab_focus()
	

func _on_StartButton_pressed():
	if state == GameData.GameState.INIT:
		get_parent().start_game()
	elif state == GameData.GameState.INGAME:
		get_tree().paused = false	
	GameData.effects_menu_press.play()
	queue_free()


func _on_OptionsButton_pressed():
	GameData.effects_menu_press.play()
	var options = options_scene.instance()
	get_tree().current_scene.add_child(options)
	


func _on_QuitButton_pressed():
	if state == GameData.GameState.INGAME:
		get_tree().paused = false
		var _main = get_tree().change_scene("res://Scenes/Main.tscn")
	elif state == GameData.GameState.INIT:
		get_tree().quit()


func _on_Start_focus_entered():
	GameData.effects_menu_select.play()


func _on_Options_focus_entered():
	GameData.effects_menu_select.play()


func _on_Quit_focus_entered():
	GameData.effects_menu_select.play()
