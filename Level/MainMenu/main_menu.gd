extends Control

func _ready() -> void:
	Utils.loadGame()



func _on_start_game_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Level/dunia.tscn")

func _on_option_pressed() -> void:
	print("Hallo, there")

func _on_exit_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()
