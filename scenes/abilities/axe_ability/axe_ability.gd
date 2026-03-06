extends Node2D
class_name AxeAbility

const MAX_ROTATION: float = 2
const MAX_RADIUS := 120
const MAX_DURATION = 3

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation := Vector2.RIGHT.rotated(randf_range(0, TAU))

func _ready() -> void:
	var tween := create_tween()
	tween.tween_method(animate_rotation, 0.0, MAX_ROTATION, MAX_DURATION)
	tween.tween_callback(queue_free)


func animate_rotation(rotations: float) -> void:
	var player := Utils.get_player_node()
	if player == null:
		return
	
	var percent = rotations / MAX_ROTATION
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	global_position = player.global_position + (current_direction * current_radius)
