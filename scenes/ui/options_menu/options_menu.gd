extends CanvasLayer
class_name OptionsMenu


@onready var master_vol_slider: HSlider = %MasterVolSlider
@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
#@onready var window_mode_check_box: CheckBox = %WindowModeCheckBox
@onready var window_mode_option_button: OptionButton = %WindowModeOptionButton
@onready var debounce_timer: Timer = $DebounceTimer
@onready var return_button: Button = %ReturnButton


signal exit


func _ready() -> void:
	_initialize()
	_initialize_signals()


func _initialize() -> void:
	window_mode_option_button.selected = DisplayServer.window_get_mode()
	master_vol_slider.value = get_bus_volume_percent("Master")
	sfx_slider.value = get_bus_volume_percent("SFX")
	music_slider.value = get_bus_volume_percent("Music")


func _initialize_signals() -> void:
	debounce_timer.timeout.connect(_on_debounce_timer_timeout)
	window_mode_option_button.item_selected.connect(_on_window_mode_option_button_item_selected)
	#window_mode_check_box.toggled.connect(_on_window_mode_check_box_toggled)
	master_vol_slider.value_changed.connect(_on_vol_slider_value_changed)
	sfx_slider.value_changed.connect(_on_vol_slider_value_changed)
	music_slider.value_changed.connect(_on_vol_slider_value_changed)
	return_button.pressed.connect(_on_return_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().root.set_input_as_handled()
		emit_exit()
	elif event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volumne_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volumne_db)


func set_bus_volume_percent(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func emit_exit() -> void:	
	await ScreenTransition.transition()
	exit.emit()

func update_volumes() -> void:
	set_bus_volume_percent("Master", master_vol_slider.value)
	set_bus_volume_percent("SFX", sfx_slider.value)
	set_bus_volume_percent("Music", music_slider.value)


func _on_window_mode_option_button_item_selected(index: int) -> void:
	var selected_mode = window_mode_option_button.get_item_id(index)
	DisplayServer.window_set_mode(selected_mode)


#func _on_window_mode_check_box_toggled(toggled_on: bool) -> void:
	#var mode = DisplayServer.window_get_mode()
	#if (toggled_on && mode == DisplayServer.WINDOW_MODE_FULLSCREEN):
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#else:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_vol_slider_value_changed(_value: float) -> void:
	debounce_timer.start()


func _on_debounce_timer_timeout() -> void:
	update_volumes()


func _on_return_button_pressed() -> void:
	emit_exit()
