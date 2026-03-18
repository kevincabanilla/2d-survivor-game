extends Node


const SAVE_FILE_PATH = "user://game.save"

var save_data := {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
		
	}
}


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


func add_meta_upgrade(meta_upgrade: MetaUpgrade) -> void:
	if (!save_data["meta_upgrades"].has(meta_upgrade.id)):
		save_data["meta_upgrades"][meta_upgrade.id] = {
			"value": meta_upgrade.value,
			"quantity": 0
		}
	
	save_data["meta_upgrades"][meta_upgrade.id]["quantity"] += 1
	#print(save_data)



func _on_experience_collected(number: float) -> void:
	save_data["meta_upgrade_currency"] += number
