extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = %TimerLabel # Access as unique name should be checked in TimerLabel in the Scene

func _process(_delta: float) -> void:
	if (arena_time_manager == null):
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds(time_elapsed)
	
func format_seconds(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return "%02d:%02d" % [minutes, floor(remaining_seconds)]
	
