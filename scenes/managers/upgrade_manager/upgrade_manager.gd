extends Node

#@export var upgrade_pool: Array[AbilityUpgrade]
@export var experince_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool := WeightedTable.new()

var ability_axe = preload("res://resources/upgrades/axe_ability.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")


func _ready() -> void:
	experince_manager.level_up.connect(on_level_up)
	
	upgrade_pool.add_items([ability_axe, upgrade_sword_damage, upgrade_sword_rate], 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:	
	if !current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade) -> void:
	if (chosen_upgrade.id == ability_axe.id):
		upgrade_pool.add_item(upgrade_axe_damage, 10)


func pick_upgrades_new() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	# upgrade pool randomizer
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade: AbilityUpgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


#deprecated, use pick_upgrades_new instead
func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	
	# upgrade pool randomizer
	var upgrades_count = filtered_upgrades.size()
	for i in (4 if upgrades_count > 4 else upgrades_count):
		#if filtered_upgrades.size() == 0:
			#break
		var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random()
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades.assign(filtered_upgrades.filter(func(upgrade: AbilityUpgrade): return upgrade.id != chosen_upgrade.id))
	
	return chosen_upgrades


func on_level_up(level: int) -> void:
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	var chosen_upgrades := pick_upgrades_new()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
