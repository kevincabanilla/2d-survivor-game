extends CanvasLayer


var options_menu_scene = preload("res://scenes/ui/options_menu/options_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%OptionsButton.pressed.connect(_on_options_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_options_button_pressed() -> void:
	var options_menu = options_menu_scene.instantiate() as OptionsMenu
	add_child(options_menu)
	options_menu.exit.connect(_on_option_menu_exit.bind(options_menu))


func _on_option_menu_exit(option_menu: OptionsMenu) -> void:
	option_menu.queue_free()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
