extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"have_mushroom": GlobalData.have_mushroom,
		"double_jump_unlocked": GlobalData.double_jump_unclocked
		#"PlayerHP": Game.playerHP,
		#"Gold": Game.Gold,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)


func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				GlobalData.have_mushroom = current_line["have_mushroom"]
				GlobalData.double_jump_unclocked = current_line["double_jump_unlocked"]
				#Game.playerHP = current_line["PlayerHP"]
				#Game.Gold = current_line["Gold"]
