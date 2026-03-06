extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent || health_component == null:
		return
	
	var hitbox_component = area as HitboxComponent
	health_component.damage(hitbox_component.damage)
