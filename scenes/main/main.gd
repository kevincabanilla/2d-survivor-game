extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu/pause_menu.tscn")
var loot_chest_scene = preload("res://scenes/game_objects/loot_chest/loot_chest.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.initialize_cooldown_timer()
	%Player.health_component.died.connect(on_player_died)
	
	if (!OS.is_debug_build()):
		$Entities/LootChest.queue_free()
	#else:
		#for i in range(30):
			#await get_tree().create_timer(.05).timeout
			#force_spawn_chest(%Player.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died() -> void:
	var end_screen_scene_instance = end_screen_scene.instantiate()
	add_child(end_screen_scene_instance)
	end_screen_scene_instance.set_defeat()
	MetaProgression.save()


func force_spawn_chest(spawn_position: Vector2):
	var loot_instance: LootChest = loot_chest_scene.instantiate();
	Utils.get_entities_node().add_child(loot_instance)
	
	loot_instance.global_position = $SpawnCheckerComponent.find_free_position_radial(spawn_position)
	#print(spawn_position)
	#loot_instance.global_position = $SpawnCheckerComponent.spawn_grid(spawn_position, Vector2i(3, 3), Vector2(25, 25))
	loot_instance.area_2d.force_update_transform()
