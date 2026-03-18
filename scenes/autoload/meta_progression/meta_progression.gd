extends Node


var save_data := {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
		
	}
}


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(_on_experience_collected)
	#add_meta_upgrade(load("res://resources/meta_upgrades/experience_gain.tres"))


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
