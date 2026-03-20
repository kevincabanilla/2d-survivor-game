extends Node

const SPAWN_RADIUS = 350

@export var basic_enemy_scene: PackedScene
@export var cyclops_enemy_scene: PackedScene

@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
	
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position() -> Vector2:
	var spawn_position := Vector2.ZERO
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return spawn_position
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0) # 1 << 0 is the collision mask bit
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		
		if result.is_empty():
			# We are clear, break the loop
			break
		else:
			# rotate spawn position by 90 degrees
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func _on_timer_timeout() -> void:
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy_scene: PackedScene = enemy_table.pick_item()
	if enemy_scene == null || !enemy_scene.can_instantiate():
		return
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	if entities_layer == null:
		get_parent().add_child(enemy)
	else:
		entities_layer.add_child(enemy)
	
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off = min((.1 / 3) * arena_difficulty, 0.9)
	#print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_item(cyclops_enemy_scene, 20)
