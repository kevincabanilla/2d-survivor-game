extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%OptionsButton.pressed.connect(_on_options_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
