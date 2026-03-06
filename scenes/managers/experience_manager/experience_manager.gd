extends Node
class_name ExperienceManager

const TARGET_EXPERIENCE_GROWTH = 5

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

var current_level = 1
var current_experience = 0
var target_experience = 1

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	
func on_experience_vial_collected(number: float) -> void:
	increment_experience(number)

func increment_experience(number: float) -> void:
	#current_experience = min(current_experience +  number, target_experience)
	current_experience += number
	
	if current_experience >= target_experience:
		current_experience -= target_experience
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		level_up.emit(current_level)
		
	experience_updated.emit(current_experience, target_experience)
