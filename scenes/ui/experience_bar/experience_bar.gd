extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready() -> void:
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	
func on_experience_updated(current_exp: float, target_exp: float) -> void:
	var percent = current_exp / target_exp
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", percent, 0.2)
	#progress_bar.value = percent
