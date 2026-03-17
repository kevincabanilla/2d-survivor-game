extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D


func _ready() -> void:
	health_component.died.connect(on_health_component_died)
	$CPUParticles2D.texture = sprite.texture
	

func on_health_component_died() -> void:
	var entities = get_tree().get_first_node_in_group(Utils.ENTITIES_LAYER_GROUP)
	if owner == null:
		return
	var spawn_position = owner.global_position
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	$AnimationPlayer.play("default")
	$RandomHitAudioPlayerComponent.play_random()
