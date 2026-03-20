extends Node

const SPAWN_RADIUS = 16

@export_range(0,1) var drop_percent: float = 0.5
@export var exp_value: float = 1
@export var health_component: Node
@export var vial_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)

func on_died():
	GameEvents.increase_exp.emit(exp_value)
	
	var adjusted_drop_percent = drop_percent
	var exp_upgrade = MetaProgression.get_meta_upgrade_save_data(MetaProgression.UPGRADE_EXP_VIAL_DROP_RATE)
	
	if (!exp_upgrade.is_empty()):
		adjusted_drop_percent += (exp_upgrade["value"] * exp_upgrade["quantity"]) as float
	
	#print("vial drop percent: " + str(adjusted_drop_percent))
	
	if randf() > adjusted_drop_percent:
		return
	
	if vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = (owner as Node2D).global_position + (random_direction * SPAWN_RADIUS)
	var vial_instance = vial_scene.instantiate() as ExperienceVial
	vial_instance.exp_value = exp_value
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		owner.get_parent().add_child(vial_instance)
	else:
		entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
