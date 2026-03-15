extends CharacterBody2D

@onready var velocity_component: VelocityComponent = $VelocityComponent

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	if velocity.x != 0:
		$SpriteVisuals.scale.x = sign(velocity.x) # flip the sprite depending on the direction
