extends Node


const SAVE_FILE_PATH = "user://game.save"

# Meta data
const CURRENT_LEVEL = "current_level"
const CURRENT_EXPERIENCE = "current_experience"
const TARGET_EXPERIENCE = "target_experience"
const TOTAL_EXP = "total_exp"
const EXPERIENCE_POINTS = "meta_upgrade_currency"

# Meta Upgrades
const UPGRADE_EXPERIENCE_GAIN = "experience_gain"
const UPGRADE_EXP_VIAL_DROP_RATE = "exp_vial_drop_rate"

var save_data := {
	"current_level": 0,
	"current_experience": 0.0,
	"target_experience": 2.0,
	"total_exp": 0.0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
		
	}
}

signal exp_points_updated(new_exp_points: int)

func _ready() -> void:
	load_save_file()
	GameEvents.experience_vial_collected.connect(_on_experience_collected)
	#add_meta_upgrade(load("res://resources/meta_upgrades/experience_gain.tres"))


func load_save_file() -> void:
	if (!FileAccess.file_exists(SAVE_FILE_PATH)):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	print(save_data)


func save() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	#print(save_data)


func get_exp_points() -> int:
	return save_data[EXPERIENCE_POINTS]


func add_meta_upgrade(meta_upgrade: MetaUpgrade) -> void:
	if (!save_data["meta_upgrades"].has(meta_upgrade.id)):
		save_data["meta_upgrades"][meta_upgrade.id] = {
			"value": meta_upgrade.value,
			"quantity": 0
		}
	
	save_data["meta_upgrades"][meta_upgrade.id]["quantity"] += 1
	update_exp_points(func(exp_points:int): return exp_points - meta_upgrade.experience_cost)
	#print(save_data)
	save()


func update_exp_points(callback: Callable) -> void:
	var new_exp = callback.call(save_data[EXPERIENCE_POINTS])
	#print("New EXP points: %d" % new_exp)
	save_data[EXPERIENCE_POINTS] = new_exp
	exp_points_updated.emit(new_exp)


func update_total_exp(exp_val: float) -> float:
	save_data[TOTAL_EXP] += exp_val
	return save_data[TOTAL_EXP]


func update_save_data(key: String, value: Variant) -> void:
	if (save_data.has(key)):
		save_data[key] = value;


func get_meta_data(key: String, default_val: Variant = null) -> Variant:
	if (save_data.has(key)):
		return save_data[key]
	else:
		return default_val


func get_meta_upgrade_save_data(meta_upgrade_id: String) -> Dictionary:
	if (save_data["meta_upgrades"].has(meta_upgrade_id)):
		return save_data["meta_upgrades"][meta_upgrade_id]
	else:
		return {}


func _on_experience_collected(number: float) -> void:
	save_data["meta_upgrade_currency"] += round(number)
