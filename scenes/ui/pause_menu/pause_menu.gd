extends CanvasLayer


@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var restart_button: Button = %RestartButton
@onready var options_button: Button = %OptionsButton
@onready var quit_menu_button: Button = %QuitMenuButton
@onready var quit_desktop_button: Button = %QuitDesktopButton

var options_menu_scene = preload("res://scenes/ui/options_menu/options_menu.tscn")

var is_closing := false


func _ready() -> void:
	get_tree().paused = true
	
	panel_container.pivot_offset = panel_container.size / 2
	
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_menu_button.pressed.connect(_on_quit_menu_button_pressed)
	quit_desktop_button.pressed.connect(_on_quit_desktop_button_pressed)
	
	$AnimationPlayer.play("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0) # workaround to prevent animation issues / jittering
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		close()


func close() -> void:
	if is_closing:
		return
	
	is_closing = true
	
	$AnimationPlayer.play_backwards("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	get_tree().paused = false
	queue_free()


func _on_resume_button_pressed() -> void:
	close()


func _on_restart_button_pressed() -> void:
	await ScreenTransition.transition()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed() -> void:
	await ScreenTransition.transition()
	var options_menu: OptionsMenu = options_menu_scene.instantiate()
	add_child(options_menu)
	options_menu.exit.connect((func(options_menu_instance: OptionsMenu): options_menu_instance.queue_free()).bind(options_menu))


func _on_quit_menu_button_pressed() -> void:
	await ScreenTransition.transition()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")


func _on_quit_desktop_button_pressed() -> void:
	get_tree().quit()
