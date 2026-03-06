extends Node

const MAX_RANGE = 150 # can be exported to be configurable

@export var sword_ability: PackedScene

var damage = 5
var base_attack_rate = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = base_attack_rate
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	# get all enemies in range
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	
	# get the nearest enemy
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
		
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	var nearestEnemy = enemies[0] as Node2D
	
	sword_instance.global_position = nearestEnemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = nearestEnemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle() # point the sword to the enemy

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if (upgrade.id != "sword_rate"):
		return
	
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
	$Timer.wait_time = max(base_attack_rate * (1 - percent_reduction), 0.00000000000001)
	#$Timer.start()
	#print($Timer.wait_time)
