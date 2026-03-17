extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

signal hit

var floating_text_scene = preload("res://scenes/ui/gameplay/floating_text.tscn")

func _on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent || health_component == null:
		return
	
	var hitbox_component = area as HitboxComponent
	health_component.damage(hitbox_component.damage)

	var floating_text_intance: FloatingText = floating_text_scene.instantiate()
	Utils.get_foreground_node().add_child(floating_text_intance)
	floating_text_intance.global_position = global_position
	var damage = hitbox_component.damage
	floating_text_intance.start(("%0.0f" if round(damage) == damage else "%0.1f")  % hitbox_component.damage)
	hit.emit()
