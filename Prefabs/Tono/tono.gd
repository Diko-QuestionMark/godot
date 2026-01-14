extends Node2D

var dalam_area = false
var gak_lagi_dialog = true
var boleh_berdialog = false


func _process(_delta: float) -> void:
	if dalam_area && gak_lagi_dialog:
		$"../../Player/PressF".visible = true
		boleh_berdialog = true
	if dalam_area && !gak_lagi_dialog:
		$"../../Player/PressF".visible = false
		boleh_berdialog = false
	if !dalam_area && gak_lagi_dialog:
		$"../../Player/PressF".visible = false
		boleh_berdialog = false

	
	if GlobalData.double_jump_unclocked:
		$AnimatedSprite2D.play("bergerak")
	
	if boleh_berdialog && Input.is_action_just_pressed("interact"):
		if GlobalData.have_mushroom == true and GlobalData.double_jump_unclocked == false:
			$AnimationPlayer.play("have mushroom")
			gak_lagi_dialog = false
		elif GlobalData.have_mushroom == true and GlobalData.double_jump_unclocked == true:
			$AnimationPlayer.play("final")
			gak_lagi_dialog = false
		else:
			$AnimationPlayer.play("gak_punya_mushroom")
			gak_lagi_dialog = false
			

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "gak_punya_mushroom":
		gak_lagi_dialog = true
	
	if _anim_name == "have mushroom":
		gak_lagi_dialog = true
		GlobalData.double_jump_unclocked = true
		Utils.saveGame()
		$AnimationPlayer.play("final")
		gak_lagi_dialog = false
	
	if _anim_name == "final":
		gak_lagi_dialog = true


func _on_deteksi_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dalam_area = true


func _on_deteksi_player_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		dalam_area = false
		$"../../Player/PressF".visible = false
