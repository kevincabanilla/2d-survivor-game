extends Node

# Groups
const PLAYER_GROUP = "player"
const ENEMY_GROUP = "enemy"
const FOREGROUND_LAYER_GROUP = "foreground_layer"
const ENTITIES_LAYER_GROUP = "entities_layer"
const UPGRADE_CARD_GROUP = "upgrade_card"

# Ablities/Upgrades
const ABILITY_AXE = "axe_ability"
const UPGRADE_SWORD_DAMAGE = "sword_damage"
#const UPGRADE_SWORD_RATE = "sword_rate"
const UPGRADE_AXE_DAMAGE = "axe_damage"
const UPGRADE_PLAYER_SPEED = "player_speed"
const UPGRADE_ATTACK_SPEED = "attack_speed"


func get_first_node_in_group(group_name: String) -> Node2D:
	return get_tree().get_first_node_in_group(group_name) as Node2D


func get_player_node() -> Node2D:
	return get_tree().get_first_node_in_group(PLAYER_GROUP) as Node2D


func get_foreground_node() -> Node2D:
	return get_tree().get_first_node_in_group(FOREGROUND_LAYER_GROUP) as Node2D


func get_entities_node() -> Node2D:
	return get_tree().get_first_node_in_group(ENTITIES_LAYER_GROUP) as Node2D


func format_number_with_commas(number: int) -> String:
	var num_str := str(number).lstrip("-")
	var result := ""
	var count: int = 0

	for i in range(num_str.length() - 1, -1, -1):
		result = num_str[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = "," + result

	if number < 0:
		result = "-" + result

	return result
