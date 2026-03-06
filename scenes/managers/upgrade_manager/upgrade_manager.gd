extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experince_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}

func _ready() -> void:
	experince_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:	
	if !current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	
	# upgrade pool randomizer
	for i in 2:
		var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random()
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades.assign(filtered_upgrades.filter(func(upgrade: AbilityUpgrade): return upgrade.id != chosen_upgrade.id))
	
	return chosen_upgrades


func on_level_up(level: int) -> void:
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	var chosen_upgrades := pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
