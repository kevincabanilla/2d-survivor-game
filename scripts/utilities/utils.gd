extends Node

const PLAYER_GROUP = "player"
const ENEMY_GROUP = "enemy"
const FOREGROUND_LAYER_GROUP = "foreground_layer"
const ENTITIES_LAYER_GROUP = "entities_layer_group"

func get_player_node() -> Node2D:
	return get_tree().get_first_node_in_group(PLAYER_GROUP) as Node2D

func get_foreground_node() -> Node2D:
	return get_tree().get_first_node_in_group(FOREGROUND_LAYER_GROUP) as Node2D
