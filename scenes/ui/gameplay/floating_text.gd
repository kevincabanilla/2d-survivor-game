extends Node2D
class_name FloatingText

@onready var label: Label = $Label


func _ready() -> void:
	scale = Vector2.ZERO


func start(text: String) -> void:
	label.text = text
	var tween = create_tween()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.parallel().tween_property(self, "scale", Vector2.ONE, .4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 12), 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.parallel().tween_property(self, "scale", Vector2.ONE / 2, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.tween_callback(queue_free)
