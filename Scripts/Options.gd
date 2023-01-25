extends CanvasLayer

var mastervolume = db2linear(AudioServer.get_bus_volume_db(GameData._masterbus))
var musicvolume = db2linear(AudioServer.get_bus_volume_db(GameData._musicbus))
var effectsvolume = db2linear(AudioServer.get_bus_volume_db(GameData._effectsbus))
export(PackedScene) var menu_scene

onready var hmaster = $MarginContainer/CenterContainer/OptionContainer/HBoxContainer/HMaster
onready var hmusic = $MarginContainer/CenterContainer/OptionContainer/HBoxContainer3/HMusic
onready var heffects = $MarginContainer/CenterContainer/OptionContainer/HBoxContainer2/HEffects
onready var lmastervol = $MarginContainer/CenterContainer/OptionContainer/MasterVolume
onready var lmusicvol = $MarginContainer/CenterContainer/OptionContainer/MusicVolume
onready var leffectsvol = $MarginContainer/CenterContainer/OptionContainer/EffectsVolume

func _ready():
	hmaster.grab_focus()
	hmaster.value = mastervolume
	hmusic.value = musicvolume
	heffects.value = effectsvolume
	lmastervol.text = str(round(mastervolume*100)) + "%"
	lmusicvol.text = str(round(musicvolume*100)) + "%"
	leffectsvol.text = str(round(effectsvolume*100)) + "%"


func _on_BackButton_pressed():
	if GameData.gamestate == GameData.GameState.GAMEOVER:
		var _go = get_parent().get_node("Level1/GameOver")
		_go.show()
	GameData.effects_menu_press.play()
	queue_free()


func _on_HMaster_value_changed(value):
	AudioServer.set_bus_volume_db(GameData._masterbus, linear2db(value))
	lmastervol.text = str(value*100) + "%"
	
	
func _on_HMusic_value_changed(value):
	AudioServer.set_bus_volume_db(GameData._musicbus, linear2db(value))
	lmusicvol.text = str(value*100) + "%"


func _on_HEffects_value_changed(value):
	AudioServer.set_bus_volume_db(GameData._effectsbus, linear2db(value))
	leffectsvol.text = str(value*100) + "%"


func _on_Quit_focus_entered():
	GameData.effects_menu_select.play()


func _on_HMaster_focus_entered():
	GameData.effects_menu_select.play()


func _on_HMusic_focus_entered():
	GameData.effects_menu_select.play()


func _on_HEffects_focus_entered():
	GameData.effects_menu_select.play()
