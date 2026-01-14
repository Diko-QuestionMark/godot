extends Area2D

@export var delay = 0.5

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Timer.start(delay)




func _on_timer_timeout() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().reload_current_scene()
