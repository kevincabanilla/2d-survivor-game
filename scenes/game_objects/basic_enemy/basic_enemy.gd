extends CharacterBody2D

#const MAX_SPEED = 40

@onready var velocity_component: VelocityComponent = $VelocityComponent

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	# OLD move code
	#var direction = get_direction_to_player()
	#velocity = direction * MAX_SPEED
	#move_and_slide()
	
	if velocity.x != 0:
		$SpriteVisual.scale.x = sign(velocity.x) # flip the sprite depending on the direction

#func get_direction_to_player():
	#var player_node = get_tree().get_first_node_in_group("player") as Node2D
	#if player_node != null:
		#return (player_node.global_position - global_position).normalized()
	#else:
		#return Vector2.ZERO


func _on_hurtbox_component_hit() -> void:
	$RandomHitAudioPlayerComponent.play_random()
