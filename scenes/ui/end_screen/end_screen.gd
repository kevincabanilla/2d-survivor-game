extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	
	var tween := create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true

func set_defeat() -> void:
	%TitleLabel.text = "Defeat"
	%DescLabel.text = "You lost!"

func _on_restart_button_pressed() -> void:
	$AnimationPlayer.play_backwards("in")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
