extends Node

signal vial_points_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal player_leveled_up(new_level: int)
signal increase_exp(exp_val: float)
signal loot_chest_collected()

func emit_vial_points_collected(number: float) -> void:
	vial_points_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)
