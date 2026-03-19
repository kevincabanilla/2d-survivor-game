extends Node
class_name ExperienceManager

const TARGET_EXPERIENCE_GROWTH = 2.0

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

var current_level = 1
var current_experience := 0.0
var target_experience := 2.0

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	
func on_experience_vial_collected(number: float) -> void:
	increment_experience(number)

func increment_experience(number: float) -> void:
	var exp_multiplier = 1.0
	var exp_gain_upgrade = MetaProgression.get_meta_upgrade_save_data(MetaProgression.UPGRADE_EXPERIENCE_GAIN)
	
	if (!exp_gain_upgrade.is_empty()):
		exp_multiplier += (exp_gain_upgrade["value"] * exp_gain_upgrade["quantity"]) as float
	
	#print("Exp multiplier: %0.03f" % exp_multiplier)
	#print("Exp gained: %0.03f" % (number * exp_multiplier))
	
	#current_experience = min(current_experience +  number, target_experience)
	current_experience += (number * exp_multiplier)
	
	if current_experience >= target_experience:
		current_experience -= target_experience
		current_level += 1
		target_experience *= TARGET_EXPERIENCE_GROWTH
		level_up.emit(current_level)
		
	experience_updated.emit(current_experience, target_experience)
