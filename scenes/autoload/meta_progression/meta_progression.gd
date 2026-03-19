extends Node


const SAVE_FILE_PATH = "user://game.save"
const EXPERIENCE_POINTS = "meta_upgrade_currency"

var save_data := {
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
	#print(save_data)


func save() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


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
	#save()


func update_exp_points(callback: Callable) -> void:
	var new_exp = callback.call(save_data[EXPERIENCE_POINTS])
	print("New EXP points: %d" % new_exp)
	save_data[EXPERIENCE_POINTS] = new_exp
	exp_points_updated.emit(new_exp)


func _on_experience_collected(number: float) -> void:
	save_data["meta_upgrade_currency"] += number
