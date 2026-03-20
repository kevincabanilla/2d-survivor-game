extends Node

@export var loot_chest_scene: PackedScene
@export var health_component: HealthComponent
@export_range(0,1) var drop_percent: float = 0.01


func _ready() -> void:
	if health_component != null:
		health_component.died.connect(_on_health_component_died)


func get_final_drop_rate() -> float:
	var adjusted_drop_percent = drop_percent
	var loot_drop_rate_upgrade = MetaProgression.get_meta_upgrade_save_data(MetaProgression.UPGRADE_LOOT_DROP_RATE)
	
	if (!loot_drop_rate_upgrade.is_empty()):
		adjusted_drop_percent += (loot_drop_rate_upgrade["value"] * loot_drop_rate_upgrade["quantity"]) as float
	
	#print("Loot drop percent: " + str(adjusted_drop_percent))
	
	return adjusted_drop_percent


func spawn_chest() -> void:
	if loot_chest_scene == null || not owner is Node2D:
		return

	var final_drop_rate = get_final_drop_rate();
	
	if randf() > final_drop_rate:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var loot_instance: LootChest = loot_chest_scene.instantiate();	
	var entities_layer = Utils.get_entities_node()
	if entities_layer == null:
		owner.get_parent().add_child(loot_instance)
	else:
		entities_layer.add_child(loot_instance)
	
	loot_instance.global_position = spawn_position
	GameEvents.start_spawn_loot_cooldown_timer()


func _on_health_component_died() -> void:
	if (GameEvents.can_spawn_loot):
		spawn_chest()
