class_name ExperienceVial extends Node2D

@export var exp_value := 0.0

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func tween_collect(percent: float, start_position: Vector2) -> void:
	var player = Utils.get_player_node()
	if (player == null):
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collecct() -> void:
	visible = false
	$RandomAudioPlayerComponent.play_random()
	await $RandomAudioPlayerComponent.finished
	GameEvents.emit_vial_points_collected(exp_value)
	queue_free()


func disable_collision(value: bool) -> void:
	collision_shape_2d.disabled = value


func _on_area_2d_area_entered(area: Area2D) -> void:
	var player_pickup_layer := 5
	if (!area.collision_layer & (1 << (player_pickup_layer - 1))):
		return

	Callable(disable_collision).call_deferred(true)
	
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, .1).set_delay(.4)
	tween.chain() # Wait for above to finish.
	tween.tween_callback(collecct)	
	
