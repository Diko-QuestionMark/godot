extends Area2D

@export var scene_choice: int
@export var context: String
@export var label = false
var scene
var boleh = false

func _ready() -> void:
	$Label.visible = label
	$Label.text = context
	scene = GlobalScenes.scenes.get(scene_choice)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" && scene:
		$"../../Player/AnimationPlayer".play("pressf true")
		$AnimatedSprite2D.play("open")
		boleh = true
		#print(boleh)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$"../../Player/AnimationPlayer".play("pressf false")
		$AnimatedSprite2D.play("close")
		boleh = false

func _process(_delta: float) -> void:
	if boleh == true && Input.is_action_just_pressed("interact"):
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(scene)
