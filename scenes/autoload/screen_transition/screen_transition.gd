extends CanvasLayer


signal transition_halfway

var transition_halfway_emitted := false

func transition() -> void:
	$AnimationPlayer.play("default")
	await transition_halfway
	$AnimationPlayer.play_backwards("default")


func transition_to_scene(scene_path: String) -> void:
	await transition()
	get_tree().change_scene_to_file(scene_path)


func transition_to_main_menu() -> void:
	await transition_to_scene("res://scenes/ui/main_menu/main_menu.tscn")


func emit_transition_halfway() -> void:
	if (transition_halfway_emitted):
		transition_halfway_emitted = false
		return
	transition_halfway.emit()
	transition_halfway_emitted = true
