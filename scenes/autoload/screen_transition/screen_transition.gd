extends CanvasLayer


signal transition_halfway

var transition_halfway_emitted := false

func transition() -> void:
	$AnimationPlayer.play("default")
	await transition_halfway
	$AnimationPlayer.play_backwards("default")


func emit_transition_halfway() -> void:
	if (transition_halfway_emitted):
		transition_halfway_emitted = false
		return
	transition_halfway.emit()
	transition_halfway_emitted = true
