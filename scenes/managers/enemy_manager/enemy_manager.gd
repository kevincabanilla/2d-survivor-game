extends Node

const SPAWN_RADIUS = 350

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer

var base_spawn_time = 0

func _ready() -> void:
	base_spawn_time = timer.wait_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func _on_timer_timeout() -> void:
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	if basic_enemy_scene == null || !basic_enemy_scene.can_instantiate():
		return
	var enemy = basic_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	if entities_layer == null:
		get_parent().add_child(enemy)
	else:
		entities_layer.add_child(enemy)
	
	enemy.global_position = spawn_position


func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off = min((.1 / 3) * arena_difficulty, 0.9)
	print(time_off)
	timer.wait_time = base_spawn_time - time_off
